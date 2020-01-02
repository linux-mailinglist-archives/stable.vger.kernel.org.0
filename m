Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D86412EC79
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgABWSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgABWSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E41B21582;
        Thu,  2 Jan 2020 22:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003533;
        bh=Dupq50N1G2KBIYbVmQMEw4LpptEWkvK00ll+rCy/DAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytM5Fyo3HJCOXi+Kj06Hho8s8TuWH5TJ3+rejF3CoDzKkm8WINOWX/LfuMCZEL+jv
         OazYeog5sLoGMXBSGEgPKCmDNyd0WVOqGzDdVk5xKAPhh4R2jFrXnRuvM9xLzGHOJ8
         SPmc2SHol/8CG0cEWrpK2uXF29Y8G1FDtTGYZJI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/114] scsi: lpfc: Fix discovery failures when target device connectivity bounces
Date:   Thu,  2 Jan 2020 23:06:13 +0100
Message-Id: <20200102220029.311794077@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b36b3da323a0..5d657178c2b9 100644
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



