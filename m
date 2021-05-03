Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EF6371C75
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhECQwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232498AbhECQur (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5A061930;
        Mon,  3 May 2021 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060073;
        bh=ljK0OWRWU91H4eVv5i+48sgdxmdT4Aek2r5IceEEQfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3PHjEitbL3EY4g5uRj1OhHB9pb2nhlxA1xCAfWfnXJJmA5XyEQJfdSniYtF1dKRD
         sx308Crmg9edJhNmf4Lzymsx2PorLeOOvGlY28boIzchmBeh1YaXMne5zl6lYVTrYW
         mejUs5/pH0QABiWs20R3p0V6HBYsh9mAPYnTxGRexqk0jnevzlQeu5FRUX0OjOzOD1
         atKs5UzFL0DWdSIuwSEDAQZ6Jr3qgAnYHesCVyxQMqzvIEq3ih5fWpwIR1go85/Wrx
         TDfOw1m4DuNm06p1GQF83q8YtWCoiQN4v0KrMuVHM+mxxQznAASp4MsubuLbX3AmUf
         3PVuLsln6y9vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/35] scsi: lpfc: Fix pt2pt connection does not recover after LOGO
Date:   Mon,  3 May 2021 12:40:36 -0400
Message-Id: <20210503164109.2853838-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit bd4f5100424d17d4e560d6653902ef8e49b2fc1f ]

On a pt2pt setup, between 2 initiators, if one side issues a a LOGO, there
is no relogin attempt. The FC specs are grey in this area on which port
(higher wwn or not) is to re-login.

As there is no spec guidance, unconditionally re-PLOGI after the logout to
ensure a login is re-established.

Link: https://lore.kernel.org/r/20210301171821.3427-8-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 3dfed191252c..518bdae24543 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -708,9 +708,14 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
 		((ndlp->nlp_type & NLP_FCP_TARGET) ||
-		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
+		(ndlp->nlp_type & NLP_NVME_TARGET) ||
+		(vport->fc_flag & FC_PT2PT))) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
-		/* Only try to re-login if this is NOT a Fabric Node */
+		/* Only try to re-login if this is NOT a Fabric Node
+		 * AND the remote NPORT is a FCP/NVME Target or we
+		 * are in pt2pt mode. NLP_STE_ADISC_ISSUE is a special
+		 * case for LOGO as a response to ADISC behavior.
+		 */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(shost->host_lock);
-- 
2.30.2

