Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F008123A5F9
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgHCM34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgHCM3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:29:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 819AD2086A;
        Mon,  3 Aug 2020 12:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457790;
        bh=vuJ+vdrsK92pRbi+okBw0ZX4DDztUCvpyo3YbmCm25U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BV5/TLjbOmMQPTNnh3rqvm2m9sNtAGgr8Hl5NO1VB2XU82eIzibMKzqlahhxn7c5e
         z7b3pj5OXfFwURz+MsG/UW3Jw6M/QpwVcahREnVFBHdSpOtDGPQ7VpieQry2hkTsVv
         zzwTrXlsZUndTLCoptNCU7z6rq5fkgCBqpnWIV9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 75/90] scsi: core: Run queue in case of I/O resource contention failure
Date:   Mon,  3 Aug 2020 14:19:37 +0200
Message-Id: <20200803121901.242202603@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3f0dcfbcd2e162fc0a11c1f59b7acd42ee45f126 ]

I/O requests may be held in scheduler queue because of resource contention.
The starvation scenario was handled properly in the regular completion
path but we failed to account for it during I/O submission. This lead to
the hang captured below. Make sure we run the queue when resource
contention is encountered in the submission path.

[   39.054963] scsi 13:0:0:0: rejecting I/O to dead device
[   39.058700] scsi 13:0:0:0: rejecting I/O to dead device
[   39.087855] sd 13:0:0:1: [sdd] Synchronizing SCSI cache
[   39.088909] scsi 13:0:0:1: rejecting I/O to dead device
[   39.095351] scsi 13:0:0:1: rejecting I/O to dead device
[   39.096962] scsi 13:0:0:1: rejecting I/O to dead device
[  247.021859] INFO: task scsi-stress-rem:813 blocked for more than 122 seconds.
[  247.023258]       Not tainted 5.8.0-rc2 #8
[  247.024069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.025331] scsi-stress-rem D    0   813    802 0x00004000
[  247.025334] Call Trace:
[  247.025354]  __schedule+0x504/0x55f
[  247.027987]  schedule+0x72/0xa8
[  247.027991]  blk_mq_freeze_queue_wait+0x63/0x8c
[  247.027994]  ? do_wait_intr_irq+0x7a/0x7a
[  247.027996]  blk_cleanup_queue+0x4b/0xc9
[  247.028000]  __scsi_remove_device+0xf6/0x14e
[  247.028002]  scsi_remove_device+0x21/0x2b
[  247.029037]  sdev_store_delete+0x58/0x7c
[  247.029041]  kernfs_fop_write+0x10d/0x14f
[  247.031281]  vfs_write+0xa2/0xdf
[  247.032670]  ksys_write+0x6b/0xb3
[  247.032673]  do_syscall_64+0x56/0x82
[  247.034053]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  247.034059] RIP: 0033:0x7f69f39e9008
[  247.036330] Code: Bad RIP value.
[  247.036331] RSP: 002b:00007ffdd8116498 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  247.037613] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f69f39e9008
[  247.039714] RDX: 0000000000000002 RSI: 000055cde92a0ab0 RDI: 0000000000000001
[  247.039715] RBP: 000055cde92a0ab0 R08: 000000000000000a R09: 00007f69f3a79e80
[  247.039716] R10: 000000000000000a R11: 0000000000000246 R12: 00007f69f3abb780
[  247.039717] R13: 0000000000000002 R14: 00007f69f3ab6740 R15: 0000000000000002

Link: https://lore.kernel.org/r/20200720025435.812030-1-ming.lei@redhat.com
Cc: linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 206c9f53e9e7a..e6944e1cba2ba 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -568,6 +568,15 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	scsi_del_cmd_from_list(cmd);
 }
 
+static void scsi_run_queue_async(struct scsi_device *sdev)
+{
+	if (scsi_target(sdev)->single_lun ||
+	    !list_empty(&sdev->host->starved_list))
+		kblockd_schedule_work(&sdev->requeue_work);
+	else
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 /* Returns false when no more bytes to process, true if there are more */
 static bool scsi_end_request(struct request *req, blk_status_t error,
 		unsigned int bytes)
@@ -612,11 +621,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 
 	__blk_mq_end_request(req, error);
 
-	if (scsi_target(sdev)->single_lun ||
-	    !list_empty(&sdev->host->starved_list))
-		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(q, true);
+	scsi_run_queue_async(sdev);
 
 	percpu_ref_put(&q->q_usage_counter);
 	return false;
@@ -1729,6 +1734,7 @@ out_put_budget:
 		 */
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
+		scsi_run_queue_async(sdev);
 		break;
 	}
 	return ret;
-- 
2.25.1



