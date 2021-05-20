Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DD138A35F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhETJvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234466AbhETJtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:49:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E36613AD;
        Thu, 20 May 2021 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503310;
        bh=vleUwT8ne0v3+Na98UM1t6unvtkKVTKwiXYriCg59DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U49fAnQ5Kg8fTNBn4tt7dSi/7x2sRJhLnboKwy/jjkIsZ0UEswLWuQGrvZ170Ueh4
         V0S/p/+reEuEb7p6QM3Si3jrIVCbc8l+z7SpzDW8hC/9MjnWVFgyVQjK3DWk5C+Fvq
         Mk61zLZLH0H6XpRy777KXyuDp4fjniP0yGZ99Oyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/425] ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
Date:   Thu, 20 May 2021 11:18:52 +0200
Message-Id: <20210520092136.812144767@linuxfoundation.org>
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
index c0476c290977..d4bb5f65b9f3 100644
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



