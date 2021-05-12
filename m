Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8196937CBF3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbhELQjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240188AbhELQab (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1541861C24;
        Wed, 12 May 2021 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835050;
        bh=6NiQJ/q3WcncjlGCCbrhVGSVKXoGZoj0U7fSuoFQY7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhiR7t4hL8ptTVlCklHX5WPhMvwdGHlTHuZLjv7Ixnj6pz48OS7sB4to04Kp64fhK
         2TTUip/7kskAos+ehlXHwb9RSaZ/yn8mt8OVS7p62Tjse9UNrniIDkMhjcmc7gWgcQ
         yKsOsUni0YGvaYLgAK3NPY7qYYCvWOYgxNsNw7wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 153/677] ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
Date:   Wed, 12 May 2021 16:43:19 +0200
Message-Id: <20210512144842.325444256@linuxfoundation.org>
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
index 6635f6184051..2335c4687349 100644
--- a/arch/arm/boot/dts/exynos5250-snow-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
@@ -292,7 +292,7 @@
 	max77686: pmic@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		wakeup-source;
-- 
2.30.2



