Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113973A621C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhFNKzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234186AbhFNKxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20EED613FA;
        Mon, 14 Jun 2021 10:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667198;
        bh=ybWbKRT6SyVWjItDV8O6L3KrhsfiBNd/ktFe2SWzlMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9aJDnmmZMl3EZfFvUHR5o1uIWOXvBpX2R/hF5mkvWYUbUlggdE4sAG5v75nehXEX
         jjiGR7rmwmwLwgnFcHTCGhNiJtimjY/pccYaD0xG1n70cX80CkqoXgwCIxusyFWamW
         SiIoO/X3Yr3v5yM6eZVZPB++9wqrPrH6AQYGSMBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/84] scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq
Date:   Mon, 14 Jun 2021 12:26:59 +0200
Message-Id: <20210614102647.076448603@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 723f51c822af..916447f3c607 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3274,14 +3274,14 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
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



