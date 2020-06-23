Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22598205D1D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388348AbgFWUJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388362AbgFWUJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B8BF2078A;
        Tue, 23 Jun 2020 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942950;
        bh=eDfL3JuLelj7xO3kbKYdLwY99ZR4LRlpajMsM2UADRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx+ED35TO79ADXGIPslij1Z6+DIqfGLaF6GQIHgdnw6feGhzUvmBDoLfBD/hAxjAY
         DK3UYdUkiHoeIm+ptbTeQTaLla6DsfmRMFU0fg1zmpbTEJvM3kNKfVD6z/KGNfZSsD
         qy4dBuWZ2cZiIUDaowhm2Y4Gl0uEbgUn2f85Zxnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 198/477] arm64: dts: qcom: db820c: Fix invalid pm8994 supplies
Date:   Tue, 23 Jun 2020 21:53:15 +0200
Message-Id: <20200623195416.945955649@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c4abbccf2bed0..eaa1eb70b4555 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
@@ -117,16 +117,6 @@
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
@@ -705,14 +695,14 @@
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



