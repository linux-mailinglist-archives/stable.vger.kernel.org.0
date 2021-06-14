Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5BF3A627B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhFNLBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234667AbhFNK6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E2606142E;
        Mon, 14 Jun 2021 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667328;
        bh=BzaYx7fpMsxsiOeTmJBdfTpVjnWGpnleTHfSLKwCxIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7ma/JERoU7kXF0DSSL+1DFv5/DZY6+xqVOHXBy0TwvUeXe+UKlj0Dp+NiRHgXbi8
         D5PbQpZpQ1l6FzvuqmfxFK+oaYhlgkx5wJ3+0lIP489skk/E1cyzyKGCbLhxLoBIhK
         OGEzl+Jxb0ma04rZrRd+SswRLR2WOejH19/6Thls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/131] scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq
Date:   Mon, 14 Jun 2021 12:26:29 +0200
Message-Id: <20210614102653.961626619@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
index 19170c7ac336..e9a82a390672 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3359,14 +3359,14 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
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



