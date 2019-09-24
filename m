Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DE5BCD55
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633220AbfIXQpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409942AbfIXQpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71FBA21783;
        Tue, 24 Sep 2019 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343505;
        bh=oZ/CdR4pk54TSdx6nW2duEampafCF/90uNe4q3GZa9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSJ18mwEt4NMbKAZ/DLAYDkZlowLqWnxG3x8UNVTBPYQYWbXCC4Ko1DDzrrSAEuiQ
         8IiQ9ed6L6mnmwQ923jY0dlRzuGglrDk3WZZz76D6C1L1HbcDXU7Mue+wc0DtpwOGd
         nEdgmGzDtSs9nvWrU2BfwlpQbWcO/BkgbAEkc82Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 74/87] ARM: dts: dir685: Drop spi-cpol from the display
Date:   Tue, 24 Sep 2019 12:41:30 -0400
Message-Id: <20190924164144.25591-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2a7326caab479ca257c4b9bd67db42d1d49079bf ]

The D-Link DIR-685 had its clock polarity set as active
low using the special SPI "spi-cpol" property.

This is not correct: the datasheet clearly states:
"Fix SCL to GND level when not in use" which is
indicative that this line is active high.

After a recent fix making the GPIO-based SPI driver
force the clock line de-asserted at the beginning of
each SPI transaction this reared its ugly head: now
de-asserted was taken to mean the line should be
driven high, but it should be driven low.

Fix this up in the DTS file and the display works again.

Link: https://lore.kernel.org/r/20190915135444.11066-1-linus.walleij@linaro.org
Cc: Mark Brown <broonie@kernel.org>
Fixes: 2922d1cc1696 ("spi: gpio: Add SPI_MASTER_GPIO_SS flag")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-dlink-dir-685.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini-dlink-dir-685.dts b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
index bfaa2de63a100..e2030ba16512f 100644
--- a/arch/arm/boot/dts/gemini-dlink-dir-685.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
@@ -72,7 +72,6 @@
 			reg = <0>;
 			/* 50 ns min period = 20 MHz */
 			spi-max-frequency = <20000000>;
-			spi-cpol; /* Clock active low */
 			vcc-supply = <&vdisp>;
 			iovcc-supply = <&vdisp>;
 			vci-supply = <&vdisp>;
-- 
2.20.1

