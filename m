Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F267A80C16
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfHDTKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 15:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbfHDTKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 15:10:15 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81F5930860BD;
        Sun,  4 Aug 2019 19:10:14 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-120-181.rdu2.redhat.com [10.10.120.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D02FA5D6B0;
        Sun,  4 Aug 2019 19:10:13 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     josef@toxicpanda.com, linux-block@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] nbd: fix max number of supported devs
Date:   Sun,  4 Aug 2019 14:10:06 -0500
Message-Id: <20190804191006.5359-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sun, 04 Aug 2019 19:10:14 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a bug added in 4.10 with commit:

commit 9561a7ade0c205bc2ee035a2ac880478dcc1a024
Author: Josef Bacik <jbacik@fb.com>
Date:   Tue Nov 22 14:04:40 2016 -0500

    nbd: add multi-connection support

that limited the number of devices to 256. Before the patch we could
create 1000s of devices, but the patch switched us from using our
own thread to using a work queue which has a default limit of 256
active works.

The problem is that our recv_work function sits in a loop until
disconnection but only handles IO for one connection. The work is
started when the connection is started/restarted, but if we end up
creating 257 or more connections, the queue_work call just queues
connection257+'s recv_work and that waits for connection 1 - 256's
recv_work to be disconnected and that work instance completing.

Instead of reverting back to kthreads, this has us allocate a
workqueue_struct per device, so we can block in the work.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/nbd.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9bcde2325893..cc4b2ae57409 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -108,6 +108,7 @@ struct nbd_device {
 	struct nbd_config *config;
 	struct mutex config_lock;
 	struct gendisk *disk;
+	struct workqueue_struct *recv_workq;
 
 	struct list_head list;
 	struct task_struct *task_recv;
@@ -138,7 +139,6 @@ static struct dentry *nbd_dbg_dir;
 
 static unsigned int nbds_max = 16;
 static int max_part = 16;
-static struct workqueue_struct *recv_workqueue;
 static int part_shift;
 
 static int nbd_dev_dbg_init(struct nbd_device *nbd);
@@ -1036,7 +1036,7 @@ static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
 		/* We take the tx_mutex in an error path in the recv_work, so we
 		 * need to queue_work outside of the tx_mutex.
 		 */
-		queue_work(recv_workqueue, &args->work);
+		queue_work(nbd->recv_workq, &args->work);
 
 		atomic_inc(&config->live_connections);
 		wake_up(&config->conn_wait);
@@ -1137,6 +1137,10 @@ static void nbd_config_put(struct nbd_device *nbd)
 		kfree(nbd->config);
 		nbd->config = NULL;
 
+		if (nbd->recv_workq)
+			destroy_workqueue(nbd->recv_workq);
+		nbd->recv_workq = NULL;
+
 		nbd->tag_set.timeout = 0;
 		nbd->disk->queue->limits.discard_granularity = 0;
 		nbd->disk->queue->limits.discard_alignment = 0;
@@ -1165,6 +1169,14 @@ static int nbd_start_device(struct nbd_device *nbd)
 		return -EINVAL;
 	}
 
+	nbd->recv_workq = alloc_workqueue("knbd%d-recv",
+					  WQ_MEM_RECLAIM | WQ_HIGHPRI |
+					  WQ_UNBOUND, 0, nbd->index);
+	if (!nbd->recv_workq) {
+		dev_err(disk_to_dev(nbd->disk), "Could not allocate knbd recv work queue.\n");
+		return -ENOMEM;
+	}
+
 	blk_mq_update_nr_hw_queues(&nbd->tag_set, config->num_connections);
 	nbd->task_recv = current;
 
@@ -1195,7 +1207,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		INIT_WORK(&args->work, recv_work);
 		args->nbd = nbd;
 		args->index = i;
-		queue_work(recv_workqueue, &args->work);
+		queue_work(nbd->recv_workq, &args->work);
 	}
 	nbd_size_update(nbd);
 	return error;
@@ -1215,8 +1227,10 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
-	if (ret)
+	if (ret) {
 		sock_shutdown(nbd);
+		flush_workqueue(nbd->recv_workq);
+	}
 	mutex_lock(&nbd->config_lock);
 	nbd_bdev_reset(bdev);
 	/* user requested, ignore socket errors */
@@ -1875,6 +1889,12 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	nbd_disconnect(nbd);
 	nbd_clear_sock(nbd);
 	mutex_unlock(&nbd->config_lock);
+	/*
+	 * Make sure recv thread has finished, so it does not drop the last
+	 * config ref and try to destroy the workqueue from inside the work
+	 * queue.
+	 */
+	flush_workqueue(nbd->recv_workq);
 	if (test_and_clear_bit(NBD_HAS_CONFIG_REF,
 			       &nbd->config->runtime_flags))
 		nbd_config_put(nbd);
@@ -2261,20 +2281,12 @@ static int __init nbd_init(void)
 
 	if (nbds_max > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
-	recv_workqueue = alloc_workqueue("knbd-recv",
-					 WQ_MEM_RECLAIM | WQ_HIGHPRI |
-					 WQ_UNBOUND, 0);
-	if (!recv_workqueue)
-		return -ENOMEM;
 
-	if (register_blkdev(NBD_MAJOR, "nbd")) {
-		destroy_workqueue(recv_workqueue);
+	if (register_blkdev(NBD_MAJOR, "nbd"))
 		return -EIO;
-	}
 
 	if (genl_register_family(&nbd_genl_family)) {
 		unregister_blkdev(NBD_MAJOR, "nbd");
-		destroy_workqueue(recv_workqueue);
 		return -EINVAL;
 	}
 	nbd_dbg_init();
@@ -2316,7 +2328,6 @@ static void __exit nbd_cleanup(void)
 
 	idr_destroy(&nbd_index_idr);
 	genl_unregister_family(&nbd_genl_family);
-	destroy_workqueue(recv_workqueue);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
 
-- 
2.20.1

