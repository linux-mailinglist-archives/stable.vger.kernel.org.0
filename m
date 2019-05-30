Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749A92F4AA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfE3EkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbfE3DMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584E623D14;
        Thu, 30 May 2019 03:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185954;
        bh=w+FhmIhS0K7NwRM3XfhGWEoAAytEYILGc9QhUeP4gCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7dk0rUyTpNwccOB2Yu6adrY3FUKHNhiNRPUbgNXnueg+2GefvuCcIlpwMZTwtXPv
         TeYJMzaHbwqczp+coHgVDKP//m7dDooBTnpLxQwzIRcSH9lvbzagiE4g04gUJWPMme
         eIXKbUNQY6TcspAEAbker3olZR9+e5Mf66+yTunc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 370/405] scsi: lpfc: Fix use-after-free mailbox cmd completion
Date:   Wed, 29 May 2019 20:06:08 -0700
Message-Id: <20190530030559.442336586@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 676f4bf3f33a3..75e9d46d44d42 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4873,6 +4873,10 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
index 7d2abb70cf093..dc933b6d7800e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2502,8 +2502,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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



