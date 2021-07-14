Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D403C8F55
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhGNTw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239114AbhGNTtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CB006141E;
        Wed, 14 Jul 2021 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291843;
        bh=qltVzMhUCkSuWWGB4rLl+ufH0pA2gORcNdWaHr3L8d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/iwgKtll33KWOkSfPGcSCGuFf/Go/g/D5j7mkgjvlhQkYNJXfmVm8xgn0yOIbnKP
         imBvv9GevCG+pBudvACc/8dSsliOWxcSTi4KsnCNN7o4HxUN7Me2EMEekENgsGCbOQ
         psXqqGH4AFkkOWSqXxZKSjFVz1hhekH2NPCKhelORhhTjo47mq3poUKJ3X7LjSoHdA
         DmHbUS869cwvSK87sdnF/hx8fH2itFjEwBZD5cllHIOAAin6Ec0MySUqkmTBIItU24
         atoI9+LiKxjcPhV7KuWcf9jcXXxsDz4kbtuYD/o75Sxg6ITKK763jy0e611jeqvB4I
         wMUScll+zi1OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/88] ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios
Date:   Wed, 14 Jul 2021 15:42:14 -0400
Message-Id: <20210714194303.54028-39-sashal@kernel.org>
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
index 243e35f7a56c..370c4e64676f 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -2033,7 +2033,7 @@ gpio4: gpio@0 {
 			};
 		};
 
-		target-module@22000 {			/* 0x48322000, ap 116 64.0 */
+		gpio5_target: target-module@22000 {		/* 0x48322000, ap 116 64.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x22000 0x4>,
 			      <0x22010 0x4>,
-- 
2.30.2

