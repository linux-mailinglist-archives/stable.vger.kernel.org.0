Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C7A37CBD8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhELQiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237238AbhELQ3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:29:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D47106193F;
        Wed, 12 May 2021 15:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835020;
        bh=VnTX+j9ZcBif8kJjxEdzbZinuTgRhiFwhm4tWvp4v1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/cy7SUyK+PgYk+xq6jMFiNy17Rd3dm/TlZNDqBiiSteuasHMGic4aLUqt9wU0/u9
         nHt+Hc4OP+mWyxkGTenN5dPIfOMAkb+P2WViiPAFA1rlfQjcb5riBpnI1y0ij61Ixf
         akYtvaoJQuSEQvkF4RyxFV8/H9N2HcyIEyHGoc64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 149/677] ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family
Date:   Wed, 12 May 2021 16:43:15 +0200
Message-Id: <20210512144842.191293132@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit e52dcd6e70fab51f53292e53336ecb007bb60889 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: 15dfdfad2d4a ("ARM: dts: Add basic dts for Exynos4412-based Trats 2 board")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-5-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index d75f554efde0..fc77c1bfd844 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -665,7 +665,7 @@
 	max77686: pmic@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-0 = <&max77686_irq>;
 		pinctrl-names = "default";
 		reg = <0x09>;
-- 
2.30.2



