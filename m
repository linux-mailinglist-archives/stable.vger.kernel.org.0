Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C9560A4F4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiJXMT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiJXMTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F288285D;
        Mon, 24 Oct 2022 04:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F593612B2;
        Mon, 24 Oct 2022 11:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8209CC433D7;
        Mon, 24 Oct 2022 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612528;
        bh=baATQorB7E7tji15g54jQol3I3flzO4pwiVl9pgM6Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOFMJQDH7NE589CQuVTvNkQNSIq4zPzviMr7VY1KNV+LYCISOiDEIGKN3KSHNr44u
         kxJvaYwvLJl2h/qX8P3oRXMGk2C5seycSloMuroz08VVvjJlNI2UVfXiMEsUWxpqmY
         EhBbxa3JtKokM81FLjhS8cZ8RAEJBd/4eUpOlzB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sergei Antonov <saproj@gmail.com>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/229] ARM: dts: fix Moxa SDIO compatible, remove sdhci misnomer
Date:   Mon, 24 Oct 2022 13:28:47 +0200
Message-Id: <20221024112959.385972274@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



