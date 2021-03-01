Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31299328627
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhCARFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236656AbhCAQ6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E429864FDA;
        Mon,  1 Mar 2021 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616617;
        bh=c+DoenjhHRV+KcLWZFcCVNsyu8iWWfYlBHoVcprEIyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwnxwEszuBaQBmNAMEhusCapSBbAoCTEr+/cT/hzrNKP3Wiq8hVBtWzNQYNthgrBV
         sJ/rVHQfYkiqz8e+9v9EA4+zy+l8y+/MiFqkk1woNbHEuMPyigsvlJoO2quluhruTy
         +lEPmEDZCOy2rDTW38cWq5JSfZmt1Pxq6PTs1Y3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/247] arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card
Date:   Mon,  1 Mar 2021 17:10:57 +0100
Message-Id: <20210301161033.499492406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 6723b8695e0bb..ca39084fddc0b 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
@@ -51,7 +51,6 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc0_pins>;
 	vmmc-supply = <&reg_dcdc1>;
-	non-removable;
 	disable-wp;
 	bus-width = <4>;
 	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
-- 
2.27.0



