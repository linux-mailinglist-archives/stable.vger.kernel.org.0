Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84A16C780
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733281AbfGRDEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbfGRDEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:04:37 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ACC82173B;
        Thu, 18 Jul 2019 03:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419076;
        bh=M4Hp0DidtU4Z5FyikNxfkGbejwLV+GEO4duPURQZ+B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Es3I931gMQy+ZJLHPxjARqCsnsntzO6zav4W0Ijncg3xFNKr/mWbwJgvO8H6ri0Ry
         nbTboP1mtDXvJqdzxyWv6gxpScvgqE4BtP6892u5IzUA+uWMH40IltEPl13UdvKcPM
         v36bb0U3MewvP6qaQ59FugRREP/Y4MlnoIIONm0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 07/54] ARM: dts: meson8: fix GPU interrupts and drop an undocumented property
Date:   Thu, 18 Jul 2019 12:01:02 +0900
Message-Id: <20190718030053.928285686@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 01dfdd7b4693496854ac92d1ebfb18d7b108f777 ]

The interrupts in Amlogic's vendor kernel sources are all contiguous.
There are two typos leading to pp2 and pp4 as well as ppmmu2 and ppmmu4
incorrectly sharing the same interrupt line.
Fix this by using interrupt 170 for pp2 and 171 for ppmmu2.

Also drop the undocumented "switch-delay" which is a left-over from my
experiments with an early lima kernel driver when it was still
out-of-tree and required this property on Amlogic SoCs.

Fixes: 7d3f6b536e72c9 ("ARM: dts: meson8: add the Mali-450 MP6 GPU")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index a9781243453e..048b55c8dc1e 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -248,8 +248,8 @@
 				     <GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>,
@@ -264,7 +264,6 @@
 			clocks = <&clkc CLKID_CLK81>, <&clkc CLKID_MALI>;
 			clock-names = "bus", "core";
 			operating-points-v2 = <&gpu_opp_table>;
-			switch-delay = <0xffff>;
 		};
 	};
 }; /* end of / */
-- 
2.20.1



