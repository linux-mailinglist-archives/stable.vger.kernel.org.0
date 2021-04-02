Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBB735275D
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 10:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhDBIUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 04:20:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:4607 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbhDBIUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 04:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617351641; x=1648887641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vRulU25IEAwnweYpFPXTeAAZj5ejlP9sZftk3ipphww=;
  b=GI7y+tATEVa5t4gmPuA04CxVs4ZZAUcj9DCDfW8ngt2noKSaw/DT9Wyk
   e94qAr9r70oHW2bGjzs+Xp+yZ7H477pu9M2IuVqq5MOWABg4d6XO48mFz
   eLnidalFYD1UNMI0ooUqr8h2AKfZxxAlchRoOa95PcsbAga76R3Nuvx3c
   O8sSnCWV20pRynHtn7CMC6OtpJQKKeDr1uieKc3tjRArgaiJF33DhVXkG
   5B0Xt26TrsQJNfxEirKOj/fzJms2ZQR0iNfoNin5U7LjAgYSf9e1KwpRk
   uVsRwCdNYltWhINWj+Q6XjgQYY/HxDoicOcVN8t/rJpvOAFfbQgfsKbYk
   Q==;
IronPort-SDR: Q64WanxaLYSwRju4Nu5qmC2uIW5OB7lVRYAwtpPi0djvMmyhnRUFwgvcNxMaPYUJCsSmZhrXr8
 0eucLYAekymiWkfd5MIbZ9gT7S5n8DUJnu9gSeBTPUCki9O1DEvETO/E6yH/M27zpO78QOGG37
 qI4rqkkyhLnkIEmGL7lFEYkngnBMvR9yPKGSNd6PPQ9+HV8s4Fj4mKX8O7CYMMjG9xjfJ1gXVk
 61pwtklk96FEoSmO8GcoUzheruQUHqAg8KoY73fg0sM/cpDaPYukpZyArwamyZaPPr/bzbWuNj
 fM0=
X-IronPort-AV: E=Sophos;i="5.81,299,1610434800"; 
   d="scan'208";a="115094219"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2021 01:20:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 01:20:39 -0700
Received: from atudor-ThinkPad-T470p.amer.actel.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 2 Apr 2021 01:20:36 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <michael@walle.cc>, <p.yadav@ti.com>, <vigneshr@ti.com>,
        <masonccyang@mxic.com.tw>, <zhengxunli@mxic.com.tw>,
        <ycllin@mxic.com.tw>, <juliensu@mxic.com.tw>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] Revert "mtd: spi-nor: macronix: Add support for mx25l51245g"
Date:   Fri, 2 Apr 2021 11:20:30 +0300
Message-ID: <20210402082031.19055-2-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210402082031.19055-1-tudor.ambarus@microchip.com>
References: <20210402082031.19055-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 04b8edad262eec0d153005973dfbdd83423c0dcb.

mx25l51245g and mx66l51235l have the same flash ID. The flash
detection returns the first entry in the flash_info array that
matches the flash ID that was read, thus for the 0xc2201a ID,
mx25l51245g was always hit, introducing a regression for
mx66l51235l.

If one wants to differentiate the flash names, a better fix would be
to differentiate between the two at run-time, depending on SFDP,
and choose the correct name from a list of flash names, depending on
the SFDP differentiator.

Fixes: 04b8edad262e ("mtd: spi-nor: macronix: Add support for mx25l51245g")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/mtd/spi-nor/macronix.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/macronix.c b/drivers/mtd/spi-nor/macronix.c
index 6c2680b4cdad..42c2cf31702e 100644
--- a/drivers/mtd/spi-nor/macronix.c
+++ b/drivers/mtd/spi-nor/macronix.c
@@ -72,9 +72,6 @@ static const struct flash_info macronix_parts[] = {
 			      SECT_4K | SPI_NOR_DUAL_READ |
 			      SPI_NOR_QUAD_READ) },
 	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
-	{ "mx25l51245g", INFO(0xc2201a, 0, 64 * 1024, 1024,
-			      SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
-			      SPI_NOR_4B_OPCODES) },
 	{ "mx66l51235l", INFO(0xc2201a, 0, 64 * 1024, 1024,
 			      SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
 			      SPI_NOR_4B_OPCODES) },
-- 
2.25.1

