Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5610A29BC16
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802580AbgJ0PuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801344AbgJ0Pka (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1542F222C8;
        Tue, 27 Oct 2020 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813229;
        bh=Zi/6Agu3AptgIO7mIFylc82hjZYgqO06v7ajIwnqxLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0SLpSyNNEyTm6AzYQ3qh/aQjJgIA2Ywzh1ikeGP8pMuIPS+Pl9APKeclX2ozM4BE
         yQJ3MsoZSxZpxeVQVoKLXwy5Awo2GKxOPYOZTGbpa2hcAlhr5TdiphTDb4DAx6tlfn
         +1On2foGoiSzNQfR5gCuT7pyFnDQP/M/vyCyQcIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Chuanhong Guo <gch981213@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 474/757] mtd: spinand: gigadevice: Only one dummy byte in QUADIO
Date:   Tue, 27 Oct 2020 14:52:04 +0100
Message-Id: <20201027135512.735630103@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 6387ad9caf8f09747a8569e5876086b72ee9382c ]

The datasheet only lists one dummy byte in the 0xEH operation for the
following chips:
* GD5F1GQ4xExxG
* GD5F1GQ4xFxxG
* GD5F1GQ4UAYIG
* GD5F4GQ4UAYIG

Fixes: c93c613214ac ("mtd: spinand: add support for GigaDevice GD5FxGQ4xA")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Tested-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200820165121.3192-2-hauke@hauke-m.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/gigadevice.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/gigadevice.c b/drivers/mtd/nand/spi/gigadevice.c
index d219c970042a2..679d3c43e15aa 100644
--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -21,7 +21,7 @@
 #define GD5FXGQ4UXFXXG_STATUS_ECC_UNCOR_ERROR	(7 << 4)
 
 static SPINAND_OP_VARIANTS(read_cache_variants,
-		SPINAND_PAGE_READ_FROM_CACHE_QUADIO_OP(0, 2, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_QUADIO_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_X4_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_DUALIO_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_X2_OP(0, 1, NULL, 0),
@@ -29,7 +29,7 @@ static SPINAND_OP_VARIANTS(read_cache_variants,
 		SPINAND_PAGE_READ_FROM_CACHE_OP(false, 0, 1, NULL, 0));
 
 static SPINAND_OP_VARIANTS(read_cache_variants_f,
-		SPINAND_PAGE_READ_FROM_CACHE_QUADIO_OP(0, 2, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_QUADIO_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_X4_OP_3A(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_DUALIO_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_X2_OP_3A(0, 1, NULL, 0),
-- 
2.25.1



