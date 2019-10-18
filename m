Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653ADDD3E0
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394243AbfJRWVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbfJRWG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97D792245A;
        Fri, 18 Oct 2019 22:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436387;
        bh=YL/GOslPbKzWPVIGCvbmtekbS/5Pr6SFRznL14kivv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSM9Gd2j4TvvyQfbl8tJjTxUYw66fUkL01oXnpZRQW+fPynuEsrl8L4a2MrL7sEVs
         EynnaFMDvHqpFNp7BN4+YHfEts1Mg7sHrTzWjs89ls1ZJOgFekz38b1FUv6YIWRqEP
         Lc8nfIX6SRV6qAm4/hlKLpGJxgZAe8YtRbmzix4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 039/100] scsi: lpfc: Correct localport timeout duration error
Date:   Fri, 18 Oct 2019 18:04:24 -0400
Message-Id: <20191018220525.9042-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2a0fb340fcc816975b8b0f2fef913d11999c39cf ]

Current code incorrectly specifies a completion wait timeout duration in 5
jiffies, when it should have been 5 seconds.

Fix the adjust for units for the completion timeout call.

[mkp: manual merge]

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 6 +++++-
 drivers/scsi/lpfc/lpfc_nvmet.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e2575c8ec93e8..22efefcc6cd84 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1713,7 +1713,11 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		}
 		tgtp->tport_unreg_cmp = &tport_unreg_cmp;
 		nvmet_fc_unregister_targetport(phba->targetport);
-		wait_for_completion_timeout(&tport_unreg_cmp, 5);
+		if (!wait_for_completion_timeout(tgtp->tport_unreg_cmp,
+					msecs_to_jiffies(LPFC_NVMET_WAIT_TMO)))
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6179 Unreg targetport %p timeout "
+					"reached.\n", phba->targetport);
 		lpfc_nvmet_cleanup_io_context(phba);
 	}
 	phba->targetport = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 0ec1082ce7ef6..3b170284a0e59 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -31,6 +31,8 @@
 #define LPFC_NVMET_MRQ_AUTO		0
 #define LPFC_NVMET_MRQ_MAX		16
 
+#define LPFC_NVMET_WAIT_TMO		(5 * MSEC_PER_SEC)
+
 /* Used for NVME Target */
 struct lpfc_nvmet_tgtport {
 	struct lpfc_hba *phba;
-- 
2.20.1

