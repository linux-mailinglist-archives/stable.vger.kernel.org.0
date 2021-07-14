Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E683C8DB2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhGNTp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbhGNToy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C9F1613D2;
        Wed, 14 Jul 2021 19:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291688;
        bh=UsKyJiGxM5oZPFswj1xWUd9yE/lYzjzQ8OFYzK+hWQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwGn8sfHfO2+v2H9pOo1FUi/nlB0aX25wIlZVQ6rxR3w+ccv4Khq+bHx2glN78f12
         4QuQn5GMYkVwEPB3SzLVsemOGh1Wjt5m95WPlykin9eNRaoISRThmjZH4++1F6KaRd
         STCs9WqBApDw2xm6LPd0ZUqSPlEB1Ar8fSzhh5oDq652Blirg6wRCTL2xmlHAv3ByK
         oSDPBSFPLKtUi5IYvArvdep1OljgmmY2B55xfM5IZiG0Hh1nhN8pn7CJ1y8Tb/oz7x
         c5Ef5Jp+Mvj11y1WYM/OBtbK/Z39pJx6OfCe2FFB65d6dEAlpViRYq1/+9t4e50Zh8
         tGpKOx7KcaKBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 037/102] arm64: dts: renesas: beacon: Fix USB extal reference
Date:   Wed, 14 Jul 2021 15:39:30 -0400
Message-Id: <20210714194036.53141-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 56bc54496f5d6bc638127bfc9df3742cbf0039e7 ]

The USB extal clock reference isn't associated to a crystal, it's
associated to a programmable clock, so remove the extal reference,
add the usb2_clksel.  Since usb_extal is referenced by the versaclock,
reference it here so the usb2_clksel can get the proper clock speed
of 50MHz.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 8d3a4d6ee885..bd3d26b2a2bb 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -319,8 +319,10 @@ &sdhi3 {
 	status = "okay";
 };
 
-&usb_extal_clk {
-	clock-frequency = <50000000>;
+&usb2_clksel {
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+		  <&versaclock5 3>, <&usb3s0_clk>;
+	status = "okay";
 };
 
 &usb3s0_clk {
-- 
2.30.2

