Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB4C27C30A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgI2LCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbgI2LCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:02:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD38D2158C;
        Tue, 29 Sep 2020 11:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377367;
        bh=KZz5/GEJRjnSLNW7zLad0z702KP6WTlUtH0qtgQvhH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szvXl36lt5kIOdPCksO3qW9DKBCTcjJ0pZ8eR6/jpl5VJbymw/LjG2hCEHmTiSJCL
         1/d4Mypg0i1/Xky1/92k5LEMsbE05UbwsfnJ607FS6k9fTnFIwTUjv+dgGBZ/sSfMe
         BGX4Hu7aoFIrDeqilU6MVAqwBZ98iKWZifPUki3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balsundar P <balsundar.p@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/85] scsi: aacraid: fix illegal IO beyond last LBA
Date:   Tue, 29 Sep 2020 12:59:39 +0200
Message-Id: <20200929105928.826417854@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
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



