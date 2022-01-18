Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A894491602
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346011AbiARCc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344667AbiARCah (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:30:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694F9C0611DA;
        Mon, 17 Jan 2022 18:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E830B81240;
        Tue, 18 Jan 2022 02:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF70BC36AE3;
        Tue, 18 Jan 2022 02:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472822;
        bh=Pkf9ujhYB+B01cj1wQ8NKmFmBIpi5dtDa0gGKsqdyv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh4+VtrWvImi16scJujiShPWjHMxDiH12tBRuPgfsxT66eE0GkLGd5r0vnw0li8hn
         WyNiXzmSfdcpMH7V8gDAYMWDfVeqUAgsfURkrTnU93ZYWbcHFDuUh5mlfy0HjsrybB
         yMsarOM0s6eZnod9y7JV2jQXSB/RJBw3SFPCLKCzt3AjJQenL0YlMaFuLEyexaiYJM
         PTGbWvRJQdLq53AVTK8nzVQkTtVjtn7tr58R4sQOAbaWqXnHg1Pc40Vy4HLziYDwkN
         jZjvVP2Jb03lzq5j40ZSBkUpN67j/6M/hhK4EmOgSTwcqgzakBeOey6gFYdT4kOZZ8
         QdGMHnqwc+WIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biwen Li <biwen.li@nxp.com>, Li Yang <leoyang.lil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 143/217] arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus
Date:   Mon, 17 Jan 2022 21:18:26 -0500
Message-Id: <20220118021940.1942199-143-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 6e2a1da662fb4..4597848598df0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -272,11 +272,6 @@ temperature-sensor@4c {
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
@@ -318,6 +313,15 @@ mux: mux-controller {
 
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
 	phy-mode = "rgmii-id";
-- 
2.34.1

