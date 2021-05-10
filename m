Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DF437889D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhEJLW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234883AbhEJLJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B5E613C2;
        Mon, 10 May 2021 11:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644712;
        bh=yHG2IUCs5gcLBdPzjv1JfdOvr4kqgN2uOkGi6ALdm70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCczAdYmfph8S2blg6uNQKRS+zdcNI1OwEX1Q6V5vYoU/7vp5lRBu6R11M7hMZ7Ut
         3JnDdUVAMGWTry8L60DOj7SRDU7sIAUl/o7zjanIkO1k/fTiYv1r4YDaR0dt913HzI
         eJTL9B+wObDeRregbtL3wa81qFvaAYN+X9kbGThM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 158/384] scsi: lpfc: Fix ADISC handling that never frees nodes
Date:   Mon, 10 May 2021 12:19:07 +0200
Message-Id: <20210510102020.090699946@linuxfoundation.org>
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

[ Upstream commit 309b477462df7542355ac984674a6e89c01c89aa ]

While testing target port swap test with ADISC enabled, several nodes
remain in UNUSED state. These nodes are never freed and rmmod hangs for
long time before finising with "0233 Nodelist not empty" error.

During PLOGI completion lpfc_plogi_confirm_nport() looks for existing nodes
with same WWPN. If found, the existing node is used to continue discovery.
The node on which plogi was performed is freed.  When ADISC is enabled, an
ADISC els request is triggered in response to an RSCN.  It's possible that
the ADISC may be rejected by the remote port causing the ADISC completion
handler to clear the port and node name in the node.  If this occurs, if a
PLOGI is received it causes a node lookup based on wwpn to now fail,
causing the port swap logic to kick in which allocates a new node and swaps
to it. This effectively orphans the original node structure.

Fix the situation by detecting when the lookup fails and forgo the node
swap and node allocation by using the node on which the PLOGI was issued.

Link: https://lore.kernel.org/r/20210301171821.3427-15-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index beb2fcd2d8e7..04c002eea446 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1600,7 +1600,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct lpfc_nodelist *new_ndlp;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
+	uint32_t keepDID = 0, keep_nlp_flag = 0;
 	uint32_t keep_new_nlp_flag = 0;
 	uint16_t keep_nlp_state;
 	u32 keep_nlp_fc4_type = 0;
@@ -1622,7 +1622,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
 	/* return immediately if the WWPN matches ndlp */
-	if (new_ndlp == ndlp)
+	if (!new_ndlp || (new_ndlp == ndlp))
 		return ndlp;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -1641,30 +1641,11 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 (new_ndlp ? new_ndlp->nlp_flag : 0),
 			 (new_ndlp ? new_ndlp->nlp_fc4_type : 0));
 
-	if (!new_ndlp) {
-		rc = memcmp(&ndlp->nlp_portname, name,
-			    sizeof(struct lpfc_name));
-		if (!rc) {
-			if (active_rrqs_xri_bitmap)
-				mempool_free(active_rrqs_xri_bitmap,
-					     phba->active_rrq_pool);
-			return ndlp;
-		}
-		new_ndlp = lpfc_nlp_init(vport, ndlp->nlp_DID);
-		if (!new_ndlp) {
-			if (active_rrqs_xri_bitmap)
-				mempool_free(active_rrqs_xri_bitmap,
-					     phba->active_rrq_pool);
-			return ndlp;
-		}
-	} else {
-		keepDID = new_ndlp->nlp_DID;
-		if (phba->sli_rev == LPFC_SLI_REV4 &&
-		    active_rrqs_xri_bitmap)
-			memcpy(active_rrqs_xri_bitmap,
-			       new_ndlp->active_rrqs_xri_bitmap,
-			       phba->cfg_rrq_xri_bitmap_sz);
-	}
+	keepDID = new_ndlp->nlp_DID;
+
+	if (phba->sli_rev == LPFC_SLI_REV4 && active_rrqs_xri_bitmap)
+		memcpy(active_rrqs_xri_bitmap, new_ndlp->active_rrqs_xri_bitmap,
+		       phba->cfg_rrq_xri_bitmap_sz);
 
 	/* At this point in this routine, we know new_ndlp will be
 	 * returned. however, any previous GID_FTs that were done
-- 
2.30.2



