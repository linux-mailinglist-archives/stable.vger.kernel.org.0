Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A3E595060
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiHPEmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiHPEk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB62A4B1C;
        Mon, 15 Aug 2022 13:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A73B5B80EB1;
        Mon, 15 Aug 2022 20:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB1C433C1;
        Mon, 15 Aug 2022 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595501;
        bh=BQ1s9s0dZ/Sag+DLBsLkFGFSRatq94lhF0DW1njR9H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw8194Z39gJWrDTHDWexBJwwy9lpVMV4O5BAawO8505P9mhCckF/yfdG0y4Zhk5ur
         1PxqSZbBT6jB+drHJj8iMJvkLthZ8z8LBcBo2mUOpzuO7Y8JvIfJb8q8M58WysjQI0
         0HocyKzXae59pLqQT/fWwMI7JKcyZpzZRtjl9MNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>, ericspero@icloud.com,
        jason600.groome@gmail.com, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0784/1157] scsi: sd: Rework asynchronous resume support
Date:   Mon, 15 Aug 2022 20:02:20 +0200
Message-Id: <20220815180510.851284927@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 88f1669019bd62b3009a3cebf772fbaaa21b9f38 ]

For some technologies, e.g. an ATA bus, resuming can take multiple
seconds. Waiting for resume to finish can cause a very noticeable delay.
Hence this commit that restores the behavior from before "scsi: core: pm:
Rely on the device driver core for async power management" for most SCSI
devices.

This commit introduces a behavior change: if the START command fails, do
not consider this as a SCSI disk resume failure.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215880
Link: https://lore.kernel.org/r/20220630195703.10155-3-bvanassche@acm.org
Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: ericspero@icloud.com
Cc: jason600.groome@gmail.com
Tested-by: jason600.groome@gmail.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 84 +++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/sd.h |  5 +++
 2 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1a2ac09066f..081e39b3543b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -103,6 +103,7 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
+static void sd_start_done_work(struct work_struct *work);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
@@ -3463,6 +3464,7 @@ static int sd_probe(struct device *dev)
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
+	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
@@ -3585,12 +3587,69 @@ static void scsi_disk_release(struct device *dev)
 	kfree(sdkp);
 }
 
+/* Process sense data after a START command finished. */
+static void sd_start_done_work(struct work_struct *work)
+{
+	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
+					      start_done_work);
+	struct scsi_sense_hdr sshdr;
+	int res = sdkp->start_result;
+
+	if (res == 0)
+		return;
+
+	sd_print_result(sdkp, "Start/Stop Unit failed", res);
+
+	if (res < 0)
+		return;
+
+	if (scsi_normalize_sense(sdkp->start_sense_buffer,
+				 sdkp->start_sense_len, &sshdr))
+		sd_print_sense_hdr(sdkp, &sshdr);
+}
+
+/* A START command finished. May be called from interrupt context. */
+static void sd_start_done(struct request *req, blk_status_t status)
+{
+	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
+
+	sdkp->start_result = scmd->result;
+	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
+	sdkp->start_sense_len = scmd->sense_len;
+	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer,
+	       ARRAY_SIZE(sdkp->start_sense_buffer));
+	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
+}
+
+/* Submit a START command asynchronously. */
+static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
+{
+	struct scsi_device *sdev = sdkp->device;
+	struct request_queue *q = sdev->request_queue;
+	struct request *req;
+	struct scsi_cmnd *scmd;
+
+	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = cmd_len;
+	memcpy(scmd->cmnd, cmd, cmd_len);
+	scmd->allowed = sdkp->max_retries;
+	req->timeout = SD_TIMEOUT;
+	req->rq_flags |= RQF_PM | RQF_QUIET;
+	req->end_io = sd_start_done;
+	blk_execute_rq_nowait(req, /*at_head=*/true);
+
+	return 0;
+}
+
 static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp = sdkp->device;
-	int res;
 
 	if (start)
 		cmd[4] |= 1;	/* START */
@@ -3601,23 +3660,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
-	if (res) {
-		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (res > 0 && scsi_sense_valid(&sshdr)) {
-			sd_print_sense_hdr(sdkp, &sshdr);
-			/* 0x3a is medium not present */
-			if (sshdr.asc == 0x3a)
-				res = 0;
-		}
-	}
+	/* Wait until processing of sense data has finished. */
+	flush_work(&sdkp->start_done_work);
 
-	/* SCSI error codes must not go to the generic layer */
-	if (res)
-		return -EIO;
-
-	return 0;
+	return sd_submit_start(sdkp, cmd, sizeof(cmd));
 }
 
 /*
@@ -3644,6 +3690,8 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
+
+	flush_work(&sdkp->start_done_work);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5eea762f84d1..b89187761d61 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -150,6 +150,11 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+
+	int		start_result;
+	u32		start_sense_len;
+	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	struct work_struct start_done_work;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
-- 
2.35.1



