Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44D2F5249
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 19:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbhAMSgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 13:36:06 -0500
Received: from mxwww.masterlogin.de ([95.129.51.170]:36312 "EHLO
        mxwww.masterlogin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbhAMSgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 13:36:05 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2021 13:36:04 EST
Received: from mxout1.routing.net (unknown [192.168.10.81])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id F1EFB2C42D;
        Wed, 13 Jan 2021 18:10:36 +0000 (UTC)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout1.routing.net (Postfix) with ESMTP id B79043FF07;
        Wed, 13 Jan 2021 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1610561380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=E2lk75BZSz27MihA13aYu0dHFwcD4S99yuODfKDmRY4=;
        b=p7KbIaT2J3AJYD/JahEVLjPrQ4jj7GjomcnVJ1/fcmhVkIq5wT9Poun1UJTkfxPJgCRs2E
        ZIwh4ylWARf/gJ8NRKEki06Nr2tg/vW8um66hjs/vhUbrUAh4m3HNYVjaLDlJI1z0NsXEj
        pMpCAGQ/8uCMPo41Ebg8aqi654rZ5k4=
Received: from localhost.localdomain (fttx-pool-185.75.74.15.bambit.de [185.75.74.15])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 884FD80AFA;
        Wed, 13 Jan 2021 18:09:39 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Jimin Wang <jimin.wang@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sin_wenjiehu <sin_wenjiehu@mediatek.com>,
        Wenbin.Mei@mediatek.com, skylake.huang@mediatek.com,
        stable@vger.kernel.org
Subject: [PATCH v2] dts64: mt7622: fix slow sd card access
Date:   Wed, 13 Jan 2021 19:09:19 +0100
Message-Id: <20210113180919.49523-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: a4fbb957-4fd1-4532-9841-53bdb81f3d8c
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Fix extreme slow speed (200MB takes ~20 min) on writing sdcard on
bananapi-r64 by adding reset-control for mmc1 like it's done for mmc0/emmc.

Cc: stable@vger.kernel.org
Fixes: 2c002a3049f7 ("arm64: dts: mt7622: add mmc related device nodes")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
changes since v1:
 - drop change to uhs-mode because mt7622 does not support it
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 5b9ec032ce8d..7c6d871538a6 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -698,6 +698,8 @@ mmc1: mmc@11240000 {
 		clocks = <&pericfg CLK_PERI_MSDC30_1_PD>,
 			 <&topckgen CLK_TOP_AXI_SEL>;
 		clock-names = "source", "hclk";
+		resets = <&pericfg MT7622_PERI_MSDC1_SW_RST>;
+		reset-names = "hrst";
 		status = "disabled";
 	};
 
-- 
2.25.1

