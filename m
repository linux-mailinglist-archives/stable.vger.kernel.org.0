Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B068663DF57
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiK3SqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiK3Sp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912F15DB97
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E70861D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D43C433D6;
        Wed, 30 Nov 2022 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833954;
        bh=XcSzRWqW0B4aUdTFiS3pjydaXAg11V6kt3WtwX4EGd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RASvFSuKUQa4o328h0n/Q+lzFBAi0Pj+nfZlrte+O2gdrdJH9s609eZ+rwPU4bN3E
         dg8Sb0UkdHkrgRCWTlg4x4bN24VAmnBiEj1dwMm79MyrDTaRO9FjdXE+6CeGNpJDdh
         3IoR8C/9HYqLI410txpTLpj/qt8CpBQpfYGaXW5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 075/289] net: neigh: decrement the family specific qlen
Date:   Wed, 30 Nov 2022 19:21:00 +0100
Message-Id: <20221130180545.841413547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>

[ Upstream commit 8207f253a097fe15c93d85ac15ebb73c5e39e1e1 ]

Commit 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit
per-device") introduced the length counter qlen in struct neigh_parms.
There are separate neigh_parms instances for IPv4/ARP and IPv6/ND, and
while the family specific qlen is incremented in pneigh_enqueue(), the
mentioned commit decrements always the IPv4/ARP specific qlen,
regardless of the currently processed family, in pneigh_queue_purge()
and neigh_proxy_process().

As a result, with IPv6/ND, the family specific qlen is only incremented
(and never decremented) until it exceeds PROXY_QLEN, and then, according
to the check in pneigh_enqueue(), neighbor solicitations are not
answered anymore. As an example, this is noted when using the
subnet-router anycast address to access a Linux router. After a certain
amount of time (in the observed case, qlen exceeded PROXY_QLEN after two
days), the Linux router stops answering neighbor solicitations for its
subnet-router anycast address and effectively becomes unreachable.

Another result with IPv6/ND is that the IPv4/ARP specific qlen is
decremented more often than incremented. This leads to negative qlen
values, as a signed integer has been used for the length counter qlen,
and potentially to an integer overflow.

Fix this by introducing the helper function neigh_parms_qlen_dec(),
which decrements the family specific qlen. Thereby, make use of the
existing helper function neigh_get_dev_parms_rcu(), whose definition
therefore needs to be placed earlier in neighbour.c. Take the family
member from struct neigh_table to determine the currently processed
family and appropriately call neigh_parms_qlen_dec() from
pneigh_queue_purge() and neigh_proxy_process().

Additionally, use an unsigned integer for the length counter qlen.

Fixes: 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit per-device")
Signed-off-by: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h |  2 +-
 net/core/neighbour.c    | 58 +++++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 3827a6b395fd..bce6b228cf56 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -83,7 +83,7 @@ struct neigh_parms {
 	struct rcu_head rcu_head;
 
 	int	reachable_time;
-	int	qlen;
+	u32	qlen;
 	int	data[NEIGH_VAR_DATA_MAX];
 	DECLARE_BITMAP(data_state, NEIGH_VAR_DATA_MAX);
 };
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 84755db81e9d..35f5a3125808 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -307,7 +307,31 @@ static int neigh_del_timer(struct neighbour *n)
 	return 0;
 }
 
-static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
+static struct neigh_parms *neigh_get_dev_parms_rcu(struct net_device *dev,
+						   int family)
+{
+	switch (family) {
+	case AF_INET:
+		return __in_dev_arp_parms_get_rcu(dev);
+	case AF_INET6:
+		return __in6_dev_nd_parms_get_rcu(dev);
+	}
+	return NULL;
+}
+
+static void neigh_parms_qlen_dec(struct net_device *dev, int family)
+{
+	struct neigh_parms *p;
+
+	rcu_read_lock();
+	p = neigh_get_dev_parms_rcu(dev, family);
+	if (p)
+		p->qlen--;
+	rcu_read_unlock();
+}
+
+static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net,
+			       int family)
 {
 	struct sk_buff_head tmp;
 	unsigned long flags;
@@ -321,13 +345,7 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 		struct net_device *dev = skb->dev;
 
 		if (net == NULL || net_eq(dev_net(dev), net)) {
-			struct in_device *in_dev;
-
-			rcu_read_lock();
-			in_dev = __in_dev_get_rcu(dev);
-			if (in_dev)
-				in_dev->arp_parms->qlen--;
-			rcu_read_unlock();
+			neigh_parms_qlen_dec(dev, family);
 			__skb_unlink(skb, list);
 			__skb_queue_tail(&tmp, skb);
 		}
@@ -409,7 +427,8 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
 	pneigh_ifdown_and_unlock(tbl, dev);
-	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
+	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
+			   tbl->family);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
 		del_timer_sync(&tbl->proxy_timer);
 	return 0;
@@ -1621,13 +1640,8 @@ static void neigh_proxy_process(struct timer_list *t)
 
 		if (tdif <= 0) {
 			struct net_device *dev = skb->dev;
-			struct in_device *in_dev;
 
-			rcu_read_lock();
-			in_dev = __in_dev_get_rcu(dev);
-			if (in_dev)
-				in_dev->arp_parms->qlen--;
-			rcu_read_unlock();
+			neigh_parms_qlen_dec(dev, tbl->family);
 			__skb_unlink(skb, &tbl->proxy_queue);
 
 			if (tbl->proxy_redo && netif_running(dev)) {
@@ -1821,7 +1835,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 	cancel_delayed_work_sync(&tbl->managed_work);
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue, NULL);
+	pneigh_queue_purge(&tbl->proxy_queue, NULL, tbl->family);
 	neigh_ifdown(tbl, NULL);
 	if (atomic_read(&tbl->entries))
 		pr_crit("neighbour leakage\n");
@@ -3542,18 +3556,6 @@ static int proc_unres_qlen(struct ctl_table *ctl, int write,
 	return ret;
 }
 
-static struct neigh_parms *neigh_get_dev_parms_rcu(struct net_device *dev,
-						   int family)
-{
-	switch (family) {
-	case AF_INET:
-		return __in_dev_arp_parms_get_rcu(dev);
-	case AF_INET6:
-		return __in6_dev_nd_parms_get_rcu(dev);
-	}
-	return NULL;
-}
-
 static void neigh_copy_dflt_parms(struct net *net, struct neigh_parms *p,
 				  int index)
 {
-- 
2.35.1



