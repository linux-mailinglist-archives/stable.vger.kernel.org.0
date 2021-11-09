Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7BA44B7C5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbhKIWha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345135AbhKIWf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:35:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB11A60EE5;
        Tue,  9 Nov 2021 22:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496537;
        bh=B1qpdar5VTMlYhiCxSMJGmKt5EPBXuoOTwUQmWJgnNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB1SZJ4r9tL1NLLPNeVIz68kXHGfNiClcChwNOl0Ey3I0Sm5C5XWcve7fgM1hLImG
         g8QGpAm+UwqFK7p+CTznp5dg8D1IE12tIUsoF8sep/lNL19ZFwSGAM8BS0ZT39Y3us
         fhCeFX+gx/3mea5KoKjt5ugADGvsO8WpG2RkiVKCz6Z0eVCgigcvFc07M2pnd5ybwF
         Uv9QrP6tZGo6jvrFUEkoZ/mDIjFMUA4kZDMKXQsIkGik/6wHMEEsXcsbec92r9RENt
         aY1XyT2jR7lbVlF/PmTOu9UqwSbyWbNsaKUYcSponAqQ2aR+0aXGDKbdiPCllUsn8Q
         35mUk3iJEu55A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 46/50] arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM
Date:   Tue,  9 Nov 2021 17:20:59 -0500
Message-Id: <20211109222103.1234885-46-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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
index 277f9e8a281ad..da9b0abfd30f5 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -123,6 +123,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD0>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu0_acc>;
+			qcom,saw = <&cpu0_saw>;
 		};
 
 		CPU1: cpu@1 {
@@ -136,6 +138,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD1>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu1_acc>;
+			qcom,saw = <&cpu1_saw>;
 		};
 
 		CPU2: cpu@2 {
@@ -149,6 +153,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD2>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu2_acc>;
+			qcom,saw = <&cpu2_saw>;
 		};
 
 		CPU3: cpu@3 {
@@ -162,6 +168,8 @@
 			#cooling-cells = <2>;
 			power-domains = <&CPU_PD3>;
 			power-domain-names = "psci";
+			qcom,acc = <&cpu3_acc>;
+			qcom,saw = <&cpu3_saw>;
 		};
 
 		L2_0: l2-cache {
@@ -1788,6 +1796,54 @@
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

