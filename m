Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353B42E39D8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390026AbgL1N3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390019AbgL1N27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FC022AAA;
        Mon, 28 Dec 2020 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162124;
        bh=N7oWq1TSHJJXcpLjjSC+29H7BiQDeXX0UwpvMvsDtnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGwdwxbWjjFkxq+XdzIgS6TAmbR8CGNLqWQzi9kefcV4WQoAuJXYPzXqQqMXI8eXG
         nRf7l3t+1CqUU/j8vnNFNy4g0GGDcShebzxPNsJn8r+p/eDh6oLR3U0v45wx/J7KQK
         W2Xoli2M7IPv0IBHYqKxmAcRRlavWFgMdnYUdg4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 196/346] ARM: dts: at91: sama5d2: map securam as device
Date:   Mon, 28 Dec 2020 13:48:35 +0100
Message-Id: <20201228124929.269707945@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index b405992eb6016..d57be54f5df9c 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -1247,6 +1247,7 @@
 				clocks = <&securam_clk>;
 				#address-cells = <1>;
 				#size-cells = <1>;
+				no-memory-wc;
 				ranges = <0 0xf8044000 0x1420>;
 			};
 
-- 
2.27.0



