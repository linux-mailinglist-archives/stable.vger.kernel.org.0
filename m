Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D268711B4F0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbfLKPuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732762AbfLKPXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A23692077B;
        Wed, 11 Dec 2019 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077828;
        bh=XlcuPom1v922VlL6KJOeBwrfX/62As98LqKkl/hH6o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urYEtcDQZbKLm3LwjzovLfWx4kPgBVRmV0FgW9UOA6UAAqUiO6RVHKLI+LRlD/8HP
         oUswRi1yXx9l8khhEWh9qfoquu4hO/x+u7Pbxa1sh52gRdu/+3E013ycq8uj2Hptyp
         t8JPfqZxB6ypdKg/SHlZD9p7Y5G3zYq56t0HnkV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/243] ARM: dts: sun8i: a23/a33: Fix up RTC device node
Date:   Wed, 11 Dec 2019 16:05:47 +0100
Message-Id: <20191211150351.658072828@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit f6f4422532ad9ec9380a9936ed16b30922066a50 ]

The RTC module on the A23 was claimed to be the same as on the A31, when
in fact it is not. The A31 does not have an RTC external clock output,
and its internal RC oscillator's average clock rate is not in the same
range. The A33's RTC is the same as the A23.

This patch fixes the compatible string and clock properties to conform
to the updated bindings. The register range is also fixed.

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a23-a33.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a23-a33.dtsi b/arch/arm/boot/dts/sun8i-a23-a33.dtsi
index c16ffcc4db7da..5616333c0e0e3 100644
--- a/arch/arm/boot/dts/sun8i-a23-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23-a33.dtsi
@@ -565,11 +565,11 @@
 		};
 
 		rtc: rtc@1f00000 {
-			compatible = "allwinner,sun6i-a31-rtc";
-			reg = <0x01f00000 0x54>;
+			compatible = "allwinner,sun8i-a23-rtc";
+			reg = <0x01f00000 0x400>;
 			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
-			clock-output-names = "osc32k";
+			clock-output-names = "osc32k", "osc32k-out";
 			clocks = <&ext_osc32k>;
 			#clock-cells = <1>;
 		};
-- 
2.20.1



