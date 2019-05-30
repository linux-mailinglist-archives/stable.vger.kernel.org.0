Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DF42F1F7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfE3ERQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730427AbfE3DPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CECD24547;
        Thu, 30 May 2019 03:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186140;
        bh=IDRiz9yMnUVa9EqiwOcEISUc1H4lpoejZIC77XXYcXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtbbNe5/LUDUwvqGUtkNQdzeEO2+iizIeLxTlohA9dNFnKC3osxPOezLuyvf/EJmM
         vPfnMctVezrPR1d1lCINoSm9+Qfc52ZRh4Kyciu3uFzaupm1l8kGILKbudAg3IP6CM
         rXSzA5Y+YfJq9vTa0ZVXjFFJf3BmJ8szQ6tpv1ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 315/346] scsi: lpfc: Fix use-after-free mailbox cmd completion
Date:   Wed, 29 May 2019 20:06:28 -0700
Message-Id: <20190530030556.781145612@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b1640686470fbbd1c6efb35ada6fe1427ea8d0f ]

When unloading the driver, mailbox commands may be sent without holding a
reference on the ndlp. By the time the mailbox command completes, the ndlp
may have reduced its ref counts and been freed.  The problem was reported
by KASAN.

While unregistering due to driver unload, have the completion noop'd by
setting the ndlp context NULL'd. Due to the unload, no further action was
necessary.  Also, while reviewing this path, the generic nulling of the
context after handling should be slightly moved.

Reported by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++++
 drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2f01e5397a11d..8d553cfb85aa1 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4879,6 +4879,10 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 					 * accept PLOGIs after unreg_rpi_cmpl
 					 */
 					acc_plogi = 0;
+				} else if (vport->load_flag & FC_UNLOADING) {
+					mbox->ctx_ndlp = NULL;
+					mbox->mbox_cmpl =
+						lpfc_sli_def_mbox_cmpl;
 				} else {
 					mbox->ctx_ndlp = ndlp;
 					mbox->mbox_cmpl =
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2242e9b3ca128..d3a942971d818 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2518,8 +2518,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			} else {
 				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 			}
+			pmb->ctx_ndlp = NULL;
 		}
-		pmb->ctx_ndlp = NULL;
 	}
 
 	/* Check security permission status on INIT_LINK mailbox command */
-- 
2.20.1



