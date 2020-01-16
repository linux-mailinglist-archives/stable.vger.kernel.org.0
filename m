Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E0E13F922
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgAPQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730724AbgAPQxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D8324679;
        Thu, 16 Jan 2020 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193597;
        bh=drBKSQal6Kqb4KQB0xgWPDgk84pgJ9f9Sw1WHZ+o6NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNOfFfRdK0XtR/5z+Nhr6f42+JRa2Yy6dkZzrJQvJBNaQKXPmmXZ+VaLSkkmtY4J2
         S0jim98y6SF2R1jxae4QN5/8vs11uPAfKgv6BoPZBu1I+fp2kE8u/I3B1e9Wb9mN0v
         nlWpl8dZaALevsEX/xaRGA8MpB+IrWwHOd64r/0M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 136/205] scsi: hisi_sas: Return directly if init hardware failed
Date:   Thu, 16 Jan 2020 11:41:51 -0500
Message-Id: <20200116164300.6705-136-sashal@kernel.org>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 547fde8b5a1923050f388caae4f76613b5a620e0 ]

Need to return directly if init hardware failed.

Fixes: 73a4925d154c ("scsi: hisi_sas: Update all the registers after suspend and resume")
Link: https://lore.kernel.org/r/1573551059-107873-3-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c4f76d7c29db..723f51c822af 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3423,6 +3423,7 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
 	if (rc) {
 		scsi_remove_host(shost);
 		pci_disable_device(pdev);
+		return rc;
 	}
 	hisi_hba->hw->phys_init(hisi_hba);
 	sas_resume_ha(sha);
-- 
2.20.1

