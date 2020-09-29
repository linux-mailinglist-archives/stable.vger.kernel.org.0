Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E627CC05
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733028AbgI2McU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729090AbgI2LW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4097421D7F;
        Tue, 29 Sep 2020 11:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378440;
        bh=R0cYLuCf/RXxmg0SWDR4nzFewjhj6tgTJf0VaNdYvKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxWruyjHFfqCMu529eCZ0NRV2mtqLZjKN25LjwFC21buUASgtMe6iumLDO72hKIOn
         ZN7ukhT8lLhq3a+EJZkyyewrdXX93OVYsD7giKkJV+hYXyQwlyZ3lC2REe+MJBNfjh
         OPWpPUFOop92XRiM5OnIDr25EeTaH2OoTorO5hTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balsundar P <balsundar.p@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/245] scsi: aacraid: fix illegal IO beyond last LBA
Date:   Tue, 29 Sep 2020 12:57:38 +0200
Message-Id: <20200929105947.344854342@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balsundar P <balsundar.p@microsemi.com>

[ Upstream commit c86fbe484c10b2cd1e770770db2d6b2c88801c1d ]

The driver fails to handle data when read or written beyond device reported
LBA, which triggers kernel panic

Link: https://lore.kernel.org/r/1571120524-6037-2-git-send-email-balsundar.p@microsemi.com
Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/aachba.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 6e356325d8d98..54717fb84a54c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2481,13 +2481,13 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
 			SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
-			  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
+			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
 		scsicmd->scsi_done(scsicmd);
-		return 1;
+		return 0;
 	}
 
 	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
@@ -2573,13 +2573,13 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
 			SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
-			  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
+			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
 		scsicmd->scsi_done(scsicmd);
-		return 1;
+		return 0;
 	}
 
 	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %llu, t = %ld.\n",
-- 
2.25.1



