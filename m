Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2B6944A2
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBMLf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBMLf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:35:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B5C2118
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A17CDCE167D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C3DC433EF;
        Mon, 13 Feb 2023 11:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676288153;
        bh=DXP90kQcBDCCKVcRKCY3eMel6OQMSTc97CvQJpQS4qk=;
        h=Subject:To:Cc:From:Date:From;
        b=HIkxMEn7KwiPACzCKm31HH5IYHm40tL9kQUf2Vo4D7qtqyUO5agqkWnDl+wXh9vlx
         bn4gGlus9+EMG0z1CLczPi/vsHFp4LX0mV2glfLTrVu8BeVIw/G7B5Ar+BhbEstqcF
         usiiHmVoSkCbvimrSfK01MhmwKKTRDik6HpkOCtQ=
Subject: FAILED: patch "[PATCH] arm64: dts: meson-gx: Make mmc host controller interrupts" failed to apply to 4.14-stable tree
To:     hkallweit1@gmail.com, neil.armstrong@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:35:51 +0100
Message-ID: <16762881511976@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

66e45351f7d6 ("arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive")
e490520c902e ("ARM64: dts: meson: fix register ranges for SD/eMMC")
221cf34bac54 ("ARM64: dts: meson-axg: enable the eMMC controller")
777fa58db622 ("ARM64: dts: meson-axg: add RMII pins for ethernet controller")
7d6d8a2053e6 ("ARM64: dts: meson-axg: enable I2C Master-1 for the audio speaker")
29390d277d01 ("ARM64: dts: meson-axg: add ethernet mac controller")
7bd46a79aad5 ("ARM64: dts: meson-axg: enable IR controller")
06b7a631878a ("arm64: dts: meson-axg: switch uart_ao clock to CLK81")
4a81e5ddfb43 ("ARM64: dts: meson-axg: add PWM DT info for Meson-Axg SoC")
de05ded6a99f ("ARM64: dts: meson-axg: add pinctrl DT info for Meson-AXG SoC")
0cb6c604232c ("ARM64: dts: amlogic: use generic bus node names")
9d59b708500f ("arm64: dts: meson-axg: add initial A113D SoC DT support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 66e45351f7d6798751f98001d1fcd572024d87f0 Mon Sep 17 00:00:00 2001
From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 9 Feb 2023 21:11:47 +0100
Subject: [PATCH] arm64: dts: meson-gx: Make mmc host controller interrupts
 level-sensitive

The usage of edge-triggered interrupts lead to lost interrupts under load,
see [0]. This was confirmed to be fixed by using level-triggered
interrupts.
The report was about SDIO. However, as the host controller is the same
for SD and MMC, apply the change to all mmc controller instances.

[0] https://www.spinics.net/lists/linux-mmc/msg73991.html

Fixes: ef8d2ffedf18 ("ARM64: dts: meson-gxbb: add MMC support")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/76e042e0-a610-5ed5-209f-c4d7f879df44@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index e3c12e0be99d..5eed15035b67 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -603,21 +603,21 @@ apb: apb@d0000000 {
 			sd_emmc_a: mmc@70000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x70000 0x0 0x800>;
-				interrupts = <GIC_SPI 216 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 216 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sd_emmc_b: mmc@72000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x72000 0x0 0x800>;
-				interrupts = <GIC_SPI 217 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 217 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sd_emmc_c: mmc@74000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x74000 0x0 0x800>;
-				interrupts = <GIC_SPI 218 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 		};

