Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF0ED24E6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbfJJIvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390128AbfJJIvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:51:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33A2C2064A;
        Thu, 10 Oct 2019 08:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697495;
        bh=e+TI/1OfcOrCYF9xwtLecH9ZYoaL93k0XwSgE+QMVBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsWp6lc3q59CKJCATn+XnSeVy+c8a8KT+lZiosw/2KFPBiIie96Hx6paYsv4V+RjJ
         kJDeFnPj5iJG1FFixCJ94IcQ6iPgO7ad8/do2t2R/6fKR1wTqKNSJ8Uv+mDBT9NB5g
         6pI+m0DCBrU+telMC5S8lBHnGzYXMM09NY8asTkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/61] nbd: fix max number of supported devs
Date:   Thu, 10 Oct 2019 10:37:13 +0200
Message-Id: <20191010083519.876334933@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

[ Upstream commit e9e006f5fcf2bab59149cb38a48a4817c1b538b4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 14b491c5cf7b6..a234600849558 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -106,6 +106,7 @@ struct nbd_device {
 	struct nbd_config *config;
 	struct mutex config_lock;
 	struct gendisk *disk;
+	struct workqueue_struct *recv_workq;
 
 	struct list_head list;
 	struct task_struct *task_recv;
@@ -136,7 +137,6 @@ static struct dentry *nbd_dbg_dir;
 
 static unsigned int nbds_max = 16;
 static int max_part = 16;
-static struct workqueue_struct *recv_workqueue;
 static int part_shift;
 
 static int nbd_dev_dbg_init(struct nbd_device *nbd);
@@ -1015,7 +1015,7 @@ static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
 		/* We take the tx_mutex in an error path in the recv_work, so we
 		 * need to queue_work outside of the tx_mutex.
 		 */
-		queue_work(recv_workqueue, &args->work);
+		queue_work(nbd->recv_workq, &args->work);
 
 		atomic_inc(&config->live_connections);
 		wake_up(&config->conn_wait);
@@ -1120,6 +1120,10 @@ static void nbd_config_put(struct nbd_device *nbd)
 		kfree(nbd->config);
 		nbd->config = NULL;
 
+		if (nbd->recv_workq)
+			destroy_workqueue(nbd->recv_workq);
+		nbd->recv_workq = NULL;
+
 		nbd->tag_set.timeout = 0;
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 
@@ -1145,6 +1149,14 @@ static int nbd_start_device(struct nbd_device *nbd)
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
 
@@ -1175,7 +1187,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		INIT_WORK(&args->work, recv_work);
 		args->nbd = nbd;
 		args->index = i;
-		queue_work(recv_workqueue, &args->work);
+		queue_work(nbd->recv_workq, &args->work);
 	}
 	nbd_size_update(nbd);
 	return error;
@@ -1195,8 +1207,10 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
-	if (ret)
+	if (ret) {
 		sock_shutdown(nbd);
+		flush_workqueue(nbd->recv_workq);
+	}
 	mutex_lock(&nbd->config_lock);
 	bd_set_size(bdev, 0);
 	/* user requested, ignore socket errors */
@@ -1836,6 +1850,12 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	mutex_lock(&nbd->config_lock);
 	nbd_disconnect(nbd);
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
@@ -2216,20 +2236,12 @@ static int __init nbd_init(void)
 
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
@@ -2271,7 +2283,6 @@ static void __exit nbd_cleanup(void)
 
 	idr_destroy(&nbd_index_idr);
 	genl_unregister_family(&nbd_genl_family);
-	destroy_workqueue(recv_workqueue);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
 
-- 
2.20.1



