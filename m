Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06AF3D28CB
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhGVP64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232859AbhGVP6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A071E61369;
        Thu, 22 Jul 2021 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971922;
        bh=F2JytO9c1WB6KQLXbwzXwCJnwm4B9ZBXTwzvFgQcCFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEs0+FHJ22HrTaZOmvi9pO1PSbXLjA+/C+OFVA7z8u8mP08h131kKeDgEVk/spbgV
         y+YETRvg3BCaKPfCqiote+chUEGzSacts8Qzl5qa93RPYieIUd4zD8/GhHhOCAOLRI
         zLXJAr58+TxRBjysnBOKNGd07zg/CoPSbzuJktIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Szymaszek <gszymaszek@short.pl>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/125] ARM: dts: stm32: fix stm32mp157c-odyssey card detect pin
Date:   Thu, 22 Jul 2021 18:30:33 +0200
Message-Id: <20210722155626.093896000@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -64,7 +64,7 @@
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



