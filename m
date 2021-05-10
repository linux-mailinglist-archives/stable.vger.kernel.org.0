Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28921378883
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhEJLVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237151AbhEJLL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B5C61944;
        Mon, 10 May 2021 11:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644862;
        bh=H5vO1PhcR9KCes3dqydKMHs2i98QgjcTxW8llFMZEOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWpwIOMo7MkGqBgjGLeIBJi2JiCSh95s1cztBvS3U8aHFAkHM/HJx6tBtxmf4VGRa
         woA8BmdDgTJxbCL1YSPRWttNYBiMvkPiSu2pWxOFdQ5pFROy6B1KPVPRAisEnvw/ZP
         6Edf1s+PU5J79b6uapDHabGqHc4ClD/D5mi7q8z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 254/384] scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
Date:   Mon, 10 May 2021 12:20:43 +0200
Message-Id: <20210510102023.250461776@linuxfoundation.org>
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
index 7fc796905a7a..9f05f5e329c6 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1891,8 +1891,6 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		lpfc_issue_els_logo(vport, ndlp, 0);
-		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 071a13d4d14a..8e34d6076fbc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18074,7 +18074,6 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc_hba *phba,
 	if (cmd_iocbq) {
 		ndlp = (struct lpfc_nodelist *)cmd_iocbq->context1;
 		lpfc_nlp_put(ndlp);
-		lpfc_nlp_not_used(ndlp);
 		lpfc_sli_release_iocbq(phba, cmd_iocbq);
 	}
 
-- 
2.30.2



