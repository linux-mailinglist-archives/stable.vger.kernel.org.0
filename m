Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D63C2DF7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhGJCZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233155AbhGJCZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1B8613D4;
        Sat, 10 Jul 2021 02:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883759;
        bh=XnDN9pY6kL83puQnuylqwJPtm5AH+qDJ7djfVJQ4clA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trUuq5FS0A9ASyeZf4mjBV1UWhZafv1sVtlmBVTfWRW6/ZpcSgtz64VvoReU9EQbC
         9Uq11b4h5Z0UpaH65gt9OJBHTuFC5SNTek8l5SZiY2QPKKBaDKfohdlLZQL2URCagK
         FPjhpPBWEsqS/rW6/fj/yp3/pnOJ8y/QeMuv3wZofEwhh7Js63+zz3MEexJchpxpdN
         ABdaZpBTCXLBvV0kQ/EyewXl6KTNuwwj+2Ndhm/qwTgZupRJ/yjgyDZJ0/O2nkfPxo
         AprFf6a/TbR1mxEDTmZmkeen0tGqbLTHKuzfkAKwiQfFbqInFjRhKExB4H8igAhhP6
         1qHiGtoRhHlGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 033/104] scsi: core: Fixup calling convention for scsi_mode_sense()
Date:   Fri,  9 Jul 2021 22:20:45 -0400
Message-Id: <20210710022156.3168825-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 8793613de913e03e7c884f4cc56e350bc716431e ]

The description for scsi_mode_sense() claims to return the number of valid
bytes on success, which is not what the code does.  Additionally there is
no gain in returning the SCSI status, as everything the callers do is to
check against scsi_result_is_good(), which is what scsi_mode_sense() does
already.  So change the calling convention to return a standard error code
on failure, and 0 on success, and adapt the description and all callers.

Link: https://lore.kernel.org/r/20210427083046.31620-4-hare@suse.de
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c           | 10 ++++++----
 drivers/scsi/scsi_transport_sas.c |  9 ++++-----
 drivers/scsi/sd.c                 | 12 ++++++------
 drivers/scsi/sr.c                 |  2 +-
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d52a11e1b61..333342a08b5d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2080,9 +2080,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
- *	Returns zero if unsuccessful, or the header offset (either 4
- *	or 8 depending on whether a six or ten byte command was
- *	issued) if successful.
+ *	Returns zero if successful, or a negative error number on failure
  */
 int
 scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
@@ -2129,6 +2127,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
 				  sshdr, timeout, retries, NULL);
+	if (result < 0)
+		return result;
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
@@ -2173,13 +2173,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			data->block_descriptor_length = buffer[3];
 		}
 		data->header_length = header_length;
+		result = 0;
 	} else if ((status_byte(result) == CHECK_CONDITION) &&
 		   scsi_sense_valid(sshdr) &&
 		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
 		retry_count--;
 		goto retry;
 	}
-
+	if (result > 0)
+		result = -EIO;
 	return result;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index c9abed8429c9..4a96fb05731d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1229,16 +1229,15 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	char *buffer = kzalloc(BUF_SIZE, GFP_KERNEL), *msdata;
 	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
 	struct scsi_mode_data mode_data;
-	int res, error;
+	int error;
 
 	if (!buffer)
 		return -ENOMEM;
 
-	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
-			      &mode_data, NULL);
+	error = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+				&mode_data, NULL);
 
-	error = -EINVAL;
-	if (!scsi_status_is_good(res))
+	if (error)
 		goto out;
 
 	msdata = buffer +  mode_data.header_length +
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a0356f3707b8..3431ac12b730 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2683,18 +2683,18 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * 5: Illegal Request, Sense Code 24: Invalid field in
 		 * CDB.
 		 */
-		if (!scsi_status_is_good(res))
+		if (res < 0)
 			res = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
 		 */
-		if (!scsi_status_is_good(res))
+		if (res < 0)
 			res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
 					       &data, NULL);
 	}
 
-	if (!scsi_status_is_good(res)) {
+	if (res < 0) {
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
@@ -2755,7 +2755,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
 			&data, &sshdr);
 
-	if (!scsi_status_is_good(res))
+	if (res < 0)
 		goto bad_sense;
 
 	if (!data.header_length) {
@@ -2787,7 +2787,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
 				&data, &sshdr);
 
-	if (scsi_status_is_good(res)) {
+	if (!res) {
 		int offset = data.header_length + data.block_descriptor_length;
 
 		while (offset < len) {
@@ -2905,7 +2905,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
-	if (!scsi_status_is_good(res) || !data.header_length ||
+	if (res < 0 || !data.header_length ||
 	    data.length < 6) {
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7815ed642d43..1a94c7b1de2d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -913,7 +913,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
-	if (!scsi_status_is_good(rc) || data.length > ms_len ||
+	if (rc < 0 || data.length > ms_len ||
 	    data.header_length + data.block_descriptor_length > data.length) {
 		/* failed, drive doesn't have capabilities mode page */
 		cd->cdi.speed = 1;
-- 
2.30.2

