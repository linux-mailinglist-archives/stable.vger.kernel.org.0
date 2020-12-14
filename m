Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7122C2D9DDC
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408595AbgLNRhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408582AbgLNRhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:10 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 007/105] net, xsk: Avoid taking multiple skbuff references
Date:   Mon, 14 Dec 2020 18:27:41 +0100
Message-Id: <20201214172555.632033722@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 36ccdf85829a7dd6936dba5d02fa50138471f0d3 ]

Commit 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
addressed the problem that packets were discarded from the Tx AF_XDP
ring, when the driver returned NETDEV_TX_BUSY. Part of the fix was
bumping the skbuff reference count, so that the buffer would not be
freed by dev_direct_xmit(). A reference count larger than one means
that the skbuff is "shared", which is not the case.

If the "shared" skbuff is sent to the generic XDP receive path,
netif_receive_generic_xdp(), and pskb_expand_head() is entered the
BUG_ON(skb_shared(skb)) will trigger.

This patch adds a variant to dev_direct_xmit(), __dev_direct_xmit(),
where a user can select the skbuff free policy. This allows AF_XDP to
avoid bumping the reference count, but still keep the NETDEV_TX_BUSY
behavior.

Fixes: 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
Reported-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20201123175600.146255-1-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 14 +++++++++++++-
 net/core/dev.c            |  8 ++------
 net/xdp/xsk.c             |  8 +-------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8fbdfae2c8c02..edc5fbd07c1ca 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2778,9 +2778,21 @@ u16 dev_pick_tx_zero(struct net_device *dev, struct sk_buff *skb,
 		     struct net_device *sb_dev);
 u16 dev_pick_tx_cpu_id(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
+
 int dev_queue_xmit(struct sk_buff *skb);
 int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev);
-int dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
+int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
+
+static inline int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
+{
+	int ret;
+
+	ret = __dev_direct_xmit(skb, queue_id);
+	if (!dev_xmit_complete(ret))
+		kfree_skb(skb);
+	return ret;
+}
+
 int register_netdevice(struct net_device *dev);
 void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
 void unregister_netdevice_many(struct list_head *head);
diff --git a/net/core/dev.c b/net/core/dev.c
index 010de57488ce7..4a6241c0534d2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4176,7 +4176,7 @@ int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev)
 }
 EXPORT_SYMBOL(dev_queue_xmit_accel);
 
-int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
+int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 {
 	struct net_device *dev = skb->dev;
 	struct sk_buff *orig_skb = skb;
@@ -4205,17 +4205,13 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	dev_xmit_recursion_dec();
 
 	local_bh_enable();
-
-	if (!dev_xmit_complete(ret))
-		kfree_skb(skb);
-
 	return ret;
 drop:
 	atomic_long_inc(&dev->tx_dropped);
 	kfree_skb_list(skb);
 	return NET_XMIT_DROP;
 }
-EXPORT_SYMBOL(dev_direct_xmit);
+EXPORT_SYMBOL(__dev_direct_xmit);
 
 /*************************************************************************
  *			Receiver routines
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 6c5e09e7440a9..a1ec2c8fa70a9 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -377,11 +377,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
-		/* Hinder dev_direct_xmit from freeing the packet and
-		 * therefore completing it in the destructor
-		 */
-		refcount_inc(&skb->users);
-		err = dev_direct_xmit(skb, xs->queue_id);
+		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
 			skb->destructor = sock_wfree;
@@ -395,12 +391,10 @@ static int xsk_generic_xmit(struct sock *sk)
 		/* Ignore NET_XMIT_CN as packet might have been sent */
 		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
-			kfree_skb(skb);
 			err = -EBUSY;
 			goto out;
 		}
 
-		consume_skb(skb);
 		sent_frame = true;
 	}
 
-- 
2.27.0



