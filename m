Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B644C6704
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 11:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiB1KTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 05:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiB1KTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 05:19:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149EE42ED4;
        Mon, 28 Feb 2022 02:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A94A261320;
        Mon, 28 Feb 2022 10:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F5DC340E7;
        Mon, 28 Feb 2022 10:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646043510;
        bh=7ScyWwOVVGtMOk8c5/t+4srA6OPpuWDgrvhjwqRsEgE=;
        h=From:To:Cc:Subject:Date:From;
        b=lPPuD1220/VQdT1E1OaecvRoCQmza/F46WBx8P658CH3eCNM49lOnETpxdW08bLp8
         Y7LU+0Q1gcOIkQVi9rq0ySb8JPLO0TYtchzK2vjmRj/74UEPXpW+dOPz/LnTDiZpU3
         ecj5HY1qCXU+YRpTvoeBMr9uwW+ZX0+0yOYPGybg5ChFgDGonGlEI4o6I5IdlubMjY
         oCfMVMYy7jOshPkV2XTu6gq3xGYoNCkMUIRrMEctzSIGRKEF6+FMyzPmtl/eqjUmnt
         00QkSuJgMwYMw+iZxD94R59E9Fis3X2gN483SZ/FLO7pBOeCFBCmbWD8WvZpmJDG6O
         yGMhGlJa69doQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nOd6n-0003KK-TQ; Mon, 28 Feb 2022 11:18:26 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH] arm64: dts: imx8mm-venice: fix spi2 pin configuration
Date:   Mon, 28 Feb 2022 11:16:17 +0100
Message-Id: <20220228101617.12694-1-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Due to what looks like a copy-paste error, the ECSPI2_MISO pad is not
muxed for SPI mode and causes reads from a slave-device connected to the
SPI header to always return zero.

Configure the ECSPI2_MISO pad for SPI mode on the gw71xx, gw72xx and
gw73xx families of boards that got this wrong.

Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
Cc: stable@vger.kernel.org      # 5.12
Cc: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
index 28012279f6f6..ecf6c9a6db90 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -166,7 +166,7 @@ pinctrl_spi2: spi2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
index 27afa46a253a..6e0f0a2f6970 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -231,7 +231,7 @@ pinctrl_spi2: spi2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
index a59e849c7be2..6c4c9ae9715f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -280,7 +280,7 @@ pinctrl_spi2: spi2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
-- 
2.34.1

