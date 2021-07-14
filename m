Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9615C3C8D1F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhGNTno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhGNTnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 903C8613D9;
        Wed, 14 Jul 2021 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291616;
        bh=Pxlnwv8napXDZoRmaRApqQlVCE6UzmhCC4cRf2paaBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYD+1lWRqtmpFu6qif73rE+NPm3vsj7GPs41yeQ1z6Q63F0ygVBbCP8YKRugCOh7F
         weuwHjKfd4/H5oQrV25IH5iwuH6kvBQMUBb8/bGAFvR9GUp8sreRgqwuovXw0Pouly
         x7sAflqLsaUtdN+UlkW3QoVY/vpY2bIUg416B0kDYG3pOmIuIwNQcPCDaYWRHzPlbP
         rRzx4bNmTxlLx99l/s4Ys0kUKjtJyB4HG1lgPtq7lrpM36uEve9ZvpWIB2/06ZgJfx
         WK6D52rdbOdZgaEwuWF9LTlbn0MiJWT0nUd5PY3S5lsKPFstRiul9i5Z3WkT87gkLm
         PD4QKKXD9freA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 094/108] arm64: dts: qcom: sm8150: Disable Adreno and modem by default
Date:   Wed, 14 Jul 2021 15:37:46 -0400
Message-Id: <20210714193800.52097-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -354,7 +354,11 @@ vreg_l6f_2p85: ldo6 {
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
 
@@ -372,6 +376,10 @@ resin {
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
@@ -349,7 +349,11 @@ vreg_l6f_2p85: ldo6 {
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
 
@@ -367,6 +371,10 @@ resin {
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
@@ -1082,6 +1082,8 @@ gpu: gpu@2c00000 {
 
 			qcom,gmu = <&gmu>;
 
+			status = "disabled";
+
 			zap-shader {
 				memory-region = <&gpu_mem>;
 			};
@@ -1149,6 +1151,8 @@ gmu: gmu@2c6a000 {
 
 			operating-points-v2 = <&gmu_opp_table>;
 
+			status = "disabled";
+
 			gmu_opp_table: opp-table {
 				compatible = "operating-points-v2";
 
@@ -1496,6 +1500,8 @@ remoteproc_mpss: remoteproc@4080000 {
 			qcom,smem-states = <&modem_smp2p_out 0>;
 			qcom,smem-state-names = "stop";
 
+			status = "disabled";
+
 			glink-edge {
 				interrupts = <GIC_SPI 449 IRQ_TYPE_EDGE_RISING>;
 				label = "modem";
-- 
2.30.2

