Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364B62F4AE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfE3EkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729100AbfE3DMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757AA23F4C;
        Thu, 30 May 2019 03:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185953;
        bh=D5sRcs3SwtZUPrs/1DaxUqQKn2kN5i+/jrA8gD7B3NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpccSM6bgyMJHEygXDIpMB5XEiQDSISbcnS17RkBvPnGyTj9/WqYVmdY3wTZue5XC
         AnoMaU3DKPE2nBSW/7agsJSaJz7a1sYKww89U2NXQm93wpL5rqRWe3gTF/eZMPRAIA
         Y/131qUtuHGk0nNe25612qhBCgCCizlCX/bOxRnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 368/405] scsi: lpfc: Resolve inconsistent check of hdwq in lpfc_scsi_cmd_iocb_cmpl
Date:   Wed, 29 May 2019 20:06:06 -0700
Message-Id: <20190530030559.343432436@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ff6bf89717b0dc7b8dd0934d1c065f29069831e7 ]

A prior patch which added support for non-uniform allocation of MSIX
vectors now causes a smatch complaint:

 drivers/scsi/lpfc/lpfc_scsi.c:3674 lpfc_scsi_cmd_iocb_cmpl()
   error: we previously assumed 'phba->sli4_hba.hdwq' could be
          null (see line 3667)

Resolve by removing the unnecessary check for a NULL hdwq table.

Fixes 6a828b0f6192: ("scsi: lpfc: Support non-uniform allocation of MSIX vectors to hardware queues")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a497b2c0cb798..25501d4605ff3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3670,7 +3670,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (phba->cpucheck_on & LPFC_CHECK_SCSI_IO) {
 		cpu = smp_processor_id();
-		if (cpu < LPFC_CHECK_CPU_CNT)
+		if (cpu < LPFC_CHECK_CPU_CNT && phba->sli4_hba.hdwq)
 			phba->sli4_hba.hdwq[idx].cpucheck_cmpl_io[cpu]++;
 	}
 #endif
-- 
2.20.1



