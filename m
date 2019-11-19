Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0836210135B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfKSFYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbfKSFYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:24:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1254821783;
        Tue, 19 Nov 2019 05:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141092;
        bh=c/ibTNbMklbkWTbukVx7j2j/iB5SSjr6ytTVhUTXei8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU3CQflYIo9FCyINKOGWkZ3K8qHxjC5EYbQMhLU9g5VPH5QOPyC7WJb+Kk7iGduen
         qkL1FVIlq+glN1ppQC4TVzUkjM4X+PzYSUjqL8DwDraDueeAMrz0m90mVoZ3R6/vob
         P1KFwzzk+A4yAhKHoc+4U1u5i1CYNbris0+Py3Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Martin Lucina <martin@lucina.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/422] arm64: dts: allwinner: a64: Olinuxino: fix DRAM voltage
Date:   Tue, 19 Nov 2019 06:13:58 +0100
Message-Id: <20191119051402.602701766@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 93366b49a35f3a190052734b3f32c8fe2535b53f ]

The Olinuxino board uses DDR3L chips which are supposed to be driven
with 1.35V. The reset default of the AXP is properly set to 1.36V.

While technically the chips can also run at 1.5 volts, changing the
voltage on the fly while booting Linux is asking for trouble. Also
running at a lower voltage saves power.

So fix the DCDC5 value to match the actual board design.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Martin Lucina <martin@lucina.net>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
index 3f531393eaee9..b3f186434f363 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
@@ -142,10 +142,14 @@
 
 /* DCDC3 is polyphased with DCDC2 */
 
+/*
+ * The board uses DDR3L DRAM chips. 1.36V is the closest to the nominal
+ * 1.35V that the PMIC can drive.
+ */
 &reg_dcdc5 {
 	regulator-always-on;
-	regulator-min-microvolt = <1500000>;
-	regulator-max-microvolt = <1500000>;
+	regulator-min-microvolt = <1360000>;
+	regulator-max-microvolt = <1360000>;
 	regulator-name = "vcc-ddr3";
 };
 
-- 
2.20.1



