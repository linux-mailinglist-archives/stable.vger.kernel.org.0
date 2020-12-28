Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25612E4266
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436841AbgL1OCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbgL1OCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 242A320715;
        Mon, 28 Dec 2020 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164127;
        bh=7IDpwvkh2/CeIX75Mr6xcB2w18dVth07cTES6nGsdmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryCv65aCjtObEGNvAWogyoNtKPGLNuwRhrXtusO8dtXAMMMt+gVAxThSjV8jxUj2F
         5HPatGqsHVFv7pO5z7+hQ7VaM7LIoSYlntYo475L7QcfyR7rbeBBkAZOekSj/1Llrb
         KbgQ2kxTUSWujt2vADvl+UOcZpNeXZST5ZfG5C/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/717] arm64: dts: exynos: Correct psci compatible used on Exynos7
Date:   Mon, 28 Dec 2020 13:41:08 +0100
Message-Id: <20201228125024.344449748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>

[ Upstream commit e1e47fbca668507a81bb388fcae044b89d112ecc ]

It's not possible to reboot or poweroff Exynos7420 using PSCI. Instead
we need to use syscon reboot/poweroff drivers, like it's done for other
Exynos SoCs. This was confirmed by checking vendor source and testing it
on Samsung Galaxy S6 device based on this SoC.

To be able to use custom restart/poweroff handlers instead of PSCI
functions, we need to correct psci compatible. This also requires us to
provide function ids for CPU_ON and CPU_OFF.

Fixes: fb026cb65247 ("arm64: dts: Add reboot node for exynos7")
Fixes: b9024cbc937d ("arm64: dts: Add initial device tree support for exynos7")
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
Link: https://lore.kernel.org/r/20201107133926.37187-2-pawel.mikolaj.chmiel@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos7.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 545e67901938a..7599e1a00ff51 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -79,8 +79,10 @@
 	};
 
 	psci {
-		compatible = "arm,psci-0.2";
+		compatible = "arm,psci";
 		method = "smc";
+		cpu_off = <0x84000002>;
+		cpu_on = <0xC4000003>;
 	};
 
 	soc: soc@0 {
-- 
2.27.0



