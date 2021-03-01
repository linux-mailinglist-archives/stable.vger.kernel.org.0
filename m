Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE375328A98
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbhCASTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239226AbhCASN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 691E160C3D;
        Mon,  1 Mar 2021 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618332;
        bh=FKH2nZ1x5mqa8jW5OOvEBx2ygv2sKNb29e4eN66/mMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9YXUKePJ7sJD51m0V6LTR6Wmvlyl9IfbAftmj7d1xLdPrRxOMfv/uX9p/x/e19nn
         q8w6MTdrlEfSIch5rM5suxtwWyYRoHMMAgbxpE6n7D1w2iV+2YVN2C+XaLM1ZPCCbA
         EhFZ/uS1TiJwbD+QKiO9mgP9HGVewN7qoYu8bYk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/663] arm64: dts: qcom: msm8916-samsung-a2015: Fix sensors
Date:   Mon,  1 Mar 2021 17:04:57 +0100
Message-Id: <20210301161144.197849779@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index f7ac4c4033db6..7bf2cb01513e3 100644
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



