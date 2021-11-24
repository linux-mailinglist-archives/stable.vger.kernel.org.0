Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7186345C470
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348656AbhKXNtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350036AbhKXNrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:47:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12A54619F9;
        Wed, 24 Nov 2021 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758896;
        bh=uXLdFreliruZcHUnbkIjkcCWyqh/R/zKjuTr6LTpqG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLNRXN7WzZTRb5cRZBQo+FLZo9aorLowWLzah7JLOqbObVvtCdnCIV621s3O1NtoO
         RPRk+DmuAdt/VYziP0uwVR2RJuyDptWh3bZpcD0sRynZVsjZ1P1Z+F2Up8SZzLQxr8
         y1ypkuz88D0Pel16KE5n8zu1PYxZKz9W/KzBCWDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/279] scsi: lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
Date:   Wed, 24 Nov 2021 12:55:54 +0100
Message-Id: <20211124115721.026950867@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6f2e07c30f98f..e1c02229c82d9 100644
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



