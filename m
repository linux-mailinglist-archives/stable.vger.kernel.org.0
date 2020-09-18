Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4084426EDD4
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgIRCX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbgIRCQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA66235F7;
        Fri, 18 Sep 2020 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395405;
        bh=KZz5/GEJRjnSLNW7zLad0z702KP6WTlUtH0qtgQvhH0=;
        h=From:To:Cc:Subject:Date:From;
        b=JTttQceD2d5A1M5wTog4h1F1vAKTjD7NoVrc64KO7Tq2EtuWcpO6NRPJFNoohdR1G
         ZUnyExzsEIL2gR4cg2m39UXOXaePYNuxr4TrJ+R34Y8lW1u6H6uJJcXEC8FpW77cNq
         9NQR8wIX9EIuOJE7zrSWf1VmJLN97MiRT917d6cs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balsundar P <balsundar.p@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/64] scsi: aacraid: fix illegal IO beyond last LBA
Date:   Thu, 17 Sep 2020 22:15:40 -0400
Message-Id: <20200918021643.2067895-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index de33801ca31ea..0614d05a990a6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1938,13 +1938,13 @@ static int aac_read(struct scsi_cmnd * scsicmd)
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
@@ -2035,13 +2035,13 @@ static int aac_write(struct scsi_cmnd * scsicmd)
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

