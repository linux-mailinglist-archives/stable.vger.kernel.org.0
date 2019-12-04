Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EBC1131BF
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfLDSCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbfLDSCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:08 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA4F206DF;
        Wed,  4 Dec 2019 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482527;
        bh=a84wFZWHFaoV0m4VFKLRCiScqrK5dvzdvTvmGaCGcfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORiwYoIR3mbit34ZSFBuGbziqBHFBcwKXrBLgPo/PTvEHbFRFIqLl1zMQoZGRlJzn
         mVgvT8ceaMBzCQEzroY96MaaBDzlc3RTkl2C6L2fAcKiDb5KYM/iuvz4wzfqbNH/wf
         jmqec/rFuheLxwsBEgLSXCedzTU5pNwPaqMZn8aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/209] scsi: lpfc: Fix dif and first burst use in write commands
Date:   Wed,  4 Dec 2019 18:54:03 +0100
Message-Id: <20191204175323.634921579@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 7c4042a4d0b7532cfbc90478fd3084b2dab5849e ]

When dif and first burst is used in a write command wqe, the driver was not
properly setting fields in the io command request. This resulted in no dif
bytes being sent and invalid xfer_rdy's, resulting in the io being aborted
by the hardware.

Correct the wqe initializaton when both dif and first burst are used.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 07cb671bb8550..2eba0c39ac1c4 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2714,6 +2714,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the bpl beyond fcp_cmnd
@@ -2819,6 +2820,14 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
 
+	/*
+	 * For First burst, we may need to adjust the initial transfer
+	 * length for DIF
+	 */
+	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
+	    (fcpdl < vport->cfg_first_burst_size))
+		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
+
 	return 0;
 err:
 	if (lpfc_cmd->seg_cnt)
@@ -3371,6 +3380,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the sgl beyond fcp_cmnd
@@ -3486,6 +3496,14 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
 
+	/*
+	 * For First burst, we may need to adjust the initial transfer
+	 * length for DIF
+	 */
+	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
+	    (fcpdl < vport->cfg_first_burst_size))
+		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
+
 	/*
 	 * If the OAS driver feature is enabled and the lun is enabled for
 	 * OAS, set the oas iocb related flags.
-- 
2.20.1



