Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C4613F93C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgAPQxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbgAPQxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18E4221D56;
        Thu, 16 Jan 2020 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193579;
        bh=DtVOZRyHl8PCArYtIWTWEE6k8DoNzsgbYZyWaqZdNhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvNZxcoY8Lg7fXl8i0kycFBx2j5ZqndZZZg1USInFAxOoRF7iro1efRKzZFVZQQBp
         9vdjsq0v2LYQKEH1NWPSdXowYunVycXdfJTiwtF2dyLkSepAEJ0yM/04auM785AOJf
         0Aj9hKT024os3ZgTPyiA1pSF1ctGwM/WHdnh0whI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 122/205] scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()
Date:   Thu, 16 Jan 2020 11:41:37 -0500
Message-Id: <20200116164300.6705-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 765ab6cdac3b681952da0e22184bf6cf1ae41cf8 ]

Fix the following kernel bug report:

BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/954

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Link: https://lore.kernel.org/r/20191107052158.25788-2-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9771638b64ba..2d75be07cd6e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20430,7 +20430,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(smp_processor_id()));
+				   cpu_to_node(raw_smp_processor_id()));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8353 error kmalloc memory for HDWQ "
@@ -20573,7 +20573,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(smp_processor_id()));
+				   cpu_to_node(raw_smp_processor_id()));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8355 error kmalloc memory for HDWQ "
-- 
2.20.1

