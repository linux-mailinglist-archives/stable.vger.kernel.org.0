Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA9613F8D6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbgAPTVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731176AbgAPQxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 565EF22522;
        Thu, 16 Jan 2020 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193626;
        bh=rNQrhZDV21oaKlrh7C5bTvuE3dr16hMZ8aHHmoo8iyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFuTxxkkcTmZdz0Kk+ANFoJY5juN+8C4teZVz22RHadpfKI7je8YyQ+FLDaJn3Lxg
         At4oNwISSIhDEswMxxO7K+nBUCExtIyf9K/XAIJUClST3oT4bhMqkeGKksUY1l5USp
         a3qxAXquhxfamSl9IbPUBG1AUwc4sFaQzliAnMt4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 160/205] ARM: dts: dra7: fix cpsw mdio fck clock
Date:   Thu, 16 Jan 2020 11:42:15 -0500
Message-Id: <20200116164300.6705-160-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 6af0a549c25e0d02366aa95507bfe3cad2f7b68b ]

The DRA7 CPSW MDIO functional clock (gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0)
is specified incorrectly, which is caused incorrect MDIO bus clock
configuration MDCLK. The correct CPSW MDIO functional clock is
gmac_main_clk (125MHz), which is the same as CPSW fck. Hence fix it.

Fixes: 1faa415c9c6e ("ARM: dts: Add fck for cpsw mdio for omap variants")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 5cac2dd58241..c3954e34835b 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3059,7 +3059,7 @@
 
 				davinci_mdio: mdio@1000 {
 					compatible = "ti,cpsw-mdio","ti,davinci_mdio";
-					clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
+					clocks = <&gmac_main_clk>;
 					clock-names = "fck";
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.20.1

