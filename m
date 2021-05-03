Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4213371C50
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhECQv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234559AbhECQu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A9C61929;
        Mon,  3 May 2021 16:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060061;
        bh=+YEct+Y8S7NbwlkbygDanQtv7V60BVLf9aTdtBUpt2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIDlnvMUzSVRvTbbjQTFelz/8ZRfEGdCMQbhw9jWzXgXeweHEa1uvNBkuE9Z1izFy
         Cm2t0EBkpu+/6lNzRDLSHQxADhsUHyzL0j9G8SoLhjUPUlPD/M4qzmCrOlAkTmbyyk
         qmV1Oa7gO91T5s2EoKlbvvpjYuYV55I65k03uDFeFfnOZHlTtz1sMYJEORj+Yxo0Ef
         ruZVhH22bEmzM/etEasOdY8oWWTzEg6/WCfFpqzk/ea4npJfo15Toc1o4Z+nicTf+k
         UkIOL2u3UhEX5/HiQyXVL9+nIaXN7FHlUfbpvCcRKPmhhcp47kkskt1zxYTmGm3i8i
         I/RdqxaBtpYeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 52/57] scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
Date:   Mon,  3 May 2021 12:39:36 -0400
Message-Id: <20210503163941.2853291-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit fffd18ec6579c2d9c72b212169259062fe747888 ]

Fix a crash caused by a double put on the node when the driver completed an
ACC for an unsolicted abort on the same node.  The second put was executed
by lpfc_nlp_not_used() and is wrong because the completion routine executes
the nlp_put when the iocbq was released.  Additionally, the driver is
issuing a LOGO then immediately calls lpfc_nlp_set_state to put the node
into NPR.  This call does nothing.

Remove the lpfc_nlp_not_used call and additional set_state in the
completion routine.  Remove the lpfc_nlp_set_state post issue_logo.  Isn't
necessary.

Link: https://lore.kernel.org/r/20210412013127.2387-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 --
 drivers/scsi/lpfc/lpfc_sli.c       | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index ea31711b1aeb..fdd87508c804 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1961,8 +1961,6 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		lpfc_issue_els_logo(vport, ndlp, 0);
-		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b9857d7b224f..79ae01bc7abf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17472,7 +17472,6 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc_hba *phba,
 	if (cmd_iocbq) {
 		ndlp = (struct lpfc_nodelist *)cmd_iocbq->context1;
 		lpfc_nlp_put(ndlp);
-		lpfc_nlp_not_used(ndlp);
 		lpfc_sli_release_iocbq(phba, cmd_iocbq);
 	}
 
-- 
2.30.2

