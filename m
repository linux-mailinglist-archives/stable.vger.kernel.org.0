Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5C4F4903
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391708AbfKHMAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390594AbfKHLnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689E1222CF;
        Fri,  8 Nov 2019 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213432;
        bh=wV0PEgMTP2ewp/zK9SfyPeKGCygghrXr9NicZlG2qNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLOCgoZpcd8gq26i5vkKo/clm9FVA6GSVCrszBdYOu2ZmcX7bFxyrDyMRWFaHfUcI
         fr80BOXmqww9eHagdNbnFiqWEnnDpb8UgNmORfE9oCeVhU5Oq4BZ2RJQ3A1TJi+oRA
         25c3P6ZXqF1bsOJDim0ZhInxE0/C1E7m9psAGlww=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 030/103] ARM: dts: pxa: fix the rtc controller
Date:   Fri,  8 Nov 2019 06:41:55 -0500
Message-Id: <20191108114310.14363-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

