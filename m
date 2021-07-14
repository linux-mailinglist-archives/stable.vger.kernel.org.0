Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1953C8CE3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhGNTnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhGNTmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3B4613D1;
        Wed, 14 Jul 2021 19:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291586;
        bh=cwuknsUkyFQntYNQeT7PI+Xr5t9188BliD8rS4NwD9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2rzIoe73drkuwk8O/ZJ0QcSNdz1HBK2f6OwDbzw/rhHQayaNs/9RTqwAutVCHJ5+
         1ilm9E6+11VK8jFN2Fwe46nSkYhOlUVCPtdL56dVjM0Kvs3qFc36W1NIA+VdeR7wH2
         bbFwGzJZJbB2n7cVQTPTtIk/8bZRcpBCQz/zysSSoicBJrE3GX21BjWACiQQSepxBT
         rsXZpbN3XpI2AQD9D8DEfEZ6w3C/XFeZvgbkpncvJaD9kbwuL7EykOJeCVO2sjNfA3
         LH5+SejU2aaBJe0FADzU1igN9RlGIQ/AaZtGDSD8SiZUhIjysq0OiWluKJsrqM7SvU
         +N3YpdDn/7Uog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 073/108] ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15
Date:   Wed, 14 Jul 2021 15:37:25 -0400
Message-Id: <20210714193800.52097-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
 arch/arm/boot/dts/stm32mp151.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index fcd3230c469b..23234f950de6 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -1416,12 +1416,6 @@ crc1: crc@58009000 {
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
@@ -1447,6 +1441,12 @@ ethernet0: ethernet@5800a000 {
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
 
 		usbh_ohci: usb@5800c000 {
-- 
2.30.2

