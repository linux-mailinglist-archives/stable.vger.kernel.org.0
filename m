Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D313CE104
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347330AbhGSPTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347182AbhGSPPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 584DE61003;
        Mon, 19 Jul 2021 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710189;
        bh=YqEKOD+jbFI2SPkTCsG8hHcld8NPo8tsmJX1Z8hqID4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISETRliupciNk8Mqqt/NhW4d7q3oylGs5fEJZpPi/zOBTPQRxlNWHt8GS/p8mNFj+
         LQ19dyQ6Jcv4Xu01iILa2EIP3/UE7nNU6iYhYSdqU2jVM8ZlBLDpdhtf0iq40RV8IK
         iWz6q4PiY4HBfyr7n5jgZvNnlGUqRNxw7QYsIr/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/243] scsi: storvsc: Correctly handle multiple flags in srb_status
Date:   Mon, 19 Jul 2021 16:51:48 +0200
Message-Id: <20210719144943.450202519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ded00a89bfc4..0ee0b80006e0 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -994,17 +994,40 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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
@@ -1017,37 +1040,19 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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



