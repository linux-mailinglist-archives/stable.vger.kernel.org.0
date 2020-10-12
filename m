Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E128B67A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389204AbgJLNeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389030AbgJLNcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBCC3204EA;
        Mon, 12 Oct 2020 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509565;
        bh=AIPOUgDrEhBvroaU/P9P3ES4Mn0db5g6zCY8tG9ugwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCUgxSzTKtdJlINs3WD2iAlQg7RfkF6b1MefcDzIRSm/RlyL6TTrXXIN3Fnc7fcuq
         Upt9fICCstwralY0HyT1n4PNvQKdPcDI1B1ijIR6j52voiyvuIpENva6nUmZ2MM5Cy
         Z5SadyT+zj3Red8FuojeiSpMIOYasL1q9JYi0Yrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Daniel Walter <dwalter@sigma-star.at>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/39] mtd: nand: Provide nand_cleanup() function to free NAND related resources
Date:   Mon, 12 Oct 2020 15:27:00 +0200
Message-Id: <20201012132629.561192866@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

[ Upstream commit d44154f969a44269a9288c274c1c2fd9e85df8a5 ]

Provide a nand_cleanup() function to free all nand related resources
without unregistering the mtd device.
This should allow drivers to call mtd_device_unregister() and handle
its return value and still being able to cleanup all nand related
resources.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Daniel Walter <dwalter@sigma-star.at>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/nand_base.c | 22 +++++++++++++++-------
 include/linux/mtd/nand.h     |  6 +++++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8406f346b0be5..09864226428b2 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -4427,18 +4427,14 @@ int nand_scan(struct mtd_info *mtd, int maxchips)
 EXPORT_SYMBOL(nand_scan);
 
 /**
- * nand_release - [NAND Interface] Free resources held by the NAND device
- * @mtd: MTD device structure
+ * nand_cleanup - [NAND Interface] Free resources held by the NAND device
+ * @chip: NAND chip object
  */
-void nand_release(struct mtd_info *mtd)
+void nand_cleanup(struct nand_chip *chip)
 {
-	struct nand_chip *chip = mtd->priv;
-
 	if (chip->ecc.mode == NAND_ECC_SOFT_BCH)
 		nand_bch_free((struct nand_bch_control *)chip->ecc.priv);
 
-	mtd_device_unregister(mtd);
-
 	/* Free bad block table memory */
 	kfree(chip->bbt);
 	if (!(chip->options & NAND_OWN_BUFFERS))
@@ -4449,6 +4445,18 @@ void nand_release(struct mtd_info *mtd)
 			& NAND_BBT_DYNAMICSTRUCT)
 		kfree(chip->badblock_pattern);
 }
+EXPORT_SYMBOL_GPL(nand_cleanup);
+
+/**
+ * nand_release - [NAND Interface] Unregister the MTD device and free resources
+ *		  held by the NAND device
+ * @mtd: MTD device structure
+ */
+void nand_release(struct mtd_info *mtd)
+{
+	mtd_device_unregister(mtd);
+	nand_cleanup(mtd->priv);
+}
 EXPORT_SYMBOL_GPL(nand_release);
 
 static int __init nand_base_init(void)
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 93fc372007937..1a066faf7b801 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -38,7 +38,7 @@ extern int nand_scan_ident(struct mtd_info *mtd, int max_chips,
 			   struct nand_flash_dev *table);
 extern int nand_scan_tail(struct mtd_info *mtd);
 
-/* Free resources held by the NAND device */
+/* Unregister the MTD device and free resources held by the NAND device */
 extern void nand_release(struct mtd_info *mtd);
 
 /* Internal helper for board drivers which need to override command function */
@@ -1029,4 +1029,8 @@ int nand_check_erased_ecc_chunk(void *data, int datalen,
 				void *ecc, int ecclen,
 				void *extraoob, int extraooblen,
 				int threshold);
+
+/* Free resources held by the NAND device */
+void nand_cleanup(struct nand_chip *chip);
+
 #endif /* __LINUX_MTD_NAND_H */
-- 
2.25.1



