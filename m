Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F129F39A6FB
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhFCRJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231475AbhFCRJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFCD0613F4;
        Thu,  3 Jun 2021 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740090;
        bh=GYnBavskh1K21ICisCRLOl5jmMjynEhXhWNdlUbVhYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1LMZcYGHtT0JnbkRg/TNGOYh/R8TKxaDGduesiCZMxNfPAZYunEwjAWwxzhPBH6k
         s94dxVFncv6QXVgLZkJufDCY+5Sm6PLm63cKgrbesScsyoU8w4zDeiXaLhIlopUpYm
         Zz72v6vMAR3MQAR9rKN3l6EP2gcOCNA7wjZP8RT1bC23euvGZa3yoKpTtSgtqR62m1
         B8VzEXGS7LOigA2sZOoE8i3EBGwCEpl8cVCsnzBrdbL2opYAq5FWS20l35vKZ5y3hJ
         VJQl4At01IdTo1yxt45WEd9mxh9WaDfneInpMI2HhbRN8wzJ8ik5iHVnHaLXyC8ao9
         ccdzaZTvzADAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 29/43] scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq
Date:   Thu,  3 Jun 2021 13:07:19 -0400
Message-Id: <20210603170734.3168284-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7907a021e4bbfa29cccacd2ba2dade894d9a7d4c ]

irqs allocated with devm_request_irq() should not be freed using
free_irq(). Doing so causes a dangling pointer and a subsequent double
free.

Link: https://lore.kernel.org/r/20210519130519.2661938-1-yangyingliang@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4580e081e489..b21246b1ba99 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4799,14 +4799,14 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
 {
 	int i;
 
-	free_irq(pci_irq_vector(pdev, 1), hisi_hba);
-	free_irq(pci_irq_vector(pdev, 2), hisi_hba);
-	free_irq(pci_irq_vector(pdev, 11), hisi_hba);
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 1), hisi_hba);
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 2), hisi_hba);
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 11), hisi_hba);
 	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 		int nr = hisi_sas_intr_conv ? 16 : 16 + i;
 
-		free_irq(pci_irq_vector(pdev, nr), cq);
+		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);
 	}
 	pci_free_irq_vectors(pdev);
 }
-- 
2.30.2

