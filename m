Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DB13D29D2
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhGVQG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhGVQFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E85B661CA2;
        Thu, 22 Jul 2021 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972366;
        bh=0STKWQC+Vj49YIn5F31YrtfI6IIFJAqpXKpo2sOYDLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jZuxnVB7E1Msy3aFQzSgbyHuHbpisJe8Rv3+AkNAUvWeJcF2UQRDmviamUiwlarQ
         6XhqOENfCHGQarJbKeUlsg4/IyHsVyh2zzIS2dmcP2HKzmAXrboMKyVwjgaBBERXoI
         O/g+esaAb4YtfTpZxPd960Wnkwi1Yv+2Wmodnh8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 087/156] arm64: dts: qcom: sm8150: Disable Adreno and modem by default
Date:   Thu, 22 Jul 2021 18:31:02 +0200
Message-Id: <20210722155631.198942373@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit b1dc3c6b3dabbedaf896a3c1a998da191c311c70 ]

Components that rely on proprietary (not to mention signed!) firmware should
not be enabled by default, as lack of the aforementioned firmware could cause
various issues, from random errors to straight-up failing to boot.

Not enabling modem back on the HDK, as it uses a sa8150.

Also fixed a sorting mistake in both boards' dt while at it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210611203301.101067-1-konrad.dybcio@somainline.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150-hdk.dts | 10 +++++++++-
 arch/arm64/boot/dts/qcom/sm8150-mtp.dts | 10 +++++++++-
 arch/arm64/boot/dts/qcom/sm8150.dtsi    |  6 ++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
index fb2cf3d987a1..50ee3bb97325 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
@@ -354,7 +354,11 @@
 	};
 };
 
-&qupv3_id_1 {
+&gmu {
+	status = "okay";
+};
+
+&gpu {
 	status = "okay";
 };
 
@@ -372,6 +376,10 @@
 	};
 };
 
+&qupv3_id_1 {
+	status = "okay";
+};
+
 &remoteproc_adsp {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/qcom/sm8150-mtp.dts b/arch/arm64/boot/dts/qcom/sm8150-mtp.dts
index 3774f8e63416..7de54b2e497e 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-mtp.dts
@@ -349,7 +349,11 @@
 	};
 };
 
-&qupv3_id_1 {
+&gmu {
+	status = "okay";
+};
+
+&gpu {
 	status = "okay";
 };
 
@@ -367,6 +371,10 @@
 	};
 };
 
+&qupv3_id_1 {
+	status = "okay";
+};
+
 &remoteproc_adsp {
 	status = "okay";
 	firmware-name = "qcom/sm8150/adsp.mdt";
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 51235a9521c2..618a1e64f808 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1082,6 +1082,8 @@
 
 			qcom,gmu = <&gmu>;
 
+			status = "disabled";
+
 			zap-shader {
 				memory-region = <&gpu_mem>;
 			};
@@ -1149,6 +1151,8 @@
 
 			operating-points-v2 = <&gmu_opp_table>;
 
+			status = "disabled";
+
 			gmu_opp_table: opp-table {
 				compatible = "operating-points-v2";
 
@@ -1496,6 +1500,8 @@
 			qcom,smem-states = <&modem_smp2p_out 0>;
 			qcom,smem-state-names = "stop";
 
+			status = "disabled";
+
 			glink-edge {
 				interrupts = <GIC_SPI 449 IRQ_TYPE_EDGE_RISING>;
 				label = "modem";
-- 
2.30.2



