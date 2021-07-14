Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E9D3C8C91
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhGNTmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhGNTmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDEC3613CB;
        Wed, 14 Jul 2021 19:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291548;
        bh=jir2cNK+ANRJYZso/w887kj11Jfyf58dBIl3nVhhy2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdPBWUlKs5Pd2ssLHmolpQz9DqrjuhT87Eq/oBiS9B5o489e5UeYYqHk8ylTC58uA
         XdQQ2AZhDuCKeVrpmZ8W0pnpEEJDEmSJDhJdtn8vBLB0xfNwpeNLksPLplqthOi+2D
         +23z2Vh3xaOgQbnH1zegYsBKAvc0igbHA08AITUAJn/+pwC/jmOatyS9h26fzlgI4t
         tXGHqVTc7mSLSrC7Xo2Xr7zgsjOWycEDEqvGHiRtYlcE9jQ5ugI55QqA7jZxoaJu5g
         gEvDXFV8tPciXt9my79SNUBGZroBRcwVO8dpI6Q0FLnExBX8JSnEDggnVpPSmkltGM
         OS3fR2wT10OLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 047/108] ARM: dts: am335x: fix ti,no-reset-on-init flag for gpios
Date:   Wed, 14 Jul 2021 15:36:59 -0400
Message-Id: <20210714193800.52097-47-sashal@kernel.org>
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

[ Upstream commit d7d30b8fcd111e9feb171023c0e0c8d855582dcb ]

The ti,no-reset-on-init flag need to be at the interconnect target module
level for the modules that have it defined.
The ti-sysc driver handles this case, but produces warning, not a critical
issue.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-baltos.dtsi              | 4 ++--
 arch/arm/boot/dts/am335x-evmsk.dts                | 2 +-
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi | 2 +-
 arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi | 2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-baltos.dtsi b/arch/arm/boot/dts/am335x-baltos.dtsi
index 3ea286180382..1103a2cb836f 100644
--- a/arch/arm/boot/dts/am335x-baltos.dtsi
+++ b/arch/arm/boot/dts/am335x-baltos.dtsi
@@ -393,10 +393,10 @@ &aes {
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
-&gpio3 {
+&gpio3_target {
 	ti,no-reset-on-init;
 };
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index d5f8d5e2eb5d..45bf0273ecd8 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -646,7 +646,7 @@ &aes {
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
diff --git a/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi b/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
index 4e90f9c23d2e..8121a199607c 100644
--- a/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
+++ b/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
@@ -150,7 +150,7 @@ &aes {
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
diff --git a/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi b/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi
index 98d8ed4ad967..39e5d2ce600a 100644
--- a/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi
+++ b/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi
@@ -353,7 +353,7 @@ &aes {
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 039a9ab4c7ea..dcce5e3e001e 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -1789,7 +1789,7 @@ gpio2: gpio@0 {
 			};
 		};
 
-		target-module@ae000 {			/* 0x481ae000, ap 56 3a.0 */
+		gpio3_target: target-module@ae000 {		/* 0x481ae000, ap 56 3a.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0xae000 0x4>,
 			      <0xae010 0x4>,
-- 
2.30.2

