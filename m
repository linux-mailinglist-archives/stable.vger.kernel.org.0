Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA73C2E53
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhGJC0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhGJC0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25AD613E6;
        Sat, 10 Jul 2021 02:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883803;
        bh=C/OoGrByiwoGUX9qlIPjEx89gIEtY0WGeJ0OV3W5X04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+IhGHG/0sAgU3m5pQWBNVIPWSMePOaJrht9XTV143qwSHq2Ixd4EuV3/j/3kN5TG
         KjQ0z2qX9tl4VLizZ9JsyE9m04afSYg64gvk1YZBL2TVSIQRA9cSWSECyuZynQU+96
         O1lctQyJ2/lAC9KgDagwuwfGHSOq+gUrPbn8leEmfC6c200wbtINUQ/81pYwZ3zlU4
         sJbnJ7Cji8PPdllE9CIpUKqGBjQPLhi1wb3XKoc9GeKiVtDQzkJ58gABfpFplnegAj
         +tKDVfkC+7O9UKd8qbgsTnq213682yYUvvEpFWEZHSBRBeCjj5JlV3REKz2lNNHQVL
         mW8LStJRww6Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 066/104] scsi: storvsc: Correctly handle multiple flags in srb_status
Date:   Fri,  9 Jul 2021 22:21:18 -0400
Message-Id: <20210710022156.3168825-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 6bc5453cea8a..181d7b372fd0 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1005,17 +1005,40 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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
@@ -1028,37 +1051,19 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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

