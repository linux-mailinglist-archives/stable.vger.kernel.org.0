Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6763C8F58
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241394AbhGNTw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239201AbhGNTtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E77960FF2;
        Wed, 14 Jul 2021 19:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291849;
        bh=q3NJyJfhIGkLleFwN7UUYvLNduBnBmgYyo2FEYvO44E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqBzvZN7adIEtNXZyFSdwZPv3v9h2B3oY5diwOTwhzCCddAKk9mcloOMTQwP3qQKE
         Dz1zriOpKR92IbTigYojnGypwrsbzEFu96+w3nDL5pX6aAxFwt9VPzHnlv5GO6Y0Q/
         ODj85uSkNBj0gGwZZg1WDAuFc8m2ifoQsToZNwYwRLfmimwD2nDQIWUZTAY7Ey5kjq
         NY2nqlJsHExEvMa79oZ7DUrIwRLqsuNkitsUmOcAB7RasyLQiBQfjl2McGLNvElSxk
         qVufbxi8w5KqQk78opYEhY1H+n1gyND1ukg0mV0boJF8r6v0f+KkOIyTXjfBq9whvd
         Zm1MWSwqJFa0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 43/88] ARM: tegra: wm8903: Fix polarity of headphones-detection GPIO in device-trees
Date:   Wed, 14 Jul 2021 15:42:18 -0400
Message-Id: <20210714194303.54028-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 5f45da704de425d74abd75feaa928fc8a3df03ba ]

All Tegra boards which use WM8903 audio codec are specifying a wrong
polarity for the headphones detection GPIO. The kernel driver hardcodes
the polarity to active-low, which is the correct polarity, so we can fix
the device-trees safely.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts | 2 +-
 arch/arm/boot/dts/tegra20-harmony.dts           | 2 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts       | 2 +-
 arch/arm/boot/dts/tegra20-plutux.dts            | 2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts          | 2 +-
 arch/arm/boot/dts/tegra20-tec.dts               | 2 +-
 arch/arm/boot/dts/tegra20-ventana.dts           | 2 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi           | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
index 068aabcffb13..5d0f0fbba1d2 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -1009,7 +1009,7 @@ sound {
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
-		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_LOW>;
 		nvidia,int-mic-en-gpios = <&wm8903 1 GPIO_ACTIVE_HIGH>;
 		nvidia,headset;
 
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 86494cb4d5a1..ae4312eedcbd 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -748,7 +748,7 @@ sound {
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
 		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
-			GPIO_ACTIVE_HIGH>;
+			GPIO_ACTIVE_LOW>;
 		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(X, 0)
 			GPIO_ACTIVE_HIGH>;
 		nvidia,ext-mic-en-gpios = <&gpio TEGRA_GPIO(X, 1)
diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index a348ca30e522..b31c9bca16e6 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -84,7 +84,7 @@ sound {
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
-		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_LOW>;
 
 		clocks = <&tegra_car TEGRA20_CLK_PLL_A>,
 			 <&tegra_car TEGRA20_CLK_PLL_A_OUT0>,
diff --git a/arch/arm/boot/dts/tegra20-plutux.dts b/arch/arm/boot/dts/tegra20-plutux.dts
index 378f23b2958b..5811b7006a9b 100644
--- a/arch/arm/boot/dts/tegra20-plutux.dts
+++ b/arch/arm/boot/dts/tegra20-plutux.dts
@@ -52,7 +52,7 @@ sound {
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
-		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_LOW>;
 
 		clocks = <&tegra_car TEGRA20_CLK_PLL_A>,
 			 <&tegra_car TEGRA20_CLK_PLL_A_OUT0>,
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index c24d4a37613e..92d494b8c3d2 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -911,7 +911,7 @@ sound {
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
-		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(X, 1) GPIO_ACTIVE_HIGH>;
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(X, 1) GPIO_ACTIVE_LOW>;
 
 		clocks = <&tegra_car TEGRA20_CLK_PLL_A>,
 			 <&tegra_car TEGRA20_CLK_PLL_A_OUT0>,
diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 44ced60315de..10ff09d86efa 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -61,7 +61,7 @@ sound {
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
 		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
-			GPIO_ACTIVE_HIGH>;
+			GPIO_ACTIVE_LOW>;
 
 		clocks = <&tegra_car TEGRA20_CLK_PLL_A>,
 			 <&tegra_car TEGRA20_CLK_PLL_A_OUT0>,
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 055334ae3d28..fe400fb84f02 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -686,7 +686,7 @@ sound {
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
-		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_LOW>;
 		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(X, 0)
 			GPIO_ACTIVE_HIGH>;
 		nvidia,ext-mic-en-gpios = <&gpio TEGRA_GPIO(X, 1)
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index dab9989fa760..57aead7d8162 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -589,7 +589,7 @@ sound {
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
 		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
-			GPIO_ACTIVE_HIGH>;
+			GPIO_ACTIVE_LOW>;
 
 		clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
 			 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>,
-- 
2.30.2

