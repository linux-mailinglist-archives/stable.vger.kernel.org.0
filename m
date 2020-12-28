Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9F82E409A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408057AbgL1Oy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441406AbgL1ORP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C00224D2;
        Mon, 28 Dec 2020 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165019;
        bh=7Sg5z2LFIBoU0sYqpSGLCyBm0aHGsvk7lRjq0LwXLbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bn8WOHEkyBVrjDz4Rom1kZK96hzLx8b6HtwDmE3+0Hb8Tx7Ivx9AJFP3vPgp2jGPA
         3e7mjfhRY6/VA+HXkbhth0XUz8qPBE+0T/9SZBEdWcosWim5yawxwnlOT8j97kKZGQ
         F8JZSbah2D6pTofBvXBc+JV24D8JYDs3VYxNx/10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/717] arm64: dts: meson: fix PHY deassert timing requirements
Date:   Mon, 28 Dec 2020 13:45:49 +0100
Message-Id: <20201228125037.843972631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit c183c406c4321002fe85b345b51bc1a3a04b6d33 ]

According to the datasheet (Rev. 1.9) the RTL8211F requires at least
72ms "for internal circuits settling time" before accessing the PHY
registers. This fixes an issue seen on ODROID-C2 where the Ethernet
link doesn't come up when using ip link set down/up:
  [ 6630.714855] meson8b-dwmac c9410000.ethernet eth0: Link is Down
  [ 6630.785775] meson8b-dwmac c9410000.ethernet eth0: PHY [stmmac-0:00] driver [RTL8211F Gigabit Ethernet] (irq=36)
  [ 6630.893071] meson8b-dwmac c9410000.ethernet: Failed to reset the dma
  [ 6630.893800] meson8b-dwmac c9410000.ethernet eth0: stmmac_hw_setup: DMA engine initialization failed
  [ 6630.902835] meson8b-dwmac c9410000.ethernet eth0: stmmac_open: Hw setup failed

Fixes: f29cabf240ed ("arm64: dts: meson: use the generic Ethernet PHY reset GPIO bindings")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/4a322c198b86e4c8b3dda015560a683babea4d63.1607363522.git.stefan@agner.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts  | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts   | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi  | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi     | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts  | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts   | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts        | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts    | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
index 7be3e354093bf..de27beafe9db9 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
@@ -165,7 +165,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 			interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
index 70fcfb7b0683d..50de1d01e5655 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
@@ -200,7 +200,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 			interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
index 222ee8069cfaa..9b0b81f191f1f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
@@ -126,7 +126,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 			interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
index ad812854a107f..a350fee1264d7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
@@ -147,7 +147,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 			interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
index b08c4537f260d..b2ab05c220903 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
@@ -82,7 +82,7 @@
 
 		/* External PHY reset is shared with internal PHY Led signal */
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 		interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
index e2bd9c7c817d7..62d3e04299b67 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -194,7 +194,7 @@
 		reg = <0>;
 
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 		interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
index 83eca3af44ce7..dfa7a37a1281f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
@@ -112,7 +112,7 @@
 		max-speed = <1000>;
 
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 	};
 };
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
index ea45ae0c71b7f..8edbfe040805c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
@@ -64,7 +64,7 @@
 
 		/* External PHY reset is shared with internal PHY Led signal */
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 		interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
index c89c9f846fb10..dde7cfe12cffa 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
@@ -114,7 +114,7 @@
 		max-speed = <1000>;
 
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 	};
 };
-- 
2.27.0



