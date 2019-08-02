Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629577F202
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405204AbfHBJoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391488AbfHBJnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCB112086A;
        Fri,  2 Aug 2019 09:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738992;
        bh=9eaYUajJCWUORYIELbRhhwap7w2FWbuSby3EDs7IJEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOV54WcEcqMp5K9TJqCqm3f4yTtvTVRxzKV8R/qmkYJJtximGhWBOGe74i00qQjit
         mEZQ7vIK3vS8F3SbhRwGu4JR55Xq/tYsywZz8D+bXI2tjVjq+sAAkafwBUTygzH+8i
         zBH3VvPuF/aZfXYJbfRFR1pISulGELKX6VadEUSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 075/223] scsi: NCR5380: Reduce goto statements in NCR5380_select()
Date:   Fri,  2 Aug 2019 11:35:00 +0200
Message-Id: <20190802092243.696800783@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
@@ -1086,7 +1086,7 @@ static struct scsi_cmnd *NCR5380_select(
 	if (!hostdata->selecting) {
 		/* Command was aborted */
 		NCR5380_write(MODE_REG, MR_BASE);
-		goto out;
+		return NULL;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1135,7 +1135,7 @@ static struct scsi_cmnd *NCR5380_select(
 	if (!hostdata->selecting) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		goto out;
+		return NULL;
 	}
 
 	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
@@ -1218,13 +1218,16 @@ static struct scsi_cmnd *NCR5380_select(
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
 
@@ -1257,7 +1260,7 @@ static struct scsi_cmnd *NCR5380_select(
 	}
 	if (!hostdata->selecting) {
 		do_abort(instance);
-		goto out;
+		return NULL;
 	}
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",


