Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF005B44A7
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiIJGda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiIJGcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:32:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871CCAF483
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AE6DB80682
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39594C433D6;
        Sat, 10 Sep 2022 06:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791557;
        bh=4yFSDVUA70YXzl+zHJCNGpcj1Nuu+iPKxYKmXAZ8Z6o=;
        h=Subject:To:Cc:From:Date:From;
        b=JR8dQJ/gfhVFsHX2bv1OcrcHv1YH7Zd8eEURCeIadYV5BJl6DxrYSAC7wc6xHcPlk
         6NgTs50ET/6tpEwP01MTrnKgOWMKPwczdyqNHlFNaQ6MGjJTy+z1/3TRFSnhW6ak8Y
         lrn538irnrVC/OyiXEE0luVQjBhyfXg+3kXBu0ao=
Subject: FAILED: patch "[PATCH] scsi: core: Fix a use-after-free" failed to apply to 5.15-stable tree
To:     bvanassche@acm.org, hare@suse.de, hch@lst.de,
        john.garry@huawei.com, lizhijian@fujitsu.com,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Sep 2022 08:32:51 +0200
Message-ID: <166279157139198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
6f8191fdf41d ("block: simplify disk shutdown")
0e3534022f26 ("block: stop setting the nomerges flags in blk_cleanup_queue")
1f90307e5f0d ("block: remove QUEUE_FLAG_DEAD")
e8b58ef09e84 ("mtip32xx: fix device removal")
ec5263f422a3 ("mtip32xx: remove the device_status debugfs file")
50e34d78815e ("block: disable the elevator int del_gendisk")
78c6499c9209 ("Merge tag 'for-5.19/drivers-2022-06-02' of git://git.kernel.dk/linux-block")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8fe4ce5836e932f5766317cb651c1ff2a4cd0506 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 25 Aug 2022 17:26:34 -0700
Subject: [PATCH] scsi: core: Fix a use-after-free

There are two .exit_cmd_priv implementations. Both implementations use
resources associated with the SCSI host. Make sure that these resources are
still available when .exit_cmd_priv is called by waiting inside
scsi_remove_host() until the tag set has been freed.

This commit fixes the following use-after-free:

==================================================================
BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
Read of size 8 at addr ffff888100337000 by task multipathd/16727
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x5e/0x5db
 kasan_report+0xab/0x120
 srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
 scsi_mq_exit_request+0x4d/0x70
 blk_mq_free_rqs+0x143/0x410
 __blk_mq_free_map_and_rqs+0x6e/0x100
 blk_mq_free_tag_set+0x2b/0x160
 scsi_host_dev_release+0xf3/0x1a0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_device_dev_release_usercontext+0x4c1/0x4e0
 execute_in_process_context+0x23/0x90
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_disk_release+0x3f/0x50
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 disk_release+0x17f/0x1b0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 dm_put_table_device+0xa3/0x160 [dm_mod]
 dm_put_device+0xd0/0x140 [dm_mod]
 free_priority_group+0xd8/0x110 [dm_multipath]
 free_multipath+0x94/0xe0 [dm_multipath]
 dm_table_destroy+0xa2/0x1e0 [dm_mod]
 __dm_destroy+0x196/0x350 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x2c2/0x590 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Link: https://lore.kernel.org/r/20220826002635.919423-1-bvanassche@acm.org
Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 26bf3b153595..9857dba09c95 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -182,6 +182,15 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
+	/*
+	 * New SCSI devices cannot be attached anymore because of the SCSI host
+	 * state so drop the tag set refcnt. Wait until the tag set refcnt drops
+	 * to zero because .exit_cmd_priv implementations may need the host
+	 * pointer.
+	 */
+	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
+	wait_for_completion(&shost->tagset_freed);
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
@@ -245,6 +254,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto fail;
 
+	kref_init(&shost->tagset_refcnt);
+	init_completion(&shost->tagset_freed);
+
 	/*
 	 * Increase usage count temporarily here so that calling
 	 * scsi_autopm_put_host() will trigger runtime idle if there is
@@ -317,6 +329,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
+	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
  fail:
 	return error;
 }
@@ -350,9 +363,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-	if (shost->tag_set.tags)
-		scsi_mq_destroy_tags(shost);
-
 	kfree(shost->shost_data);
 
 	ida_free(&host_index_ida, shost->host_no);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ef08029a0079..96e7e3eaca29 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1983,9 +1983,13 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	return blk_mq_alloc_tag_set(tag_set);
 }
 
-void scsi_mq_destroy_tags(struct Scsi_Host *shost)
+void scsi_mq_free_tags(struct kref *kref)
 {
+	struct Scsi_Host *shost = container_of(kref, typeof(*shost),
+					       tagset_refcnt);
+
 	blk_mq_free_tag_set(&shost->tag_set);
+	complete(&shost->tagset_freed);
 }
 
 /**
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 429663bd78ec..f385b3f04d6e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -94,7 +94,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
-extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
+extern void scsi_mq_free_tags(struct kref *kref);
 extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a6682..5d27f5196de6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -340,6 +340,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
+	kref_get(&sdev->host->tagset_refcnt);
 	sdev->request_queue = q;
 	q->queuedata = sdev;
 	__scsi_init_queue(sdev->host, q);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index aa70d9282161..5d61f58399dc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1476,6 +1476,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	mutex_unlock(&sdev->state_mutex);
 
 	blk_mq_destroy_queue(sdev->request_queue);
+	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 
 	if (sdev->host->hostt->slave_destroy)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b6e41ee3d566..9b0a028bf053 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -557,6 +557,8 @@ struct Scsi_Host {
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
 
+	struct kref		tagset_refcnt;
+	struct completion	tagset_freed;
 	/* Area to keep a shared tag map */
 	struct blk_mq_tag_set	tag_set;
 

