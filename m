Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B7E2E3D30
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439880AbgL1OM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439876AbgL1OM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17D620731;
        Mon, 28 Dec 2020 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164733;
        bh=VJeCSk2OcPWhoWvyAv2BOS9dluNOfHJJX4tTZ0+pxPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ly61r5u5MzvGcWKYyOMDYvuLWLEZFuW+0W1enGQeeQCGYReF3x2PKJ4vBH9J+sxoh
         As31LlgYk6ZU+SDnDgckaqNH+jN0N9t3PH10QuKC8RLDp7+gJWR6Ur/BkTjw12lmfX
         g39rOcaNQOzeb+CgK8E+S6Pb0yT7uLMkPBoDmMtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/717] scsi: hisi_sas: Fix up probe error handling for v3 hw
Date:   Mon, 28 Dec 2020 13:44:05 +0100
Message-Id: <20201228125032.820369419@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 2ebde94f2ea4cffd812ece2f318c2f4922239b1d ]

Fix some rollbacks in function hisi_sas_v3_probe() and
interrupt_init_v3_hw().

Link: https://lore.kernel.org/r/1606207594-196362-3-git-send-email-john.garry@huawei.com
Fixes: 8d98416a55eb ("scsi: hisi_sas: Switch v3 hw to MQ")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 960de375ce699..2cbd8a524edab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2409,8 +2409,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			      DRV_NAME " phy", hisi_hba);
 	if (rc) {
 		dev_err(dev, "could not request phy interrupt, rc=%d\n", rc);
-		rc = -ENOENT;
-		goto free_irq_vectors;
+		return -ENOENT;
 	}
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, 2),
@@ -2418,8 +2417,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			      DRV_NAME " channel", hisi_hba);
 	if (rc) {
 		dev_err(dev, "could not request chnl interrupt, rc=%d\n", rc);
-		rc = -ENOENT;
-		goto free_irq_vectors;
+		return -ENOENT;
 	}
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, 11),
@@ -2427,8 +2425,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			      DRV_NAME " fatal", hisi_hba);
 	if (rc) {
 		dev_err(dev, "could not request fatal interrupt, rc=%d\n", rc);
-		rc = -ENOENT;
-		goto free_irq_vectors;
+		return -ENOENT;
 	}
 
 	if (hisi_sas_intr_conv)
@@ -2449,8 +2446,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "could not request cq%d interrupt, rc=%d\n",
 				i, rc);
-			rc = -ENOENT;
-			goto free_irq_vectors;
+			return -ENOENT;
 		}
 		cq->irq_mask = pci_irq_get_affinity(pdev, i + BASE_VECTORS_V3_HW);
 		if (!cq->irq_mask) {
@@ -2460,10 +2456,6 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 
 	return 0;
-
-free_irq_vectors:
-	pci_free_irq_vectors(pdev);
-	return rc;
 }
 
 static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
@@ -3317,11 +3309,11 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = interrupt_preinit_v3_hw(hisi_hba);
 	if (rc)
-		goto err_out_ha;
+		goto err_out_debugfs;
 	dev_err(dev, "%d hw queues\n", shost->nr_hw_queues);
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_ha;
+		goto err_out_free_irq_vectors;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -3348,8 +3340,12 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_out_register_ha:
 	scsi_remove_host(shost);
-err_out_ha:
+err_out_free_irq_vectors:
+	pci_free_irq_vectors(pdev);
+err_out_debugfs:
 	hisi_sas_debugfs_exit(hisi_hba);
+err_out_ha:
+	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
-- 
2.27.0



