Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECAB406326
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242317AbhIJAqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234155AbhIJAW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE5F60F6D;
        Fri, 10 Sep 2021 00:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233307;
        bh=VgrjoEzRRisM1bUHZg6uZpuh7YFXRDzOHlDnw8mSGt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8kRhRQCsO++Dt6Jp//aroCgDB412EuH79A9xWsX92+gsXpiSyqkZS/BmWn4D++bn
         g08nFpxEVEwHJQKS4DiDEvjaxyk0pynt7o+GnRQBNk8kSh0E1p0b1wEssdYT4VJqGH
         FHdjd+aFJse3s0Onf0Uc6um4ugtCdcHjq6jr9jnq+VoVPNagll8NYiVFmGtHnNdiYZ
         E1RTMpKKqxZy1oVqZOSh+iAetgxHO7uPKt6f73uJVxokIMGz7adoQCYR+N0U/A95mP
         kFLjVBdupjvioS4UO0IUel9c+zyksZQkVeqfmE856ILpFtaSHDQ9BwF2ztnqgq5ZYW
         gIMXAZyHVLwlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/37] scsi: lpfc: Fix NVMe support reporting in log message
Date:   Thu,  9 Sep 2021 20:21:08 -0400
Message-Id: <20210910002143.175731-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit ae463b60235e7a5decffbb0bd7209952ccda78eb ]

The NVMe support indicator in log message 6422 is displaying a field that
was initialized but never set to indicate NVMe support.  Remove obsolete
nvme_support element from the lpfc_hba structure and change log message to
display NVMe support status as reported in SLI4 Config Parameters mailbox
command.

Link: https://lore.kernel.org/r/20210707184351.67872-2-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      | 1 -
 drivers/scsi/lpfc/lpfc_init.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8943d42fc406..767dbc4a5276 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -791,7 +791,6 @@ struct lpfc_hba {
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
 	uint8_t  fcp_embed_io;
-	uint8_t  nvme_support;	/* Firmware supports NVME */
 	uint8_t  nvmet_support;	/* driver supports NVMET */
 #define LPFC_NVMET_MAX_PORTS	32
 	uint8_t  mds_diags_support;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b5cee2a2ac66..393909a71c59 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11653,7 +11653,6 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 					bf_get(cfg_xib, mbx_sli4_parameters),
 					phba->cfg_enable_fc4_type);
 fcponly:
-			phba->nvme_support = 0;
 			phba->nvmet_support = 0;
 			phba->cfg_nvmet_mrq = 0;
 			phba->cfg_nvme_seg_cnt = 0;
@@ -11714,7 +11713,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 			"6422 XIB %d PBDE %d: FCP %d NVME %d %d %d\n",
 			bf_get(cfg_xib, mbx_sli4_parameters),
 			phba->cfg_enable_pbde,
-			phba->fcp_embed_io, phba->nvme_support,
+			phba->fcp_embed_io, sli4_params->nvme,
 			phba->cfg_nvme_embed_cmd, phba->cfg_suppress_rsp);
 
 	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
-- 
2.30.2

