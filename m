Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470B23C2D68
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhGJCWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232876AbhGJCWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D2FE60BD3;
        Sat, 10 Jul 2021 02:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883568;
        bh=2PZ0lzObAQRnJF57W3GYqnaYB/bfZfQaQjuMHASKseE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKi4YEPkVQyi21Mpv7GAZoEW4OeWp7Oh05C9omxhyxKgMFn/KvUj9XGsCuO7XJwPW
         vCVRrniomo+9x3GVXy/5YYUpwTTWT1E6q2lqc3V+wPLTkpPbks8CeJJl6wpFEVOZiC
         gtK7UU9+b8Bwbjwsv/T8HsyXc2EvqMZaMQScyQT1d2UGCFoSjVWaxOumpeSn+Ijpvn
         5eWK9ke+OXXYHCzwmvJQ+MohLui5pyxWcctWURKnCCnLAzfgwBguvK+0ambQb6wZSj
         7K+c5kCMWzqG5L9x2wm+LBwSgTsRQVW90X2RHzwqGuP/p1Hh2viGtQXcbxcCnNNYf+
         rEGtR5WFULdng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 074/114] scsi: storvsc: Correctly handle multiple flags in srb_status
Date:   Fri,  9 Jul 2021 22:17:08 -0400
Message-Id: <20210710021748.3167666-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 52e1b3b3daa9d53f0204bf474ee1d4b1beb38234 ]

Hyper-V is observed to sometimes set multiple flags in the srb_status, such
as ABORTED and ERROR. Current code in storvsc_handle_error() handles only a
single flag being set, and does nothing when multiple flags are set.  Fix
this by changing the case statement into a series of "if" statements
testing individual flags. The functionality for handling each flag is
unchanged.

Link: https://lore.kernel.org/r/1622827263-12516-3-git-send-email-mikelley@microsoft.com
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 61 +++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e6718a74e5da..b2e28197a086 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1009,17 +1009,40 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	struct storvsc_scan_work *wrk;
 	void (*process_err_fn)(struct work_struct *work);
 	struct hv_host_device *host_dev = shost_priv(host);
-	bool do_work = false;
 
-	switch (SRB_STATUS(vm_srb->srb_status)) {
-	case SRB_STATUS_ERROR:
+	/*
+	 * In some situations, Hyper-V sets multiple bits in the
+	 * srb_status, such as ABORTED and ERROR. So process them
+	 * individually, with the most specific bits first.
+	 */
+
+	if (vm_srb->srb_status & SRB_STATUS_INVALID_LUN) {
+		set_host_byte(scmnd, DID_NO_CONNECT);
+		process_err_fn = storvsc_remove_lun;
+		goto do_work;
+	}
+
+	if (vm_srb->srb_status & SRB_STATUS_ABORTED) {
+		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
+		    /* Capacity data has changed */
+		    (asc == 0x2a) && (ascq == 0x9)) {
+			process_err_fn = storvsc_device_scan;
+			/*
+			 * Retry the I/O that triggered this.
+			 */
+			set_host_byte(scmnd, DID_REQUEUE);
+			goto do_work;
+		}
+	}
+
+	if (vm_srb->srb_status & SRB_STATUS_ERROR) {
 		/*
 		 * Let upper layer deal with error when
 		 * sense message is present.
 		 */
-
 		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID)
-			break;
+			return;
+
 		/*
 		 * If there is an error; offline the device since all
 		 * error recovery strategies would have already been
@@ -1032,37 +1055,19 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 			set_host_byte(scmnd, DID_PASSTHROUGH);
 			break;
 		/*
-		 * On Some Windows hosts TEST_UNIT_READY command can return
-		 * SRB_STATUS_ERROR, let the upper level code deal with it
-		 * based on the sense information.
+		 * On some Hyper-V hosts TEST_UNIT_READY command can
+		 * return SRB_STATUS_ERROR. Let the upper level code
+		 * deal with it based on the sense information.
 		 */
 		case TEST_UNIT_READY:
 			break;
 		default:
 			set_host_byte(scmnd, DID_ERROR);
 		}
-		break;
-	case SRB_STATUS_INVALID_LUN:
-		set_host_byte(scmnd, DID_NO_CONNECT);
-		do_work = true;
-		process_err_fn = storvsc_remove_lun;
-		break;
-	case SRB_STATUS_ABORTED:
-		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
-		    (asc == 0x2a) && (ascq == 0x9)) {
-			do_work = true;
-			process_err_fn = storvsc_device_scan;
-			/*
-			 * Retry the I/O that triggered this.
-			 */
-			set_host_byte(scmnd, DID_REQUEUE);
-		}
-		break;
 	}
+	return;
 
-	if (!do_work)
-		return;
-
+do_work:
 	/*
 	 * We need to schedule work to process this error; schedule it.
 	 */
-- 
2.30.2

