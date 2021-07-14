Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754373C905F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbhGNTyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241164AbhGNTuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0418C613F1;
        Wed, 14 Jul 2021 19:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292027;
        bh=HG60cVCT1JCULS2JgAMUWLUPnq+0jbxwrhCzMn1w3TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2vpaD/5yE4/Kn5Nhy1S5l/fxYpNF3V00lzUnnL8x7qru+2Wzq1bOJgJDx/3aN/03
         Fz6Fy80ctqooeLvhPX0GNYWwC+UBCFYV75tWEc4YzwGkYzdqQ9FExUzGrslXlmOIK+
         SqblS9FXyGkQosNxkaclUz8iTqZrHZd/YPBzIrTmhtAJwzW1mCG7gKR9iCY2F7jAS6
         JXH1AmlmEEGV6mYhOGr0VFSke9Wx02XRPlSAzSjvyCBIF65Sk9YnFpTaqAu7zu8l6Y
         uAKjlfW15i4w82R2fKbZ1WZnw7CKO+XSZAPhb2JeewGAIwSQShQfCluVs51AJMTCvC
         Fxw9FINoemmLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 29/39] ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15
Date:   Wed, 14 Jul 2021 15:46:14 -0400
Message-Id: <20210714194625.55303-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit fb1406335c067be074eab38206cf9abfdce2fb0b ]

It fixes the following warning seen running "make dtbs_check W=1"

Warning (simple_bus_reg): /soc/stmmac-axi-config: missing or empty
reg/ranges property

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index c50c36baba75..4278a4b22860 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -964,12 +964,6 @@ crc1: crc@58009000 {
 			status = "disabled";
 		};
 
-		stmmac_axi_config_0: stmmac-axi-config {
-			snps,wr_osr_lmt = <0x7>;
-			snps,rd_osr_lmt = <0x7>;
-			snps,blen = <0 0 0 0 16 8 4>;
-		};
-
 		ethernet0: ethernet@5800a000 {
 			compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
 			reg = <0x5800a000 0x2000>;
@@ -992,6 +986,12 @@ ethernet0: ethernet@5800a000 {
 			snps,axi-config = <&stmmac_axi_config_0>;
 			snps,tso;
 			status = "disabled";
+
+			stmmac_axi_config_0: stmmac-axi-config {
+				snps,wr_osr_lmt = <0x7>;
+				snps,rd_osr_lmt = <0x7>;
+				snps,blen = <0 0 0 0 16 8 4>;
+			};
 		};
 
 		usbh_ohci: usbh-ohci@5800c000 {
-- 
2.30.2

