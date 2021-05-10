Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C35378837
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbhEJLU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhEJLJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 478E4610C9;
        Mon, 10 May 2021 11:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644702;
        bh=7srYcspVMaQu6rWVBDD2fDnGG5ZgedcliWdsa+JRC5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcY1/q/BHQyr7KuwPRAnRt3dqDhBB+bFXVRGvAv1XFtwrX/v5gKWJd+kL7x3VQboR
         0qyGRHNQ+VMYlKSxGe2/Iw5eMBgfu0Z6BfqoQxhVZiKwGBagu5SeICrmktChIYqSo1
         Jm8j2skGReUxEyy2AHgDoBYyXS1O/0gTAxEaTec8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 154/384] scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Mon, 10 May 2021 12:19:03 +0200
Message-Id: <20210510102019.962226249@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bb2a4a0d1295..a3fd959f7431 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3304,7 +3304,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
-- 
2.30.2



