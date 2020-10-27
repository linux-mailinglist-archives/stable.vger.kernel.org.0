Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A98929C1EC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762196AbgJ0OlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761386AbgJ0OjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C562206B2;
        Tue, 27 Oct 2020 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809563;
        bh=eFZ/oyPdUgxHAEE7v9H/Sflidyvb+8diGlbs85+U3IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQGJ7nJGCkqon4w5kTnV/M4Y2JVIBuJ9Rlqo0y7gBJiCh5LPeHbPbswy8QPQF7jSt
         PEPVgdqctHpk0y4ZCBgb0+Jzx1gFKKpMULOhPwYpxPrl5kFE/f1d35vSG04PA4Wcrf
         1igLHeJh/ePXowYuLvrnOh13FlViNn9Ck9OAgk5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Chuanhong Guo <gch981213@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/408] mtd: spinand: gigadevice: Add QE Bit
Date:   Tue, 27 Oct 2020 14:52:58 +0100
Message-Id: <20201027135506.189832484@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 45f4c1f4a3d1c..b13b39763a405 100644
--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -201,7 +201,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4xa_ooblayout,
 				     gd5fxgq4xa_ecc_get_status)),
 	SPINAND_INFO("GD5F2GQ4xA", 0xF2,
@@ -210,7 +210,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4xa_ooblayout,
 				     gd5fxgq4xa_ecc_get_status)),
 	SPINAND_INFO("GD5F4GQ4xA", 0xF4,
@@ -219,7 +219,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4xa_ooblayout,
 				     gd5fxgq4xa_ecc_get_status)),
 	SPINAND_INFO("GD5F1GQ4UExxG", 0xd1,
@@ -228,7 +228,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&gd5fxgq4_variant2_ooblayout,
 				     gd5fxgq4uexxg_ecc_get_status)),
 	SPINAND_INFO("GD5F1GQ4UFxxG", 0xb148,
@@ -237,7 +237,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
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



