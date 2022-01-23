Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1624D496E99
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiAWANW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:13:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36804 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbiAWAMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6A7260F77;
        Sun, 23 Jan 2022 00:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC6FC004E1;
        Sun, 23 Jan 2022 00:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896751;
        bh=3gLQh3f3+oWaMhkGHsFQqoHKnRNIrxUNODuNRihVYVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hz8vRJCj0pP7A4PTqJsYeWT56Nm7qT4zKZhMXubDGUFgQIPgl2rj1x4VrWtHI8sAD
         sO+AWm5TMAu6GPMiv0xzzsX/YSXJ2zufn6NEhAHQcdB59HNX8r1RSS2SwCktMnBK/z
         UQkCA7Ds4FO03v+c3SnJrlCoa4x2EkOwVhWxn1aNEW3XObXjBcNMOR+b0hzQWsEOnk
         kSfpzLERDVGUqUGd855VLC4SqvdSwfm+v6DHDkSWc6qzWqw9RmLawZH5bWHaK15+Ft
         Rxtj08Z7I3mLf/hUaPNKC+bD/6Qa/4XJa2IncTyxBBCEAmsvCmdD72FdkMJ1EuJlj8
         Z4MGdSrTyM2mQ==
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
Subject: [PATCH AUTOSEL 5.15 04/16] riscv: dts: microchip: mpfs: Fix reference clock node
Date:   Sat, 22 Jan 2022 19:12:03 -0500
Message-Id: <20220123001216.2460383-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
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
index cce5eca31f257..4b69ab4ff30a2 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -40,6 +40,10 @@ soc {
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
index b12fd594e7172..18ccbdbe86d99 100644
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

