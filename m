Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7689138A35D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhETJvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234523AbhETJtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6995613AA;
        Thu, 20 May 2021 09:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503312;
        bh=1FtuE6wXrf3KBrDZ3bGpFjPzzlYwJ06oNlq908LCyfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6Y5NyOeY20ClEF8371eHLEVceuuN23jaS2ikQf3bTijoZwrwtoNFZp0rAxvW0VfU
         93V4/TP4piTy2Wd2afW//BHqmNcH0kdhjHRhGndqrdokrae0yI6Iz6sGMrTMgIkLDo
         oHUfspJDP+b2MZWGpZ6cTN5wxRF9cx5T0I4GXe5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/425] ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family
Date:   Thu, 20 May 2021 11:18:53 +0200
Message-Id: <20210520092136.844793823@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 15107e443ab8c6cb35eff10438993e4bc944d9ae ]

The Maxim MUIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: 7eec1266751b ("ARM: dts: Add Maxim 77693 PMIC to exynos4412-trats2")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-4-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index d4bb5f65b9f3..c6cc3d2a1121 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -139,7 +139,7 @@
 		max77693@66 {
 			compatible = "maxim,max77693";
 			interrupt-parent = <&gpx1>;
-			interrupts = <5 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77693_irq>;
 			reg = <0x66>;
-- 
2.30.2



