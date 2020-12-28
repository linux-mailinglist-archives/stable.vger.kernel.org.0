Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5DE2E3B40
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404332AbgL1Nrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405768AbgL1Nru (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB8F21D94;
        Mon, 28 Dec 2020 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163229;
        bh=TnVZjgS3Co0+IzX1LTDWGCwoVi5O6FN83UmHfj2fM/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewPPrmXxd1p60w9AEChGVU829D56GJz8g+pPMfIfsO+a9whFfPdMVhsu1nrNRxCiL
         iJzl3zXPWDH9pR4cjE3jyY+L0lqSxsGKwace7KsOf9bcy5iYTuFVgbQ6qHlsSGxG8M
         cXk+nfFuPnU5krty6z/n9kOCBjQTEaKjKDQkTMdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/453] ARM: dts: at91: sama5d2: map securam as device
Date:   Mon, 28 Dec 2020 13:47:31 +0100
Message-Id: <20201228124947.562996720@linuxfoundation.org>
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
index 2e2c1a7b1d1dc..5ea9aa9c060a0 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -648,6 +648,7 @@
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 51>;
 				#address-cells = <1>;
 				#size-cells = <1>;
+				no-memory-wc;
 				ranges = <0 0xf8044000 0x1420>;
 			};
 
-- 
2.27.0



