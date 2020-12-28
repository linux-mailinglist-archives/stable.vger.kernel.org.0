Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B492E3CFF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438876AbgL1OJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438871AbgL1OJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B51A20731;
        Mon, 28 Dec 2020 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164547;
        bh=N69y/d/H65ecCoLoSNVk6ywXFKlWycJhbkQtS2xRbI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOa9HQV8iwjqTwaQo2+xDY2GGrKz5LyOcRHCrTMDQzb6h4ZVRywErFKL3ur8W6nfI
         AB9RnXQEPZUxKBlvFGs6Px2JilYLfnl29je6ccJsABY5noZYGuvUPkIXYPY81I035q
         sx9KSNF9lpSaMzXF+bOYx7ulk3BoyCyv9IZRDQeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Nikita Travkin <nikitos.tr@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/717] arm64: dts: qcom: msm8916-samsung-a2015: Disable muic i2c pin bias
Date:   Mon, 28 Dec 2020 13:43:01 +0100
Message-Id: <20201228125029.735014381@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Travkin <nikitos.tr@gmail.com>

[ Upstream commit 4e8692c2ee3d4ac6b669f7e306364d77a574c810 ]

Some versions of the firmware leave i2c gpios in a wrong state.
Add pinctrl that disables pin bias since external pull-up resistors
are present.

Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Fixes: 1329c1ab0730 ("arm64: dts: qcom: Add device tree for Samsung Galaxy A3U/A5U")
Signed-off-by: Nikita Travkin <nikitos.tr@gmail.com>
Link: https://lore.kernel.org/r/20201113175917.189123-6-nikitos.tr@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/msm8916-samsung-a2015-common.dtsi   | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi b/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
index b18d21e42f596..f7ac4c4033db6 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
@@ -78,6 +78,9 @@
 		sda-gpios = <&msmgpio 105 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
 		scl-gpios = <&msmgpio 106 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&muic_i2c_default>;
+
 		#address-cells = <1>;
 		#size-cells = <0>;
 
@@ -314,6 +317,14 @@
 		};
 	};
 
+	muic_i2c_default: muic-i2c-default {
+		pins = "gpio105", "gpio106";
+		function = "gpio";
+
+		drive-strength = <2>;
+		bias-disable;
+	};
+
 	muic_int_default: muic-int-default {
 		pins = "gpio12";
 		function = "gpio";
-- 
2.27.0



