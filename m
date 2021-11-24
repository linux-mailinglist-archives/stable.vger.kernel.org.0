Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331DC45C218
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350326AbhKXNZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349433AbhKXNVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:21:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B52F961B1D;
        Wed, 24 Nov 2021 12:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758041;
        bh=OUiFxJpxj+/5MpLORH9DKyxWdGQ9Uj4/WrY6UX+GzxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdwZUY4BxvQ4CTuRG3dEAlptWQNxsCCQWTIo1paHet9PHInoZjfTmiv+To+HTKKnO
         i7OpFLTP9PL/SH4P9t7YJUsqu5xhi50v1hc8g9/FxSwCrWkJx1jY5t+sU7QOTjqvLP
         LjkNtdeXwWFF95eOin36I6bib+RDSTzDy9CZJt8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/100] arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency
Date:   Wed, 24 Nov 2021 12:57:25 +0100
Message-Id: <20211124115655.149758380@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 3f1dcaff642e75c1d2ad03f783fa8a3b1f56dd50 ]

The entry/exit latency and minimum residency in state for the idle
states of MSM8998 were ..bad: first of all, for all of them the
timings were written for CPU sleep but the min-residency-us param
was miscalculated (supposedly, while porting this from downstream);
Then, the power collapse states are setting PC on both the CPU
cluster *and* the L2 cache, which have different timings: in the
specific case of L2 the times are higher so these ones should be
taken into account instead of the CPU ones.

This parameter misconfiguration was not giving particular issues
because on MSM8998 there was no CPU scaling at all, so cluster/L2
power collapse was rarely (if ever) hit.
When CPU scaling is enabled, though, the wrong timings will produce
SoC unstability shown to the user as random, apparently error-less,
sudden reboots and/or lockups.

This set of parameters are stabilizing the SoC when CPU scaling is
ON and when power collapse is frequently hit.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210901183123.1087392-3-angelogioacchino.delregno@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index ccd535edbf4e1..dcb79003ca0e6 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -246,38 +246,42 @@
 			LITTLE_CPU_SLEEP_0: cpu-sleep-0-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "little-retention";
+				/* CPU Retention (C2D), L2 Active */
 				arm,psci-suspend-param = <0x00000002>;
 				entry-latency-us = <81>;
 				exit-latency-us = <86>;
-				min-residency-us = <200>;
+				min-residency-us = <504>;
 			};
 
 			LITTLE_CPU_SLEEP_1: cpu-sleep-0-1 {
 				compatible = "arm,idle-state";
 				idle-state-name = "little-power-collapse";
+				/* CPU + L2 Power Collapse (C3, D4) */
 				arm,psci-suspend-param = <0x40000003>;
-				entry-latency-us = <273>;
-				exit-latency-us = <612>;
-				min-residency-us = <1000>;
+				entry-latency-us = <814>;
+				exit-latency-us = <4562>;
+				min-residency-us = <9183>;
 				local-timer-stop;
 			};
 
 			BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "big-retention";
+				/* CPU Retention (C2D), L2 Active */
 				arm,psci-suspend-param = <0x00000002>;
 				entry-latency-us = <79>;
 				exit-latency-us = <82>;
-				min-residency-us = <200>;
+				min-residency-us = <1302>;
 			};
 
 			BIG_CPU_SLEEP_1: cpu-sleep-1-1 {
 				compatible = "arm,idle-state";
 				idle-state-name = "big-power-collapse";
+				/* CPU + L2 Power Collapse (C3, D4) */
 				arm,psci-suspend-param = <0x40000003>;
-				entry-latency-us = <336>;
-				exit-latency-us = <525>;
-				min-residency-us = <1000>;
+				entry-latency-us = <724>;
+				exit-latency-us = <2027>;
+				min-residency-us = <9419>;
 				local-timer-stop;
 			};
 		};
-- 
2.33.0



