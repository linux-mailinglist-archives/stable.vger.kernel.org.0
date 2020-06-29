Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB12C20DB8E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbgF2UHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732949AbgF2TaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3853325209;
        Mon, 29 Jun 2020 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444924;
        bh=m8R7Cg1KJead1vQgeNRh3B18Pdr1dvqBOejLktU59HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiTQzkjt9R2myUtp+sNNVYrmvcQN/bGJaegQAGpDazpHkTwqNn3agAjScZ/Kp5X1P
         QQ2mbEGT25a2ueCQDFE3H8VHrzDFRxfVmywdV+myIs5xySLRYpaLtqMWUJ5i9uVFkc
         VF7UmVfRfAR0n4whthQddGYBnkWXBt6GPYlNpY88=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 021/131] net: place xmit recursion in softnet data
Date:   Mon, 29 Jun 2020 11:33:12 -0400
Message-Id: <20200629153502.2494656-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 97cdcf37b57e3f204be3000b9eab9686f38b4356 upstream.

This fills a hole in softnet data, so no change in structure size.

Also prepares for xmit_more placement in the same spot;
skb->xmit_more will be removed in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h | 40 +++++++++++++++++++++++++++++++--------
 net/core/dev.c            | 10 +++-------
 net/core/filter.c         |  6 +++---
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 84bbdcbb199a9..41beebcc61f45 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2620,14 +2620,6 @@ void netdev_freemem(struct net_device *dev);
 void synchronize_net(void);
 int init_dummy_netdev(struct net_device *dev);
 
-DECLARE_PER_CPU(int, xmit_recursion);
-#define XMIT_RECURSION_LIMIT	10
-
-static inline int dev_recursion_level(void)
-{
-	return this_cpu_read(xmit_recursion);
-}
-
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
@@ -2967,6 +2959,11 @@ struct softnet_data {
 #ifdef CONFIG_XFRM_OFFLOAD
 	struct sk_buff_head	xfrm_backlog;
 #endif
+	/* written and read only by owning cpu: */
+	struct {
+		u16 recursion;
+		u8  more;
+	} xmit;
 #ifdef CONFIG_RPS
 	/* input_queue_head should be written by cpu owning this struct,
 	 * and only read by other cpus. Worth using a cache line.
@@ -3002,6 +2999,28 @@ static inline void input_queue_tail_incr_save(struct softnet_data *sd,
 
 DECLARE_PER_CPU_ALIGNED(struct softnet_data, softnet_data);
 
+static inline int dev_recursion_level(void)
+{
+	return __this_cpu_read(softnet_data.xmit.recursion);
+}
+
+#define XMIT_RECURSION_LIMIT	10
+static inline bool dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.recursion) >
+			XMIT_RECURSION_LIMIT);
+}
+
+static inline void dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.recursion);
+}
+
+static inline void dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.recursion);
+}
+
 void __netif_schedule(struct Qdisc *q);
 void netif_schedule_queue(struct netdev_queue *txq);
 
@@ -4314,6 +4333,11 @@ static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
 	return ops->ndo_start_xmit(skb, dev);
 }
 
+static inline bool netdev_xmit_more(void)
+{
+	return __this_cpu_read(softnet_data.xmit.more);
+}
+
 static inline netdev_tx_t netdev_start_xmit(struct sk_buff *skb, struct net_device *dev,
 					    struct netdev_queue *txq, bool more)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 5e668d3b1e717..8f9a8b009a238 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3534,9 +3534,6 @@ static void skb_update_prio(struct sk_buff *skb)
 #define skb_update_prio(skb)
 #endif
 
-DEFINE_PER_CPU(int, xmit_recursion);
-EXPORT_SYMBOL(xmit_recursion);
-
 /**
  *	dev_loopback_xmit - loop back @skb
  *	@net: network namespace this loopback is happening in
@@ -3827,8 +3824,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 		int cpu = smp_processor_id(); /* ok because BHs are off */
 
 		if (txq->xmit_lock_owner != cpu) {
-			if (unlikely(__this_cpu_read(xmit_recursion) >
-				     XMIT_RECURSION_LIMIT))
+			if (dev_xmit_recursion())
 				goto recursion_alert;
 
 			skb = validate_xmit_skb(skb, dev, &again);
@@ -3838,9 +3834,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			HARD_TX_LOCK(dev, txq, cpu);
 
 			if (!netif_xmit_stopped(txq)) {
-				__this_cpu_inc(xmit_recursion);
+				dev_xmit_recursion_inc();
 				skb = dev_hard_start_xmit(skb, dev, txq, &rc);
-				__this_cpu_dec(xmit_recursion);
+				dev_xmit_recursion_dec();
 				if (dev_xmit_complete(rc)) {
 					HARD_TX_UNLOCK(dev, txq);
 					goto out;
diff --git a/net/core/filter.c b/net/core/filter.c
index b5521b60a2d4f..636e67a928477 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2002,7 +2002,7 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	int ret;
 
-	if (unlikely(__this_cpu_read(xmit_recursion) > XMIT_RECURSION_LIMIT)) {
+	if (dev_xmit_recursion()) {
 		net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
 		kfree_skb(skb);
 		return -ENETDOWN;
@@ -2011,9 +2011,9 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 	skb->dev = dev;
 	skb->tstamp = 0;
 
-	__this_cpu_inc(xmit_recursion);
+	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
-	__this_cpu_dec(xmit_recursion);
+	dev_xmit_recursion_dec();
 
 	return ret;
 }
-- 
2.25.1

