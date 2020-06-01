Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C3F1EACD2
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgFASkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbgFASNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A86920776;
        Mon,  1 Jun 2020 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035197;
        bh=d07kKZJF85G6WmyNuDRY5D8ZQiahqedqqafcMO5l6EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdneYINCpIz2/Wdha7RnF/rO8KxUS93NuakYbV7xSa4T9xVIMCa9h66OeEtZcf2yj
         I3nC8woCJKpS+1B5GrR1nvzWNQ9LPmOTX3AkiplD91AHkWFz6NikJSRUW3U17bXmV6
         gJH3zK3lFwN69QlFYpxjxKZf7DVILABt8McHsFII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 053/177] ARM: dts: omap4-droid4: Fix flakey wlan by disabling internal pull for gpio
Date:   Mon,  1 Jun 2020 19:53:11 +0200
Message-Id: <20200601174053.463124568@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 30fa60c678eaa27b8f2a531920d77f7184658f73 ]

The wlan on droid4 is flakey on some devices, and experiments have shown this
gets fixed if we disable the internal pull for wlan gpio interrupt line.

The symptoms are that the wlan connection is very slow and almost useless
with lots of wlcore firmware reboot warnings in the dmesg.

In addition to configuring the wlan gpio pulls, let's also configure the rest
of the wlan sd pins. We have not configured those eariler as we're booting
using kexec.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/motorola-mapphone-common.dtsi    | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index 9067e0ef4240..01ea9a1e2c86 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -367,6 +367,8 @@
 };
 
 &mmc3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc3_pins>;
 	vmmc-supply = <&wl12xx_vmmc>;
 	/* uart2_tx.sdmmc3_dat1 pad as wakeirq */
 	interrupts-extended = <&wakeupgen GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH
@@ -472,6 +474,37 @@
 		>;
 	};
 
+	/*
+	 * Android uses PIN_OFF_INPUT_PULLDOWN | PIN_INPUT_PULLUP | MUX_MODE3
+	 * for gpio_100, but the internal pull makes wlan flakey on some
+	 * devices. Off mode value should be tested if we have off mode working
+	 * later on.
+	 */
+	mmc3_pins: pinmux_mmc3_pins {
+		pinctrl-single,pins = <
+		/* 0x4a10008e gpmc_wait2.gpio_100 d23 */
+		OMAP4_IOPAD(0x08e, PIN_INPUT | MUX_MODE3)
+
+		/* 0x4a100102 abe_mcbsp1_dx.sdmmc3_dat2 ab25 */
+		OMAP4_IOPAD(0x102, PIN_INPUT_PULLUP | MUX_MODE1)
+
+		/* 0x4a100104 abe_mcbsp1_fsx.sdmmc3_dat3 ac27 */
+		OMAP4_IOPAD(0x104, PIN_INPUT_PULLUP | MUX_MODE1)
+
+		/* 0x4a100118 uart2_cts.sdmmc3_clk ab26 */
+		OMAP4_IOPAD(0x118, PIN_INPUT | MUX_MODE1)
+
+		/* 0x4a10011a uart2_rts.sdmmc3_cmd ab27 */
+		OMAP4_IOPAD(0x11a, PIN_INPUT_PULLUP | MUX_MODE1)
+
+		/* 0x4a10011c uart2_rx.sdmmc3_dat0 aa25 */
+		OMAP4_IOPAD(0x11c, PIN_INPUT_PULLUP | MUX_MODE1)
+
+		/* 0x4a10011e uart2_tx.sdmmc3_dat1 aa26 */
+		OMAP4_IOPAD(0x11e, PIN_INPUT_PULLUP | MUX_MODE1)
+		>;
+	};
+
 	/* gpmc_ncs0.gpio_50 */
 	poweroff_gpio: pinmux_poweroff_pins {
 		pinctrl-single,pins = <
-- 
2.25.1



