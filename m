Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3DF451F67
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355705AbhKPAii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344403AbhKOTYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B05B633D1;
        Mon, 15 Nov 2021 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002621;
        bh=X0rLVvR884dfc8DTquZ0GWWLb0ggoBKa3pK2TkxM8ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13ZZtOPSjAo1TVKAipCmHjZ4TkFPJ9+CN66G19WT2bmxPjMUkH1zaq+r7t8Ad1ihV
         C6wtxQElUtb/TIzRrVdR2JrsGVm1yT4G4qWZF7gXg5h+SGcbRDyZ85Ih+MSWTj/ArS
         fdKwD2m0vLBmMegYNNR+XIh3G4je+efj5FgwNHXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/917] ARM: dts: stm32: fix STUSB1600 Type-C irq level on stm32mp15xx-dkx
Date:   Mon, 15 Nov 2021 18:02:12 +0100
Message-Id: <20211115165450.420235229@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 3d4fb3d4c431f45272bf8c308d3cbe030817f046 ]

STUSB1600 IRQ (Alert pin) is active low (open drain). Interrupts may get
lost currently, so fix the IRQ type.

Fixes: 83686162c0eb ("ARM: dts: stm32: add STUSB1600 Type-C using I2C4 on stm32mp15xx-dkx")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
index 899bfe04aeb91..48beed0f1f30a 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
@@ -249,7 +249,7 @@
 	stusb1600@28 {
 		compatible = "st,stusb1600";
 		reg = <0x28>;
-		interrupts = <11 IRQ_TYPE_EDGE_FALLING>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-parent = <&gpioi>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&stusb1600_pins_a>;
-- 
2.33.0



