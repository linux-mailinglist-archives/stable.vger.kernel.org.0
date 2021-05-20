Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A65938A68D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbhETK2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236276AbhETK0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32E3061481;
        Thu, 20 May 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504206;
        bh=ZFA6gY6tY5t7f/xGx1cAN/0EmEpTjDefe2qpwo97BhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZNkaOgiheOFx8bWQ4xGg2LXbX16m+35OAjwniaYKGD6jmCtDDufw+m4Ux6rqbXog
         O6k5hefYjD+GLZK5qakEz47/yOQGU1GkaJi5nu26noCe+0IxzgYy+43pZETt42asmW
         Ss6oJV1vtshE2XxYVhqCSNSPoSZwyOrL5Fz0rywI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/323] ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
Date:   Thu, 20 May 2021 11:20:33 +0200
Message-Id: <20210520092124.934897438@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8987efbb17c2522be8615085df9a14da2ab53d34 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: c61248afa819 ("ARM: dts: Add max77686 RTC interrupt to cros5250-common")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-9-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-snow-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow-common.dtsi b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
index 8788880e459d..134e6e54447f 100644
--- a/arch/arm/boot/dts/exynos5250-snow-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
@@ -284,7 +284,7 @@
 	max77686: max77686@09 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		wakeup-source;
-- 
2.30.2



