Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162403C8DEC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhGNTqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234525AbhGNTp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3824B613E7;
        Wed, 14 Jul 2021 19:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291717;
        bh=8GeQ5M75UeMZspnSxlJDRK/s5IqEBi4K7a3A1jfCdVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBAFdW+W5KGXhoIvs6gVwH+0hAiWUkbdOQc1LsaIZW35rYwkBF5BexnkoiQ7ueXXW
         nqkEDyQznPyNcFfJm7MuqySKMrbgQLIi6IkAWFYAQWcAz6mzulhr/EVPfUHTWg7PSt
         H2sEBkL1TsVmvkeZqU1U3M1i00Vzixgj12PpQi6dda6ZgAAlxqjcTnssibcwUl3OCl
         iQslGKsiXQHLKleud/z07WYsgEa16Vu54O+Ae5cvjrtecn5T5W17pq+asUljIaF7g8
         HPu7OteWRdY25JMK/RmFRRO3UG90up358lolkfsXeLnxW2oOo8YhwoWKNaxSbjoP7j
         wwqXYPHtnJ/Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grzegorz Szymaszek <gszymaszek@short.pl>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 057/102] ARM: dts: stm32: fix stm32mp157c-odyssey card detect pin
Date:   Wed, 14 Jul 2021 15:39:50 -0400
Message-Id: <20210714194036.53141-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szymaszek <gszymaszek@short.pl>

[ Upstream commit 0171b07373cc8c2815ca5fa79a7308fdefa54ca4 ]

The microSD card detect pin is physically connected to the MPU pin PI3.
The Device Tree configuration of the card detect pin was wrong—it was
set to pin PB7 instead. If such configuration was used, the kernel would
hang on “Waiting for root device” when booting from a microSD card.

Signed-off-by: Grzegorz Szymaszek <gszymaszek@short.pl>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-odyssey.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-odyssey.dts b/arch/arm/boot/dts/stm32mp157c-odyssey.dts
index a7ffec8f1516..be1dd5e9e744 100644
--- a/arch/arm/boot/dts/stm32mp157c-odyssey.dts
+++ b/arch/arm/boot/dts/stm32mp157c-odyssey.dts
@@ -64,7 +64,7 @@ &sdmmc1 {
 	pinctrl-0 = <&sdmmc1_b4_pins_a>;
 	pinctrl-1 = <&sdmmc1_b4_od_pins_a>;
 	pinctrl-2 = <&sdmmc1_b4_sleep_pins_a>;
-	cd-gpios = <&gpiob 7 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
+	cd-gpios = <&gpioi 3 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
 	disable-wp;
 	st,neg-edge;
 	bus-width = <4>;
-- 
2.30.2

