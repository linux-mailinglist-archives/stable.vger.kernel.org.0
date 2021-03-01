Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10D73289B8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhCASDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239142AbhCAR6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:58:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A9764DDF;
        Mon,  1 Mar 2021 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618323;
        bh=3VYUcoViFPnf+4FXGF+rYTvwNJdrsI5fzYOj7PRVt0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXWgNISe8ygtFvNB2Lz7torUAZ4HbrQZqcO7x0tiGU3Yix1xu4Tk/x1Wj9OHcsFiH
         m6UaLrJeioRndcB+enN0GmAWDohi0XcJSnI+XCKCslSP/spJTJicXrF9Kz84imJGTw
         hkLP5xcJRfw7MvtJ9RMeHYNycHkWijdRXrFFwqrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/663] arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card
Date:   Mon,  1 Mar 2021 17:04:54 +0100
Message-Id: <20210301161144.060193205@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 941432d007689f3774646e41a1439228b6c6ee0e ]

The SD card on the SoPine SoM module is somewhat concealed, so was
originally defined as "non-removable".
However there is a working card-detect pin (tested on two different
SoM versions), and in certain SoM base boards it might be actually
accessible at runtime.
Also the Pine64-LTS shares the SoPine base .dtsi, so inherited the
non-removable flag, even though the SD card slot is perfectly accessible
and usable there. (It turns out that just *my* board has a broken card
detect switch, so I originally thought CD wouldn't work on the LTS.)

Drop the "non-removable" flag to describe the SD card slot properly.

Fixes: c3904a269891 ("arm64: allwinner: a64: add DTSI file for SoPine SoM")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210113152630.28810-5-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
index c48692b06e1fa..3402cec87035b 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
@@ -32,7 +32,6 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc0_pins>;
 	vmmc-supply = <&reg_dcdc1>;
-	non-removable;
 	disable-wp;
 	bus-width = <4>;
 	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
-- 
2.27.0



