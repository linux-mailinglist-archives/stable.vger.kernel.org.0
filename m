Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D279D44B589
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343741AbhKIWV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245644AbhKIWUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E3161506;
        Tue,  9 Nov 2021 22:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496259;
        bh=NfPyr9IlCDfBsxnZ/l72Ps3Kcil/CP535+5XrY0/ZvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCo5iHbu/w6r4hHj75Q3hHxyrSyg5R0ZoXN+cMIwQ62gpoInHiP9u6/ZSiIGU0y8t
         cHnpLEbxJLJcJOY263du3P7IszqIdei5rSER/KZGZwNtTQtU185Y2+Eknsq6aeouhj
         uetL+AKMYAKjALdcg51NILQyoG2chqD1ykmUxw9lV7EQIFHPHP5zR8vKHtHyGhj3si
         ShzOLlXE/ury2+tQnYiJz9I13H12QsAoTXbUFgbO/wXtjwASJDCsmsK/CjBRO1TJkD
         8W0s4FS6u1yQEhzK0auqre78xZmagRY0jRxhMf3bfWSQL79LbdUjfE2iLd60e9d67p
         rRxF+yMwyb8rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 28/82] arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency
Date:   Tue,  9 Nov 2021 17:15:46 -0500
Message-Id: <20211109221641.1233217-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 34039b5c80175..5a221cfc41387 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -308,38 +308,42 @@
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

