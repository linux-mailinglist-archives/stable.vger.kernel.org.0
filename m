Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAD535CCA2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244524AbhDLQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243472AbhDLQ11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06FBE6137C;
        Mon, 12 Apr 2021 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244710;
        bh=01zgyFiqG7+b476HStgnSCB7NL3CXYAT6UJMEzxkGBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGHrjsq1uqyI67rDY01NiFG/UJmAigrzzpiX70pEIzB6b2KzlhlCazHtgXVmsejhI
         YG82CsM43QxhTeE17PlfdFXhzf0XQX0f2Ej1SdUFs4BY5VLXqchAW8+VIEEEjpoG21
         tcCVVTJGfovKM9TkX00WwCslQJIJp94cASLr/J7w2HmfdCJpVJdQJvvLgJYg353R17
         K1qAOX6Jz+7tQXCvZjo9Ab4HJAIpWsRss7ugQdeh3gsvIGrYjWKVkcR29Wc1MFR61p
         zEqfQE7JSGr+9MzWbPercuo2O9Nd79dYw7tgX7Knse+JD15NfOgNZFIIXKoaFURV0a
         apS5JINea3bYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/39] ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
Date:   Mon, 12 Apr 2021 12:24:28 -0400
Message-Id: <20210412162502.314854-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
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
index e9d9c8460682..68ab6a95f222 100644
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

