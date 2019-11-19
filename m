Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1A1018C5
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfKSF3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbfKSF3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7F2B208C3;
        Tue, 19 Nov 2019 05:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141392;
        bh=wV0PEgMTP2ewp/zK9SfyPeKGCygghrXr9NicZlG2qNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d15IJHamlZujr0akS8RdAYNNUljM1Qnlwi7G2YxXkpgbcuN8UqshNF0iz+fVr5Zd8
         286jfHgVrUDpClz39YZSipD5CHDLE75doo9VDrG+3lyJB2Dha0DBBdL3MJrUBk11al
         AFNwMICS3zHZktxAk37qrM0NpSvp5hbtazVy9GJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/422] ARM: dts: pxa: fix the rtc controller
Date:   Tue, 19 Nov 2019 06:14:51 +0100
Message-Id: <20191119051405.420868711@linuxfoundation.org>
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

From: Robert Jarzmik <robert.jarzmik@free.fr>

[ Upstream commit 24a610eba32a80ed778ea79680b600c3fe73d7de ]

The RTC controller is fed by an external fixed 32kHz clock. Yet the
driver wants to acquire this clock, even though it doesn't make any use
of it, ie. doesn't get the rate to make calculation.

Therefore, use the exported 32.768kHz clock in the PXA clock tree to
make the driver happy and working.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/pxa25x.dtsi | 4 ++++
 arch/arm/boot/dts/pxa27x.dtsi | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/pxa25x.dtsi b/arch/arm/boot/dts/pxa25x.dtsi
index 95d59be97213e..8494b57871709 100644
--- a/arch/arm/boot/dts/pxa25x.dtsi
+++ b/arch/arm/boot/dts/pxa25x.dtsi
@@ -80,6 +80,10 @@
 			#pwm-cells = <1>;
 			clocks = <&clks CLK_PWM1>;
 		};
+
+		rtc@40900000 {
+			clocks = <&clks CLK_OSC32k768>;
+		};
 	};
 
 	timer@40a00000 {
diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index 747f750f675d9..2ab6986433c82 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -113,6 +113,10 @@
 
 			status = "disabled";
 		};
+
+		rtc@40900000 {
+			clocks = <&clks CLK_OSC32k768>;
+		};
 	};
 
 	clocks {
-- 
2.20.1



