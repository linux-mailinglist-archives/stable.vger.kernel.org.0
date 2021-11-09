Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1B44B60E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhKIWZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344206AbhKIWXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D9E619E1;
        Tue,  9 Nov 2021 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496319;
        bh=w+Dqxqw4uDORwHJzyVtT/4AOmuHH1jzHEus7nZCU2ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv+SYjn9C/zjLqhHxtM85kJMbGBpS5tMqrHrrTVQ4Pl/WFANIhSPN/+FsmzBR6jYp
         7utBSd63SpTNdKYnXUv+OBA/3896vM+1uuzrBYHUnuj3LLHD7+MY67oqF+sy7FeHO0
         f/21wfxvGdJY5qsb9P45pUeuzvJKCh+MXFDiTz1D21mKlFckIM7TLOq1whodcB3vcT
         Y9g9z+LP9nWrAPdQdS90H5dLkfLJ3SqA2K84g2ivKA7B0QgmqLKF0i+Wj5kbQO93Dk
         fZo02hrD9JP6X72HsE1Z7Uhd18vD+2+YR1EWwv1HgWqxVmU91BIzeAbwgRy6SxeRhJ
         qtdp3cCI9bxDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 68/82] scsi: lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
Date:   Tue,  9 Nov 2021 17:16:26 -0500
Message-Id: <20211109221641.1233217-68-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index 7195ca0275f93..787898d25670d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4360,6 +4360,7 @@ lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 ndlp->nlp_state);
 
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+	ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
-- 
2.33.0

