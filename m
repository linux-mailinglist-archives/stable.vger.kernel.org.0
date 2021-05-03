Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0049E371CCE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhECQ47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232756AbhECQxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03E0C6192E;
        Mon,  3 May 2021 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060126;
        bh=mreJA38N0U0gb/wXrh/DdUeY8KH2zVlSVER6kcpkOiY=;
        h=From:To:Cc:Subject:Date:From;
        b=R/Gp3Zmm8XD9HUcmspWQ33cMvzzPaiwoVSru3k/+ORG0Np30OWyWHk+RHqMPCDJGp
         7xKLA17yXPjoMQdSd+ZPLKWu1v3qxKqTnJZVj+tG9eejJrYyC+cZ7QtNJSjY5vZeIq
         65N8jZBjrGOSlYey4liRuSpgOCLhaRHMO0qBIekCLkXSBM6tnoSFDhmmA5vhN7aXx7
         oFUJ/hoTHU7nadYkRFnj0ByNId9BtJWNKmPxqfJp5IwbAy0xHUm0bYFs+xbFIeP0bj
         G9ouWc6+N1YhP5dwLMPoyFL5gIvC3La86tvI0M4QggIAsN2ObiT0gz9dTMVOz6hYmt
         +dHkEu76cyfAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/31] scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Mon,  3 May 2021 12:41:34 -0400
Message-Id: <20210503164204.2854178-1-sashal@kernel.org>
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
index eacdcb931bda..fa0d0d15e82c 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2554,7 +2554,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
-- 
2.30.2

