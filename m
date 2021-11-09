Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B9044B71D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbhKIWc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344596AbhKIWa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE6BE61406;
        Tue,  9 Nov 2021 22:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496445;
        bh=dJT6x0oNL0AHDJyVSeahQxj7UWsBu4auVfxdjzi0iZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AytkZQpMRODlJkpilVQqUquY/ZJAzxq5qygaRv1RDM6pxTaQZ5fxDfo7bsn9XHK+i
         Xz1eSvCOnCtDV/fKPXnVQ1805rX0rOuyKVnT+MEdTMsD2L+HGdj2WbalBYi4c0RnSf
         l2loCmXTwqWck7Pynl3KhBv9Kj2Vw3aS+AxyTX1iODJd5+G5YZUjoXVbSiX6ebrWuu
         tEbn2iDUioPVJhkriq20HjYrn74JHop0MBRdSEo3GjH2cE0gi5Yj7WzLPotWhmQG7J
         3rwSQtmrvIcfXbTguHrsRh2uza6s0LGEpK1kWcba4YK5oQ+odYDLr5UsV/MXEi5x2H
         5EPrC3azfU0Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 64/75] scsi: lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
Date:   Tue,  9 Nov 2021 17:18:54 -0500
Message-Id: <20211109221905.1234094-64-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 79b20beccea3a3938a8500acef4e6b9d7c66142f ]

An error is detected with the following report when unloading the driver:
  "KASAN: use-after-free in lpfc_unreg_rpi+0x1b1b"

The NLP_REG_LOGIN_SEND nlp_flag is set in lpfc_reg_fab_ctrl_node(), but the
flag is not cleared upon completion of the login.

This allows a second call to lpfc_unreg_rpi() to proceed with nlp_rpi set
to LPFC_RPI_ALLOW_ERROR.  This results in a use after free access when used
as an rpi_ids array index.

Fix by clearing the NLP_REG_LOGIN_SEND nlp_flag in
lpfc_mbx_cmpl_fc_reg_login().

Link: https://lore.kernel.org/r/20211020211417.88754-5-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 7cc5920979f8a..6a7754105ce3a 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4340,6 +4340,7 @@ lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 ndlp->nlp_state);
 
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+	ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
-- 
2.33.0

