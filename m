Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB171CF3AD
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfJHH0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:26:03 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:39343 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729740AbfJHH0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:26:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 48165315;
        Tue,  8 Oct 2019 03:26:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mq0YZM
        WWq3JqOx45g3CvkPLFBrJySy56E3vNAJ+IkXs=; b=t3Y5wBsrXf+8LglVbGJF7D
        b2VB0lgVfOuXvtwjrlxH2eEvnMZzu3SYLceKMB4kL30Q6w9JxVdJxbb4yYqwNzxy
        mvK514ajTtvUn1Zoy3h7EjGwnBRd4KAsmm6qmrWkYwJP55hQv6xE33BFGl2vJ/zB
        oRsLPPRyGcS5YBsnChjiVQNBv7T1yQVZQv/uSqREDNv/4WVoHU+thYqvq27BtHte
        AiC4IuJ83nfAkHEvQ/cnzpkHlIAJlqAuseL1gC95jm0l/KN7n40Ku/z+0t61dy4B
        rHspkEf0rFXNOvhHdm5m9tlJe3BNL5be+7keX59W6JjE7VDNCRdgyfYAWV1oXEYw
        ==
X-ME-Sender: <xms:CDqcXfaM918yeO-NGOK680EURuUvqAvF1JSMXjFNR7Own8e4eR0otQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CDqcXWL8WTtlU3UW1_LUvoLldsB2luZ8Ez-Lu8TXfdRCubyddYPbHA>
    <xmx:CDqcXQio2qc2E-GrJMwujO2c-GhhsOcnot78qd3gwcMBx4r8RB0mhw>
    <xmx:CDqcXf-8A7w_1E3doCyiSzS85OHFSq1GPkV-g00K9Lwvq_2CCyWD5w>
    <xmx:CDqcXQt0L6TBkDkzN8vO-J4HLBOvyAbIZqE1WJ4XBj2ImCyoLy-ieA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 145B4D6005E;
        Tue,  8 Oct 2019 03:25:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] nbd: fix max number of supported devs" failed to apply to 4.14-stable tree
To:     mchristi@redhat.com, axboe@kernel.dk, jbacik@fb.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:25:58 +0200
Message-ID: <157051955816884@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e9e006f5fcf2bab59149cb38a48a4817c1b538b4 Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Sun, 4 Aug 2019 14:10:06 -0500
Subject: [PATCH] nbd: fix max number of supported devs

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
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 98c618e5732c..a8e3815295fe 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -108,6 +108,7 @@ struct nbd_device {
 	struct nbd_config *config;
 	struct mutex config_lock;
 	struct gendisk *disk;
+	struct workqueue_struct *recv_workq;
 
 	struct list_head list;
 	struct task_struct *task_recv;
@@ -139,7 +140,6 @@ static struct dentry *nbd_dbg_dir;
 
 static unsigned int nbds_max = 16;
 static int max_part = 16;
-static struct workqueue_struct *recv_workqueue;
 static int part_shift;
 
 static int nbd_dev_dbg_init(struct nbd_device *nbd);
@@ -1058,7 +1058,7 @@ static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
 		/* We take the tx_mutex in an error path in the recv_work, so we
 		 * need to queue_work outside of the tx_mutex.
 		 */
-		queue_work(recv_workqueue, &args->work);
+		queue_work(nbd->recv_workq, &args->work);
 
 		atomic_inc(&config->live_connections);
 		wake_up(&config->conn_wait);
@@ -1159,6 +1159,10 @@ static void nbd_config_put(struct nbd_device *nbd)
 		kfree(nbd->config);
 		nbd->config = NULL;
 
+		if (nbd->recv_workq)
+			destroy_workqueue(nbd->recv_workq);
+		nbd->recv_workq = NULL;
+
 		nbd->tag_set.timeout = 0;
 		nbd->disk->queue->limits.discard_granularity = 0;
 		nbd->disk->queue->limits.discard_alignment = 0;
@@ -1187,6 +1191,14 @@ static int nbd_start_device(struct nbd_device *nbd)
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
 
@@ -1217,7 +1229,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		INIT_WORK(&args->work, recv_work);
 		args->nbd = nbd;
 		args->index = i;
-		queue_work(recv_workqueue, &args->work);
+		queue_work(nbd->recv_workq, &args->work);
 	}
 	nbd_size_update(nbd);
 	return error;
@@ -1237,8 +1249,10 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
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
@@ -1899,6 +1913,12 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
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
@@ -2283,20 +2303,12 @@ static int __init nbd_init(void)
 
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
@@ -2338,7 +2350,6 @@ static void __exit nbd_cleanup(void)
 
 	idr_destroy(&nbd_index_idr);
 	genl_unregister_family(&nbd_genl_family);
-	destroy_workqueue(recv_workqueue);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
 

