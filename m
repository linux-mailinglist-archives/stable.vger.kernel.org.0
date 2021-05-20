Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B885A38A5E3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhETKVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235919AbhETKRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B992F619AB;
        Thu, 20 May 2021 09:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503992;
        bh=mreJA38N0U0gb/wXrh/DdUeY8KH2zVlSVER6kcpkOiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/5dldeFEEIE0sIxP5mwJBsohNeRKcU0ZPL/UQj7Ms4Svt9u5nxPgrBu5FTmYfHyu
         Zn/PgvF6IWy82xlTDsiJDX8llSfIXu2rfwhatGAZmQva+Wqr8OEoR551BgcuCuyXh6
         ofOAfmmIaGzLpl8RBJx718QdJ07O6ajCyanZ+MN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/323] scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Thu, 20 May 2021 11:18:57 +0200
Message-Id: <20210520092121.654681066@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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



