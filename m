Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E94037CBE5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhELQiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239998AbhELQa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFC176147F;
        Wed, 12 May 2021 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835042;
        bh=Y32D3heCOslglfr3Z8ODH36RjL8NAcx601FGPCo4YLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7pBewzzFtNLCwF+759M6XzQFmhP95cBGziAzllrz4clT489Szg+Dfg7aCMYf+3O0
         xC9oI4Bv/6Pzv2GxY6CeTcZ49nnsfSOrEUbvgBgJpbPQBodAEFV6p55xsoeXSUq+Zk
         zSqPvG8PO7sq/5pyeiSMlvYCMSY5hUQiB47p/SjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 150/677] ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
Date:   Wed, 12 May 2021 16:43:16 +0200
Message-Id: <20210512144842.224220481@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 6503c568e97a52f8b7a3109718db438e52e59485 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: eea6653aae7b ("ARM: dts: Enable PMIC interrupts for exynos4412-odroid-common")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-6-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index 2b20d9095d9f..eebe6a3952ce 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -278,7 +278,7 @@
 	max77686: pmic@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		reg = <0x09>;
-- 
2.30.2



