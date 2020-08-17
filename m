Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583C724774A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbgHQTrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbgHQPUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6BED207FF;
        Mon, 17 Aug 2020 15:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677646;
        bh=0/hszbWEWY+uc1pMJXENVvjhlqC59WOheY0I+GsN32Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Br5wSpYpGxSHA+dlaqG5ws97yRMzRk44twMKeXSLybz1xdG5fl58EwfLKAqTV8sX3
         adcrhXzQE1DJkY9edwQ2duawJvmdvag9R+6WPQZ2G3omNymCvMb1vHfNW2guOrXem+
         oKMz5K/JcorAS2ZvEpsvb5dtfgZ3Hk4IyVO1+cnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 027/464] arm64: dts: sun50i-pinephone: dldo4 must not be >= 1.8V
Date:   Mon, 17 Aug 2020 17:09:40 +0200
Message-Id: <20200817143835.062529551@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit 86be5c789690eb08656b08c072c50a7b02bf41f1 ]

Some outputs from the RTL8723CS are connected to the PL port (BT_WAKE_AP),
which runs at 1.8V. When BT_WAKE_AP is high, the PL pin this signal is
connected to is overdriven, and the whole PL port's voltage rises
somewhat. This results in changing voltage on the R_PWM pin (PL10),
which is the cause for backlight flickering very noticeably when typing
on a Bluetooth keyboard, because backlight intensity is highly sensitive
to the voltage of the R_PWM pin.

Limit the maximum WiFi/BT I/O voltage to 1.8V to avoid overdriving
the PL port pins via BT and WiFi IO port signals. WiFi and BT
functionality is unaffected by this change.

This completely stops the backlight flicker when using bluetooth.

Fixes: 91f480d40942 ("arm64: dts: allwinner: Add initial support for Pine64 PinePhone")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Link: https://lore.kernel.org/r/20200703194842.111845-4-megous@megous.com
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
index cefda145c3c9d..342733a20c337 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
@@ -279,7 +279,7 @@ &reg_dldo3 {
 
 &reg_dldo4 {
 	regulator-min-microvolt = <1800000>;
-	regulator-max-microvolt = <3300000>;
+	regulator-max-microvolt = <1800000>;
 	regulator-name = "vcc-wifi-io";
 };
 
-- 
2.25.1



