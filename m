Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC99147C9E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbgAXJxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387835AbgAXJxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:53:18 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DE3A206D5;
        Fri, 24 Jan 2020 09:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859598;
        bh=hkb2sLweeq8hZ6/gbQsJdKanNSeDuP8uWNw6WSnGVV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pje6srsLpz/3CbM+qQIBZMqy+OEPqQswXJOnjG3k72WcwjZ7+6hwuDUTQjPymxMCT
         LRlWivLWsswoo8tnwgDwzAKLdgb159qH6gfH1Zy/VBUd3Wt9PGhdUSHF/n1tNZsnVZ
         RptQgsQIS6XzYbo990lmygl4qDSKW4lROwGZA7NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 152/343] arm64: dts: allwinner: a64: Add missing PIO clocks
Date:   Fri, 24 Jan 2020 10:29:30 +0100
Message-Id: <20200124092939.985154881@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 562bf19611c000cb7219431c3cc78aa60c2b371e ]

The pinctrl binding mandates that we have the three clocks fed into the PIO
described.

Even though the old case is still supported for backward compatibility, we
should update our DTs to fix this.

Fixes: 6bc37fac30cf ("arm64: dts: add Allwinner A64 SoC .dtsi")
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 8c8db1b057dfc..788a6f8c5994e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -274,7 +274,8 @@
 			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&ccu 58>;
+			clocks = <&ccu 58>, <&osc24M>, <&rtc 0>;
+			clock-names = "apb", "hosc", "losc";
 			gpio-controller;
 			#gpio-cells = <3>;
 			interrupt-controller;
-- 
2.20.1



