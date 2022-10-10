Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919EB5F992E
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiJJHIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiJJHHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AFF58DDE;
        Mon, 10 Oct 2022 00:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5208B60E84;
        Mon, 10 Oct 2022 07:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663D2C433D6;
        Mon, 10 Oct 2022 07:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385542;
        bh=snTKj5uUCniAAmOx2ttL6/s1ceXhHSHr5CwfTfYUtug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGFd2dzycqNlfK20EyT+F7iBbVhPGnPh/cxdraIcuZ6fAlz8OPhLBORNM8CUmlUAQ
         Tiilkm39HRdtYb1P9E1+hBcZhOHMk/de4pyuVTSRfmv6SZBr/WjvFaMBjbO0onS3DT
         W/BfJxLmgkWdhN9ail3rzM4cI0Ix6E+d8oNPx7iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sergei Antonov <saproj@gmail.com>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 17/48] ARM: dts: fix Moxa SDIO compatible, remove sdhci misnomer
Date:   Mon, 10 Oct 2022 09:05:15 +0200
Message-Id: <20221010070334.158173147@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



