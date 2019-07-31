Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E88D7BDD7
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfGaJ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:59:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44357 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbfGaJ7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 05:59:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so31713085pgl.11
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 02:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UbBQQRLxpygquoYJMp5IbAbyJw/jWOiuWIcqrrvEH4U=;
        b=e2kKXttYJCkFqN9hw6JMtpbzE0+aOyj/iV7uJ2tqExSS5b0oYL9CFakPmSmj43QWsp
         OcC+VA405d0HDCS3yo/qdV6+P7Qa5OMv1mwne44CETS/gGHbDmHqb2ARv4iJgNquTK3T
         n8EgUrANBAKqgKxg08QhSMLC9tXj9xTNxdW+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UbBQQRLxpygquoYJMp5IbAbyJw/jWOiuWIcqrrvEH4U=;
        b=sBxuMaz/KC03taJAtRclq0JgIeqc8uORVn4fAa20ZdMBagkAIsDxTu1WjZ1v0yaWJS
         DuvYxPmJFZ4uqts4LBABx7E8HrYmjcqr8LwJY6A2IvRU8de6TYcluACuGpczywISJMtA
         vO6ne9fr1Yx3WpzikuJKeNxSCfE/2qoz+P615FE7svIyHT7MJ4TyjUE0QJi9vUC2x8lg
         bchp+x18FTzPcNHyMOXppObmEabvB7/GDpG9mHGxfR8U0/lsD+257BgtaO8bbiWKLXwi
         fXOxjhUVRm0TrLTi9YeFB/mdIZnHd/j/t53+O9idq19rDPF5GGXneDOyIXauZUVVWBeK
         Tthw==
X-Gm-Message-State: APjAAAVutJozAA/f0tkxMM498GhiOiYGQvk4l6N54eQjaMcsURfsx7ri
        2o8lnI1FYzpY16BTBstHQDnZtO/YbI32jPxdUsb/Zh/e679jWj6XyhCwFUnnuuexz2tgVSBrD7z
        FeZ05mfdowpUWMb7FMNDyTy70rR3o4tJHR5Uzq8Y0+zTyp9lvS1fJh40zM7urPCaAId7HpDA5EZ
        /IDw4S/WcUZX0c
X-Google-Smtp-Source: APXvYqxJuu/srt7bpt7KCGyBWGVDhcPGCEftI/xgehGhgDndGHr/OhXUHhCp35d+SVGUV4fUkPy6OA==
X-Received: by 2002:a63:c203:: with SMTP id b3mr114453432pgd.450.1564567147655;
        Wed, 31 Jul 2019 02:59:07 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v126sm8208428pgb.23.2019.07.31.02.59.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 02:59:07 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     stable@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date:   Wed, 31 Jul 2019 05:58:49 -0400
Message-Id: <1564567129-9503-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564567129-9503-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1564567129-9503-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Although SAS3 & SAS3.5 IT HBA controllers support
64-bit DMA addressing, as per hardware design,
if DMA able range contains all 64-bits set (0xFFFFFFFF-FFFFFFFF) then
it results in a firmware fault.

e.g. SGE's start address is 0xFFFFFFFF-FFFF000 and
data length is 0x1000 bytes. when HBA tries to DMA the data
at 0xFFFFFFFF-FFFFFFFF location then HBA will
fault the firmware.

Fix:
Driver will set 63-bit DMA mask to ensure the above address
will not be used.

Cc: <stable@vger.kernel.org> # 4.19.63
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
Note:
This Patch is for stable kernel 4.19.63.
Original patch is applied to 5.3/scsi-fixes.
commit ID:  df9a606184bfdb5ae3ca9d226184e9489f5c24f7

 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8776330..d2ab520 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2565,12 +2565,14 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
 	u64 consistent_dma_mask;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
 
 	if (ioc->is_mcpu_endpoint)
 		goto try_32bit;
 
 	if (ioc->dma_mask)
-		consistent_dma_mask = DMA_BIT_MASK(64);
+		consistent_dma_mask = DMA_BIT_MASK(dma_mask);
 	else
 		consistent_dma_mask = DMA_BIT_MASK(32);
 
@@ -2578,11 +2580,11 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 		const uint64_t required_mask =
 		    dma_get_required_mask(&pdev->dev);
 		if ((required_mask > DMA_BIT_MASK(32)) &&
-		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(dma_mask)) &&
 		    !pci_set_consistent_dma_mask(pdev, consistent_dma_mask)) {
 			ioc->base_add_sg_single = &_base_add_sg_single_64;
 			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-			ioc->dma_mask = 64;
+			ioc->dma_mask = dma_mask;
 			goto out;
 		}
 	}
@@ -2609,7 +2611,7 @@ static int
 _base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
 				      struct pci_dev *pdev)
 {
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
 		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 	}
@@ -4545,7 +4547,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
-	if (ioc->dma_mask == 64) {
+	if (ioc->dma_mask > 32) {
 		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
 			pr_warn(MPT3SAS_FMT
 			    "no suitable consistent DMA mask for %s\n",
-- 
2.16.3

