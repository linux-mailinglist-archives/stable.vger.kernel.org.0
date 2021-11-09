Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2D44B635
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344230AbhKIWZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344341AbhKIWXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55E3061502;
        Tue,  9 Nov 2021 22:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496328;
        bh=7+L2Q3rZF5o/Jx+qKBIIuGbMAyD1BUieROvuASX+0d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRky1tIFs3U7h5/hW56gl7h0JgQa7M6/rrLs0zCKCVVn/XvFtOmuNIr7gLEdikr21
         lgJ5r5Upa03R4dT3Q6DqFQbGzSFuaL+KjecTHEyR5oSn0hiz7/G9B/krZyOMUemUe2
         5YOLA+ELE662HbLnWS+NrHC7DyCz9rbyUAb9bww4IViyf9T2riC2zSXub70dgxJX2r
         BT+7rITPgkpBjPEZZVjQc4YEWzyDhAVMcAR97Mv/Q3S/5hTefM2iaQ1rK52DSz0gb/
         NdXujf4GgnUV1rG3CRhQwXDH/0yTUkcO7Yn8JCAsgiNmbEw/EmsSuO7kHmUd2NB9FN
         khkw38m9qbZ+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 73/82] arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM
Date:   Tue,  9 Nov 2021 17:16:31 -0500
Message-Id: <20211109221641.1233217-73-sashal@kernel.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit a22f9a766e1dc61f8f6ee2edfe83d4d23d78e059 ]

Add the device tree nodes necessary for SMP bring-up and cpuidle
without PSCI on ARM32. The hardware is typically controlled by the
PSCI implementation in the TrustZone firmware and is therefore marked
as status = "reserved" by default (from the device tree specification):

  "Indicates that the device is operational, but should not be used.
   Typically this is used for devices that are controlled by another
   software component, such as platform firmware."

Since this is part of the MSM8916 SoC it should be added to msm8916.dtsi
but in practice these nodes should only get enabled via an extra include
on ARM32.

This is necessary for some devices with signed firmware which is missing
both ARM64 and PSCI support and can therefore only boot ARM32 kernels.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211004204955.21077-13-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 56 +++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 7c656bde927f7..c9467665250e7 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -124,6 +124,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD0>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu0_acc>;
+			qcom,saw = <&cpu0_saw>;
 		};
 
 		CPU1: cpu@1 {
@@ -137,6 +139,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD1>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu1_acc>;
+			qcom,saw = <&cpu1_saw>;
 		};
 
 		CPU2: cpu@2 {
@@ -150,6 +154,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD2>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu2_acc>;
+			qcom,saw = <&cpu2_saw>;
 		};
 
 		CPU3: cpu@3 {
@@ -163,6 +169,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD3>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu3_acc>;
+			qcom,saw = <&cpu3_saw>;
 		};
 
 		L2_0: l2-cache {
@@ -1871,6 +1879,54 @@
 				status = "disabled";
 			};
 		};
+
+		cpu0_acc: power-manager@b088000 {
+			compatible = "qcom,msm8916-acc";
+			reg = <0x0b088000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu0_saw: power-manager@b089000 {
+			compatible = "qcom,msm8916-saw2-v3.0-cpu", "qcom,saw2";
+			reg = <0x0b089000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu1_acc: power-manager@b098000 {
+			compatible = "qcom,msm8916-acc";
+			reg = <0x0b098000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu1_saw: power-manager@b099000 {
+			compatible = "qcom,msm8916-saw2-v3.0-cpu", "qcom,saw2";
+			reg = <0x0b099000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu2_acc: power-manager@b0a8000 {
+			compatible = "qcom,msm8916-acc";
+			reg = <0x0b0a8000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu2_saw: power-manager@b0a9000 {
+			compatible = "qcom,msm8916-saw2-v3.0-cpu", "qcom,saw2";
+			reg = <0x0b0a9000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu3_acc: power-manager@b0b8000 {
+			compatible = "qcom,msm8916-acc";
+			reg = <0x0b0b8000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
+
+		cpu3_saw: power-manager@b0b9000 {
+			compatible = "qcom,msm8916-saw2-v3.0-cpu", "qcom,saw2";
+			reg = <0x0b0b9000 0x1000>;
+			status = "reserved"; /* Controlled by PSCI firmware */
+		};
 	};
 
 	thermal-zones {
-- 
2.33.0

