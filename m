Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312BA371980
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhECQgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbhECQg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D08613BC;
        Mon,  3 May 2021 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059736;
        bh=7srYcspVMaQu6rWVBDD2fDnGG5ZgedcliWdsa+JRC5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFN4z7+eEDnsT9KWw2MZbiRRKe6YWnDsmuyc7nIsgF78U1zgpYCrl4wf5G0SP2xCl
         waU2GK8xmNVIYERVw6+MNgEL4Ts66E3vTQPb2qoeBwyHgqCPIni3EA/LtnIytSFopF
         UYNJ2SiZdmO4RrgmxHxdN+LQ3OCTd6rhjcua9ysqKoO6uTcp5kxAVSiXuU9v1sy4fY
         4WNrQbPSDHM7NX85yXZBgMxC0Z3m1f2Rix5tTxj/qWU2q2p/thqbOVWK/peMfpMicB
         9VsF8Kuy5SZGNXQTZCjKefILLb1iyJOeEnETnmHqmEojDt/7OeEpJM6SquMuhAa0yA
         vNCj+DuWF4EzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 014/134] scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Mon,  3 May 2021 12:33:13 -0400
Message-Id: <20210503163513.2851510-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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

