Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F9851A90E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356246AbiEDRLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357158AbiEDRKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A9A4925D;
        Wed,  4 May 2022 09:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B873618D7;
        Wed,  4 May 2022 16:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1218C385AF;
        Wed,  4 May 2022 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683426;
        bh=TJj4Yiloi+OzkR9APGeJI/DYk4NVRmMyNOzm9Hso+HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh5lyCRkijuOgYSoHPWijriHMbVaI+YtjkD1ZV1FQ0rra/fBxDVUlpjc63Z2EqIoo
         Z75ntbNJ7blbSrVRQSXnexzHJc94GaBDnuE5btwwHIlpSZB+yHvwegoYgYpwSw3Oen
         ZxY9ftbkUNYTBtALMBhpn4fB7yAIdrSWVaNselVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 092/225] ARM: dts: logicpd-som-lv: Fix wrong pinmuxing on OMAP35
Date:   Wed,  4 May 2022 18:45:30 +0200
Message-Id: <20220504153119.065008180@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 46ff3df87215ff42c0cd2c4bdb7d74540384a69c ]

The pinout of the OMAP35 and DM37 variants of the SOM-LV are the
same, but the macros which define the pinmuxing are different
between OMAP3530 and DM3730.  The pinmuxing was correct for
for the DM3730, but wrong for the OMAP3530.  Since the boot loader
was correctly pin-muxing the pins, this was not obvious. As the
bootloader not guaranteed to pinmux all the pins any more, this
causes an issue, so the pinmux needs to be moved from a common
file to their respective board files.

Fixes: f8a2e3ff7103 ("ARM: dts: Add minimal support for LogicPD OMAP35xx SOM-LV devkit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Message-Id: <20220303171818.11060-1-aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts | 15 +++++++++++++++
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts | 15 +++++++++++++++
 arch/arm/boot/dts/logicpd-som-lv.dtsi            | 15 ---------------
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts b/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts
index 2a0a98fe67f0..3240c67e0c39 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts
+++ b/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts
@@ -11,3 +11,18 @@ / {
 	model = "LogicPD Zoom OMAP35xx SOM-LV Development Kit";
 	compatible = "logicpd,dm3730-som-lv-devkit", "ti,omap3430", "ti,omap3";
 };
+
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hsusb2_2_pins>;
+	hsusb2_2_pins: pinmux_hsusb2_2_pins {
+		pinctrl-single,pins = <
+			OMAP3430_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
+			OMAP3430_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
+			OMAP3430_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
+			OMAP3430_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
+			OMAP3430_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
+			OMAP3430_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
+		>;
+	};
+};
diff --git a/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts b/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts
index a604d92221a4..c757f0d7781c 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts
+++ b/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts
@@ -11,3 +11,18 @@ / {
 	model = "LogicPD Zoom DM3730 SOM-LV Development Kit";
 	compatible = "logicpd,dm3730-som-lv-devkit", "ti,omap3630", "ti,omap3";
 };
+
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hsusb2_2_pins>;
+	hsusb2_2_pins: pinmux_hsusb2_2_pins {
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
+			OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
+			OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
+			OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
+			OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
+			OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
+		>;
+	};
+};
diff --git a/arch/arm/boot/dts/logicpd-som-lv.dtsi b/arch/arm/boot/dts/logicpd-som-lv.dtsi
index b56524cc7fe2..55b619c99e24 100644
--- a/arch/arm/boot/dts/logicpd-som-lv.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv.dtsi
@@ -265,21 +265,6 @@ OMAP3_WKUP_IOPAD(0x2a0c, PIN_OUTPUT | MUX_MODE4)	/* sys_boot1.gpio_3 */
 	};
 };
 
-&omap3_pmx_core2 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&hsusb2_2_pins>;
-	hsusb2_2_pins: pinmux_hsusb2_2_pins {
-		pinctrl-single,pins = <
-			OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
-			OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
-			OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
-			OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
-			OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
-			OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
-		>;
-	};
-};
-
 &uart2 {
 	interrupts-extended = <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
 	pinctrl-names = "default";
-- 
2.35.1



