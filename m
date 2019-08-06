Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A69982F8B
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 12:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbfHFKNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 06:13:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38564 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFKNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 06:13:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so41263389pfn.5
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 03:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=7NJ+wiYrZBSzT7T/m/YjM+5J0bJRbCG/9IwkVfKiHmM=;
        b=fY9j5WBydLrzUI8t/trbu6BClx5xCtAxHfMWFLRbEZ4t7UZifBL/rgzvTDpiYT94Wm
         IZscdYIxfW9i7WBsKrdQBmX6fBl2deTk+lgR6mZDyqMzZ580p2p/3nQxA61c/LsRbqZ9
         7WgsWRXbDP4V1czvJo7msY0SUpWrkXwgQe9TI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7NJ+wiYrZBSzT7T/m/YjM+5J0bJRbCG/9IwkVfKiHmM=;
        b=Txvd612wylBaq3EOraoW0go+WSey0JAMepXQcDqcmagprB1NUUtutE5Ki5iCC7da6s
         f4h3WvWkQuhCKD+pG5yXW1HheiqRvvuH1UIIwnA0HkIuy2FXSovOf95QtTqmu4gR6vd3
         BRadeHGiFlpEQ857+ffONzaFR2uyC4JcdDMJleYXPG+9ev2SpxLjg7K1fgxBTtElwNTb
         +1teWLOHOEcEd6dN7ezKSMyFornW/goQt8nx2W+nx4ecYFpJjxi/aTHE5rs50pYnXdf2
         Ho8Fg9tCKHNqD1u9ItFieYbqhaPM67CtVIox5GRjLsWNnawUrF2bsqRSi8+ihMiLbVJE
         bRvA==
X-Gm-Message-State: APjAAAXUw5/0Z+qEtUqoh8IqtXD4cXmgif8UTnQ77x8NansQS5o6LoZ4
        W19C/bSaImL3m3BY4Vs9yuL/EMcXFppLAwjGf+DRL8qLGU7ocy9Dx0ogJLqUq/0fEHYJxWBZYal
        sYyQ1DtoBB2UwC83p8Icm53AcI54U3mOuyGbPA4czA06yLmUBOoONbgPwRjzyT/hAvd0dd5VCEF
        n9fdgwuwQnDfiH
X-Google-Smtp-Source: APXvYqxXuUkNrR5+OEIjnaaJjAkf2rhvcyXi3eisWD9Wy4dl8cAG2Xp9fg/JPmg93Y6Yfbz6p8lbHA==
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr2417346pjs.73.1565086409114;
        Tue, 06 Aug 2019 03:13:29 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g2sm141343181pfq.88.2019.08.06.03.13.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 03:13:28 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH RESEND] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date:   Tue,  6 Aug 2019 06:13:16 -0400
Message-Id: <1565086396-44714-1-git-send-email-suganath-prabu.subramani@broadcom.com>
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

Cc: <stable@vger.kernel.org> # 4.4.186, # 4.9.186 # 4.14.136
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
RESEND: Resending this patch to include 4.14.136 stable kernel.

This Patch is for stable kernels 4.4.186, 4.9.186 and 4.14.136.
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

