Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC67F45C24E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348916AbhKXN1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349724AbhKXNXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 243F86141B;
        Wed, 24 Nov 2021 12:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758094;
        bh=54BYwtf3E5TRRI0jfDtgOjPCs0YjCYdIs2QEkUBmahk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUPlLwfS5y9DojrMbfqKjK3SjuknCyZ/8in844/K0EXu95R8QsfzUEJ5IUs8SCWAD
         YTXbrU3cPj8rHBhVrc7MT/fyVYYe8Zdjb0T9w7TTghJqiAuQGD2BIH4rwO/0YA2khF
         HcCZW/GbpYToqGTuAFdHf7NKPG5zrpYcKVmQw3K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/100] net: sched: act_mirred: drop dst for the direction from egress to ingress
Date:   Wed, 24 Nov 2021 12:58:15 +0100
Message-Id: <20211124115656.781929790@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f799ada6bf2397c351220088b9b0980125c77280 ]

Without dropping dst, the packets sent from local mirred/redirected
to ingress will may still use the old dst. ip_rcv() will drop it as
the old dst is for output and its .input is dst_discard.

This patch is to fix by also dropping dst for those packets that are
mirred or redirected from egress to ingress in act_mirred.

Note that we don't drop it for the direction change from ingress to
egress, as on which there might be a user case attaching a metadata
dst by act_tunnel_key that would be used later.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index e3ff884a48c56..b87d2a1ee0b16 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -19,6 +19,7 @@
 #include <linux/if_arp.h>
 #include <net/net_namespace.h>
 #include <net/netlink.h>
+#include <net/dst.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_mirred.h>
@@ -218,6 +219,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	bool want_ingress;
 	bool is_redirect;
 	bool expects_nh;
+	bool at_ingress;
 	int m_eaction;
 	int mac_len;
 	bool at_nh;
@@ -253,7 +255,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	 * ingress - that covers the TC S/W datapath.
 	 */
 	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
-	use_reinsert = skb_at_tc_ingress(skb) && is_redirect &&
+	at_ingress = skb_at_tc_ingress(skb);
+	use_reinsert = at_ingress && is_redirect &&
 		       tcf_mirred_can_reinsert(retval);
 	if (!use_reinsert) {
 		skb2 = skb_clone(skb, GFP_ATOMIC);
@@ -261,10 +264,12 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
+	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+
 	/* All mirred/redirected skbs should clear previous ct info */
 	nf_reset_ct(skb2);
-
-	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+	if (want_ingress && !at_ingress) /* drop dst for egress -> ingress */
+		skb_dst_drop(skb2);
 
 	expects_nh = want_ingress || !m_mac_header_xmit;
 	at_nh = skb->data == skb_network_header(skb);
-- 
2.33.0



