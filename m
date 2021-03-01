Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79127328E19
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhCATYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241284AbhCATTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:19:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F97664FF2;
        Mon,  1 Mar 2021 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618390;
        bh=b08ItFFBQkR6m8pEBqZGxMESzggQSPo1IWWC9+qa0TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsefvWAo7f674myKR7xbbBUIVjEKybfjvguIOnxJw9Yo2/VHKMloLWPgXW6uZ/6wO
         8lVk/xm+TFQmmzx42FXuiILCH6WP866mtnNUK+Io2npOAUa0KSkwHA0CVZoXMN1I9c
         1tS49M8gIIRJLorjr81VdKUIdVxng/XjwBab8+BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/663] ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
Date:   Mon,  1 Mar 2021 17:04:38 +0100
Message-Id: <20210301161143.286429168@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 77e6a5467cb8657cf8b5e610a30a4c502085e4f9 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: 53dd4138bb0a ("ARM: dts: Add exynos5250-spring device tree")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212903.216728-4-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-spring.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index a92ade33779cf..5a9c936407ea3 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -109,7 +109,7 @@
 		compatible = "samsung,s5m8767-pmic";
 		reg = <0x66>;
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
 		wakeup-source;
-- 
2.27.0



