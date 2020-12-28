Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A992E38B5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbgL1NNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:13:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732315AbgL1NNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7523120776;
        Mon, 28 Dec 2020 13:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161189;
        bh=E5KaS4Hoa52hXqI/4RI+ExeS0aDhKRCmCEwd5G0LEJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGmqGXfk3RSesB16OapfKkWesWX91SDgq8fRSY0WF2IStzmm7b4S5nWz/d75QKmIC
         g4jWi2fJ1d6acFl0soRxWnPM3YRK21AEq7RoTPUFfQ0RihvqFkX+lsDcUjdr4tlGTV
         bjfVDKML6c6gNl76f4c5a9EOOFHMTfKdBlZxyUv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/242] ARM: dts: at91: sama5d2: map securam as device
Date:   Mon, 28 Dec 2020 13:48:56 +0100
Message-Id: <20201228124911.151012157@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 9b5dcc8d427e2bcb84c49eb03ffefe11e7537a55 ]

Due to strobe signal not being propagated from CPU to securam
the securam needs to be mapped as device or strongly ordered memory
to work properly. Otherwise, updating to one offset may affect
the adjacent locations in securam.

Fixes: d4ce5f44d4409 ("ARM: dts: at91: sama5d2: Add securam node")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/1606903025-14197-3-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama5d2.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index a8e4b89097d9c..8a09c2eab0f97 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -1243,6 +1243,7 @@
 				clocks = <&securam_clk>;
 				#address-cells = <1>;
 				#size-cells = <1>;
+				no-memory-wc;
 				ranges = <0 0xf8044000 0x1420>;
 			};
 
-- 
2.27.0



