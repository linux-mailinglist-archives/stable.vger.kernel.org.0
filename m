Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48CC328DB4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbhCATPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238298AbhCATKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:10:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DA1E65143;
        Mon,  1 Mar 2021 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618273;
        bh=ksPg8OfbnvbjXnRXDCzULdaran6Nojqn7RmzI6f0jxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqWR4Grqds5O8EgiOZV2Kw6E5y8Ac7bJRvsfRK2g9cGT6YbYGsiUorT6EEY2LE6pn
         mfZHwjFdGeLR7v61ZhCCKvGKRN3dbMBEVDDptvIEPdj8xHo/EPAPvQ5lxd41YbOG3m
         pUtcz1qKubsASYuPY0mhgYxQ+xNToeHJi02dZG/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/663] ARM: dts: exynos: correct PMIC interrupt trigger level on Artik 5
Date:   Mon,  1 Mar 2021 17:04:35 +0100
Message-Id: <20210301161143.137985529@linuxfoundation.org>
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

[ Upstream commit cb31334687db31c691901269d65074a7ffaecb18 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: b004a34bd0ff ("ARM: dts: exynos: Add exynos3250-artik5 dtsi file for ARTIK5 module")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-artik5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-artik5.dtsi b/arch/arm/boot/dts/exynos3250-artik5.dtsi
index 12887b3924af8..ad525f2accbb4 100644
--- a/arch/arm/boot/dts/exynos3250-artik5.dtsi
+++ b/arch/arm/boot/dts/exynos3250-artik5.dtsi
@@ -79,7 +79,7 @@
 	s2mps14_pmic@66 {
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx3>;
-		interrupts = <5 IRQ_TYPE_NONE>;
+		interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s2mps14_irq>;
 		reg = <0x66>;
-- 
2.27.0



