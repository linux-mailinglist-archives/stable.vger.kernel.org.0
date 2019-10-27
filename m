Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14D2E6706
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbfJ0VRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731036AbfJ0VRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:24 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD99205C9;
        Sun, 27 Oct 2019 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211044;
        bh=fZWWucbpLxJGkKOUSdJkJb/oxZDR/zbWPQ//eAJTko8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPBsgPBdVfjy9H4LGnCxuia1xcOmvP4IWe1UM3BRkyFzfzieIj2O22/HeFabQOWji
         NYMcWOhoHa3YKOJ8Oj0EfJTD9kkd1xvCA0PGJ0zmJd+Hj6QmexKc7qtZCsChuxAu/l
         nsI7he4PsyrJirYcbilVXCSQQnX5cb5Iw43qsz70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 013/197] ARM: dts: Fix gpio0 flags for am335x-icev2
Date:   Sun, 27 Oct 2019 21:58:51 +0100
Message-Id: <20191027203352.392665239@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



