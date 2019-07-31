Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5AD7BDD5
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfGaJ7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:59:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34234 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaJ7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 05:59:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so25491534pgc.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=B2F/W6Khl5b8DIAKp/DZU3rMzP5GHON6W3RzTeWHMDA=;
        b=cknzDh4S9MO0DThFVAwVWn8+sVTE2/S5SRSXOFvPbdpZRDPD8MCa/lkT4ACyOULmlH
         b+n24Hf6Xf4PuaKoBJKBKV/Qn+nAicfVB2IxO+cnToWBZC6FlPUh9JRl6lfNmBjfGLzk
         DIf6UCPhvrP0IfIupCiIkfR9VCthMjwPdGGzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B2F/W6Khl5b8DIAKp/DZU3rMzP5GHON6W3RzTeWHMDA=;
        b=KPUvfY1jLC7N3XLRb+vH9xg1LjKdNPv59zxQBqtAWHYxQuDYkMUCB8UkrarDaQuapf
         GgvF9TXZMdqJ0XPm3b/eY0sUIjlVXIrPl8yRDeVZTEhxSeBkN11sTbl8mkZTcqtULDLY
         RFx2OMGlg9tMaM6+Yr7Z5NauIRLAFngYBfwkpkjBsUf/I8O0VbS2pMVmrdLJEkKOeCSV
         HXEsu1zkjqzEu1BrVkFHLgp4TNsNGc7+6+8Yqc/goZwF2UtbpfLYhqciWspD/74KwCQ8
         S/UoN59EEMQV5qw4U6T0U2q/wN9uw0a3TH4h0dnYYJTLBM0F019+M1sdOEMiAY4qDsM2
         X3lg==
X-Gm-Message-State: APjAAAUSssMg+6Ha6DMKMDjVmOr75eHvVQJQjRHl0HE2zotkz5PxcSWr
        x1ALMQR6UxXYMBTl87RxxBY09jOqEtYXsMdE/1aUMcga2ZhYM/XVRCm7F5230HYPDVHugLQYCtf
        eeAfmm3sCfoL5PsP4ENXTxcBdPX5N/s2Yabjrts8mUzFta2sj5PnfFpmQ3NSmi5hUPBVdrMrkko
        C2eiUh4yqFT7tC
X-Google-Smtp-Source: APXvYqyzJu0u3A7E8VAM+pU8cymSDEWIA/EycP2f1Hp9FurY1BVtOy1Bpe9h7pMBjpwa+gV/0fR+3A==
X-Received: by 2002:a17:90a:9b8a:: with SMTP id g10mr2070612pjp.66.1564567145302;
        Wed, 31 Jul 2019 02:59:05 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v126sm8208428pgb.23.2019.07.31.02.59.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 02:59:04 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     stable@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date:   Wed, 31 Jul 2019 05:58:48 -0400
Message-Id: <1564567129-9503-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
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

Cc: <stable@vger.kernel.org> # 4.4.186, # 4.9.186
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
Note:
This Patch is for stable kernel 4.4.186 and 4.9.186.
Original patch is applied to 5.3/scsi-fixes.
commit ID:  df9a606184bfdb5ae3ca9d226184e9489f5c24f7

 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9b53672..7af7a08 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1686,9 +1686,11 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
 	u64 consistent_dma_mask;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
 
 	if (ioc->dma_mask)
-		consistent_dma_mask = DMA_BIT_MASK(64);
+		consistent_dma_mask = DMA_BIT_MASK(dma_mask);
 	else
 		consistent_dma_mask = DMA_BIT_MASK(32);
 
@@ -1696,11 +1698,11 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
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
@@ -1726,7 +1728,7 @@ static int
 _base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
 				      struct pci_dev *pdev)
 {
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
 		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 	}
@@ -3325,7 +3327,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
-	if (ioc->dma_mask == 64) {
+	if (ioc->dma_mask > 32) {
 		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
 			pr_warn(MPT3SAS_FMT
 			    "no suitable consistent DMA mask for %s\n",
-- 
2.16.3

