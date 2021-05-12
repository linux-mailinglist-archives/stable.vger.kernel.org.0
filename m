Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA8A37C13D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhELO5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231455AbhELO4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:56:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C2A61440;
        Wed, 12 May 2021 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831304;
        bh=z4e7l8p6Cpon/zOsU9iHY3ar7o3fden3FRcwU1dVm9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUmVUeph38kT9SkOD/d0x6slchfdaX3E7oy2T5y1r2IQKVDabp4MDtRdM/OjYFBue
         GDG/maPNuIAJDGrok7vFrUgP/0yfplG62sl8Kfehw+LTDwjbm8Ukzo0kwu5Ch1kI2P
         UGog2RF16L8NtZM3ZmParqtNWRkwh4REacbUOupY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/244] ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
Date:   Wed, 12 May 2021 16:47:17 +0200
Message-Id: <20210512144745.147374775@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 83be3a797411..342abf97921e 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -187,7 +187,7 @@
 		max77693-fuel-gauge@36 {
 			compatible = "maxim,max17047";
 			interrupt-parent = <&gpx2>;
-			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77693_fuel_irq>;
 			reg = <0x36>;
-- 
2.30.2



