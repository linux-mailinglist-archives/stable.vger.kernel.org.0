Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AF923FB26
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHHXrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgHHXhv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364452073E;
        Sat,  8 Aug 2020 23:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929871;
        bh=0/hszbWEWY+uc1pMJXENVvjhlqC59WOheY0I+GsN32Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ib5YtUe1xL+57MrE1w1WtPok9Bim07ir+mikydiBnzduLEaZB4NuFV0t5X9AaabYP
         t+eUr9ikFvR0m0uth7XFDD58hOSrQZ1T1LIKXaCpLQctOloaIKA2EmPJBOXBVYaVJn
         JhU5eyNJLJFI6rG4/a7Yc+5Hn9vwt4MgVlCFbhCw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 20/58] arm64: dts: sun50i-pinephone: dldo4 must not be >= 1.8V
Date:   Sat,  8 Aug 2020 19:36:46 -0400
Message-Id: <20200808233724.3618168-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

