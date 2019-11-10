Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D391F6430
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfKJC5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbfKJC4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71D1224F1;
        Sun, 10 Nov 2019 02:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354102;
        bh=355OjtmtRv93XyHT/1hfDWzGXWO13YE85GdtD4/dVCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyyGPJ/uLhmta7aHH1IQUUMUVxDniA8iShhmv1RZy0pVWf0Df/T23uxHHPz6bcE8m
         qTXWXxJvVIFM4xuSbTSzue9hAL3szNxg2tmNjnMVfv8YJfrsmsPgynSN+m/VWyb6jw
         bH9kyU3/sY9h1sLpxqkXxw6aka2fCBln1oraEV1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 093/109] scsi: NCR5380: Withhold disconnect privilege for REQUEST SENSE
Date:   Sat,  9 Nov 2019 21:45:25 -0500
Message-Id: <20191110024541.31567-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 7c8ed783c2faa1e3f741844ffac41340338ea0f4 ]

This is mostly needed because an AztecMonster II target has been observed
disconnecting REQUEST SENSE commands and then failing to reselect properly.

Suggested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 60e051c249a6f..5f26aa2875bd9 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -938,6 +938,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	int len;
 	int err;
 	bool ret = true;
+	bool can_disconnect = instance->irq != NO_IRQ &&
+			      cmd->cmnd[0] != REQUEST_SENSE;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
@@ -1157,7 +1159,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
 	         scmd_id(cmd));
-	tmp[0] = IDENTIFY(((instance->irq == NO_IRQ) ? 0 : 1), cmd->device->lun);
+	tmp[0] = IDENTIFY(can_disconnect, cmd->device->lun);
 
 	len = 1;
 	data = tmp;
-- 
2.20.1

