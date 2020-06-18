Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277EB1FE778
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgFRClH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbgFRBM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D04E221EB;
        Thu, 18 Jun 2020 01:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442749;
        bh=akzNYp/BG7Kv+ev3sVP1mF5oUsQ0FXBpqIqVlnZYvl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdVUjYiV2nHkGkAypF31DIZ5AshUv3iAW3ShR/onMFiHIa0Fo/VDBWRHvGkgz3Xy5
         Xcpvnsm+RMcxGH97nqgMwfartPz4qblLYvujPXBbPw50DQUfRs69uomMxcBWrVofOt
         oOGhHJdIz9PlPyZ3STZsJ1KVgMooshem3casFpcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 201/388] arm64: dts: qcom: db820c: Fix invalid pm8994 supplies
Date:   Wed, 17 Jun 2020 21:04:58 -0400
Message-Id: <20200618010805.600873-201-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 1cacdf5d3bb9644ac7b9339c611ac5b9dd90d09d ]

It's uncertain where the "vreg_s8a_l3a_input" comes from, but the supply
for VDD_L3_L11 on PM8994 should be VREG_S3A_1P3, so correct this - and
drop the vreg_s8a_l3a_input.

Reviewed-by: Vinod Koul <vkoul@kernel.org>
Fixes: 83d9ed4342a3 ("arm64: dts: qcom: db820c: Use regulator names from schematics")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200417070712.1376355-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
index c4abbccf2bed..eaa1eb70b455 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
@@ -117,16 +117,6 @@ vph_pwr: vph-pwr-regulator {
 		regulator-max-microvolt = <3700000>;
 	};
 
-	vreg_s8a_l3a_input: vreg-s8a-l3a-input {
-		compatible = "regulator-fixed";
-		regulator-name = "vreg_s8a_l3a_input";
-		regulator-always-on;
-		regulator-boot-on;
-
-		regulator-min-microvolt = <0>;
-		regulator-max-microvolt = <0>;
-	};
-
 	wlan_en: wlan-en-1-8v {
 		pinctrl-names = "default";
 		pinctrl-0 = <&wlan_en_gpios>;
@@ -705,14 +695,14 @@ pm8994-regulators {
 		vdd_s11-supply = <&vph_pwr>;
 		vdd_s12-supply = <&vph_pwr>;
 		vdd_l2_l26_l28-supply = <&vreg_s3a_1p3>;
-		vdd_l3_l11-supply = <&vreg_s8a_l3a_input>;
+		vdd_l3_l11-supply = <&vreg_s3a_1p3>;
 		vdd_l4_l27_l31-supply = <&vreg_s3a_1p3>;
 		vdd_l5_l7-supply = <&vreg_s5a_2p15>;
 		vdd_l6_l12_l32-supply = <&vreg_s5a_2p15>;
 		vdd_l8_l16_l30-supply = <&vph_pwr>;
 		vdd_l14_l15-supply = <&vreg_s5a_2p15>;
 		vdd_l25-supply = <&vreg_s3a_1p3>;
-		vdd_lvs1_2-supply = <&vreg_s4a_1p8>;
+		vdd_lvs1_lvs2-supply = <&vreg_s4a_1p8>;
 
 		vreg_s3a_1p3: s3 {
 			regulator-name = "vreg_s3a_1p3";
-- 
2.25.1

