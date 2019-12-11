Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D30911B2FC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfLKPkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387659AbfLKPig (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D2B2467F;
        Wed, 11 Dec 2019 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078715;
        bh=v7NXfuoFVjuFyBu9o28MKB2XGHkf0ThvJn1RrLDUic4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0maCFJA+dMOktcL9rREd6keDcalcUYXUNn1IqEkDxpq+D/AynMMDllb3IB4Tl+cKp
         oh9fu4MojhAlPS68qj1WpsMgELJA6jFCmCFQ5hCrnX2ZhBH67slFA/ghM5O5QhLniB
         Qo43l+E8O5xKe6xbXp+yB6zrHd3+z8AiSnSamUWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        James Bottomley <James.Bottomley@SteelEye.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 20/37] scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences
Date:   Wed, 11 Dec 2019 10:37:56 -0500
Message-Id: <20191211153813.24126-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7ca8c2522c928..530b7df21322a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3839,7 +3839,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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

