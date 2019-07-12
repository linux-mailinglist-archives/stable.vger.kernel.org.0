Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D266566EA8
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfGLMZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbfGLMZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A2D2084B;
        Fri, 12 Jul 2019 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934335;
        bh=gJSx/fs7WM32HrnaDMAU7u+BbhEfVSier6eHccGZFwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxsbQig9ZF9/FvVPAShBYG8uVMutSSKEYEZTAvL74LGsPzYtBA8dzzUL/xdOZYWCR
         Xj/0OPKCFo9KLPfMzF4mOqn7+zO7CFJeIcpd+XX+U9n0shMvxVQDn5X1E7TT3pVP/Z
         Ott+5YfN6vT3Gl9NKBMxiCljbco2IPHAdNzs8dxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 021/138] ARM: dts: Drop bogus CLKSEL for timer12 on dra7
Date:   Fri, 12 Jul 2019 14:18:05 +0200
Message-Id: <20190712121629.524768688@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



