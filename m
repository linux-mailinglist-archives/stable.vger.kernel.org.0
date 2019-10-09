Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16ABD16BF
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfJIRX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732004AbfJIRX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:57 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C3E21929;
        Wed,  9 Oct 2019 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641837;
        bh=fZWWucbpLxJGkKOUSdJkJb/oxZDR/zbWPQ//eAJTko8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUJ5AgSlAze/wY3vUaiHBv3XQloBGFWhzZh9EDWLCV8CpmVNOUjTOjOdLrAclts0i
         w2YXsoGcCVAgVoc6ByTKV8JLHQssZvXJjEBXcm2TJUG6fN2u8C5qhzNcp207lU9iuY
         owJj0G05hBD4XDpWymIjVegQF3pjkeFN0yD/JEEI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Suman Anna <s-anna@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 14/68] ARM: dts: Fix gpio0 flags for am335x-icev2
Date:   Wed,  9 Oct 2019 13:04:53 -0400
Message-Id: <20191009170547.32204-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 4ef5d76b453908f21341e661a9b6f96862f6f589 ]

The ti,no-idle-on-init and ti,no-reset-on-init flags need to be at
the interconnect target module level for the modules that have it
defined. Otherwise we get the following warnings:

dts flag should be at module level for ti,no-idle-on-init
dts flag should be at module level for ti,no-reset-on-init

Fixes: 87fc89ced3a7 ("ARM: dts: am335x: Move l4 child devices to probe them with ti-sysc")
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Reported-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-icev2.dts | 2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-icev2.dts b/arch/arm/boot/dts/am335x-icev2.dts
index 18f70b35da4c7..204bccfcc110a 100644
--- a/arch/arm/boot/dts/am335x-icev2.dts
+++ b/arch/arm/boot/dts/am335x-icev2.dts
@@ -432,7 +432,7 @@
 	pinctrl-0 = <&mmc0_pins_default>;
 };
 
-&gpio0 {
+&gpio0_target {
 	/* Do not idle the GPIO used for holding the VTT regulator */
 	ti,no-reset-on-init;
 	ti,no-idle-on-init;
diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 46849d6ecb3e2..1515f4f914999 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -127,7 +127,7 @@
 			ranges = <0x0 0x5000 0x1000>;
 		};
 
-		target-module@7000 {			/* 0x44e07000, ap 14 20.0 */
+		gpio0_target: target-module@7000 {	/* 0x44e07000, ap 14 20.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			ti,hwmods = "gpio1";
 			reg = <0x7000 0x4>,
-- 
2.20.1

