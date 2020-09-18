Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B45226F488
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgIRDPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgIRCBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E32C21707;
        Fri, 18 Sep 2020 02:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394489;
        bh=nkzm/jJZVRuK3E2FPK9wmfAxR5FlQ2fiP4Og6qKQ/AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCPjbUtGP1zqLA8lH4UP5kkJLZ7bkaq6p4rq01w8kuOhp2KPRhoZr2FBo7+YkqJBN
         RpYUlzGLngjpgF4IUHZKuuG6IlcyTiWCT4rql+pxJYVXUl55MQjN3GS2sCs7nZwmXJ
         m19dF5sRDrtX1+tAlmMT6f//4B5/XWqK9kKdfu8U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balsundar P <balsundar.p@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 015/330] scsi: aacraid: fix illegal IO beyond last LBA
Date:   Thu, 17 Sep 2020 21:55:55 -0400
Message-Id: <20200918020110.2063155-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 0ed3f806ace54..2388143d59f5d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2467,13 +2467,13 @@ static int aac_read(struct scsi_cmnd * scsicmd)
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
@@ -2559,13 +2559,13 @@ static int aac_write(struct scsi_cmnd * scsicmd)
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

