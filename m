Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DF229BF5F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793734AbgJ0PIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791009AbgJ0PFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FFB321707;
        Tue, 27 Oct 2020 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811152;
        bh=v1TWsyl9QkVJ3ilSlyOLFTJV5GSW46ODBKPlzPkHzno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSQEe6XbEXcRY7oDF/rybZNLq6a4B7O+a3hPdgS1W+zX5j01rSntbmBNxAfpT3Vp4
         LcpAfNP3z4HDA9M1xrkLliMOHoDHrJilGDCcXxNhNmbz34q+7JxU7rMvX3hEoSL/WA
         RtXmyuixZ+veAEQ6xs+dAak+YqHvjU3ago93ON0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Chuanhong Guo <gch981213@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 392/633] mtd: spinand: gigadevice: Add QE Bit
Date:   Tue, 27 Oct 2020 14:52:15 +0100
Message-Id: <20201027135541.092570579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit aea7687e77bebce5b67fab9d03347bd8df7933c7 ]

The following GigaDevice chips have the QE BIT in the feature flags, I
checked the datasheets, but did not try this.
* GD5F1GQ4xExxG
* GD5F1GQ4xFxxG
* GD5F1GQ4UAYIG
* GD5F4GQ4UAYIG

The Quad operations like 0xEB mention that the QE bit has to be set.

Fixes: c93c613214ac ("mtd: spinand: add support for GigaDevice GD5FxGQ4xA")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Tested-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200820165121.3192-3-hauke@hauke-m.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/gigadevice.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/spi/gigadevice.c b/drivers/mtd/nand/spi/gigadevice.c
index 679d3c43e15aa..0b7667e60780f 100644
--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -202,7 +202,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4xa_ooblayout,
 				     gd5fxgq4xa_ecc_get_status)),
 	SPINAND_INFO("GD5F2GQ4xA",
@@ -212,7 +212,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4xa_ooblayout,
 				     gd5fxgq4xa_ecc_get_status)),
 	SPINAND_INFO("GD5F4GQ4xA",
@@ -222,7 +222,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4xa_ooblayout,
 				     gd5fxgq4xa_ecc_get_status)),
 	SPINAND_INFO("GD5F1GQ4UExxG",
@@ -232,7 +232,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4_variant2_ooblayout,
 				     gd5fxgq4uexxg_ecc_get_status)),
 	SPINAND_INFO("GD5F1GQ4UFxxG",
@@ -242,7 +242,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants_f,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4_variant2_ooblayout,
 				     gd5fxgq4ufxxg_ecc_get_status)),
 };
-- 
2.25.1



