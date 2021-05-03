Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEC0371C6C
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhECQwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234678AbhECQun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 303686192A;
        Mon,  3 May 2021 16:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060072;
        bh=VpicjMrC7wIbSeScJ//MRPXRuxWp5cOb6PXgVW05iAw=;
        h=From:To:Cc:Subject:Date:From;
        b=dvyoaKLZAugbZs0E8mC14tbLB7DrFkZDSCExQkiwVvR4nckDhufzQjfZ0wjloL0By
         BVh9jNuYU8bg2PvqvByR8+z+tsd8WiLnkPqzLtMmKu7ixKADmhYsFNxNRy98J8g1dS
         LnE4hFaVT9q/atGYSkwbw0YN4+4hzvJxXg1LJcCt6fHyGgRd0IR5kYDzhASRUuQEhz
         SP9bSj9ljmat2so+PLDHFVdggviMUao16k6cfv6bGmqwDxkxHoCoXSHqqE/BQUAT42
         L7gT8I4xwxVGG1NbTqNkSkDsufY7VVsQ2XBR8umknGj74nJc94eLzPjPqtwkooOexJ
         0Nyd/Tq4KcGCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/35] scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Mon,  3 May 2021 12:40:35 -0400
Message-Id: <20210503164109.2853838-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 5bc33817568e..23ead17e60fe 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2912,7 +2912,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
-- 
2.30.2

