Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951A137CC14
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242925AbhELQkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242256AbhELQdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AA76194F;
        Wed, 12 May 2021 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835139;
        bh=YXNAP00Wz2LpMgnWRh/OGuFesmZ2onvXp/uLyI156RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htiV4wvOcCmUp9SNoVPaCiln0uPf3OetdU/Ce3dm4+cAtX3oz4CanXsqD5eMeeUzX
         EoaXzzBup1TiKsPtdlFsIjakZYumajSyvHJQHOdAvXC9jZYX6j4XKF7MUJ0Jj8tlEp
         NBjtQGLBCVnsC7h5sCgk5bW61jclRcUDdYQrpAkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 189/677] arm64: dts: ti: k3-j721e-main: Update the speed modes supported and their itap delay values for MMCSD subsystems
Date:   Wed, 12 May 2021 16:43:55 +0200
Message-Id: <20210512144843.525424646@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit eb8f6194e8074d7b00642dd75cf04d13e1b218e4 ]

According to latest errata of J721e [1], HS400 mode is not supported
in MMCSD0 subsystem (i2024) and SDR104 mode is not supported in MMCSD1/2
subsystems (i2090). Therefore, replace mmc-hs400-1_8v with mmc-hs200-1_8v
in MMCSD0 subsystem and add a sdhci mask to disable SDR104 speed mode.

Also, update the itap delay values for all the MMCSD subsystems according
the latest J721e data sheet[2]

[1] - https://www.ti.com/lit/er/sprz455/sprz455.pdf
[2] - https://www.ti.com/lit/ds/symlink/tda4vm.pdf

Fixes: cd48ce86a4d0 ("arm64: dts: ti: k3-j721e-common-proc-board: Add support for SD card UHS modes")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20210305054104.10153-1-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 8c84dafb7125..f1e7da3dfa27 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -1042,13 +1042,16 @@
 		assigned-clocks = <&k3_clks 91 1>;
 		assigned-clock-parents = <&k3_clks 91 2>;
 		bus-width = <8>;
-		mmc-hs400-1_8v;
+		mmc-hs200-1_8v;
 		mmc-ddr-1_8v;
 		ti,otap-del-sel-legacy = <0xf>;
 		ti,otap-del-sel-mmc-hs = <0xf>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x6>;
 		ti,otap-del-sel-hs400 = <0x0>;
+		ti,itap-del-sel-legacy = <0x10>;
+		ti,itap-del-sel-mmc-hs = <0xa>;
+		ti,itap-del-sel-ddr52 = <0x3>;
 		ti,trm-icp = <0x8>;
 		ti,strobe-sel = <0x77>;
 		dma-coherent;
@@ -1069,9 +1072,15 @@
 		ti,otap-del-sel-sdr25 = <0xf>;
 		ti,otap-del-sel-sdr50 = <0xc>;
 		ti,otap-del-sel-ddr50 = <0xc>;
+		ti,itap-del-sel-legacy = <0x0>;
+		ti,itap-del-sel-sd-hs = <0x0>;
+		ti,itap-del-sel-sdr12 = <0x0>;
+		ti,itap-del-sel-sdr25 = <0x0>;
+		ti,itap-del-sel-ddr50 = <0x2>;
 		ti,trm-icp = <0x8>;
 		ti,clkbuf-sel = <0x7>;
 		dma-coherent;
+		sdhci-caps-mask = <0x2 0x0>;
 	};
 
 	main_sdhci2: mmc@4f98000 {
@@ -1089,9 +1098,15 @@
 		ti,otap-del-sel-sdr25 = <0xf>;
 		ti,otap-del-sel-sdr50 = <0xc>;
 		ti,otap-del-sel-ddr50 = <0xc>;
+		ti,itap-del-sel-legacy = <0x0>;
+		ti,itap-del-sel-sd-hs = <0x0>;
+		ti,itap-del-sel-sdr12 = <0x0>;
+		ti,itap-del-sel-sdr25 = <0x0>;
+		ti,itap-del-sel-ddr50 = <0x2>;
 		ti,trm-icp = <0x8>;
 		ti,clkbuf-sel = <0x7>;
 		dma-coherent;
+		sdhci-caps-mask = <0x2 0x0>;
 	};
 
 	usbss0: cdns-usb@4104000 {
-- 
2.30.2



