Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474B71481D0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391263AbgAXLW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391061AbgAXLW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:56 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8779206D4;
        Fri, 24 Jan 2020 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864976;
        bh=Fj05ruSZNor8JajwyIqGZe8JueBtgFbQrK6tm2uZtQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyBScbzayXD8aQbMIRL8LAm7yUHBEOtlmu0M4K0gv8vWraNyGjGsl+Hq7ouWOwgVO
         cw1gIusHilln7bJL/NtIDmgrRle+DJIuKu1El0S434WGkrYm8P9K8PM5BOC8EsRZha
         itz1rMjskm29Iz5W+t0iOUZZJEVm/gGsXGIL0tPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 405/639] net: core: support XDP generic on stacked devices.
Date:   Fri, 24 Jan 2020 10:29:35 +0100
Message-Id: <20200124093137.817937720@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 458bf2f224f04a513b0be972f8708e78ee2c986e ]

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device was not called.

Move the call to XDP generic inside __netif_receive_skb_core where
it can be done multiple times for stacked case.

Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 58 +++++++++++---------------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a26d87073f714..935fe158cfaff 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4465,23 +4465,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		/* Consider XDP consuming the packet a success from
-		 * the netdev point of view we do not want to count
-		 * this as an error.
-		 */
-		if (ret != XDP_PASS)
-			return NET_RX_SUCCESS;
-	}
-
 #ifdef CONFIG_RPS
 	if (static_key_false(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -4815,6 +4798,18 @@ another_round:
 
 	__this_cpu_inc(softnet_data.processed);
 
+	if (static_branch_unlikely(&generic_xdp_needed_key)) {
+		int ret2;
+
+		preempt_disable();
+		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		preempt_enable();
+
+		if (ret2 != XDP_PASS)
+			return NET_RX_DROP;
+		skb_reset_mac_len(skb);
+	}
+
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
 		skb = skb_vlan_untag(skb);
@@ -5133,19 +5128,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		if (ret != XDP_PASS)
-			return NET_RX_DROP;
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_key_false(&rps_needed)) {
@@ -5166,7 +5148,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 
 static void netif_receive_skb_list_internal(struct list_head *head)
 {
-	struct bpf_prog *xdp_prog = NULL;
 	struct sk_buff *skb, *next;
 	struct list_head sublist;
 
@@ -5179,21 +5160,6 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 	}
 	list_splice_init(&sublist, head);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		preempt_disable();
-		rcu_read_lock();
-		list_for_each_entry_safe(skb, next, head, list) {
-			xdp_prog = rcu_dereference(skb->dev->xdp_prog);
-			skb_list_del_init(skb);
-			if (do_xdp_generic(xdp_prog, skb) == XDP_PASS)
-				list_add_tail(&skb->list, &sublist);
-		}
-		rcu_read_unlock();
-		preempt_enable();
-		/* Put passed packets back on main list */
-		list_splice_init(&sublist, head);
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_key_false(&rps_needed)) {
-- 
2.20.1



