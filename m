Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CB729BE42
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794435AbgJ0PLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794431AbgJ0PLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4922121D41;
        Tue, 27 Oct 2020 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811506;
        bh=tt3NQKYNv8WXmCGKswzK/TFW7PKxX+/qbaeIGNOZU/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPOehKPvW4QYFZdx25EDvJorpx4W6EfrfA1tF5BoBkr7MAXKrU8LEhBLEb1BAIbRm
         QmdhxJO2kPl1qsJSKcRqDCm8ey9r19hs0leVgDYrODwOiBFwmpkbAyKYPre6CfabMV
         c585bI5BMWNr/XWqU2Bmo3ATWmThUkF3wsZELw4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiang Yu <yuq825@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 486/633] arm64: dts: allwinner: h5: remove Mali GPU PMU module
Date:   Tue, 27 Oct 2020 14:53:49 +0100
Message-Id: <20201027135545.537464896@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang Yu <yuq825@gmail.com>

[ Upstream commit 2933bf3528007f834fb7f5eab033f9c5b0683f91 ]

H5's Mali GPU PMU is not present or working corretly although
H5 datasheet record its interrupt vector.

Adding this module will miss lead lima driver try to shutdown
it and get waiting timeout. This problem is not exposed before
lima runtime PM support is added.

Fixes: bb39ed07e55b ("arm64: dts: allwinner: h5: Add device node for Mali-450 GPU")
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20200822062755.534761-1-yuq825@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index 4462a68c06815..cdc4209f94d0e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -125,8 +125,7 @@ mali: gpu@1e80000 {
 				     <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "gp",
 					  "gpmmu",
 					  "pp",
@@ -137,8 +136,7 @@ mali: gpu@1e80000 {
 					  "pp2",
 					  "ppmmu2",
 					  "pp3",
-					  "ppmmu3",
-					  "pmu";
+					  "ppmmu3";
 			clocks = <&ccu CLK_BUS_GPU>, <&ccu CLK_GPU>;
 			clock-names = "bus", "core";
 			resets = <&ccu RST_BUS_GPU>;
-- 
2.25.1



