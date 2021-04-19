Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A306364410
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242128AbhDSNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238675AbhDSNW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71D461407;
        Mon, 19 Apr 2021 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838305;
        bh=MY2gr6bkbx477bunHnTIpOKu3tQP5qji/pBNec4m/bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMyfJWNnB7nci0TiFcFXOjKCDESudTGBRrLJyxoYF7AAvtGtOXoPvFMQb5VQQCldc
         LnUnOl597DXiQFUFWdpaeFNfp/GpwzOiYcNKGswBhcHul0QNPvjY5Sx8e0zsUsOsjs
         yiA7i7Wj5JC+Nscxi/INNLOt8xy5J6rMkWQMdbkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/73] ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
Date:   Mon, 19 Apr 2021 15:06:04 +0200
Message-Id: <20210419130524.253245284@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
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
index e9d9c8460682..68ab6a95f222 100644
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



