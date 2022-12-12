Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DEA64A027
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiLLNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiLLNVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53A11038
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 593F6B80D3B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33644C433D2;
        Mon, 12 Dec 2022 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851263;
        bh=9i4pRGiizVLpZ5jaoDdlgrGoanNKpqn/LYiLNgy95Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFw8AvtPNkFEXPNT8UzyaehVF9FJTV+hfSpubZHXZQCI8VQ6be9bEUZxCCQOJlQgz
         jtLRCE+KreMxmuhjKHr8BCIoYqeXfhARQdo1H/vq5ye29RW0D8B/87W5YkFvh3K4E5
         H6IvlMlHorNQC85qvKVyUVRetQ4CicvDX+SU5gQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Wei Liu <wei.liu@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/67] xen/netback: do some code cleanup
Date:   Mon, 12 Dec 2022 14:16:56 +0100
Message-Id: <20221212130918.640093274@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 5834e72eda0b7e5767eb107259d98eef19ebd11f ]

Remove some unused macros and functions, make local functions static.

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
Link: https://lore.kernel.org/r/20220608043726.9380-1-jgross@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 74e7e1efdad4 ("xen/netback: don't call kfree_skb() with interrupts disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/common.h    | 12 ------------
 drivers/net/xen-netback/interface.c | 16 +---------------
 drivers/net/xen-netback/netback.c   |  4 +++-
 drivers/net/xen-netback/rx.c        |  2 +-
 4 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index f7e746f1c9fb..fa52d5ffca72 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -48,7 +48,6 @@
 #include <linux/debugfs.h>
 
 typedef unsigned int pending_ring_idx_t;
-#define INVALID_PENDING_RING_IDX (~0U)
 
 struct pending_tx_info {
 	struct xen_netif_tx_request req; /* tx request */
@@ -82,8 +81,6 @@ struct xenvif_rx_meta {
 /* Discriminate from any valid pending_idx value. */
 #define INVALID_PENDING_IDX 0xFFFF
 
-#define MAX_BUFFER_OFFSET XEN_PAGE_SIZE
-
 #define MAX_PENDING_REQS XEN_NETIF_TX_RING_SIZE
 
 /* The maximum number of frags is derived from the size of a grant (same
@@ -364,11 +361,6 @@ void xenvif_free(struct xenvif *vif);
 int xenvif_xenbus_init(void);
 void xenvif_xenbus_fini(void);
 
-int xenvif_schedulable(struct xenvif *vif);
-
-int xenvif_queue_stopped(struct xenvif_queue *queue);
-void xenvif_wake_queue(struct xenvif_queue *queue);
-
 /* (Un)Map communication rings. */
 void xenvif_unmap_frontend_data_rings(struct xenvif_queue *queue);
 int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
@@ -391,7 +383,6 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_action(struct xenvif_queue *queue);
 void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
@@ -399,9 +390,6 @@ void xenvif_carrier_on(struct xenvif *vif);
 /* Callback from stack when TX packet can be released */
 void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success);
 
-/* Unmap a pending page and release it back to the guest */
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
-
 static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 {
 	return MAX_PENDING_REQS -
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 809089587301..5efe86b3ba06 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -70,7 +70,7 @@ void xenvif_skb_zerocopy_complete(struct xenvif_queue *queue)
 	wake_up(&queue->dealloc_wq);
 }
 
-int xenvif_schedulable(struct xenvif *vif)
+static int xenvif_schedulable(struct xenvif *vif)
 {
 	return netif_running(vif->dev) &&
 		test_bit(VIF_STATUS_CONNECTED, &vif->status) &&
@@ -178,20 +178,6 @@ irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int xenvif_queue_stopped(struct xenvif_queue *queue)
-{
-	struct net_device *dev = queue->vif->dev;
-	unsigned int id = queue->id;
-	return netif_tx_queue_stopped(netdev_get_tx_queue(dev, id));
-}
-
-void xenvif_wake_queue(struct xenvif_queue *queue)
-{
-	struct net_device *dev = queue->vif->dev;
-	unsigned int id = queue->id;
-	netif_tx_wake_queue(netdev_get_tx_queue(dev, id));
-}
-
 static u16 xenvif_select_queue(struct net_device *dev, struct sk_buff *skb,
 			       struct net_device *sb_dev)
 {
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 5706a1694c9c..982e501173f1 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -105,6 +105,8 @@ static void make_tx_response(struct xenvif_queue *queue,
 			     s8       st);
 static void push_tx_responses(struct xenvif_queue *queue);
 
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
+
 static inline int tx_work_todo(struct xenvif_queue *queue);
 
 static inline unsigned long idx_to_pfn(struct xenvif_queue *queue,
@@ -1433,7 +1435,7 @@ static void push_tx_responses(struct xenvif_queue *queue)
 		notify_remote_via_irq(queue->tx_irq);
 }
 
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
 {
 	int ret;
 	struct gnttab_unmap_grant_ref tx_unmap_op;
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 85a5a622ec18..6f940a32dcb8 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -473,7 +473,7 @@ static void xenvif_rx_skb(struct xenvif_queue *queue)
 
 #define RX_BATCH_SIZE 64
 
-void xenvif_rx_action(struct xenvif_queue *queue)
+static void xenvif_rx_action(struct xenvif_queue *queue)
 {
 	struct sk_buff_head completed_skbs;
 	unsigned int work_done = 0;
-- 
2.35.1



