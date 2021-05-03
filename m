Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49E371AAE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhECQkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231834AbhECQjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63AF561408;
        Mon,  3 May 2021 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059841;
        bh=k9ChT4BgUSBEEY477nIRp8U+YSJQjA/6ihvjRNoeAUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwCy3WhOckjLVZAh2PbodORcyMh26iK9tSZq27VZ41jPOV2N8FQswZAL9kvBFa97J
         X38nBb3tHf/EA+zyJupInDsMm1HxhmralrR4X/2WTZLcDrE787R2nadxhOujFcToaw
         78aSCIJVQ+OVjatnRJ8oH5t/mIoWmAigXk+ZXypiINfsaZYwXwxwXsqHGTJuIUYiNC
         cZPD1/oxev71c84cht++kQCda1+O7s+ISJdg2QO7vPdJ1uNlAM9m7VrwtNgYPBMbYb
         cRnfZegifkbpuePkqtQwXDbBdYhbGGQo8jbKexlBSY+qg9mSM3rPs0Fo+wEGrmYiau
         XcaiG7m7Nhm5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 013/115] scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Mon,  3 May 2021 12:35:17 -0400
Message-Id: <20210503163700.2852194-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 9302154c07bff4e7f7f43c506a1ac84540303d06 ]

The wqe_dbde field indicates whether a Data BDE is present in Words 0:2 and
should therefore should be clear in the abts request wqe. By setting the
bit we can be misleading fw into error cases.

Clear the wqe_dbde field.

Link: https://lore.kernel.org/r/20210301171821.3427-2-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index a71df8788fff..0dbe1d399378 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3299,7 +3299,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
-- 
2.30.2

