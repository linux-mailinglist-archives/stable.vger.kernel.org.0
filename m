Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1517F491889
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbiARCrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:47:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347841AbiARCnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484F9B81229;
        Tue, 18 Jan 2022 02:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13048C36AEF;
        Tue, 18 Jan 2022 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473787;
        bh=sq+/c+27RULh7sJI51nuEHDdxzkROw5z/xLPcrOmHWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd8tmEu7kiBOvJY4YjVOdKfW8uBbd1j2pqLgHKI9PT4qUnQhnbAw1wVidKiDSxCvi
         pJXj1f3GsDg74Sii58hqnkbYpBRl38ac75PI+5fpM2mO1sJ3WqBPy2AxyGHqH/B8Rn
         KtUc08lI8B4L/dZ5i4BspvrJA2KV5ApgEpbJwVFfTqZSJfLXtY019eVLR4G3qCMd3D
         M3nOe6xDdqNU9mTS5REdGcN644qxzOWCayfTvFHK5iUhPJ+pEk9ojWTBNVrJcU74oB
         lmklyDND44DI6Xb7/SNu9xfCHsPzPN3J/YoJ2ztJPHbE4g+UzL84lCYrV+BHkuBq/t
         KxzbaS5nH/mDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biwen Li <biwen.li@nxp.com>, Li Yang <leoyang.lil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 072/116] arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus
Date:   Mon, 17 Jan 2022 21:39:23 -0500
Message-Id: <20220118024007.1950576-72-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biwen Li <biwen.li@nxp.com>

[ Upstream commit cbe9d948eadfe352ad45495a7cc5bf20a1b29d90 ]

The i2c rtc is on i2c2 bus not i2c1 bus, so fix it in dts.

Signed-off-by: Biwen Li <biwen.li@nxp.com>
Signed-off-by: Li Yang <leoyang.lil@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
index 13cdc958ba3ea..71858c9376c25 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -261,11 +261,6 @@ temperature-sensor@4c {
 				vcc-supply = <&sb_3v3>;
 			};
 
-			rtc@51 {
-				compatible = "nxp,pcf2129";
-				reg = <0x51>;
-			};
-
 			eeprom@56 {
 				compatible = "atmel,24c512";
 				reg = <0x56>;
@@ -307,6 +302,15 @@ mux: mux-controller {
 
 };
 
+&i2c1 {
+	status = "okay";
+
+	rtc@51 {
+		compatible = "nxp,pcf2129";
+		reg = <0x51>;
+	};
+};
+
 &enetc_port1 {
 	phy-handle = <&qds_phy1>;
 	phy-connection-type = "rgmii-id";
-- 
2.34.1

