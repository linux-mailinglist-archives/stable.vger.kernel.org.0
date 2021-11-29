Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCB6461F6C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379434AbhK2SrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57668 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378982AbhK2SpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:45:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 667F2CE140F;
        Mon, 29 Nov 2021 18:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D6EC53FC7;
        Mon, 29 Nov 2021 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211307;
        bh=04xVF3T5nC7vcGXAd2bJIfnS6mEcrWQmWAs66rWzxmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tN5K0u3ZPc6K+vkl9Ww7uruOx5vHjTiX3VUye6GaYL8rLBKIswURqUNua0VI4ROe9
         12j8JyLu/zeAJ88gaoKfNorwaAq7JByRDkrXiLeKcdPnn5dWo86jcp+cVocDd/f53r
         c/cCcPekuyHEimm+LMi61kXNtdmL18Scu4DDhJOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChanghuiZhong <czhong@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 176/179] blk-mq: cancel blk-mq dispatch work in both blk_cleanup_queue and disk_release()
Date:   Mon, 29 Nov 2021 19:19:30 +0100
Message-Id: <20211129181724.729522635@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 2a19b28f7929866e1cec92a3619f4de9f2d20005 upstream.

For avoiding to slow down queue destroy, we don't call
blk_mq_quiesce_queue() in blk_cleanup_queue(), instead of delaying to
cancel dispatch work in blk_release_queue().

However, this way has caused kernel oops[1], reported by Changhui. The log
shows that scsi_device can be freed before running blk_release_queue(),
which is expected too since scsi_device is released after the scsi disk
is closed and the scsi_device is removed.

Fixes the issue by canceling blk-mq dispatch work in both blk_cleanup_queue()
and disk_release():

1) when disk_release() is run, the disk has been closed, and any sync
dispatch activities have been done, so canceling dispatch work is enough to
quiesce filesystem I/O dispatch activity.

2) in blk_cleanup_queue(), we only focus on passthrough request, and
passthrough request is always explicitly allocated & freed by
its caller, so once queue is frozen, all sync dispatch activity
for passthrough request has been done, then it is enough to just cancel
dispatch work for avoiding any dispatch activity.

[1] kernel panic log
[12622.769416] BUG: kernel NULL pointer dereference, address: 0000000000000300
[12622.777186] #PF: supervisor read access in kernel mode
[12622.782918] #PF: error_code(0x0000) - not-present page
[12622.788649] PGD 0 P4D 0
[12622.791474] Oops: 0000 [#1] PREEMPT SMP PTI
[12622.796138] CPU: 10 PID: 744 Comm: kworker/10:1H Kdump: loaded Not tainted 5.15.0+ #1
[12622.804877] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 1.5.4 10/002/2015
[12622.813321] Workqueue: kblockd blk_mq_run_work_fn
[12622.818572] RIP: 0010:sbitmap_get+0x75/0x190
[12622.823336] Code: 85 80 00 00 00 41 8b 57 08 85 d2 0f 84 b1 00 00 00 45 31 e4 48 63 cd 48 8d 1c 49 48 c1 e3 06 49 03 5f 10 4c 8d 6b 40 83 f0 01 <48> 8b 33 44 89 f2 4c 89 ef 0f b6 c8 e8 fa f3 ff ff 83 f8 ff 75 58
[12622.844290] RSP: 0018:ffffb00a446dbd40 EFLAGS: 00010202
[12622.850120] RAX: 0000000000000001 RBX: 0000000000000300 RCX: 0000000000000004
[12622.858082] RDX: 0000000000000006 RSI: 0000000000000082 RDI: ffffa0b7a2dfe030
[12622.866042] RBP: 0000000000000004 R08: 0000000000000001 R09: ffffa0b742721334
[12622.874003] R10: 0000000000000008 R11: 0000000000000008 R12: 0000000000000000
[12622.881964] R13: 0000000000000340 R14: 0000000000000000 R15: ffffa0b7a2dfe030
[12622.889926] FS:  0000000000000000(0000) GS:ffffa0baafb40000(0000) knlGS:0000000000000000
[12622.898956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12622.905367] CR2: 0000000000000300 CR3: 0000000641210001 CR4: 00000000001706e0
[12622.913328] Call Trace:
[12622.916055]  <TASK>
[12622.918394]  scsi_mq_get_budget+0x1a/0x110
[12622.922969]  __blk_mq_do_dispatch_sched+0x1d4/0x320
[12622.928404]  ? pick_next_task_fair+0x39/0x390
[12622.933268]  __blk_mq_sched_dispatch_requests+0xf4/0x140
[12622.939194]  blk_mq_sched_dispatch_requests+0x30/0x60
[12622.944829]  __blk_mq_run_hw_queue+0x30/0xa0
[12622.949593]  process_one_work+0x1e8/0x3c0
[12622.954059]  worker_thread+0x50/0x3b0
[12622.958144]  ? rescuer_thread+0x370/0x370
[12622.962616]  kthread+0x158/0x180
[12622.966218]  ? set_kthread_struct+0x40/0x40
[12622.970884]  ret_from_fork+0x22/0x30
[12622.974875]  </TASK>
[12622.977309] Modules linked in: scsi_debug rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs sunrpc dm_multipath intel_rapl_msr intel_rapl_common dell_wmi_descriptor sb_edac rfkill video x86_pkg_temp_thermal intel_powerclamp dcdbas coretemp kvm_intel kvm mgag200 irqbypass i2c_algo_bit rapl drm_kms_helper ipmi_ssif intel_cstate intel_uncore syscopyarea sysfillrect sysimgblt fb_sys_fops pcspkr cec mei_me lpc_ich mei ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sr_mod cdrom sd_mod t10_pi sg ixgbe ahci libahci crct10dif_pclmul crc32_pclmul crc32c_intel libata megaraid_sas ghash_clmulni_intel tg3 wdat_wdt mdio dca wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug]

Reported-by: ChanghuiZhong <czhong@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20211116014343.610501-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c  |    4 +++-
 block/blk-mq.c    |   13 +++++++++++++
 block/blk-mq.h    |    2 ++
 block/blk-sysfs.c |   10 ----------
 block/genhd.c     |    2 ++
 5 files changed, 20 insertions(+), 11 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -389,8 +389,10 @@ void blk_cleanup_queue(struct request_qu
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
 	blk_sync_queue(q);
-	if (queue_is_mq(q))
+	if (queue_is_mq(q)) {
+		blk_mq_cancel_work_sync(q);
 		blk_mq_exit_queue(q);
+	}
 
 	/*
 	 * In theory, request pool of sched_tags belongs to request queue.
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4018,6 +4018,19 @@ unsigned int blk_mq_rq_cpu(struct reques
 }
 EXPORT_SYMBOL(blk_mq_rq_cpu);
 
+void blk_mq_cancel_work_sync(struct request_queue *q)
+{
+	if (queue_is_mq(q)) {
+		struct blk_mq_hw_ctx *hctx;
+		int i;
+
+		cancel_delayed_work_sync(&q->requeue_work);
+
+		queue_for_each_hw_ctx(q, hctx, i)
+			cancel_delayed_work_sync(&hctx->run_work);
+	}
+}
+
 static int __init blk_mq_init(void)
 {
 	int i;
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -129,6 +129,8 @@ extern int blk_mq_sysfs_register(struct
 extern void blk_mq_sysfs_unregister(struct request_queue *q);
 extern void blk_mq_hctx_kobj_init(struct blk_mq_hw_ctx *hctx);
 
+void blk_mq_cancel_work_sync(struct request_queue *q);
+
 void blk_mq_release(struct request_queue *q);
 
 static inline struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -805,16 +805,6 @@ static void blk_release_queue(struct kob
 
 	blk_free_queue_stats(q->stats);
 
-	if (queue_is_mq(q)) {
-		struct blk_mq_hw_ctx *hctx;
-		int i;
-
-		cancel_delayed_work_sync(&q->requeue_work);
-
-		queue_for_each_hw_ctx(q, hctx, i)
-			cancel_delayed_work_sync(&hctx->run_work);
-	}
-
 	blk_exit_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1086,6 +1086,8 @@ static void disk_release(struct device *
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
+	blk_mq_cancel_work_sync(disk->queue);
+
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);


