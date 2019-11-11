Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27791F7EFB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfKKSiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbfKKSiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA69B21925;
        Mon, 11 Nov 2019 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497503;
        bh=/yTxoQdhsdVTBQCLwhVcQgv5+8lzYPyz6uvpfgB+Vy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxh3ZjGtLKIEq4EmfiJ8MOsTngAq+9KVjh0cmJC30kz02vnaf8XH7sni6rdPb/G8B
         9kfdQzXFFwE2m/Ij391Xhcy+PxQ5c9B2hY5lUykKWx71Vt4ZWzdScKzGCrCqjlaqXI
         iHtnCZz2ejKjcYnVxbYMlc3foy30zTbGsltXRZVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/105] scsi: lpfc: Honor module parameter lpfc_use_adisc
Date:   Mon, 11 Nov 2019 19:28:46 +0100
Message-Id: <20191111181446.238322297@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 0fd103ccfe6a06e40e2d9d8c91d96332cc9e1239 ]

The initial lpfc_desc_set_adisc implementation in commit
dea3101e0a5c ("lpfc: add Emulex FC driver version 8.0.28") enabled ADISC if

	cfg_use_adisc && RSCN_MODE && FCP_2_DEVICE

In commit 92d7f7b0cde3 ("[SCSI] lpfc: NPIV: add NPIV support on top of
SLI-3") this changed to

	(cfg_use_adisc && RSC_MODE) || FCP_2_DEVICE

and later in commit ffc954936b13 ("[SCSI] lpfc 8.3.13: FC Discovery Fixes
and enhancements.") to

	(cfg_use_adisc && RSC_MODE) || (FCP_2_DEVICE && FCP_TARGET)

A customer reports that after a devloss, an ADISC failure is logged. It
turns out the ADISC flag is set even the user explicitly set lpfc_use_adisc
= 0.

[Sat Dec 22 22:55:58 2018] lpfc 0000:82:00.0: 2:(0):0203 Devloss timeout on WWPN 50:01:43:80:12:8e:40:20 NPort x05df00 Data: x82000000 x8 xa
[Sat Dec 22 23:08:20 2018] lpfc 0000:82:00.0: 2:(0):2755 ADISC failure DID:05DF00 Status:x9/x70000

[mkp: fixed Hannes' email]

Fixes: 92d7f7b0cde3 ("[SCSI] lpfc: NPIV: add NPIV support on top of SLI-3")
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: James Smart <james.smart@broadcom.com>
Link: https://lore.kernel.org/r/20191022072112.132268-1-dwagner@suse.de
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 36fb549eb4e86..a0658d1582287 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -809,9 +809,9 @@ lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	if (!(vport->fc_flag & FC_PT2PT)) {
 		/* Check config parameter use-adisc or FCP-2 */
-		if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
+		if (vport->cfg_use_adisc && ((vport->fc_flag & FC_RSCN_MODE) ||
 		    ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) &&
-		     (ndlp->nlp_type & NLP_FCP_TARGET))) {
+		     (ndlp->nlp_type & NLP_FCP_TARGET)))) {
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_ADISC;
 			spin_unlock_irq(shost->host_lock);
-- 
2.20.1



