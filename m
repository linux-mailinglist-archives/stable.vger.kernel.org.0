Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944C3371AD8
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhECQlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhECQjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B41613CD;
        Mon,  3 May 2021 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059847;
        bh=r18eagK+TWWaSO464JTLqmWqludixdPBwKpeMcvU/ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUlYSIw9f7c2+ZOn2DIU5Rn/EZkfIlgi6x8/i4rnEwkFTuNs1Z8VRE3aYLdbbF4XQ
         D0/14MdXf9XUldAP9K9JjUA/ekxxxCXxOS1xl+Hjw5zOLP2pExi3pAH9r+6JTwG1qK
         H2xM6CZZVPl6ZJCYHzTSDaD0rhS2cRawGjwXlDldSmjTBGgZurE0osWO9jQ+iIfwnK
         WorfNBTkbzQcejyZWaKh8qBGBGLqd2f0E3VuzVUHTaGvneNCizAMfX2kDNwnZViAk9
         z8KMlUu/y3z7Eo9R9M5Q+FA7Kfeh1rxyvXnM9C1xGhPjNYufNAMd7xfwd3Jddka9G6
         978m+h4BAWGMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 017/115] scsi: lpfc: Fix ADISC handling that never frees nodes
Date:   Mon,  3 May 2021 12:35:21 -0400
Message-Id: <20210503163700.2852194-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 20f3b21ef05c..69e8a127b44f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1597,7 +1597,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct lpfc_nodelist *new_ndlp;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
+	uint32_t keepDID = 0, keep_nlp_flag = 0;
 	uint32_t keep_new_nlp_flag = 0;
 	uint16_t keep_nlp_state;
 	u32 keep_nlp_fc4_type = 0;
@@ -1619,7 +1619,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
 	/* return immediately if the WWPN matches ndlp */
-	if (new_ndlp == ndlp)
+	if (!new_ndlp || (new_ndlp == ndlp))
 		return ndlp;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -1638,30 +1638,11 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
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

