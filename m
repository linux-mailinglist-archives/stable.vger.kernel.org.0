Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C9810649B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKVGNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfKVGNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D422068E;
        Fri, 22 Nov 2019 06:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403183;
        bh=vqEKwBQUFxSHbtDnx/1d4SRZdBCRaEyfWfJl7WNX7OY=;
        h=From:To:Cc:Subject:Date:From;
        b=0BjpDP9Yy8KzQn5iTTVuoZy7c2ZQ+eXIdtS+sPFWPVlfpzF9ApW22+EEZ6YQildOI
         R9+qTLaq7C89jNpPb+EU5grfa9y3tmfD8jOf+me3lZHZ9jTL7F6G+EjTeXvzVMMCeN
         6X8ptOH6+ZrmsISZDjeLlyY6QzeQwNg2e9lH7yMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/68] scsi: lpfc: Fix dif and first burst use in write commands
Date:   Fri, 22 Nov 2019 01:11:55 -0500
Message-Id: <20191122061301.4947-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bae36cc3740b6..ab6bff60478f9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2707,6 +2707,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the bpl beyond fcp_cmnd
@@ -2812,6 +2813,14 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
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
@@ -3361,6 +3370,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the sgl beyond fcp_cmnd
@@ -3476,6 +3486,14 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
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

