Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982B73284E8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhCAQpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:45:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234847AbhCAQig (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:38:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39EA664F7A;
        Mon,  1 Mar 2021 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616051;
        bh=8+FRpvpiGqWiGomGLZg6GCv82ZfWoPgS9xBPzIwKfX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grw4AKtc+gVy0K2GHoXrrM+R9IHRmOLIOQjwlEE3YAVosu+Btw1v644TjBMlksJp3
         p9wG/A0XhkdNcSrQHoyRn/pXnin1TBUNyrGFB5u0Kj3GBUXfjS2+FdPB0FdlNuxF+8
         EzRGHDhujrqFo2P4dY/KVTJj8AVYwaiFzS+qJ8f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 018/176] arm64: dts: exynos: correct PMIC interrupt trigger level on TM2
Date:   Mon,  1 Mar 2021 17:11:31 +0100
Message-Id: <20210301161021.877420782@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit e98e2367dfb4b6d7a80c8ce795c644124eff5f36 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: 01e5d2352152 ("arm64: dts: exynos: Add dts file for Exynos5433-based TM2 board")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-7-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi b/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
index 297597442c442..7de6a187ba8f4 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
@@ -343,7 +343,7 @@
 	s2mps13-pmic@66 {
 		compatible = "samsung,s2mps13-pmic";
 		interrupt-parent = <&gpa0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x66>;
 		samsung,s2mps11-wrstbi-ground;
 
-- 
2.27.0



