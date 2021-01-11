Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A92F1494
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbhAKN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:27:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbhAKNQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FC4B22795;
        Mon, 11 Jan 2021 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370982;
        bh=xoTRx8qQQtnSaYwMqIVpCPfEi1lceBrcYZvQ/URSaLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WEC4PZthogNisB/afzVTfzPhFfJbIbfQPv09mcXhCgJOKT9LPab4Wqa7fwNhAOWR
         xHGGOuk/d/VGDFWxZv+WWOwk0mKEUxTSLRjkzeQifbG278LjXSJvhGn4EIOzHsb3O0
         lZZTTBuuQJJ5dlZkSWOYAyDUOvf0ANA6ZVARTjEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/145] scsi: scsi_transport_spi: Set RQF_PM for domain validation commands
Date:   Mon, 11 Jan 2021 14:01:26 +0100
Message-Id: <20210111130051.525597037@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f3d5b1bbd5aa7..c37dd15d16d24 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -117,12 +117,16 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
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
@@ -1005,23 +1009,26 @@ spi_dv_device(struct scsi_device *sdev)
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
 
@@ -1041,12 +1048,16 @@ spi_dv_device(struct scsi_device *sdev)
 
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



