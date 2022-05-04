Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D9751A670
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiEDQzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353891AbiEDQwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF144757E;
        Wed,  4 May 2022 09:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EA48B827A2;
        Wed,  4 May 2022 16:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8809C385A5;
        Wed,  4 May 2022 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682927;
        bh=i2poJufnaXAHK/IAzmKjpNzqw71tHmA+KEXNBZhEApY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2KLIGnH76KCbER+ex0XaNJJCGFcDflfC+ARYtSlM74Pjf3TFrZn1bWgmMZMB3jrU
         +U2fbYIf3aTp1NVRp64lsm86RK9Rpye+BpVDD0BZqq8vIQc8cSM1lnLmz9vLXG+q8p
         1Uf+FXeo8FBFJePdFcyZqVmz8tgw3QPceVWSEaTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/84] ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue
Date:   Wed,  4 May 2022 18:44:15 +0200
Message-Id: <20220504152930.194494352@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit fa51e1dc4b91375bc18349663a52395ad585bd3c ]

On a custom carrier board with a i.MX6Q Apalis SoM, the sgtl5000 codec
on the SoM is often not detected and the following error message is
seen when the sgtl5000 driver tries to read the ID register:

sgtl5000 1-000a: Error reading chip id -6

The reason for the error is that the MCLK clock is not provided
early enough.

Fix the problem by describing the MCLK pinctrl inside the codec
node instead of placing it inside the audmux pinctrl group.

With this change applied the sgtl5000 is always detected on every boot.

Fixes: 693e3ffaae5a ("ARM: dts: imx6: Add support for Toradex Apalis iMX6Q/D SoM")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-apalis.dtsi | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-apalis.dtsi b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
index 7c4ad541c3f5..b165bd6ea53b 100644
--- a/arch/arm/boot/dts/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
@@ -314,6 +314,8 @@ vgen6_reg: vgen6 {
 	codec: sgtl5000@a {
 		compatible = "fsl,sgtl5000";
 		reg = <0x0a>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_sgtl5000>;
 		clocks = <&clks IMX6QDL_CLK_CKO>;
 		VDDA-supply = <&reg_module_3v3_audio>;
 		VDDIO-supply = <&reg_module_3v3>;
@@ -543,8 +545,6 @@ MX6QDL_PAD_DISP0_DAT20__AUD4_TXC	0x130b0
 			MX6QDL_PAD_DISP0_DAT21__AUD4_TXD	0x130b0
 			MX6QDL_PAD_DISP0_DAT22__AUD4_TXFS	0x130b0
 			MX6QDL_PAD_DISP0_DAT23__AUD4_RXD	0x130b0
-			/* SGTL5000 sys_mclk */
-			MX6QDL_PAD_GPIO_5__CCM_CLKO1		0x130b0
 		>;
 	};
 
@@ -810,6 +810,12 @@ MX6QDL_PAD_NANDF_CS1__GPIO6_IO14 0x000b0
 		>;
 	};
 
+	pinctrl_sgtl5000: sgtl5000grp {
+		fsl,pins = <
+			MX6QDL_PAD_GPIO_5__CCM_CLKO1	0x130b0
+		>;
+	};
+
 	pinctrl_spdif: spdifgrp {
 		fsl,pins = <
 			MX6QDL_PAD_GPIO_16__SPDIF_IN  0x1b0b0
-- 
2.35.1



