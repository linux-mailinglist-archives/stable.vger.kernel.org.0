Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747253CE21C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347730AbhGSP3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348366AbhGSPYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF5B6113B;
        Mon, 19 Jul 2021 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710694;
        bh=f6v+W19WU6zo6CYrTciTBaTYuk7F/RFaEF19f/evDyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ddt4FFkfpZ7tFiY3S5YM1FJViXJ+EhAiZYMGMjd+fNSIroduX/wXY9kmnssFE4Lc
         Zx/ZDopa/MOk7Bh/5hmATl8kBo8Cgrqkk8B1QDFK/cMPxVLjGxvOeUlW8J/MoMiXYC
         0DLd9b2FAiB+a+9e2pnNlUr3MRmSQh8ut6DXsx1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 074/351] scsi: core: Fixup calling convention for scsi_mode_sense()
Date:   Mon, 19 Jul 2021 16:50:20 +0200
Message-Id: <20210719144946.951393642@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 269bfb8f9165..89560562d9f6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2094,9 +2094,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
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
@@ -2143,6 +2141,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
 				  sshdr, timeout, retries, NULL);
+	if (result < 0)
+		return result;
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
@@ -2187,13 +2187,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
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
index a2c3d9ad9ee4..4df54d4b3c65 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2684,18 +2684,18 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
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
@@ -2756,7 +2756,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
 			&data, &sshdr);
 
-	if (!scsi_status_is_good(res))
+	if (res < 0)
 		goto bad_sense;
 
 	if (!data.header_length) {
@@ -2788,7 +2788,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
 				&data, &sshdr);
 
-	if (scsi_status_is_good(res)) {
+	if (!res) {
 		int offset = data.header_length + data.block_descriptor_length;
 
 		while (offset < len) {
@@ -2906,7 +2906,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
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



