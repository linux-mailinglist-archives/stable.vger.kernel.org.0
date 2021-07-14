Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8D23C8C8F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhGNTmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234382AbhGNTl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4453F613DC;
        Wed, 14 Jul 2021 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291547;
        bh=CebD5ftu/nq7tr6rupA7WEqLVx4LT7DxMpu/GFwYv/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puMErxJyCztG5eiqCnoYDt8Lun+LO/SmwcJSgg2qERan6EpHSg/VHHVB9/yjyBZ6m
         WmRAdhGRPmgfWXmpAkXDusH4wLoxwfUdLHfoCDWF8PdTH2LvgpsSwjW+DPgWav03Gd
         4Idosp2tc8qsBbe0J5k6UovCNmCk1RoJ+6q+aGOealHw7qfkzRJXQlG3xBwefIgPuc
         o8O0EQMa/hms/G0XTpzNY7g2nBGfyHjPbqmsT2DtGVfRzVEVouXqUGF3cnRsoK+eNc
         pcKNHgzHBHAM610H5U6q9GGBjPRaxwbrsOwlCpIKHNLLHLdmomuTwXD0lTvcv/s5Ix
         87iDU1dbkfEUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 046/108] ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios
Date:   Wed, 14 Jul 2021 15:36:58 -0400
Message-Id: <20210714193800.52097-46-sashal@kernel.org>
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

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 2566d5b8c1670f7d7a44cc1426d254147ec5c421 ]

The ti,no-reset-on-init flag need to be at the interconnect target module
level for the modules that have it defined.
The ti-sysc driver handles this case, but produces warning, not a critical
issue.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am437x-gp-evm.dts | 5 ++++-
 arch/arm/boot/dts/am437x-l4.dtsi    | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 45cbc7fb557a..e2677682b540 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -813,11 +813,14 @@ &gpio4 {
 	status = "okay";
 };
 
+&gpio5_target {
+	ti,no-reset-on-init;
+};
+
 &gpio5 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&display_mux_pins>;
 	status = "okay";
-	ti,no-reset-on-init;
 
 	sel-lcd-hdmi-hog {
 		/*
diff --git a/arch/arm/boot/dts/am437x-l4.dtsi b/arch/arm/boot/dts/am437x-l4.dtsi
index e217ffc09770..a6f19ae7d3e6 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -2070,7 +2070,7 @@ gpio4: gpio@0 {
 			};
 		};
 
-		target-module@22000 {			/* 0x48322000, ap 116 64.0 */
+		gpio5_target: target-module@22000 {		/* 0x48322000, ap 116 64.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x22000 0x4>,
 			      <0x22010 0x4>,
-- 
2.30.2

