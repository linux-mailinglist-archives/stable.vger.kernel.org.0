Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DA5586A7B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiHAMRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiHAMQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:16:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEA63E779;
        Mon,  1 Aug 2022 04:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA66E6023B;
        Mon,  1 Aug 2022 11:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA128C433D6;
        Mon,  1 Aug 2022 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355127;
        bh=MSU+wIZy6YkLdrzUgPvd6S2garQUL9V0rYkYpyfa7mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbeiOraKXhU8YL/MPBJhzG/i5JgPStTRY+eM9quDMJ+GSzx4zMCFiL4C+1RXtOHVO
         wj+vw0QYWOpQQSdjYbMN/RSIYAqfmYFhNtTlhiKpzE6G6qJAY0nF5AR6Glq0Fe9h7C
         qVFBAgetTnUPGnE+rgzlT3zOljwQKbg1WQtpEbac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 73/88] virtio-net: fix the race between refill work and close
Date:   Mon,  1 Aug 2022 13:47:27 +0200
Message-Id: <20220801114141.369132581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 5a159128faff151b7fe5f4eb0f310b1e0a2d56bf ]

We try using cancel_delayed_work_sync() to prevent the work from
enabling NAPI. This is insufficient since we don't disable the source
of the refill work scheduling. This means an NAPI poll callback after
cancel_delayed_work_sync() can schedule the refill work then can
re-enable the NAPI that leads to use-after-free [1].

Since the work can enable NAPI, we can't simply disable NAPI before
calling cancel_delayed_work_sync(). So fix this by introducing a
dedicated boolean to control whether or not the work could be
scheduled from NAPI.

[1]
==================================================================
BUG: KASAN: use-after-free in refill_work+0x43/0xd4
Read of size 2 at addr ffff88810562c92e by task kworker/2:1/42

CPU: 2 PID: 42 Comm: kworker/2:1 Not tainted 5.19.0-rc1+ #480
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: events refill_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0xbb/0x6ac
 ? _printk+0xad/0xde
 ? refill_work+0x43/0xd4
 kasan_report+0xa8/0x130
 ? refill_work+0x43/0xd4
 refill_work+0x43/0xd4
 process_one_work+0x43d/0x780
 worker_thread+0x2a0/0x6f0
 ? process_one_work+0x780/0x780
 kthread+0x167/0x1a0
 ? kthread_exit+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
...

Fixes: b2baed69e605c ("virtio_net: set/cancel work on ndo_open/ndo_stop")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c7804fce204c..206904e60784 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -242,9 +242,15 @@ struct virtnet_info {
 	/* Packet virtio header size */
 	u8 hdr_len;
 
-	/* Work struct for refilling if we run low on memory. */
+	/* Work struct for delayed refilling if we run low on memory. */
 	struct delayed_work refill;
 
+	/* Is delayed refill enabled? */
+	bool refill_enabled;
+
+	/* The lock to synchronize the access to refill_enabled */
+	spinlock_t refill_lock;
+
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
@@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
 	return p;
 }
 
+static void enable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = true;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
+static void disable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = false;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	}
 
 	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
-		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
-			schedule_delayed_work(&vi->refill, 0);
+		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
+			spin_lock(&vi->refill_lock);
+			if (vi->refill_enabled)
+				schedule_delayed_work(&vi->refill, 0);
+			spin_unlock(&vi->refill_lock);
+		}
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
@@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, err;
 
+	enable_delayed_refill(vi);
+
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (i < vi->curr_queue_pairs)
 			/* Make sure we have some buffers: if oom use wq. */
@@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i;
 
+	/* Make sure NAPI doesn't schedule refill work */
+	disable_delayed_refill(vi);
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
@@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	enable_delayed_refill(vi);
+
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
 		if (err)
@@ -3534,6 +3564,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	spin_lock_init(&vi->refill_lock);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-- 
2.35.1



