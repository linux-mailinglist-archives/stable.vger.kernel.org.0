Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A1D5FB532
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJKOwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJKOvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F86798374;
        Tue, 11 Oct 2022 07:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B69BB81606;
        Tue, 11 Oct 2022 14:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248B3C433D6;
        Tue, 11 Oct 2022 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499848;
        bh=Bb/rRHpADtqTAyYYszzslC2hoX8aQ5jvr2HwAzBRSxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fafDxI3VdmIuOxHfQGhOQ/GBiQZxMBUD9aOpcw7i1bxlsnZMEzQaTujE3nEh0y2bJ
         6sweF7UzO/E4GrnOQmcz0iyyzKl0Ty538S7ZyMLhtH+zL33kPsjPfFeagA7mTslt/Z
         /saTMUFnoLb5hClqQQ9szgPU0++lfubPSAN2XeP53IDyotMnAeH4lfncrcb6eSB9KM
         l7NQNNCqsFppTGWzLBEzNLOpLoBiKGRAsq3AkeC+GO5HLUeg58i7/R1Sa+ISQXG7Sb
         iN4a6JDcv6xka1/cWIb+GEf5JK+XpNK4jEcLM/G2C49gvJu1VB0MmuNr4EnBUig/w0
         hk/czet3g7RFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 19/46] arm64: dts: imx8mm-kontron: Use the VSELECT signal to switch SD card IO voltage
Date:   Tue, 11 Oct 2022 10:49:47 -0400
Message-Id: <20221011145015.1622882-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit eef2c0217e02b6c7ed5b10b82ea944127145e113 ]

It turns out that it is not necessary to declare the VSELECT signal as
GPIO and let the PMIC driver set it to a fixed high level. This switches
the voltage between 3.3V and 1.8V by setting the PMIC register for LDO5
accordingly.

Instead we can do it like other boards already do and simply mux the
VSELECT signal of the USDHC interface to the pin. This makes sure that
the correct voltage is selected by setting the PMIC's SD_VSEL input
to high or low accordingly.

Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts    | 3 +++
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index 23be1ec538ba..c54536c0a2ba 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -321,6 +321,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d0
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d0
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d0
 			MX8MM_IOMUXC_SD2_CD_B_GPIO2_IO12		0x019
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x1d0
 		>;
 	};
 
@@ -333,6 +334,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d4
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d4
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4
 			MX8MM_IOMUXC_SD2_CD_B_GPIO2_IO12		0x019
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x1d0
 		>;
 	};
 
@@ -345,6 +347,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d6
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d6
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d6
 			MX8MM_IOMUXC_SD2_CD_B_GPIO2_IO12		0x019
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x1d0
 		>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
index 8f90eb02550d..6307af803429 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -86,7 +86,6 @@ pca9450: pmic@25 {
 		pinctrl-0 = <&pinctrl_pmic>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
-		sd-vsel-gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
 
 		regulators {
 			reg_vdd_soc: BUCK1 {
@@ -229,7 +228,6 @@ MX8MM_IOMUXC_I2C1_SDA_I2C1_SDA			0x400001c3
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
 			MX8MM_IOMUXC_GPIO1_IO00_GPIO1_IO0		0x141
-			MX8MM_IOMUXC_GPIO1_IO04_GPIO1_IO4		0x141
 		>;
 	};
 
-- 
2.35.1

