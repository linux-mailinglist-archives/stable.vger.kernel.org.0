Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2E3496E5E
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiAWALo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbiAWALn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17852C061401;
        Sat, 22 Jan 2022 16:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DD3860F77;
        Sun, 23 Jan 2022 00:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C136C004E1;
        Sun, 23 Jan 2022 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896701;
        bh=+Wq/XfukU2RuymmnC+RI32yy8McfYjimAgrLewPdj2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qctFadGJ65pAlXOZ7ChRAUpIK8tVVZI8DIQFd0avdyrie4X+n1DxeoHZluNM6v47g
         HL+MyOQRNYfxrVuR+OCfLIdqzICgl6AbQnVXEHzutq1ITcKaCtKxJX+6XaDAIama1S
         Z4jeGE+NHBDw+gWfIYfbN/Hsq2ETui3Qbcs70Xw2gVFzS/OxK9Dj/c3aymYJJlepGK
         Jj761agsRE0Hs5NvsHnv+rkCI1vnThHauYN/F8lLeJvDQybYCpFwlrjZOumadITbcM
         OUIp5CK27XfrE7gYJS3imNRFwW5guw8ar1KKM9jFkaa0wVSvwAV23tCZb4CEMe/mMd
         v9lPOLZZNSJAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, bin.meng@windriver.com,
        atishp@atishpatra.org, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 04/19] riscv: dts: microchip: mpfs: Fix reference clock node
Date:   Sat, 22 Jan 2022 19:10:57 -0500
Message-Id: <20220123001113.2460140-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 9d7b3078628f591e4007210c0d5d3f94805cff55 ]

"make dtbs_check" reports:

    arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dt.yaml: soc: refclk: {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[600000000]], 'clock-output-names': ['msspllclk'], 'phandle': [[7]]} should not be valid under {'type': 'object'}
	From schema: dtschema/schemas/simple-bus.yaml

Fix this by moving the node out of the "soc" subnode.
While at it, rename it to "msspllclk", and drop the now superfluous
"clock-output-names" property.
Move the actual clock-frequency value to the board DTS, since it is not
set until bitstream programming time.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/microchip/microchip-mpfs-icicle-kit.dts |  4 ++++
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi    | 12 +++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
index fc1e5869df1b9..0c748ae1b0068 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -35,6 +35,10 @@ memory@80000000 {
 	};
 };
 
+&refclk {
+	clock-frequency = <600000000>;
+};
+
 &serial0 {
 	status = "okay";
 };
diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index c9f6d205d2ba1..393f18cdbb346 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -142,6 +142,11 @@ cpu4_intc: interrupt-controller {
 		};
 	};
 
+	refclk: msspllclk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+	};
+
 	soc {
 		#address-cells = <2>;
 		#size-cells = <2>;
@@ -191,13 +196,6 @@ dma@3000000 {
 			#dma-cells = <1>;
 		};
 
-		refclk: refclk {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <600000000>;
-			clock-output-names = "msspllclk";
-		};
-
 		clkcfg: clkcfg@20002000 {
 			compatible = "microchip,mpfs-clkcfg";
 			reg = <0x0 0x20002000 0x0 0x1000>;
-- 
2.34.1

