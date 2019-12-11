Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B230E11B455
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732810AbfLKP0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730318AbfLKP0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF40822B48;
        Wed, 11 Dec 2019 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078005;
        bh=OSFAwokhjVj4dINBlboHHTQOSgmlkV+Ovz0AurH0rXU=;
        h=From:To:Cc:Subject:Date:From;
        b=k7V7ZbpoyX42slyLqO6GVgf++h2gfXIJK6s+5e7kDkDFUPEnr8EjDtocQZueY5yyP
         liNW9vGli1dImkE3CUSwV+KmbHq4Rqv5P00w4ICnx/rqJoQ2TcHWYc/3bFNA91HOkq
         E6KO77lWbU1Q6lUu4CorTiCwbo2cN2wHX3F2qDwI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/79] scsi: lpfc: Fix discovery failures when target device connectivity bounces
Date:   Wed, 11 Dec 2019 10:25:25 -0500
Message-Id: <20191211152643.23056-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 3f97aed6117c7677eb16756c4ec8b86000fd5822 ]

An issue was seen discovering all SCSI Luns when a target device undergoes
link bounce.

The driver currently does not qualify the FC4 support on the target.
Therefore it will send a SCSI PRLI and an NVMe PRLI. The expectation is
that the target will reject the PRLI if it is not supported. If a PRLI
times out, the driver will retry. The driver will not proceed with the
device until both SCSI and NVMe PRLIs are resolved.  In the failure case,
the device is FCP only and does not respond to the NVMe PRLI, thus
initiating the wait/retry loop in the driver.  During that time, a RSCN is
received (device bounced) causing the driver to issue a GID_FT.  The GID_FT
response comes back before the PRLI mess is resolved and it prematurely
cancels the PRLI retry logic and leaves the device in a STE_PRLI_ISSUE
state. Discovery with the target never completes or resets.

Fix by resetting the node state back to STE_NPR_NODE when GID_FT completes,
thereby restarting the discovery process for the node.

Link: https://lore.kernel.org/r/20190922035906.10977-10-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b36b3da323a0a..5d657178c2b98 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5231,9 +5231,14 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			/* If we've already received a PLOGI from this NPort
 			 * we don't need to try to discover it again.
 			 */
-			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
+			if (ndlp->nlp_flag & NLP_RCV_PLOGI &&
+			    !(ndlp->nlp_type &
+			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
 				return NULL;
 
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
-- 
2.20.1

