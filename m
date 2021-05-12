Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D765437CBFB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbhELQjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241946AbhELQbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:31:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 443B661941;
        Wed, 12 May 2021 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835072;
        bh=zxib7Z5MD4Y2dw3vCKUR5dCQZ36ww3M2Hj+DWT0jGY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcYmi1Xs+ixC0w72SXk/hycLJUDy/tY8p2hb8wNejGRyiBeSlcaIk1AQhfCHWVemy
         CrsUKQObrdiLz6komWU4jQW+ImMhKMycWuyw5P4G1YG7QDwMML+Ax49u6ITl/9srdk
         ARJM7jkXAkONdAbuTKMecrv7Xm1cPnT/twoAzfLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 198/677] arm64: dts: qcom: sm8250: fix number of pins in gpio-ranges
Date:   Wed, 12 May 2021 16:44:04 +0200
Message-Id: <20210512144843.834752614@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 3232ac6253bb..c30872c94686 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2689,7 +2689,7 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			gpio-ranges = <&tlmm 0 0 180>;
+			gpio-ranges = <&tlmm 0 0 181>;
 			wakeup-parent = <&pdc>;
 
 			pri_mi2s_active: pri-mi2s-active {
-- 
2.30.2



