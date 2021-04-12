Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A7F35CCEE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244405AbhDLQcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245218AbhDLQ37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE89F6137E;
        Mon, 12 Apr 2021 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244756;
        bh=KIjlBCnctNqc0Qkw8zC7bGRvsCSFLvIvPjGwR1DxRBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ9CTBRGJFGMYIAN8eAjbm8yf7lq95n7JhWMY0DobVkjg95GQanBsOPinnnAnoo/0
         OedH/zk4Yukva8uP/cRYgCsMSLwmUwru0iyejm0jncCAuFTghXECqTAfdfkNoLZgdI
         QoWJz17Ij9baoZDnF3+b3L2joU4FYcc76iGfIO2es4dEzf3PjJ2K18S1wbM16oDE9A
         GiCtfW1Jczv3yZzwelbJW7K6wKyaPAz+qNdpV7cidCt9VVuuElD0veUeaYv4aaCV99
         44Ky/Zlrj8toXMILxrtdpve2xkJPnm8lwT6ubMC0znoGsOcq4bMO0WJrIRd2U2RrPN
         l9wBHRVCPK+Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/28] ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
Date:   Mon, 12 Apr 2021 12:25:27 -0400
Message-Id: <20210412162553.315227-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
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
index 279ff2f419df..c654588f9e8c 100644
--- a/arch/arm/boot/dts/omap44xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap44xx-clocks.dtsi
@@ -773,14 +773,6 @@ per_abe_nc_fclk: per_abe_nc_fclk@108 {
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

