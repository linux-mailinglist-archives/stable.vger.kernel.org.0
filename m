Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF14FD127
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351057AbiDLG5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351504AbiDLGxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEF237A3F;
        Mon, 11 Apr 2022 23:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D2460A69;
        Tue, 12 Apr 2022 06:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8979EC385A1;
        Tue, 12 Apr 2022 06:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745691;
        bh=JBC1OC8G7Ps53Lzne+I/Scmzs9aGQflz4/6ggT2zfYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgGkD2dPjPtfdwAsXckj1QJZ6h9qQ2Dplgh6i/rSy0UlDJi/8/q5c4+YH7a7NGfOa
         gTirXELAekDXq8wlDm4fQ9GQd9cBW+TSDqkhUqyHFoFCXC9dkTtq7majcPun0E+nRZ
         1od/p81Ht++muaRp87+f5i8o/p3ALeUm3QeEdvQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/277] nbd: Fix hungtask when nbd_config_put
Date:   Tue, 12 Apr 2022 08:26:49 +0200
Message-Id: <20220412062942.215355614@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit e2daec488c57069a4a431d5b752f50294c4bf273 ]

I got follow issue:
[  247.381177] INFO: task kworker/u10:0:47 blocked for more than 120 seconds.
[  247.382644]       Not tainted 4.19.90-dirty #140
[  247.383502] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.385027] Call Trace:
[  247.388384]  schedule+0xb8/0x3c0
[  247.388966]  schedule_timeout+0x2b4/0x380
[  247.392815]  wait_for_completion+0x367/0x510
[  247.397713]  flush_workqueue+0x32b/0x1340
[  247.402700]  drain_workqueue+0xda/0x3c0
[  247.403442]  destroy_workqueue+0x7b/0x690
[  247.405014]  nbd_config_put.cold+0x2f9/0x5b6
[  247.405823]  recv_work+0x1fd/0x2b0
[  247.406485]  process_one_work+0x70b/0x1610
[  247.407262]  worker_thread+0x5a9/0x1060
[  247.408699]  kthread+0x35e/0x430
[  247.410918]  ret_from_fork+0x1f/0x30

We can reproduce issue as follows:
1. Inject memory fault in nbd_start_device
-1244,10 +1248,18 @@ static int nbd_start_device(struct nbd_device *nbd)
        nbd_dev_dbg_init(nbd);
        for (i = 0; i < num_connections; i++) {
                struct recv_thread_args *args;
-
-               args = kzalloc(sizeof(*args), GFP_KERNEL);
+
+               if (i == 1) {
+                       args = NULL;
+                       printk("%s: inject malloc error\n", __func__);
+               }
+               else
+                       args = kzalloc(sizeof(*args), GFP_KERNEL);
2. Inject delay in recv_work
-757,6 +760,8 @@ static void recv_work(struct work_struct *work)

                blk_mq_complete_request(blk_mq_rq_from_pdu(cmd));
        }
+       printk("%s: comm=%s pid=%d\n", __func__, current->comm, current->pid);
+       mdelay(5 * 1000);
        nbd_config_put(nbd);
        atomic_dec(&config->recv_threads);
        wake_up(&config->recv_wq);
3. Create nbd server
nbd-server 8000 /tmp/disk
4. Create nbd client
nbd-client localhost 8000 /dev/nbd1
Then will trigger above issue.

Reason is when add delay in recv_work, lead to release the last reference
of 'nbd->config_refs'. nbd_config_put will call flush_workqueue to make
all work finish. Obviously, it will lead to deadloop.
To solve this issue, according to Josef's suggestion move 'recv_work'
init from start device to nbd_dev_add, then destroy 'recv_work'when
nbd device teardown.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-5-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4ae6c221b36d..582b23befb5c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -254,7 +254,7 @@ static void nbd_dev_remove(struct nbd_device *nbd)
 	mutex_lock(&nbd_index_mutex);
 	idr_remove(&nbd_index_idr, nbd->index);
 	mutex_unlock(&nbd_index_mutex);
-
+	destroy_workqueue(nbd->recv_workq);
 	kfree(nbd);
 }
 
@@ -1260,10 +1260,6 @@ static void nbd_config_put(struct nbd_device *nbd)
 		kfree(nbd->config);
 		nbd->config = NULL;
 
-		if (nbd->recv_workq)
-			destroy_workqueue(nbd->recv_workq);
-		nbd->recv_workq = NULL;
-
 		nbd->tag_set.timeout = 0;
 		nbd->disk->queue->limits.discard_granularity = 0;
 		nbd->disk->queue->limits.discard_alignment = 0;
@@ -1292,14 +1288,6 @@ static int nbd_start_device(struct nbd_device *nbd)
 		return -EINVAL;
 	}
 
-	nbd->recv_workq = alloc_workqueue("knbd%d-recv",
-					  WQ_MEM_RECLAIM | WQ_HIGHPRI |
-					  WQ_UNBOUND, 0, nbd->index);
-	if (!nbd->recv_workq) {
-		dev_err(disk_to_dev(nbd->disk), "Could not allocate knbd recv work queue.\n");
-		return -ENOMEM;
-	}
-
 	blk_mq_update_nr_hw_queues(&nbd->tag_set, config->num_connections);
 	nbd->pid = task_pid_nr(current);
 
@@ -1725,6 +1713,15 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	}
 	nbd->disk = disk;
 
+	nbd->recv_workq = alloc_workqueue("nbd%d-recv",
+					  WQ_MEM_RECLAIM | WQ_HIGHPRI |
+					  WQ_UNBOUND, 0, nbd->index);
+	if (!nbd->recv_workq) {
+		dev_err(disk_to_dev(nbd->disk), "Could not allocate knbd recv work queue.\n");
+		err = -ENOMEM;
+		goto out_err_disk;
+	}
+
 	/*
 	 * Tell the block layer that we are not a rotational device
 	 */
@@ -1755,7 +1752,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->first_minor = index << part_shift;
 	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
-		goto out_err_disk;
+		goto out_free_work;
 	}
 
 	disk->minors = 1 << part_shift;
@@ -1764,7 +1761,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	sprintf(disk->disk_name, "nbd%d", index);
 	err = add_disk(disk);
 	if (err)
-		goto out_err_disk;
+		goto out_free_work;
 
 	/*
 	 * Now publish the device.
@@ -1773,6 +1770,8 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	nbd_total_devices++;
 	return nbd;
 
+out_free_work:
+	destroy_workqueue(nbd->recv_workq);
 out_err_disk:
 	blk_cleanup_disk(disk);
 out_free_idr:
@@ -2028,13 +2027,10 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	nbd_disconnect(nbd);
 	sock_shutdown(nbd);
 	/*
-	 * Make sure recv thread has finished, so it does not drop the last
-	 * config ref and try to destroy the workqueue from inside the work
-	 * queue. And this also ensure that we can safely call nbd_clear_que()
+	 * Make sure recv thread has finished, we can safely call nbd_clear_que()
 	 * to cancel the inflight I/Os.
 	 */
-	if (nbd->recv_workq)
-		flush_workqueue(nbd->recv_workq);
+	flush_workqueue(nbd->recv_workq);
 	nbd_clear_que(nbd);
 	nbd->task_setup = NULL;
 	mutex_unlock(&nbd->config_lock);
-- 
2.35.1



