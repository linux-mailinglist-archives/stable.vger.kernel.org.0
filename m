Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89C348AE59
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 14:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbiAKNXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 08:23:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51254 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiAKNXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 08:23:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641907386; x=1673443386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c0boByf2BB5su6qOQGZkkDJXX/FAiLGM0LDe8xZdSoA=;
  b=i/EDVvws0EmwxzVcE76Fkbb1g6vQMl1q8g9U4flGnLXerlel6Kx6PZf7
   eZM0OWhUmy/n5aCnV6/SR0pvgTGxCx/flXQkHKj2oZkaJ2nVAO+VJizNZ
   BMICmNUY52CW4+3P0+lEI2xMrZQBaE+h1LSAPq8IRHRu5zKc4cUr0xCgG
   y1rWRhRPW0zFC2VarLyEqwaUA6gp6gxC87OuGcUbIR/MlJnGI7mStvqHc
   EOvi+6wvX0vGp4OAkzp6r5xBaOIivtvGkFhZ8mVmR9SZBHoqdaT1C++qg
   y1e5M18pdLqn2UKIr52CND1rEA8wQtK+QKr7ZnNkJng9QVYkjTPaceFhg
   w==;
IronPort-SDR: vPJ1CM6IMrd3wXAvL3swXFC266lt/x2UvZYeVLeteuTa8o1vdxTkJcmCk0zGptqrCUi/oCZ3w8
 Um9ECGnp0K8PDr48EseF8s5bKknQMqW0DMBzll75rkv0MZJeklLn2egUDHA76+wMOtgsAiAwf4
 mQ9MXJ0v6uYgxO8dIaZeBJsHnrSsLW/o+I32Vk1XVtcW4OktrVU05D6aaZ/UtEhKD1+P8NfhQI
 pxdJbSq2Pwg+UMitU8LMzJXT4iAJLO4VkM9GN5z1jHZvkPpR5jJi5u80e3pLbvI/NTE82Fwa4n
 TWpZCfO+6wCuZaGKrOvnFTwV
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="82119598"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2022 06:23:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 11 Jan 2022 06:23:05 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 11 Jan 2022 06:23:02 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <Nicolas.Ferre@microchip.com>, <ada@thorsis.com>
CC:     <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        <robh+dt@kernel.org>, <bbrezillon@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] ARM: dts: at91: sama5d2: Fix PMERRLOC resource size
Date:   Tue, 11 Jan 2022 15:23:01 +0200
Message-ID: <20220111132301.906712-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PMERRLOC resource size was set to 0x100, which resulted in HSMC_ERRLOCx
register being truncated to offset x = 21, causing error correction to
fail if more than 22 bit errors and if 24 or 32 bit error correction
was supported.

Fixes: d9c41bf30cf8 ("ARM: dts: at91: Declare EBI/NAND controllers")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: <stable@vger.kernel.org> # 4.13.x
---
v2:
- update commit description
- Cc stable@vger.kernel.org

 arch/arm/boot/dts/sama5d2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index 09c741e8ecb8..c700c3b19e4c 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -415,7 +415,7 @@ hsmc: hsmc@f8014000 {
 				pmecc: ecc-engine@f8014070 {
 					compatible = "atmel,sama5d2-pmecc";
 					reg = <0xf8014070 0x490>,
-					      <0xf8014500 0x100>;
+					      <0xf8014500 0x200>;
 				};
 			};
 
-- 
2.25.1

