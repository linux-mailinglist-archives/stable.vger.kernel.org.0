Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E9837C146
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhELO6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232171AbhELO4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:56:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CDB961447;
        Wed, 12 May 2021 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831317;
        bh=6uSpxcK33R092AMCfXYxap3mR2bFxWXiFC/tOz2jWdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16N+Rh1S827mUEsz5ocHMS+mTo7+lnp0dlxelsMC7FCqmkiRzlpL6EBMepTKiwrPf
         q15azd1Au9V52KpEoB5hpbpnEJSjVySxA8hOGvq/qMqcTvNK+4H6CerLXZPFSyjBG5
         jrMNZYcEiWdCppMUGZ16oHvwHMdsyCKAx8gdJ/BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/244] ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
Date:   Wed, 12 May 2021 16:47:22 +0200
Message-Id: <20210512144745.313810453@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8987efbb17c2522be8615085df9a14da2ab53d34 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: c61248afa819 ("ARM: dts: Add max77686 RTC interrupt to cros5250-common")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-9-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-snow-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow-common.dtsi b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
index c952a615148e..737f0e20a452 100644
--- a/arch/arm/boot/dts/exynos5250-snow-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
@@ -292,7 +292,7 @@
 	max77686: max77686@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		wakeup-source;
-- 
2.30.2



