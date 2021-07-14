Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22CA3C8CA4
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhGNTm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhGNTmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C5D613D2;
        Wed, 14 Jul 2021 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291554;
        bh=jBfRPxiXzomN7SqB9x91C6hiR+FiwqZBn3Xtn37tIVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGL6DAdnWyZjV4+Z4aigazBSqfHVc8jEytjAED02dFJQ6CFeLQjoc1dZrDZl+5KGB
         bfg5dLBpAHUT3sYuXNcQ+OvY8DQ5cb45qPUTHs/XxJNRLd6UU4y866CB32/WX7Pr0R
         9x0nqzGT7n1Q98vhWD+jZJPhUtnhH+soRbbRAHusxIjEi5gBcHTMvyiiF8y2YG2pn2
         NciZWikXlPd62cKhT0/bJwyc5wcSinuQSYsFoa54AknL3tPJX/9bp/69dUqo9pq3ka
         M2Smeatq2Dp39C4bu9u8F+IG8FSDv7zvyvNOzoF9UPqCtGVGPVEyftrVYQF7Q3yENC
         Sbb+uw2aePH6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 051/108] ARM: tegra: wm8903: Fix polarity of headphones-detection GPIO in device-trees
Date:   Wed, 14 Jul 2021 15:37:03 -0400
Message-Id: <20210714193800.52097-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 2298fc034183..14cd3238355b 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -1030,7 +1030,7 @@ sound {
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
index 99a356c1ccec..5a2578b3707f 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -709,7 +709,7 @@ sound {
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
-		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_LOW>;
 		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(X, 0)
 			GPIO_ACTIVE_HIGH>;
 		nvidia,ext-mic-en-gpios = <&gpio TEGRA_GPIO(X, 1)
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 2dff14b87f3e..d9dd11569d4b 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -630,7 +630,7 @@ sound {
 
 		nvidia,spkr-en-gpios = <&wm8903 2 GPIO_ACTIVE_HIGH>;
 		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
-			GPIO_ACTIVE_HIGH>;
+			GPIO_ACTIVE_LOW>;
 
 		clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
 			 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>,
-- 
2.30.2

