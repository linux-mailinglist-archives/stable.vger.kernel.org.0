Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78032328C9B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbhCASyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240720AbhCAStM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:49:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F8A64EA4;
        Mon,  1 Mar 2021 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620878;
        bh=WIYhkWcd25TAdtGLp0QqOBwbYMjtmQqQ6jfEtsH3dg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P16tWCaYBp+OxiI5r6p2tQ038E0GrXCLD4ZCEMI3BVJAFSBWhTaO52Ddr7YX1hZPy
         On8mFZJFvt/BgeW1D+8eZ3wl/9RjQvU9YkTrtf3VsJvJjtMSnu0g+CBTYmxGlUdd+i
         g/2ozSIaqqo/LcRTWASKsvJzEY3Afke5OrBj2+7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 313/775] arm64: dts: qcom: qrb5165-rb5: fix pm8009 regulators
Date:   Mon,  1 Mar 2021 17:08:01 +0100
Message-Id: <20210301161217.083903326@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c3da02421230639bf6ee5462b70b58f5b7f3b7c6 ]

Fix pm8009 compatibility string to reference pm8009 revision specific to
sm8250 platform. Also add S2 regulator to be used for qca639x.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: b1d2674e6121 ("arm64: dts: qcom: Add basic devicetree support for QRB5165 RB5")
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20201231122348.637917-5-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index f86cc5140d3b9..f13a63ca8efd6 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -122,7 +122,7 @@
 
 &apps_rsc {
 	pm8009-rpmh-regulators {
-		compatible = "qcom,pm8009-rpmh-regulators";
+		compatible = "qcom,pm8009-1-rpmh-regulators";
 		qcom,pmic-id = "f";
 
 		vdd-s1-supply = <&vph_pwr>;
@@ -131,6 +131,13 @@
 		vdd-l5-l6-supply = <&vreg_bob>;
 		vdd-l7-supply = <&vreg_s4a_1p8>;
 
+		vreg_s2f_0p95: smps2 {
+			regulator-name = "vreg_s2f_0p95";
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <952000>;
+			regulator-initial-mode = <RPMH_REGULATOR_MODE_AUTO>;
+		};
+
 		vreg_l1f_1p1: ldo1 {
 			regulator-name = "vreg_l1f_1p1";
 			regulator-min-microvolt = <1104000>;
-- 
2.27.0



