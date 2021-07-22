Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E923D29B2
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhGVQF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbhGVQEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CC561CC2;
        Thu, 22 Jul 2021 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972272;
        bh=F2JytO9c1WB6KQLXbwzXwCJnwm4B9ZBXTwzvFgQcCFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yke/+HLUNjj8Edk3jawEA+BQp4h0QTItQbme8xWV/1e9gFg4rvXLCT7R0+M/nW7IX
         q9Ik8OvAQqahkLaqSKeqKmq4D+xvB8z+behpP1OR+WpSFIQciuKZmyKByoxyXt89uM
         cgk0204LnIhBW8jYMduSS0VIUNHNNMSc/PwN5KYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Szymaszek <gszymaszek@short.pl>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 052/156] ARM: dts: stm32: fix stm32mp157c-odyssey card detect pin
Date:   Thu, 22 Jul 2021 18:30:27 +0200
Message-Id: <20210722155630.096810235@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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



