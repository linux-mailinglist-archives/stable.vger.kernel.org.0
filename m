Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD06521762
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242736AbiEJNWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243162AbiEJNVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DB6579B6;
        Tue, 10 May 2022 06:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC942B81B32;
        Tue, 10 May 2022 13:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8A0C385C2;
        Tue, 10 May 2022 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188495;
        bh=+mMHRRKrQHamkN6Ya6mXon/4x8LvbSJ7PD4Lv5wUly8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z78dg3w+pZ4a8pQ0eubpejPsSbstSe/jm9wQjEinKjhYF57U7pCMOk5ZP+90DpuwS
         K6biZcReszI0pJ1FSzKhPW47PZTQ9Pyj7T05Z/M1//sFU62XlHz9MVguBUd63/ABLf
         Xj6BuUHVFMCFzQcwffAI98mDhANUqb5Rwh4mHuFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/78] ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue
Date:   Tue, 10 May 2022 15:07:12 +0200
Message-Id: <20220510130733.309672319@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index ea339fa58f4a..2477883c0efb 100644
--- a/arch/arm/boot/dts/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
@@ -316,6 +316,8 @@ vgen6_reg: vgen6 {
 	codec: sgtl5000@0a {
 		compatible = "fsl,sgtl5000";
 		reg = <0x0a>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_sgtl5000>;
 		clocks = <&clks IMX6QDL_CLK_CKO>;
 		VDDA-supply = <&reg_2p5v>;
 		VDDIO-supply = <&reg_3p3v>;
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



