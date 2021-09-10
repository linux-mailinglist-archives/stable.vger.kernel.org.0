Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B881406080
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhIJARg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhIJARV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D012B610E9;
        Fri, 10 Sep 2021 00:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232971;
        bh=/3Y9yjUTmJ5XoVXvyWOMOH2U/+VtC/o3sQecP+tWNZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ehj99BESOIrSa89ero49c06f/s4/Tx6ARY9t5oqRXdKBBtrRmJURoO9fFJftPDnMc
         48dqPF5EPXCEIyl5cdLcqY6BhoEdt0qcURAAWO0WuIY/MpKg1W+di/AcIyg3kLFGDr
         DhCSLtbPdeU/WklblUPNIvHDWAzZgl9ftnfdg89+BUzgO5tTEkdNm14jXLuVauSFbg
         Roii9vTcz5YwrSTAoZxFuy66KO+sn6rjVug8zhAFxhYull/iDvtvXsUuE7ej/nXpUV
         nHQJ57xp6iDsY8OHVpkEagn9kG04Z/f7bk1A0g3axv3tfFyucoO80kTtBfqjPfR/W6
         hey4djXQ++EBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 09/99] scsi: lpfc: Discovery state machine fixes for LOGO handling
Date:   Thu,  9 Sep 2021 20:14:28 -0400
Message-Id: <20210910001558.173296-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e77803bdbf0aad98d36b1d3fa082852831814edd ]

If a LOGO is received for a node that is in the NPR state, post a DEVICE_RM
event to allow clean up of the logged out node.

Clearing the NLP_NPR_2B_DISC flag upon receipt of a LOGO ACC may cause
skipping of processing outstanding PLOGIs triggered by parallel RSCN
events.  If an outstanding PLOGI is being retried and receipt of a LOGO ACC
occurs, then allow the discovery state machine's PLOGI completion to clean
up the node.

Link: https://lore.kernel.org/r/20210707184351.67872-6-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e481f5fe29d7..b0c443a0cf92 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4612,6 +4612,15 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
+
+		/* If PLOGI is being retried, PLOGI completion will cleanup the
+		 * node. The NLP_NPR_2B_DISC flag needs to be retained to make
+		 * progress on nodes discovered from last RSCN.
+		 */
+		if ((ndlp->nlp_flag & NLP_DELAY_TMO) &&
+		    (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
+			goto out;
+
 		/* NPort Recovery mode or node is just allocated */
 		if (!lpfc_nlp_not_used(ndlp)) {
 			/* A LOGO is completing and the node is in NPR state.
@@ -8948,6 +8957,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb, NLP_EVT_RCV_LOGO);
+		if (newnode)
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_PRLO:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
-- 
2.30.2

