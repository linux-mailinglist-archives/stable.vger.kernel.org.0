Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DBC11B7B4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbfLKPL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfLKPL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B332D20663;
        Wed, 11 Dec 2019 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077118;
        bh=Lw/7K344nPqJmhUu7zRAQPfP9oBF4Zhz7FkPv0BldDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/ghKvYIg7mrHjUwCu8w1GJdTFsWfZpLSNkn9i6j1eZ4ZsJSz1BRqOVsMLNYXqbBc
         nNCbyTzN9GQyhH2vZrUnuilz+7Or6mAGTTWertQSChxcwdJAf29mqOll/zAMcoAeKM
         SgocMiRSGTRDMICJoz3Sv8Cf1BAg81QV7fuWE1AQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 007/134] scsi: lpfc: Fix list corruption in lpfc_sli_get_iocbq
Date:   Wed, 11 Dec 2019 10:09:43 -0500
Message-Id: <20191211151150.19073-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 15498dc1a55b7aaea4b51ff03e3ff0f662e73f44 ]

After study, it was determined there was a double free of a CT iocb during
execution of lpfc_offline_prep and lpfc_offline.  The prep routine issued
an abort for some CT iocbs, but the aborts did not complete fast enough for
a subsequent routine that waits for completion. Thus the driver proceeded
to lpfc_offline, which releases any pending iocbs. Unfortunately, the
completions for the aborts were then received which re-released the ct
iocbs.

Turns out the issue for why the aborts didn't complete fast enough was not
their time on the wire/in the adapter. It was the lpfc_work_done routine,
which requires the adapter state to be UP before it calls
lpfc_sli_handle_slow_ring_event() to process the completions. The issue is
the prep routine takes the link down as part of it's processing.

To fix, the following was performed:

 - Prevent the offline routine from releasing iocbs that have had aborts
   issued on them. Defer to the abort completions. Also means the driver
   fully waits for the completions.  Given this change, the recognition of
   "driver-generated" status which then releases the iocb is no longer
   valid. As such, the change made in the commit 296012285c90 is reverted.
   As recognition of "driver-generated" status is no longer valid, this
   patch reverts the changes made in
   commit 296012285c90 ("scsi: lpfc: Fix leak of ELS completions on adapter reset")

 - Modify lpfc_work_done to allow slow path completions so that the abort
   completions aren't ignored.

 - Updated the fdmi path to recognize a CT request that fails due to the
   port being unusable. This stops FDMI retries. FDMI will be restarted on
   next link up.

Link: https://lore.kernel.org/r/20190922035906.10977-14-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 6 ++++++
 drivers/scsi/lpfc/lpfc_els.c     | 3 +++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 5 ++++-
 drivers/scsi/lpfc/lpfc_sli.c     | 3 ---
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 25e86706e2072..f883fac2d2b1d 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1868,6 +1868,12 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
 			switch ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK)) {
 			case IOERR_SLI_ABORTED:
+			case IOERR_SLI_DOWN:
+				/* Driver aborted this IO.  No retry as error
+				 * is likely Offline->Online or some adapter
+				 * error.  Recovery will try again.
+				 */
+				break;
 			case IOERR_ABORT_IN_PROGRESS:
 			case IOERR_SEQUENCE_TIMEOUT:
 			case IOERR_ILLEGAL_FRAME:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0052b341587d9..f293b48616ae9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8016,6 +8016,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (piocb->vport != vport)
 			continue;
 
+		if (piocb->iocb_flag & LPFC_DRIVER_ABORTED)
+			continue;
+
 		/* On the ELS ring we can have ELS_REQUESTs or
 		 * GEN_REQUESTs waiting for a response.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f7c205e1da485..1286c658ba34f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -700,7 +700,10 @@ lpfc_work_done(struct lpfc_hba *phba)
 			if (!(phba->hba_flag & HBA_SP_QUEUE_EVT))
 				set_bit(LPFC_DATA_READY, &phba->data_flags);
 		} else {
-			if (phba->link_state >= LPFC_LINK_UP ||
+			/* Driver could have abort request completed in queue
+			 * when link goes down.  Allow for this transition.
+			 */
+			if (phba->link_state >= LPFC_LINK_DOWN ||
 			    phba->link_flag & LS_MDS_LOOPBACK) {
 				pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
 				lpfc_sli_handle_slow_ring_event(phba, pring,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e5413d52e49a2..995a2b56a35ee 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11050,9 +11050,6 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				irsp->ulpStatus, irsp->un.ulpWord[4]);
 
 		spin_unlock_irq(&phba->hbalock);
-		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-		    irsp->un.ulpWord[4] == IOERR_SLI_ABORTED)
-			lpfc_sli_release_iocbq(phba, abort_iocb);
 	}
 release_iocb:
 	lpfc_sli_release_iocbq(phba, cmdiocb);
-- 
2.20.1

