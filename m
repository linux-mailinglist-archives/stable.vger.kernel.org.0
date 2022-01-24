Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3A54994E7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388884AbiAXUtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33176 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350085AbiAXUhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:37:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9249C6154F;
        Mon, 24 Jan 2022 20:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B572C340E5;
        Mon, 24 Jan 2022 20:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056667;
        bh=pkScPT/qHrBlmsJ+4ABC2NTBLaFxmMQUSkN+opeaQI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhLHVH2X95kQYgOLp7BoHC2vcSYxMquG6EsNUo6CIpE9AzuD+LxKmw+1UWkVXcZJ5
         5W2sLfV6Xasa/VraaM/hjsqVJQOKfxH4r3q9hOXlmzcqZMfb1+bejXUkAvtx8iHjuZ
         Opt08ZuELZCQyzN8nPq9qAUPhEIo2UxkxR2zFlFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        Li Yang <leoyang.lil@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 560/846] arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus
Date:   Mon, 24 Jan 2022 19:41:17 +0100
Message-Id: <20220124184120.341583585@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bfd14b64567e4..2f92e62ecafe9 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -272,11 +272,6 @@
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
@@ -318,6 +313,15 @@
 
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



