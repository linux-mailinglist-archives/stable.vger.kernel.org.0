Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755C029B9B3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802736AbgJ0PvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802157AbgJ0Pps (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC03D2231B;
        Tue, 27 Oct 2020 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813547;
        bh=M+9KacV3iDbbRM/KL3prW74hLAsrm+ZAJh777mPn3cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RNPrEdCMDcH9Q3+eOt8LjVxYHMGtOEjCxo+7xeuhBLE6/dIOM7setDB1q6LsEQLN
         id4QsVzsCLfPpeRnp191pQYXJNqwC+koVLa0oHFREnqj3pSB42hT/ckbEde1v5DBcY
         PsMaeXIS9IBK3WM2GpVn+37fHyvCUfTNGIQDjd7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiang Yu <yuq825@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 589/757] arm64: dts: allwinner: h5: remove Mali GPU PMU module
Date:   Tue, 27 Oct 2020 14:53:59 +0100
Message-Id: <20201027135518.162938566@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 6735e316a39c3..6c6053a18413d 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -139,8 +139,7 @@ mali: gpu@1e80000 {
 				     <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "gp",
 					  "gpmmu",
 					  "pp",
@@ -151,8 +150,7 @@ mali: gpu@1e80000 {
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



