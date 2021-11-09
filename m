Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF3B44B758
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344963AbhKIWeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343967AbhKIWbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:31:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7424E61A88;
        Tue,  9 Nov 2021 22:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496471;
        bh=I1NDbiP/OZcVSxcRizSJiaW68LTtAtJEcjCXt0+/oh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgX/FbMhziGDs7OgLI4iWHSZniwOfHt03bugqfOqJ3vu5IvPyOx3QehWNeRJVcTeN
         apzsryjgfORzTWZ71FWC48tp26aN741LwVswgJ4TQ7unMfdPOrIlObS+m0/cmsthML
         ej6+8R1rwIYR4Ma8GPE7gwQq+zwS5K3bq6x7NocK14l0PW5Ld5SUbLHg21O2RwTKDE
         GINdxC+/6YjgjsZqPROmj6nkvJKWJDAwidlcve9S9ay7JEfp9m4KHGoZ+xK8pa44Ps
         lpJC6BCNQbbSu4gAzFzPKhHEahsQPQhkca2sjIJvVKe0CC1bx6x4xcqzj0qDKy/evz
         xASx/dXQfXnSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, maxime.ripard@free-electrons.com,
        wens@csie.org, catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 03/50] ARM: dts: sunxi: Fix OPPs node name
Date:   Tue,  9 Nov 2021 17:20:16 -0500
Message-Id: <20211109222103.1234885-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit ffbe853a3f5a37fa0a511265b21abf097ffdbe45 ]

The operating-points-v2 nodes are named inconsistently, but mostly
either opp_table0 or gpu-opp-table.  However, the underscore is an
invalid character for a node name and the thermal zone binding
explicitly requires that zones are called opp-table-*. Let's fix it.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20210901091852.479202-43-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a33.dtsi                      | 4 ++--
 arch/arm/boot/dts/sun8i-a83t.dtsi                     | 4 ++--
 arch/arm/boot/dts/sun8i-h3.dtsi                       | 4 ++--
 arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi  | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi  | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index c458f5fb124fb..46f4242e9f95d 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -46,7 +46,7 @@
 #include <dt-bindings/thermal/thermal.h>
 
 / {
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
@@ -164,7 +164,7 @@
 		io-channels = <&ths>;
 	};
 
-	mali_opp_table: gpu-opp-table {
+	mali_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-144000000 {
diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index c010b27fdb6a6..a746e449b0bae 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -200,7 +200,7 @@
 		status = "disabled";
 	};
 
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cluster0 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
@@ -253,7 +253,7 @@
 		};
 	};
 
-	cpu1_opp_table: opp_table1 {
+	cpu1_opp_table: opp-table-cluster1 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index 4e89701df91f8..ae4f933abb895 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -44,7 +44,7 @@
 #include <dt-bindings/thermal/thermal.h>
 
 / {
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
@@ -112,7 +112,7 @@
 		};
 	};
 
-	gpu_opp_table: gpu-opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-120000000 {
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi
index 578c37490d901..e39db51eb4489 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi
@@ -4,7 +4,7 @@
  */
 
 / {
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi
index b2657201957eb..1afad8b437d72 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi
@@ -2,7 +2,7 @@
 // Copyright (C) 2020 Chen-Yu Tsai <wens@csie.org>
 
 / {
-	cpu_opp_table: cpu-opp-table {
+	cpu_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi
index 1a5eddc5a40f3..653452926d857 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi
@@ -3,7 +3,7 @@
 // Copyright (C) 2020 Clément Péron <peron.clem@gmail.com>
 
 / {
-	cpu_opp_table: cpu-opp-table {
+	cpu_opp_table: opp-table-cpu {
 		compatible = "allwinner,sun50i-h6-operating-points";
 		nvmem-cells = <&cpu_speed_grade>;
 		opp-shared;
-- 
2.33.0

