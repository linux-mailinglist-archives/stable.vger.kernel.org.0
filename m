Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4995F26F4
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiJBXFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiJBXEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972E8248CC;
        Sun,  2 Oct 2022 16:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 907A8B80DA9;
        Sun,  2 Oct 2022 22:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253A3C433B5;
        Sun,  2 Oct 2022 22:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751167;
        bh=snTKj5uUCniAAmOx2ttL6/s1ceXhHSHr5CwfTfYUtug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DT1RRyaFMq/ybDkigF3Z4t/Jm0UnY1MlDnJD9uoFJCRfRxdCUcQjnPxT2x44z2j9A
         ajxwZt0rwM+TfgVo9hxkIa0+hzJLl8C1olEfuvqj9RdYdQByW1w0mzzRIdJnfaryLC
         BIH7i7y7yYfgkcRAh3sn+VZ5wLU2vnDZeJGE0NYlY6Z8bKqsPoip3623B2YpUVNG4N
         jI/IgdT7Rx4Jtgjdlse+hJORkAF8TuXls6wi7upBZey/qZqfsxUuWa2CvVRQNjMPU6
         TUVfm8J20UKYVdcfRfx9wgO0adH+I8JZGqDJHKu4KEGlRIyWsmoKcThvDFtiWscP+g
         Soi+Glr+c3hfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, vkoul@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/9] ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer
Date:   Sun,  2 Oct 2022 18:52:31 -0400
Message-Id: <20221002225236.239675-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225236.239675-1-sashal@kernel.org>
References: <20221002225236.239675-1-sashal@kernel.org>
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
index eb5291b0ee3a..e07b807b4cec 100644
--- a/arch/arm/boot/dts/moxart-uc7112lx.dts
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -79,7 +79,7 @@ &clk_pll {
 	clocks = <&ref12>;
 };
 
-&sdhci {
+&mmc {
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
index f5f070a87482..764832ddfa78 100644
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

