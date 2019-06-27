Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC8575AD
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfF0Ab2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfF0Ab1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:27 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F5B2083B;
        Thu, 27 Jun 2019 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595486;
        bh=wsAiZsdmA96sJRs3FWAGuz5i/noAL0FT81Il3kxC0Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0vMehm9PL3TQ3QNb/MHeLGDxPogK1whYIoZ2ggXrfhzHC56zhCNZIUTVyegbWr5L
         ME9oME0zncuwykU+WFbcvkbJb+I47oSlzaFmpWTpwhLdIQ04dYEAVVxPi7V3JK/nKQ
         vo9KB0vZS95pMt6XvpcjCsj80LWMtmZDjHXxz9+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 21/95] ARM: dts: Drop bogus CLKSEL for timer12 on dra7
Date:   Wed, 26 Jun 2019 20:29:06 -0400
Message-Id: <20190627003021.19867-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 34f61de87017aff3c8306280d196dddb1e168a88 ]

There is no CLKSEL for timer12 on dra7 unlike for timer1. This
causes issues on booting the device that Tomi noticed if
DEBUG_SLAB is enabled and the clkctrl clock does not properly
handle non-existing clock. Let's drop the bogus CLKSEL clock,
the clkctrl clock handling gets fixed separately.

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Fixes: 4ed0dfe3cf39 ("ARM: dts: dra7: Move l4 child devices to probe them with ti-sysc")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 73f5c050f586..17f0d8e93622 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -4450,8 +4450,6 @@
 			timer12: timer@0 {
 				compatible = "ti,omap5430-timer";
 				reg = <0x0 0x80>;
-				clocks = <&wkupaon_clkctrl DRA7_WKUPAON_TIMER12_CLKCTRL 24>;
-				clock-names = "fck";
 				interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 				ti,timer-alwon;
 				ti,timer-secure;
-- 
2.20.1

