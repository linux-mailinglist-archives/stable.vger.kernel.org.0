Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5C4328E84
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbhCATdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241537AbhCAT0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80387652B6;
        Mon,  1 Mar 2021 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620222;
        bh=j3QuAWG56mqibUhIK+hFGeh36phcwQaeFXdhidfhnIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJqOzzWIqkfyQYien2kaUZfuFYyIo2kVEDi+/AeykQXGSp/R379/FOWu0sGX+T+PL
         Zv5g+184OosYIFFkb29LTdGdfjp1+H8jNYD6b7SzeRiU5eGVUw1UmbeHdz8InWgXFf
         GScvk/PHI/+g+VA1fkhknma5jbVfXc+nUIwuV7z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 034/775] ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid XU3 family
Date:   Mon,  1 Mar 2021 17:03:22 +0100
Message-Id: <20210301161203.402295953@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 3e7d9a583a24f7582c6bc29a0d4d624feedbc2f9 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: aac4e0615341 ("ARM: dts: odroidxu3: Enable wake alarm of S2MPS11 RTC")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-6-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroid-core.dtsi b/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
index d0df560eb0db1..6d690b1db0994 100644
--- a/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
@@ -509,7 +509,7 @@
 		samsung,s2mps11-acokb-ground;
 
 		interrupt-parent = <&gpx0>;
-		interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
+		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s2mps11_irq>;
 
-- 
2.27.0



