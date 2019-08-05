Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F781ACA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbfHENJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbfHENJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 859C32067D;
        Mon,  5 Aug 2019 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010559;
        bh=AdIBBppb60+JFHEX9nqiH89j8foZ7m3Kvw4Kbc3JHEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7TyR0lQWdke4UzzyNU+2I7wkZGjZIJRFMAREeaNMTEhSFaHWvGHMbUU0SleAon9e
         j10Aa8tszXGSYeWP3z/99GJZm0B9qlMi8IGK4UMeYS94/q7FABPvhwoEmA81+oSNst
         JFWOC2meAks4LB+h7jCT5zNOrquk/Yhkk0TaYmxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/74] ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend
Date:   Mon,  5 Aug 2019 15:02:17 +0200
Message-Id: <20190805124936.173376284@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ef1ba39a9fa53d2205e633bc9b21840a275908e ]

This is similar to commit e6186820a745 ("arm64: dts: rockchip: Arch
counter doesn't tick in system suspend").  Specifically on the rk3288
it can be seen that the timer stops ticking in suspend if we end up
running through the "osc_disable" path in rk3288_slp_mode_set().  In
that path the 24 MHz clock will turn off and the timer stops.

To test this, I ran this on a Chrome OS filesystem:
  before=$(date); \
  suspend_stress_test -c1 --suspend_min=30 --suspend_max=31; \
  echo ${before}; date

...and I found that unless I plug in a device that requests USB wakeup
to be active that the two calls to "date" would show that fewer than
30 seconds passed.

NOTE: deep suspend (where the 24 MHz clock gets disabled) isn't
supported yet on upstream Linux so this was tested on a downstream
kernel.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index c706adf4aed2f..440d6783faca5 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -227,6 +227,7 @@
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		clock-frequency = <24000000>;
+		arm,no-tick-in-suspend;
 	};
 
 	timer: timer@ff810000 {
-- 
2.20.1



