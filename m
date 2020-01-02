Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109D712ED2C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgABWZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgABWZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:25:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF21A222C3;
        Thu,  2 Jan 2020 22:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003937;
        bh=S06nD4+InRMS/mrn6P6TDwIwbqOvVhfwerr3OLNfmvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgJ0KebxwSIjDOuX2T/4SaWOHNM/6Vn1xCysheh0hssu0xfagIcff/NpLnhev/dGG
         WNt2Zd7MRa0MAHHIhEaRUy1PCSG6wFR1NftlH17v1aazGXdh6lhqroWGnmJK19ujPM
         P7nuOF3/TyCWLchnU8GYgzNgd4fyGqopPcRIywiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        James Bottomley <James.Bottomley@SteelEye.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/91] scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences
Date:   Thu,  2 Jan 2020 23:07:08 +0100
Message-Id: <20200102220426.562383744@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 6c6d59e0fe5b86cf273d6d744a6a9768c4ecc756 ]

Coverity reported the following:

*** CID 101747:  Null pointer dereferences  (FORWARD_NULL)
/drivers/scsi/lpfc/lpfc_els.c: 4439 in lpfc_cmpl_els_rsp()
4433     			kfree(mp);
4434     		}
4435     		mempool_free(mbox, phba->mbox_mem_pool);
4436     	}
4437     out:
4438     	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
vvv     CID 101747:  Null pointer dereferences  (FORWARD_NULL)
vvv     Dereferencing null pointer "shost".
4439     		spin_lock_irq(shost->host_lock);
4440     		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
4441     		spin_unlock_irq(shost->host_lock);
4442
4443     		/* If the node is not being used by another discovery thread,
4444     		 * and we are sending a reject, we are done with it.

Fix by adding a check for non-null shost in line 4438.
The scenario when shost is set to null is when ndlp is null.
As such, the ndlp check present was sufficient. But better safe
than sorry so add the shost check.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 101747 ("Null pointer dereferences")
Fixes: 2e0fef85e098 ("[SCSI] lpfc: NPIV: split ports")

CC: James Bottomley <James.Bottomley@SteelEye.com>
CC: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC: linux-next@vger.kernel.org
Link: https://lore.kernel.org/r/20191111230401.12958-3-jsmart2021@gmail.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c851fd14ff3e..4c84c2ae1112 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4102,7 +4102,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		mempool_free(mbox, phba->mbox_mem_pool);
 	}
 out:
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
 		spin_unlock_irq(shost->host_lock);
-- 
2.20.1



