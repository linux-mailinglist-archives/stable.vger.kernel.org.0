Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F4237C7AF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhELQCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238065AbhELP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E276193B;
        Wed, 12 May 2021 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833392;
        bh=knwDJ4o9VWGHtdo0GzgXmfFq6KFeRYtBVKask9MlZlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMDVgivlu0MctpbGgYuxWhozId3Arrgc9GVNxA97tq4PwjLpf5KQdKWSGKj6i1oda
         K6XItcPUhXx/kijGGRfVLIIUz/1I7zd6s0zG/v+LCPLVb1I+IVjEqT9rlxroxn94Y0
         2Pmh7Q6rpb7+ntVGzmHX2vxYqFEctvKJTYVTkwhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 131/601] ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
Date:   Wed, 12 May 2021 16:43:28 +0200
Message-Id: <20210512144832.142789183@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8a45f33bd36efbb624198cfa9fdf1f66fd1c3d26 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: e8614292cd41 ("ARM: dts: Add Maxim 77693 fuel gauge node for exynos4412-trats2")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-3-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index 111c32bae02c..b8b75dc81aa1 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -221,7 +221,7 @@
 		fuel-gauge@36 {
 			compatible = "maxim,max17047";
 			interrupt-parent = <&gpx2>;
-			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77693_fuel_irq>;
 			reg = <0x36>;
-- 
2.30.2



