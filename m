Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465694EF12C
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbiDAOgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348214AbiDAOdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BFE1EA5C9;
        Fri,  1 Apr 2022 07:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 022D8B82518;
        Fri,  1 Apr 2022 14:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A2AC2BBE4;
        Fri,  1 Apr 2022 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823474;
        bh=Oouh5dIQuZP+EZooFgeCEmDkkyihPAy52mOHVf/a28g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/jz0SlcbWZ033jGayYDs753fbb4TjJhR2cF5Ut9E/OZl0dwgddPWr5CgILFSq3dh
         mEkPhkdeb6XTMUKZyXQu7My+ZDt6xfYbJ5zx+pGuyfMP8CnOsRU8DxVz1DP8chIeeK
         fMKNwfFCojJF3HV4iiAg7leQv1+GT43ykzo/5ElsSR55lg5q6LxXHjfgN74GqqHs4Y
         HxNzwELwvBZdAirIFyEM/pDl8lpevYxxsKVVdbFVce0x8jQpYbxTHwLiC8EIBQK2qE
         ATD0zzsoxqDBhT/apYH98Ad9ys2ZVBpaJHWGp1rmlmco9ucdHChTZXnSOOVhLw/0mG
         iSXaJU3JMF0Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qi Liu <liuqi115@huawei.com>, John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 107/149] scsi: hisi_sas: Free irq vectors in order for v3 HW
Date:   Fri,  1 Apr 2022 10:24:54 -0400
Message-Id: <20220401142536.1948161-107-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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
index a01a3a7b706b..ce0d4bfbe51e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2398,17 +2398,25 @@ static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
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
@@ -2420,6 +2428,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
+	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 	return 0;
 }
 
@@ -4769,7 +4778,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_free_irq_vectors;
+		goto err_out_debugfs;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -4800,8 +4809,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sas_unregister_ha(sha);
 err_out_register_ha:
 	scsi_remove_host(shost);
-err_out_free_irq_vectors:
-	pci_free_irq_vectors(pdev);
 err_out_debugfs:
 	debugfs_exit_v3_hw(hisi_hba);
 err_out_ha:
@@ -4825,7 +4832,6 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
 
 		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);
 	}
-	pci_free_irq_vectors(pdev);
 }
 
 static void hisi_sas_v3_remove(struct pci_dev *pdev)
-- 
2.34.1

