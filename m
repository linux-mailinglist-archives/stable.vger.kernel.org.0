Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171293782B3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhEJKg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232825AbhEJKfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DBB861928;
        Mon, 10 May 2021 10:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642502;
        bh=+YEct+Y8S7NbwlkbygDanQtv7V60BVLf9aTdtBUpt2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C30DiGLUwtwA8cKQm0M5fbMXJsOJeEGT79YU7iGIzmvev+D/cyIgYvO/lcXHRVw+f
         73kFmjldNeer39j2SeUqjidBMtnLPdRgtMdVgC1K2utXbkbN+yhewm6Ya03E9tBoO2
         pfj6rT6jbjVnHnJdgCIYsznzrZ14YNsl7jhJW8FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/184] scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
Date:   Mon, 10 May 2021 12:20:13 +0200
Message-Id: <20210510101954.078226382@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



