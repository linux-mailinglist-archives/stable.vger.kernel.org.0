Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2D82E4118
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408055AbgL1PCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440046AbgL1ONH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FD8206D8;
        Mon, 28 Dec 2020 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164771;
        bh=XkvJicsoILytQwnFfqfHxky5WwbR/R+66ZcGl8JN7eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8/WHD6GKx+zRtdORBR9Lm/6hNC5uljNofX78aYIku5bjl66+crMfhzznpGeAuHUr
         9DERp53iGcETsmI7Y+mlYRROUme6J9qK7gfHtmhsvkVF0dpGor7axmqbkIzDFSQpwp
         cN806Q6xTR//KSmZgITwraDKjiW5YvvbotWP8Ldw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/717] ARM: dts: at91: sama5d2: map securam as device
Date:   Mon, 28 Dec 2020 13:44:51 +0100
Message-Id: <20201228125035.073178334@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 2ddc85dff8ce9..6d399ac0385d4 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -656,6 +656,7 @@
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 51>;
 				#address-cells = <1>;
 				#size-cells = <1>;
+				no-memory-wc;
 				ranges = <0 0xf8044000 0x1420>;
 			};
 
-- 
2.27.0



