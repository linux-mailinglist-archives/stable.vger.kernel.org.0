Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC44A37C901
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhELQOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235891AbhELQBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04AA26194C;
        Wed, 12 May 2021 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833585;
        bh=daVrEhNWEutCWmgTYzFt/rnAns5RkELs5ZGZFby62Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4iHx7GW7Hnu1ST6N04E2ClrnqvtjuW4olv5cpPQFOXbOh/GX1/rb1b4uQ2fbNuN0
         BVSyq9stq6r0rNA0OY2imZ0ShW8movRX7sKQAdLejhPfPPS52kSKDsH+S581tWbPgw
         GsujS1gpQMXK8Uq4DRa9orx8oks1aYaXkOMuW/oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 181/601] arm64: dts: qcom: sm8250: fix number of pins in gpio-ranges
Date:   Wed, 12 May 2021 16:44:18 +0200
Message-Id: <20210512144833.797517589@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit e526cb03e2aed42866a0919485a3d8ac130972cf ]

The last cell of 'gpio-ranges' should be number of GPIO pins, and in
case of qcom platform it should match msm_pinctrl_soc_data.ngpio rather
than msm_pinctrl_soc_data.ngpio - 1.

This fixes the problem that when the last GPIO pin in the range is
configured with the following call sequence, it always fails with
-EPROBE_DEFER.

    pinctrl_gpio_set_config()
        pinctrl_get_device_gpio_range()
            pinctrl_match_gpio_range()

Fixes: 16951b490b20 ("arm64: dts: qcom: sm8250: Add TLMM pinctrl node")
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210303033106.549-4-shawn.guo@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 7d885d974ceb..415cf6eb5e36 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1877,7 +1877,7 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			gpio-ranges = <&tlmm 0 0 180>;
+			gpio-ranges = <&tlmm 0 0 181>;
 			wakeup-parent = <&pdc>;
 
 			qup_i2c0_default: qup-i2c0-default {
-- 
2.30.2



