Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368ED79436
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfG2T3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbfG2T3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:29:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922E3217D4;
        Mon, 29 Jul 2019 19:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428549;
        bh=LBngP+SYDecVYiJm+t3k/6UP2RSu5ScY0G4AkJwtVNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nPKV4F+xfMdbK3U6eaEngElL3Eu5sOtqCGMHQLuu8mPOV99EaHUG2NuoTJkOKoyQ
         6XIa+Vo9tZcQE1Q13xNYo3rHm7ystFgRsthSSpHMEDCCA/rZd9cbu8+GoBTM4QDb/h
         AlF6tX/9JdbN1TodfNjknwwxTOFErMTRQOhS+k0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 112/293] scsi: NCR5380: Reduce goto statements in NCR5380_select()
Date:   Mon, 29 Jul 2019 21:20:03 +0200
Message-Id: <20190729190833.219059030@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 6a162836997c10bbefb7c7ca772201cc45c0e4a6 upstream.

Replace a 'goto' statement with a simple 'return' where possible.  This
improves readability. No functional change.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/NCR5380.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -984,7 +984,7 @@ static struct scsi_cmnd *NCR5380_select(
 	if (!hostdata->selecting) {
 		/* Command was aborted */
 		NCR5380_write(MODE_REG, MR_BASE);
-		goto out;
+		return NULL;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1033,7 +1033,7 @@ static struct scsi_cmnd *NCR5380_select(
 	if (!hostdata->selecting) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		goto out;
+		return NULL;
 	}
 
 	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
@@ -1116,13 +1116,16 @@ static struct scsi_cmnd *NCR5380_select(
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
-		if (hostdata->selecting) {
-			cmd->result = DID_BAD_TARGET << 16;
-			complete_cmd(instance, cmd);
-			dsprintk(NDEBUG_SELECTION, instance, "target did not respond within 250ms\n");
-			cmd = NULL;
-		}
+		if (!hostdata->selecting)
+			return NULL;
+
+		cmd->result = DID_BAD_TARGET << 16;
+		complete_cmd(instance, cmd);
+		dsprintk(NDEBUG_SELECTION, instance,
+			"target did not respond within 250ms\n");
+		cmd = NULL;
 		goto out;
 	}
 
@@ -1155,7 +1158,7 @@ static struct scsi_cmnd *NCR5380_select(
 	}
 	if (!hostdata->selecting) {
 		do_abort(instance);
-		goto out;
+		return NULL;
 	}
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",


