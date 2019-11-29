Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F139E10D52D
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 12:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfK2LuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 06:50:13 -0500
Received: from olimex.com ([184.105.72.32]:60414 "EHLO olimex.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2LuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 06:50:12 -0500
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Nov 2019 06:50:12 EST
Received: from localhost.localdomain ([94.155.250.134])
        by olimex.com with ESMTPSA (ECDHE-RSA-AES128-GCM-SHA256:TLSv1.2:Kx=ECDH:Au=RSA:Enc=AESGCM(128):Mac=AEAD) (SMTP-AUTH username stefan@olimex.com, mechanism PLAIN)
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 03:39:57 -0800
From:   Stefan Mavrodiev <stefan@olimex.com>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
        sunXi SoC support),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     linux-sunxi@googlegroups.com, Stefan Mavrodiev <stefan@olimex.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] arm64: dts: allwinner: a64: olinuxino: Fix eMMC supply regulator
Date:   Fri, 29 Nov 2019 13:39:39 +0200
Message-Id: <20191129113941.20170-2-stefan@olimex.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191129113941.20170-1-stefan@olimex.com>
References: <20191129113941.20170-1-stefan@olimex.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A64-OLinuXino-eMMC uses 1.8V for eMMC supply. This is done via a triple
jumper, which sets VCC-PL to either 1.8V or 3.3V. This setting is different
for boards with and without eMMC.

This is not a big issue for DDR52 mode, however the eMMC will not work in
HS200/HS400, since these modes explicitly requires 1.8V.

Fixes: 94f68f3a4b2a ("arm64: dts: allwinner: a64: Add A64 OlinuXino board (with eMMC)")
Cc: stable@vger.kernel.org # v5.4
Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>
---
Changes for v2:
 - Restore the original eMMC vmmc-supply property

 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino-emmc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino-emmc.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino-emmc.dts
index 96ab0227e82d..121e6cc4849b 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino-emmc.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino-emmc.dts
@@ -15,7 +15,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc2_pins>;
 	vmmc-supply = <&reg_dcdc1>;
-	vqmmc-supply = <&reg_dcdc1>;
+	vqmmc-supply = <&reg_eldo1>;
 	bus-width = <8>;
 	non-removable;
 	cap-mmc-hw-reset;
-- 
2.17.1
