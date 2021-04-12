Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AB35CB10
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243269AbhDLQX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243291AbhDLQXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7822961289;
        Mon, 12 Apr 2021 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244585;
        bh=08saPRykXgVBm3qGNlVbF5oPH9Hn4UhPEzwU3vJzLjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9BCrT5Tl58TyleZ5/w2cds4h3vvLMP0Dv/zlMjo0CGSs3OSCa00vgX2cGqEtMvgN
         NkuFhSt0k717/ghvS6mEUMM+uXYJfGgoFs9Bsz5IjFDnU8wBgWRiMWexMR+X76iUru
         UzgNSTPPF1doC/z8UzGVkDN4wSOE5B1BQx6xZpfTgRQCMxAHip2UP1CEvCjWEfn8/h
         yICBMPi0tvRdXItz/FH+ZbzgAljmd/yqUmWKx3EoKNOb+54yePzbQLRYAB8MPuf3V8
         O7nr8Is95AEMfSAEjoTPczFAtP7MfEdFIxiPwc6kTWbGQGmReKeIWmHUq/leg1zH9B
         v+z2NyYSt5RnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 06/51] ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
Date:   Mon, 12 Apr 2021 12:22:11 -0400
Message-Id: <20210412162256.313524-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 140a776833957539c84301dbdb4c3013876de118 ]

We have a duplicate legacy clock defined for sha2md5_fck that can
sometimes race with clk_disable() with the dts configured clock
for OMAP4_SHA2MD5_CLKCTRL when unused clocks are disabled during
boot causing an "Unhandled fault: imprecise external abort".

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap44xx-clocks.dtsi | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/omap44xx-clocks.dtsi b/arch/arm/boot/dts/omap44xx-clocks.dtsi
index 532868591107..1f1c04d8f472 100644
--- a/arch/arm/boot/dts/omap44xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap44xx-clocks.dtsi
@@ -770,14 +770,6 @@ per_abe_nc_fclk: per_abe_nc_fclk@108 {
 		ti,max-div = <2>;
 	};
 
-	sha2md5_fck: sha2md5_fck@15c8 {
-		#clock-cells = <0>;
-		compatible = "ti,gate-clock";
-		clocks = <&l3_div_ck>;
-		ti,bit-shift = <1>;
-		reg = <0x15c8>;
-	};
-
 	usb_phy_cm_clk32k: usb_phy_cm_clk32k@640 {
 		#clock-cells = <0>;
 		compatible = "ti,gate-clock";
-- 
2.30.2

