Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAA92EA285
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbhAEBDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbhAEBBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0866522583;
        Tue,  5 Jan 2021 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808407;
        bh=YLGxne2Z27dnFk+C+c83Jkj5l1wv4USSGsKiDZy/V94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtgX/E8rl7B41WyCPhDhrOMF8/AziVzysW2r2TmS/1Ye2yLo6HAxPXa04gfbnVFMr
         0o/3C4rOGx+9IDhVSucz6Gumg/bShOxkULOOIsOLJjNnq+2TwiAZGi1cVcXVsoveJi
         wWAwO1PULqeKUdgJRtF5oWp165WGcvSq7rxDwAoHQtNmb2xuNDr3GjpKkdmfp8G0mm
         m9TngrBj+7joHcN7LU5ww+8+c3B8yyE1PsKx3i/P5EtOU2/43rQwp74ofBv9nAolP6
         odkIu4j6VcsmvSH7iSir/qqHHjYxYYvq+oHSS5x/rr06rvOEkUH/gmzqAy7b5Yu6fL
         m81yiygclR28Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 5/8] scsi: scsi_transport_spi: Set RQF_PM for domain validation commands
Date:   Mon,  4 Jan 2021 19:59:56 -0500
Message-Id: <20210105005959.3954510-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005959.3954510-1-sashal@kernel.org>
References: <20210105005959.3954510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit cfefd9f8240a7b9fdd96fcd54cb029870b6d8d88 ]

Disable runtime power management during domain validation. Since a later
patch removes RQF_PREEMPT, set RQF_PM for domain validation commands such
that these are executed in the quiesced SCSI device state.

Link: https://lore.kernel.org/r/20201209052951.16136-6-bvanassche@acm.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Woody Suwalski <terraluna977@gmail.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Stan Johnson <userm57@yahoo.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_spi.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 69213842e63e0..efb9c3d902133 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -130,12 +130,16 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		sshdr = &sshdr_tmp;
 
 	for(i = 0; i < DV_RETRIES; i++) {
+		/*
+		 * The purpose of the RQF_PM flag below is to bypass the
+		 * SDEV_QUIESCE state.
+		 */
 		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
 				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
-				      0, NULL);
+				      RQF_PM, NULL);
 		if (driver_byte(result) != DRIVER_SENSE ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -1018,23 +1022,26 @@ spi_dv_device(struct scsi_device *sdev)
 	 */
 	lock_system_sleep();
 
+	if (scsi_autopm_get_device(sdev))
+		goto unlock_system_sleep;
+
 	if (unlikely(spi_dv_in_progress(starget)))
-		goto unlock;
+		goto put_autopm;
 
 	if (unlikely(scsi_device_get(sdev)))
-		goto unlock;
+		goto put_autopm;
 
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
-		goto out_put;
+		goto put_sdev;
 
 	/* We need to verify that the actual device will quiesce; the
 	 * later target quiesce is just a nice to have */
 	if (unlikely(scsi_device_quiesce(sdev)))
-		goto out_free;
+		goto free_buffer;
 
 	scsi_target_quiesce(starget);
 
@@ -1054,12 +1061,16 @@ spi_dv_device(struct scsi_device *sdev)
 
 	spi_initial_dv(starget) = 1;
 
- out_free:
+free_buffer:
 	kfree(buffer);
- out_put:
+
+put_sdev:
 	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
-unlock:
+put_autopm:
+	scsi_autopm_put_device(sdev);
+
+unlock_system_sleep:
 	unlock_system_sleep();
 }
 EXPORT_SYMBOL(spi_dv_device);
-- 
2.27.0

