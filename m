Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9352E3A93
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391246AbgL1Niq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391142AbgL1Nip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C542063A;
        Mon, 28 Dec 2020 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162684;
        bh=NeFd4lEf32w+JFO2vKinOV5tLGKEUrFRfWp0DtDf0Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt0iudFE1Cp+LCsjklOhzmaZKWA8bIZB+k4rL4BdI3V5hPyptwdfqe5cImTDEfuYE
         ZVrVL2h1X5jXSMNarQ1HRF4Gvcn6iTd0v9t4AJEi5ygCoG8AOq6qJ3Jzh5vipNOtQA
         I/i6n95QBv0yFATYHG4cgTN79AQNTSGQQBPdFDPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Sampson <ats@offog.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Andrew Lunn <andrew@lunn.ch>, Chen-Yu Tsai <wens@csie.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/453] ARM: dts: sun7i: pcduino3-nano: enable RGMII RX/TX delay on PHY
Date:   Mon, 28 Dec 2020 13:44:03 +0100
Message-Id: <20201228124937.598033257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Sampson <ats@offog.org>

[ Upstream commit a7361b9c4615951f52ffd2b1afa09a1384c7b4e4 ]

The RX/TX delays for the Ethernet PHY on the Linksprite pcDuino 3 Nano
are configured in hardware, using resistors that are populated to pull
the RTL8211E's RXDLY/TXDLY pins low or high as needed.

phy-mode should be set to rgmii-id to reflect this. Previously it was
set to rgmii, which used to work but now results in the delays being
disabled again as a result of the bugfix in commit bbc4d71d6354 ("net:
phy: realtek: fix rtl8211e rx/tx delay config").

Tested on two pcDuino 3 Nano boards purchased in 2015. Without this fix,
Ethernet works unreliably on one board and doesn't work at all on the
other.

Fixes: 061035d456c9 ("ARM: dts: sun7i: Add dts file for pcDuino 3 Nano board")
Signed-off-by: Adam Sampson <ats@offog.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20201123174739.6809-1-ats@offog.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts b/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts
index fce2f7fcd084a..bf38c66c1815b 100644
--- a/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts
+++ b/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts
@@ -1,5 +1,5 @@
 /*
- * Copyright 2015 Adam Sampson <ats@offog.org>
+ * Copyright 2015-2020 Adam Sampson <ats@offog.org>
  *
  * This file is dual-licensed: you can use it either under the terms
  * of the GPL or the X11 license, at your option. Note that this dual
@@ -115,7 +115,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.27.0



