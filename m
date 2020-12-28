Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AC02E37E5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgL1NCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbgL1NCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88439224D2;
        Mon, 28 Dec 2020 13:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160535;
        bh=wSDyD2Be5KnwnGjocgvnSnT0VL9YoD0Jsyk1kXVqQm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn4B56jFHZCMt2F7s/CQ/YeDpjnB2Kcm+Zr+A7jAjhKnqV5zzyLwypPO0EGy/eV97
         DkfHhoIg3rY0z+TYgbA5sFaz6S+jL9t+hB3pGrhZbjytzp40jz9HPmhT3j48IDXDAm
         69Z1hb5IN6F50IHzpFSvYMNFYMEuIdbbH9q7Dvrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 056/175] arm64: dts: exynos: Correct psci compatible used on Exynos7
Date:   Mon, 28 Dec 2020 13:48:29 +0100
Message-Id: <20201228124855.974867631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 6328a66ed97e4..4c7c40ce50662 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -65,8 +65,10 @@
 	};
 
 	psci {
-		compatible = "arm,psci-0.2";
+		compatible = "arm,psci";
 		method = "smc";
+		cpu_off = <0x84000002>;
+		cpu_on = <0xC4000003>;
 	};
 
 	soc: soc {
-- 
2.27.0



