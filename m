Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B02F63D1
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfKJCzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbfKJCuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFBEE22583;
        Sun, 10 Nov 2019 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354221;
        bh=qHwt6qY58WGCpmbsKOfJ8HhoTBltAdAPuFT+Fs5YduM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv2aD8cDEbPj75TuXohX/B5vDUtjigbkMLmmDy4xKWogjBnioV96E7NzO6gprCQbx
         RkRMaXqZg4yJOqnzqtJg0HMVMBo1gWWVy5Vwd55jNMoldTY1sfN8Cr4W/wUC/dxEKY
         2GW4qN/Dk4Px02QXJZWFEYCUcJf2phhjaPZ3BbGg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 59/66] scsi: NCR5380: Don't call dsprintk() following reselection interrupt
Date:   Sat,  9 Nov 2019 21:48:38 -0500
Message-Id: <20191110024846.32598-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 08267216b3f8aa5adc204bdccf8deb72c1cd7665 ]

The X3T9.2 specification (draft) says, under "6.1.4.1 RESELECTION",

    ... The reselected initiator shall then assert the BSY signal
    within a selection abort time of its most recent detection of being
    reselected; this is required for correct operation of the time-out
    procedure.

The selection abort time is only 200 us which may be insufficient time for a
printk() call. Move the diagnostics to the error paths.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index a4856eeac26f6..03f9ddbc37fbb 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2109,8 +2109,6 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		return;
 	}
 
-	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
-
 	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
 	 * SEL is true and BSY was false for at least one bus settle delay
@@ -2123,6 +2121,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
 	if (NCR5380_poll_politely(instance,
 	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+		shost_printk(KERN_ERR, instance, "reselect: !SEL timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		return;
 	}
@@ -2134,6 +2133,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (NCR5380_poll_politely(instance,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
 		do_abort(instance);
 		return;
 	}
-- 
2.20.1

