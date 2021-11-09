Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3258C44B68F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhKIW2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344480AbhKIW0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F6061A0C;
        Tue,  9 Nov 2021 22:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496391;
        bh=d4/2VTAQlp3ClXfdV6FW3JvQk/PDhTVqifO6KA0gjkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hcx1E3znOHfcLm6hYFs5WWI/fzabOyOE2I0nT9AEAUXOF9GpmMowaFrOOhytx+xei
         Gfbv2+Vbex1cLlksSDAD7wxpR/9PMKaOe/2ERM7WdbGXWLuk1SBoQ6WQJdN7wN2IVL
         jttMDGMvlm65iVsK0ULKjbSmtTSFt0Wy23OJnlrtCHLCh6bpl29vX+KAN/2bMNgJdK
         gOnBcWS1qKZXaZ0XBTh6xfOfMG+Ng5AqSqEBDKjaPcWwiNBo1CcFK3JuETEArQj1j6
         tKEnhaJxSVwlPoL0fszqRvBOhrrrgjL/WMGN0F2jSa88wTEzbh4txvxw0Fx+4x5BNY
         F8mEubWh0BwDQ==
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
Subject: [PATCH AUTOSEL 5.14 26/75] arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency
Date:   Tue,  9 Nov 2021 17:18:16 -0500
Message-Id: <20211109221905.1234094-26-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index e9d3ce29937c4..b1cf28ddd5697 100644
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

