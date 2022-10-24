Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1919E60ABDD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbiJXN6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiJXN6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A114DF23;
        Mon, 24 Oct 2022 05:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E07BD612C9;
        Mon, 24 Oct 2022 12:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC4DC433D6;
        Mon, 24 Oct 2022 12:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615460;
        bh=ZxHISU1o26LB6Sne1xESDXRiBzy9SbM+/TdvPkaq9rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyVJ/FZh9Xq1qgSLt2XwZsRyXd32Pr5NnYclxaWj6G9/ZZxofO+EfGhxLdlIhhJXr
         4idwFUZmWmtWn4t7FriMJ3QCzAUCf5B3b/e2Q+VKMPYFGe2XfXPF9/AF0nEA6xtXXs
         rWuzaP/YO0c7qmNOY5OLOR4duZQopsw25nVnX2do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Ranostay <mranostay@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vaishnav Achath <vaishnav.a@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/530] arm64: dts: ti: k3-j7200: fix main pinmux range
Date:   Mon, 24 Oct 2022 13:30:02 +0200
Message-Id: <20221024113056.747007679@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

From: Matt Ranostay <mranostay@ti.com>

[ Upstream commit 0d0a0b4413460383331088b2203ba09a6971bc3a ]

Range size of 0x2b4 was incorrect since there isn't 173 configurable
pins for muxing. Additionally there is a non-addressable region in the
mapping which requires splitting into two ranges.

main_pmx0 -> 67 pins
main_pmx1 -> 3 pins

Fixes: d361ed88455f ("arm64: dts: ti: Add support for J7200 SoC")
Signed-off-by: Matt Ranostay <mranostay@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Tested-by: Vaishnav Achath <vaishnav.a@ti.com>
Link: https://lore.kernel.org/r/20220919205723.8342-1-mranostay@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts | 10 ++++++----
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi             | 11 ++++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
index d14f3c18b65f..c3406e7f10a9 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
@@ -131,15 +131,17 @@
 		>;
 	};
 
-	main_usbss0_pins_default: main-usbss0-pins-default {
+	vdd_sd_dv_pins_default: vdd-sd-dv-pins-default {
 		pinctrl-single,pins = <
-			J721E_IOPAD(0x120, PIN_OUTPUT, 0) /* (T4) USB0_DRVVBUS */
+			J721E_IOPAD(0xd0, PIN_OUTPUT, 7) /* (T5) SPI0_D1.GPIO0_55 */
 		>;
 	};
+};
 
-	vdd_sd_dv_pins_default: vdd-sd-dv-pins-default {
+&main_pmx1 {
+	main_usbss0_pins_default: main-usbss0-pins-default {
 		pinctrl-single,pins = <
-			J721E_IOPAD(0xd0, PIN_OUTPUT, 7) /* (T5) SPI0_D1.GPIO0_55 */
+			J721E_IOPAD(0x04, PIN_OUTPUT, 0) /* (T4) USB0_DRVVBUS */
 		>;
 	};
 };
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 000b5732ea0c..b1df17525dea 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -295,7 +295,16 @@
 	main_pmx0: pinctrl@11c000 {
 		compatible = "pinctrl-single";
 		/* Proxy 0 addressing */
-		reg = <0x00 0x11c000 0x00 0x2b4>;
+		reg = <0x00 0x11c000 0x00 0x10c>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	main_pmx1: pinctrl@11c11c {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x11c11c 0x00 0xc>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-- 
2.35.1



