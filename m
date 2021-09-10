Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAC34061E0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhIJAoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhIJATs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FEEC610E9;
        Fri, 10 Sep 2021 00:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233118;
        bh=sm+FccchJKCIPtXH/Cfkp2MrxS4Sdo7Q7eJEc9pffsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoxzU6exj7cOD32taKsE1V/WKfWkSS39VMeBQQmaLBAml7kNzEa5q3eqGKzUp8xRd
         MtTyEpGvwwufDseGWrHOOZMJpLqp6uWjXmZbvPsHKJoopArGJC4AoEo2nOsoytFENk
         N1EZIcL5KI2kFgv/HTpuhq3WgSPEIi69ZmvXnNCgPc7Sa7R31+slfrLvjSiOieSWG9
         H/maSEDhKpck3UzO9qtwpuvHTgBI3hXr0orUW4xOXcbfbHTvSEB/2mz0AsQvXsvBqj
         QJLUnIH7TTIPv3i1VZHs5J8h2MHRZYurptPQ6WF5QbokfALHii8pi3AaHC2uYLewaX
         W+QTkyqtR5FfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 12/88] scsi: lpfc: Skip issuing ADISC when node is in NPR state
Date:   Thu,  9 Sep 2021 20:17:04 -0400
Message-Id: <20210910001820.174272-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit ab803860882514ddbf97713b143b861b524e8476 ]

When a node moves to NPR state due to a device recovery event, the
nlp_fc4_types in the node are cleared. An ADISC received for a node in the
NPR state triggers an ADISC. Without fc4 types being known, the calls to
register with the transport are no-op'd, thus no additional references are
placed on the node by transport re-registrations. A subsequent RSCN could
trigger another unregister request, which will decrement the reference
counts, leading to the ref count hitting zero and the node being freed
while futher discovery on the node is being attempted by the RSCN event
handling.

Fix by skipping the trigger of an ADISC when in NPR state. The normal ADISC
process will kick off in the regular discovery path after receiving a
response from name server.

Link: https://lore.kernel.org/r/20210707184351.67872-19-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 34 +++++++++++++++++-------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 3dac116c405b..b3da39abc90f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -732,9 +732,13 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * is already in MAPPED or UNMAPPED state.  Catch this
 		 * condition and don't set the nlp_state again because
 		 * it causes an unnecessary transport unregister/register.
+		 *
+		 * Nodes marked for ADISC will move MAPPED or UNMAPPED state
+		 * after issuing ADISC
 		 */
 		if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET)) {
-			if (ndlp->nlp_state != NLP_STE_MAPPED_NODE)
+			if ((ndlp->nlp_state != NLP_STE_MAPPED_NODE) &&
+			    !(ndlp->nlp_flag & NLP_NPR_ADISC))
 				lpfc_nlp_set_state(vport, ndlp,
 						   NLP_STE_MAPPED_NODE);
 		}
@@ -2630,14 +2634,13 @@ lpfc_rcv_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
-		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			spin_unlock_irq(&ndlp->lock);
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
-			lpfc_issue_els_adisc(vport, ndlp, 0);
-		} else {
+		/*
+		 * ADISC nodes will be handled in regular discovery path after
+		 * receiving response from NS.
+		 *
+		 * For other nodes, Send PLOGI to trigger an implicit LOGO.
+		 */
+		if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
@@ -2670,12 +2673,13 @@ lpfc_rcv_padisc_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 */
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC)) {
-		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
-			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
-			lpfc_issue_els_adisc(vport, ndlp, 0);
-		} else {
+		/*
+		 * ADISC nodes will be handled in regular discovery path after
+		 * receiving response from NS.
+		 *
+		 * For other nodes, Send PLOGI to trigger an implicit LOGO.
+		 */
+		if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
-- 
2.30.2

