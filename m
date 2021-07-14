Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0753C8FF5
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbhGNTxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240741AbhGNTuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C4F613FC;
        Wed, 14 Jul 2021 19:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291955;
        bh=MvvbXelBNcWthf9LAxQYVUWx8cQ0rhCKwLY3mwg7nug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlHyalq/aa0+/chyVORP8zZVtzG3stubEeu0nKQ1a7rkQNN/ODt33XLuW0xadNEVJ
         Uof9v8cAEf7jbdNdgmv6KTJ/qKrFanXk14amKjrDUY7qLmnLWLtkdBPPE+nrH42L8w
         4l2Fr+I7d13FxxRYYnDh8jATIIDv/1thcgH8xtr9mk0jsK9CH3USMe2b9b/Vu2RZKN
         AteuZUv5JBD07R/o4cmfD5cbuf27QK4AGYgHZcBoFEaUrxCl7/EywCuu34y/LHuFlh
         3z/nfmOVZ1EtzM6KgFN+3Jgr931y1nAmHOglfvTB77Y3+slGBXdTq2ASHyZJ399o0W
         vMPrBxSoip5wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/51] ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios
Date:   Wed, 14 Jul 2021 15:44:51 -0400
Message-Id: <20210714194513.54827-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index acc4c2760f46..537c9eb8b748 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -829,11 +829,14 @@ &gpio4 {
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
index bbe15775fccd..6c2949991e29 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -2077,7 +2077,7 @@ gpio4: gpio@0 {
 			};
 		};
 
-		target-module@22000 {			/* 0x48322000, ap 116 64.0 */
+		gpio5_target: target-module@22000 {		/* 0x48322000, ap 116 64.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			ti,hwmods = "gpio6";
 			reg = <0x22000 0x4>,
-- 
2.30.2

