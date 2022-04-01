Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4378D4EF39E
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348820AbiDAPEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349417AbiDAOzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6255062BF6;
        Fri,  1 Apr 2022 07:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F12FE60AC9;
        Fri,  1 Apr 2022 14:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807EAC340EE;
        Fri,  1 Apr 2022 14:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824229;
        bh=EboOsaMNG1eMs0a1qxUQf1e/CapXfeAqIi3K8ChJLL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhqfZNsgsC0UL8gLnhPBKGw6C0iIGKyTpbf/GiRdPCB0gAgCQCR2H3zAC7Ks/fqUZ
         eW2jcqqENHSFdNmL53hR21GyxyjSBzRDU/8HwNOaFKk1PqlC1CoBCpEkHTSSFEDBRP
         W2QCFYVgii6I/3BbyK22MWY0t3/BpET57xTmp7p4vX2y4Iehj//9yLY6c6pWzRMwsV
         M5AjE9Vxtv1bRCK0/61CAJVDuC7Q9zj+blqr9A7Feb+7+/1bGIZHmhdIBEl7TVzimp
         ttKcG+t47e2k2pUv2tDVhQv8POBPR9D39RLTmLlKQkpMlY2PDPJSmaB0+RIof7gDi3
         iMMcUzOgpA1Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qi Liu <liuqi115@huawei.com>, John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 40/65] scsi: hisi_sas: Free irq vectors in order for v3 HW
Date:   Fri,  1 Apr 2022 10:41:41 -0400
Message-Id: <20220401144206.1953700-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Liu <liuqi115@huawei.com>

[ Upstream commit 554fb72ee34f4732c7f694f56c3c6e67790352a0 ]

If the driver probe fails to request the channel IRQ or fatal IRQ, the
driver will free the IRQ vectors before freeing the IRQs in free_irq(),
and this will cause a kernel BUG like this:

------------[ cut here ]------------
kernel BUG at drivers/pci/msi.c:369!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Call trace:
   free_msi_irqs+0x118/0x13c
   pci_disable_msi+0xfc/0x120
   pci_free_irq_vectors+0x24/0x3c
   hisi_sas_v3_probe+0x360/0x9d0 [hisi_sas_v3_hw]
   local_pci_probe+0x44/0xb0
   work_for_cpu_fn+0x20/0x34
   process_one_work+0x1d0/0x340
   worker_thread+0x2e0/0x460
   kthread+0x180/0x190
   ret_from_fork+0x10/0x20
---[ end trace b88990335b610c11 ]---

So we use devm_add_action() to control the order in which we free the
vectors.

Link: https://lore.kernel.org/r/1645703489-87194-4-git-send-email-john.garry@huawei.com
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 50a1c3478a6e..b14638910efe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2372,17 +2372,25 @@ static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
 	return IRQ_WAKE_THREAD;
 }
 
+static void hisi_sas_v3_free_vectors(void *data)
+{
+	struct pci_dev *pdev = data;
+
+	pci_free_irq_vectors(pdev);
+}
+
 static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 {
 	int vectors;
 	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
 	struct Scsi_Host *shost = hisi_hba->shost;
+	struct pci_dev *pdev = hisi_hba->pci_dev;
 	struct irq_affinity desc = {
 		.pre_vectors = BASE_VECTORS_V3_HW,
 	};
 
 	min_msi = MIN_AFFINE_VECTORS_V3_HW;
-	vectors = pci_alloc_irq_vectors_affinity(hisi_hba->pci_dev,
+	vectors = pci_alloc_irq_vectors_affinity(pdev,
 						 min_msi, max_msi,
 						 PCI_IRQ_MSI |
 						 PCI_IRQ_AFFINITY,
@@ -2394,6 +2402,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
+	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 	return 0;
 }
 
@@ -3313,7 +3322,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev_err(dev, "%d hw queues\n", shost->nr_hw_queues);
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_free_irq_vectors;
+		goto err_out_debugfs;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -3340,8 +3349,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_out_register_ha:
 	scsi_remove_host(shost);
-err_out_free_irq_vectors:
-	pci_free_irq_vectors(pdev);
 err_out_debugfs:
 	hisi_sas_debugfs_exit(hisi_hba);
 err_out_ha:
@@ -3369,7 +3376,6 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
 
 		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);
 	}
-	pci_free_irq_vectors(pdev);
 }
 
 static void hisi_sas_v3_remove(struct pci_dev *pdev)
-- 
2.34.1

