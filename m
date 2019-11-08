Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311F6F4B27
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfKHLiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732127AbfKHLiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5043D222C4;
        Fri,  8 Nov 2019 11:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213082;
        bh=CqirFA+y3Yz1r/QLQgaj2aGsvThhGc28+10qfsOM2X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZPQAQizyCqZDDib7yXUxOK3htTllDpTUIHaQoj8cpkJLYyC1EXItvai/2EgbZXvm
         8jHgsXBwP7mK/y2YT1jLVdZkZa2D6WpPltG8s9vBEr7q0WEDAuv+zGbrcrlkGOdy9C
         V1FaHDhVI77OvvKiik/sqyzldG0SqE4apT10fZbw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 008/205] arm64: dts: allwinner: a64: Orange Pi Win: Fix SD card node
Date:   Fri,  8 Nov 2019 06:34:35 -0500
Message-Id: <20191108113752.12502-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 09b964afca14d0594b2b2f265df3d987e2f43867 ]

The Orange Pi Win has a microSD card slot which is connected via all
four SD data lines. As the DT was not mentioning this fact, we got the
default single bit transfers, losing out on performance.
Also, as microSD does not have a write protect switch, we disable this
feature in the DT node.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
index 1221764f5719c..667016815cf32 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
@@ -67,7 +67,9 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc0_pins>;
 	vmmc-supply = <&reg_dcdc1>;
-	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>;
+	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
+	disable-wp;
+	bus-width = <4>;
 	status = "okay";
 };
 
-- 
2.20.1

