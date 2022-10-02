Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F205F26DA
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiJBXBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiJBXAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E0D15A39;
        Sun,  2 Oct 2022 15:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AB660EF1;
        Sun,  2 Oct 2022 22:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E20CC433C1;
        Sun,  2 Oct 2022 22:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751212;
        bh=baATQorB7E7tji15g54jQol3I3flzO4pwiVl9pgM6Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXSsbXHssZ6NT3JPBP/SSmuPuVn7ORgfA33hYtBlj6xs3162HrJmMrJtMVIOyhwll
         HEwCbaoqmpSiArg8gFY4KGeMtV/MZxAPD25Bq7jnpPFomB/XnyahxZCgYx2EaUhdFv
         Elo0I1gDf6v+XwOD4dCW8H1asoMoxBVdsDrYwa/iyW/1Oenuvf4+jv7+UMO+7cQ4tF
         6I8Lsbh75+pl9QyxvyU6doAdeHDt6oTaXYXGjczFfvt90yn25QVnZ2xWkvxm4IgmCV
         e59aonI0pmYfN3J+Qu2gDBm/Fd4UU+pilpdOLHm8GYzjSBSazbNinZSJhzcAR5HD25
         zJcTKIUVWsJ+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, vkoul@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/6] ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer
Date:   Sun,  2 Oct 2022 18:53:18 -0400
Message-Id: <20221002225323.240142-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225323.240142-1-sashal@kernel.org>
References: <20221002225323.240142-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

[ Upstream commit 02181e68275d28cab3c3f755852770367f1bc229 ]

Driver moxart-mmc.c has .compatible = "moxa,moxart-mmc".

But moxart .dts/.dtsi and the documentation file moxa,moxart-dma.txt
contain compatible = "moxa,moxart-sdhci".

Change moxart .dts/.dtsi files and moxa,moxart-dma.txt to match the driver.

Replace 'sdhci' with 'mmc' in names too, since SDHCI is a different
controller from FTSDC010.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Link: https://lore.kernel.org/r/20220907175341.1477383-1-saproj@gmail.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt | 4 ++--
 arch/arm/boot/dts/moxart-uc7112lx.dts                     | 2 +-
 arch/arm/boot/dts/moxart.dtsi                             | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
index 8a9f3559335b..7e14e26676ec 100644
--- a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
+++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
@@ -34,8 +34,8 @@ Example:
 Use specific request line passing from dma
 For example, MMC request line is 5
 
-	sdhci: sdhci@98e00000 {
-		compatible = "moxa,moxart-sdhci";
+	mmc: mmc@98e00000 {
+		compatible = "moxa,moxart-mmc";
 		reg = <0x98e00000 0x5C>;
 		interrupts = <5 0>;
 		clocks = <&clk_apb>;
diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
index 4a962a26482d..59d8775a3a93 100644
--- a/arch/arm/boot/dts/moxart-uc7112lx.dts
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -80,7 +80,7 @@ &clk_pll {
 	clocks = <&ref12>;
 };
 
-&sdhci {
+&mmc {
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
index da7b3237bfe9..804a2bc6ec82 100644
--- a/arch/arm/boot/dts/moxart.dtsi
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -93,8 +93,8 @@ watchdog: watchdog@98500000 {
 			clock-names = "PCLK";
 		};
 
-		sdhci: sdhci@98e00000 {
-			compatible = "moxa,moxart-sdhci";
+		mmc: mmc@98e00000 {
+			compatible = "moxa,moxart-mmc";
 			reg = <0x98e00000 0x5C>;
 			interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk_apb>;
-- 
2.35.1

