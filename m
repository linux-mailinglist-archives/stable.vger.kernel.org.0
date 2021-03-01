Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0945328CB3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbhCAS52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240427AbhCASv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:51:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A90746526D;
        Mon,  1 Mar 2021 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620156;
        bh=v8VjSkLaixm7Aq5Ux+hM3FZ/TU2rWNJ+w952eaXCnJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPKO8TNsa0foPl03djxkJvNre2TWHP0wkSxSInFsQbd+yYE7MIjJ4Hj/PEmBrubML
         IZRvyYhHR8J8SFyxFX0+0j8gdc/4RMz2oMwpvxVFHgDSoRCdAPW/Wi+df0i001aGc0
         uIwcjXGvwfjM6HNYHX5e9A0ukAMSZf4jyrsfGf9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 051/775] arm64: dts: qcom: msm8916-samsung-a2015: Fix sensors
Date:   Mon,  1 Mar 2021 17:03:39 +0100
Message-Id: <20210301161204.242604854@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 3716a583fe0bbe3babf4ce260064a7fa13d6d989 ]

When the BMC150 accelerometer/magnetometer was added to the device tree,
the sensors were working without specifying any regulator supplies,
likely because the regulators were on by default and then never turned off.

For some reason, this is no longer the case for pm8916_l17, which prevents
the sensors from working in some cases.

Now that the bmc150_accel/bmc150_magn drivers can enable necessary
regulators, declare the necessary regulator supplies to make the sensors
work again.

Fixes: 079f81acf10f ("arm64: dts: qcom: msm8916-samsung-a2015: Add accelerometer/magnetometer")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210111175358.97171-1-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi b/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
index f91269492d729..f1af798abd749 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
@@ -106,6 +106,9 @@
 		interrupt-parent = <&msmgpio>;
 		interrupts = <115 IRQ_TYPE_EDGE_RISING>;
 
+		vdd-supply = <&pm8916_l17>;
+		vddio-supply = <&pm8916_l5>;
+
 		pinctrl-names = "default";
 		pinctrl-0 = <&accel_int_default>;
 	};
@@ -113,6 +116,9 @@
 	magnetometer@12 {
 		compatible = "bosch,bmc150_magn";
 		reg = <0x12>;
+
+		vdd-supply = <&pm8916_l17>;
+		vddio-supply = <&pm8916_l5>;
 	};
 };
 
-- 
2.27.0



