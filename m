Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB98036436B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhDSNST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240453AbhDSNQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE906113C;
        Mon, 19 Apr 2021 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838017;
        bh=Q1nioC4D9b4Nh+kw7GJpMyO5BTuJHym0cMlMnvzbTGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BP8IufEUepMkZwksGCmPHbNU44CLjF8OCpjSSFEwE/CEgQpO8w32J/P4yH7Pg6QZg
         zBhfMUvgkHVQiAHV1Lz2oFt2z/9b8P0XOZuinw7hu3rFGTHhQKWPJT00uz62P1EpiQ
         ENY7IfqPCBphHImuyq7qdYus6wLBIjcwOBBOpS30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/103] ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
Date:   Mon, 19 Apr 2021 15:05:25 +0200
Message-Id: <20210419130528.279716270@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -770,14 +770,6 @@
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



