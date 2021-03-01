Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6692E3287B0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbhCAR1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhCARVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E667765061;
        Mon,  1 Mar 2021 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617281;
        bh=DT2kBST7JP0Sgk/kipt0vxtAZKpCnmYVTxd2MRSzJcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLQ1SVqzM2xSNU0Qr4652WBlUgYA5hKI5pVL9WEbTlaswiZ/lxui29SkmKwqEi+wc
         RSLpATpfZptFl+fkpq3NnGIk4RNs0k40n7myzaOxn8bhDQBSMAkuUsBh2MASN8loQ+
         Jmcs/HD97lVzCv7xsNzxZHRPj2tQxn4plTd1Z2Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/340] ARM: dts: exynos: correct PMIC interrupt trigger level on Rinato
Date:   Mon,  1 Mar 2021 17:09:23 +0100
Message-Id: <20210301161049.259256722@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 437ae60947716bb479e2f32466f49445c0509b1e ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: faaf348ef468 ("ARM: dts: Add board dts file for exynos3250-rinato")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-3-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 86c26a4edfd72..468932f452895 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -260,7 +260,7 @@
 	s2mps14_pmic@66 {
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x66>;
 		wakeup-source;
 
-- 
2.27.0



