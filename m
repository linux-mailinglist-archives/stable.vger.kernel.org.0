Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB1F469AFE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356437AbhLFPMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348732AbhLFPKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC4DC08E9BD;
        Mon,  6 Dec 2021 07:04:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85DCEB8110B;
        Mon,  6 Dec 2021 15:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67FFC341C2;
        Mon,  6 Dec 2021 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803059;
        bh=bdZqv2j7jhTCK+kuGvTA7dukuubaOQROgRQRacc59RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwB0RmrmsBnujQLA8H0nAlLfpkSdTf5oUj+4GTlZr5iOuFMbjYmvcYOslumt7CG3m
         Ge2cIPzJLScvJuRa6JzKRG8diAWUra2EJqsnwQu1rdKWz+y/z1W7eqV+UCCfyqcwFy
         F6x00ad0zCuX1DewGSY7BlLvjvia1gFLZ+qLoGQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanqi Liu <legend050709@qq.com>,
        yangxingwu <xingwu.yang@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 014/106] netfilter: ipvs: Fix reuse connection if RS weight is 0
Date:   Mon,  6 Dec 2021 15:55:22 +0100
Message-Id: <20211206145555.878057197@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>

[ Upstream commit c95c07836fa4c1767ed11d8eca0769c652760e32 ]

We are changing expire_nodest_conn to work even for reused connections when
conn_reuse_mode=0, just as what was done with commit dc7b3eb900aa ("ipvs:
Fix reuse connection if real server is dead").

For controlled and persistent connections, the new connection will get the
needed real server depending on the rules in ip_vs_check_template().

Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port reuse is detected")
Co-developed-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ipvs-sysctl.txt | 3 +--
 net/netfilter/ipvs/ip_vs_core.c          | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 056898685d408..fc531c29a2e83 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -30,8 +30,7 @@ conn_reuse_mode - INTEGER
 
 	0: disable any special handling on port reuse. The new
 	connection will be delivered to the same real server that was
-	servicing the previous connection. This will effectively
-	disable expire_nodest_conn.
+	servicing the previous connection.
 
 	bit 1: enable rescheduling of new connections when it is safe.
 	That is, whenever expire_nodest_conn and for TCP sockets, when
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a95fe5fe9f046..4b9cd1c1c9987 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1838,7 +1838,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	struct ip_vs_proto_data *pd;
 	struct ip_vs_conn *cp;
 	int ret, pkts;
-	int conn_reuse_mode;
 	struct sock *sk;
 
 	/* Already marked as IPVS request or reply? */
@@ -1914,15 +1913,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	 */
 	cp = pp->conn_in_get(ipvs, af, skb, &iph);
 
-	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
-	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+		int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 		bool old_ct = false, resched = false;
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
 			resched = true;
 			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
-		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
+		} else if (conn_reuse_mode &&
+			   is_new_conn_expected(cp, conn_reuse_mode)) {
 			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 			if (!atomic_read(&cp->n_control)) {
 				resched = true;
-- 
2.33.0



