Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8136137CBAF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhELQhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241736AbhELQ15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 303E66188B;
        Wed, 12 May 2021 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834944;
        bh=AOdyIxCR3ntPjXlr79sRXOwlO1e/Inm8k7DdT/DcLe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUPy+caG9/sWev+ODz50ARpZzJmD8UbhPG07PI6t0/4NGUjE8KtOmnJzITkdUCx9A
         vum1dgtrUkg3/qzeJ/LFDzCATtOfWZCP/Z+bCDkGdz+yVrtTSDLlI4ZU7+klMBf8v4
         zbjMqjxno7fLZr48ygSQrbcvxIeohlHc+JAvcf7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 145/677] ARM: dts: exynos: correct fuel gauge interrupt trigger level on GT-I9100
Date:   Wed, 12 May 2021 16:43:11 +0200
Message-Id: <20210512144842.064761522@linuxfoundation.org>
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

[ Upstream commit 46799802136670e00498f19898f1635fbc85f583 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210-i9100.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index 304a8ee2364c..d98c78207aaf 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -136,7 +136,7 @@
 			compatible = "maxim,max17042";
 
 			interrupt-parent = <&gpx2>;
-			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 
 			pinctrl-0 = <&max17042_fuel_irq>;
 			pinctrl-names = "default";
-- 
2.30.2



