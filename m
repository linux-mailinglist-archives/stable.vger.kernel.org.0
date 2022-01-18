Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A928491ADE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbiARDDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344093AbiARC5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC90C061368;
        Mon, 17 Jan 2022 18:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8761612CC;
        Tue, 18 Jan 2022 02:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408D6C36AF2;
        Tue, 18 Jan 2022 02:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473963;
        bh=vQtfTXPfT7ypSjtV4Y1LOGjNzKqgb5VXeNhI3U1g7fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLzz203UKosXGcg9hpDlHt5v2gGDhK/5+Gk7byyJR3PC9t/3soSW+i31D2Typ7F/H
         zLBglILMKvF98nsEmVmK/kBO6JkgVd5zWcwA6lRwufXuAS/LqTVHQiGemhUM9ok15x
         yF6Te01y78DUgNEvc7FsRR4YTMil6qEXKkJ2VlSt5ck6eeOhh/oAfBrdZoms0WP/B1
         AxxmfkCdNGMfO0oVzY8x5BQDVKGoOomm/CYkrANv3MBI9Sq2YCEM5UsswWMPLQgZmD
         QoBuZmNhLhJHgubXjtgwQvrwCiaVg4XcY93rVdmCjGDBWVlGoNCvGXUI+3F/Ba+BTI
         yCD107gkM4FDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biwen Li <biwen.li@nxp.com>, Li Yang <leoyang.lil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 44/73] arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus
Date:   Mon, 17 Jan 2022 21:44:03 -0500
Message-Id: <20220118024432.1952028-44-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 078a5010228cd..0b3a93c4155d2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -161,11 +161,6 @@ temperature-sensor@4c {
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
@@ -209,6 +204,15 @@ mux: mux-controller {
 
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

