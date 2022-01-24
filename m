Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7E0499222
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbiAXURd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348595AbiAXUNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B954C028C34;
        Mon, 24 Jan 2022 11:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 051A8B81232;
        Mon, 24 Jan 2022 19:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362BBC340E5;
        Mon, 24 Jan 2022 19:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052850;
        bh=ix7wDqJn/RxHYwks4UqY3CjF4nw8nPf/m6csEMp6k/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYoIjwYMu0bu0bluoxCv+20bSQneqjUEMCK5KdODzs8JHktjRhES4xMPKb6L6j2b6
         g0IhHvtv3D5PST5+PHN8dEnb8/iIlBEyn3TiPULUpaV9sggb5Z6jvWb8ojV9TQQlyt
         nQrlYQqFvJ8lJCVNp7yKxUxJCfm7P8v11CYzfLYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        Li Yang <leoyang.lil@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/320] arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus
Date:   Mon, 24 Jan 2022 19:42:58 +0100
Message-Id: <20220124184000.244014223@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 078a5010228cd..0b3a93c4155d2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -161,11 +161,6 @@
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
@@ -209,6 +204,15 @@
 
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



