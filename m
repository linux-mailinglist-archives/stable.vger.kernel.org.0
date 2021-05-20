Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114BD38A365
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhETJwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233405AbhETJuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5783A6148E;
        Thu, 20 May 2021 09:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503318;
        bh=baKML3CRuCBgP5A6IWITK4gWgd4X6pNnA/D7+jUEehY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hegR2lye5od/9XkBai2dTnh/HrZtcPh4Eu+GadS6kDaNe+m8jgY1LGiwod24DeAMC
         WK1BNuoWOIw9G6tcJ55L5nWqcdtTuDws4GtIs05UNlmZNj2E+eQue7xL5sEKyMmrBo
         VxhU8fXsg+ehj8a4QHdNl0umeMj+oay2ZheJwKqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/425] ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
Date:   Thu, 20 May 2021 11:18:56 +0200
Message-Id: <20210520092136.935971105@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit f6368c60561370e4a92fac22982a3bd656172170 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: 47580e8d94c2 ("ARM: dts: Specify MAX77686 pmic interrupt for exynos5250-smdk5250")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-8-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index d5e66189ed2a..594b246afbed 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -132,7 +132,7 @@
 		compatible = "maxim,max77686";
 		reg = <0x09>;
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		wakeup-source;
-- 
2.30.2



