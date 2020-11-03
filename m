Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C170C2A590C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbgKCUnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730754AbgKCUnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A168223C7;
        Tue,  3 Nov 2020 20:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436224;
        bh=3OOrxqRWQzt4kxk9gKhyKovE4zCUlFJ91aizshdFYqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IO/qxVcgi7dICE9z0YWcg4F5Crn2D133LMqa9rQ+dB6926kKay8SJKUyLfg12lb6x
         mvnUVpKMUqL/S1B552xKREiK74Aod3S1G0d7lGNAKHWSIiwZl5l/2Am+Niv0TV6DNO
         /UwVi2fVCvoL/0Gyl2VzEw7Z7WSPpR86Mit3ZLzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 157/391] scsi: core: Clean up allocation and freeing of sgtables
Date:   Tue,  3 Nov 2020 21:33:28 +0100
Message-Id: <20201103203357.427455522@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7007e9dd56767a95de0947b3f7599bcc2f21687f ]

Rename scsi_init_io() to scsi_alloc_sgtables(), and ensure callers call
scsi_free_sgtables() to cleanup failures close to scsi_init_io() instead of
leaking it down the generic I/O submission path.

Link: https://lore.kernel.org/r/20201005084130.143273-9-hch@lst.de
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c  | 22 ++++++++--------------
 drivers/scsi/sd.c        | 27 +++++++++++++++------------
 drivers/scsi/sr.c        | 16 ++++++----------
 include/scsi/scsi_cmnd.h |  3 ++-
 4 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7affaaf8b98e0..198130b6a9963 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -530,7 +530,7 @@ static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
-static void scsi_free_sgtables(struct scsi_cmnd *cmd)
+void scsi_free_sgtables(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
 		sg_free_table_chained(&cmd->sdb.table,
@@ -539,6 +539,7 @@ static void scsi_free_sgtables(struct scsi_cmnd *cmd)
 		sg_free_table_chained(&cmd->prot_sdb->table,
 				SCSI_INLINE_PROT_SG_CNT);
 }
+EXPORT_SYMBOL_GPL(scsi_free_sgtables);
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
@@ -966,7 +967,7 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
 }
 
 /**
- * scsi_init_io - SCSI I/O initialization function.
+ * scsi_alloc_sgtables - allocate S/G tables for a command
  * @cmd:  command descriptor we wish to initialize
  *
  * Returns:
@@ -974,7 +975,7 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
  * * BLK_STS_RESOURCE - if the failure is retryable
  * * BLK_STS_IOERR    - if the failure is fatal
  */
-blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
+blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
@@ -1066,7 +1067,7 @@ out_free_sgtables:
 	scsi_free_sgtables(cmd);
 	return ret;
 }
-EXPORT_SYMBOL(scsi_init_io);
+EXPORT_SYMBOL(scsi_alloc_sgtables);
 
 /**
  * scsi_initialize_rq - initialize struct scsi_cmnd partially
@@ -1154,7 +1155,7 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	 * submit a request without an attached bio.
 	 */
 	if (req->bio) {
-		blk_status_t ret = scsi_init_io(cmd);
+		blk_status_t ret = scsi_alloc_sgtables(cmd);
 		if (unlikely(ret != BLK_STS_OK))
 			return ret;
 	} else {
@@ -1194,7 +1195,6 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 		struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-	blk_status_t ret;
 
 	if (!blk_rq_bytes(req))
 		cmd->sc_data_direction = DMA_NONE;
@@ -1204,14 +1204,8 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
 
 	if (blk_rq_is_scsi(req))
-		ret = scsi_setup_scsi_cmnd(sdev, req);
-	else
-		ret = scsi_setup_fs_cmnd(sdev, req);
-
-	if (ret != BLK_STS_OK)
-		scsi_free_sgtables(cmd);
-
-	return ret;
+		return scsi_setup_scsi_cmnd(sdev, req);
+	return scsi_setup_fs_cmnd(sdev, req);
 }
 
 static blk_status_t
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 16503e22691ed..e93a9a874004f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -866,7 +866,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
-	return scsi_init_io(cmd);
+	return scsi_alloc_sgtables(cmd);
 }
 
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
@@ -897,7 +897,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_init_io(cmd);
+	return scsi_alloc_sgtables(cmd);
 }
 
 static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
@@ -928,7 +928,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_init_io(cmd);
+	return scsi_alloc_sgtables(cmd);
 }
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
@@ -1069,7 +1069,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	 * knows how much to actually write.
 	 */
 	rq->__data_len = sdp->sector_size;
-	ret = scsi_init_io(cmd);
+	ret = scsi_alloc_sgtables(cmd);
 	rq->__data_len = blk_rq_bytes(rq);
 
 	return ret;
@@ -1187,23 +1187,24 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	unsigned int dif;
 	bool dix;
 
-	ret = scsi_init_io(cmd);
+	ret = scsi_alloc_sgtables(cmd);
 	if (ret != BLK_STS_OK)
 		return ret;
 
+	ret = BLK_STS_IOERR;
 	if (!scsi_device_online(sdp) || sdp->changed) {
 		scmd_printk(KERN_ERR, cmd, "device offline or changed\n");
-		return BLK_STS_IOERR;
+		goto fail;
 	}
 
 	if (blk_rq_pos(rq) + blk_rq_sectors(rq) > get_capacity(rq->rq_disk)) {
 		scmd_printk(KERN_ERR, cmd, "access beyond end of device\n");
-		return BLK_STS_IOERR;
+		goto fail;
 	}
 
 	if ((blk_rq_pos(rq) & mask) || (blk_rq_sectors(rq) & mask)) {
 		scmd_printk(KERN_ERR, cmd, "request not aligned to the logical block size\n");
-		return BLK_STS_IOERR;
+		goto fail;
 	}
 
 	/*
@@ -1225,7 +1226,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (req_op(rq) == REQ_OP_ZONE_APPEND) {
 		ret = sd_zbc_prepare_zone_append(cmd, &lba, nr_blocks);
 		if (ret)
-			return ret;
+			goto fail;
 	}
 
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
@@ -1253,7 +1254,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	}
 
 	if (unlikely(ret != BLK_STS_OK))
-		return ret;
+		goto fail;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -1277,10 +1278,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 				     blk_rq_sectors(rq)));
 
 	/*
-	 * This indicates that the command is ready from our end to be
-	 * queued.
+	 * This indicates that the command is ready from our end to be queued.
 	 */
 	return BLK_STS_OK;
+fail:
+	scsi_free_sgtables(cmd);
+	return ret;
 }
 
 static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 3b3a53c6a0de5..7e8fe55f3b339 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -392,15 +392,11 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	struct request *rq = SCpnt->request;
 	blk_status_t ret;
 
-	ret = scsi_init_io(SCpnt);
+	ret = scsi_alloc_sgtables(SCpnt);
 	if (ret != BLK_STS_OK)
-		goto out;
+		return ret;
 	cd = scsi_cd(rq->rq_disk);
 
-	/* from here on until we're complete, any goto out
-	 * is used for a killable error condition */
-	ret = BLK_STS_IOERR;
-
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
 		"Doing sr request, block = %d\n", block));
 
@@ -509,12 +505,12 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	SCpnt->allowed = MAX_RETRIES;
 
 	/*
-	 * This indicates that the command is ready from our end to be
-	 * queued.
+	 * This indicates that the command is ready from our end to be queued.
 	 */
-	ret = BLK_STS_OK;
+	return BLK_STS_OK;
  out:
-	return ret;
+	scsi_free_sgtables(SCpnt);
+	return BLK_STS_IOERR;
 }
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index e76bac4d14c51..69ade4fb71aab 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -165,7 +165,8 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern blk_status_t scsi_init_io(struct scsi_cmnd *cmd);
+blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd);
+void scsi_free_sgtables(struct scsi_cmnd *cmd);
 
 #ifdef CONFIG_SCSI_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
-- 
2.27.0



