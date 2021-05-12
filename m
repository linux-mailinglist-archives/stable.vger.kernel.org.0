Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D3537CBFD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241003AbhELQj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241952AbhELQbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:31:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAEBB61945;
        Wed, 12 May 2021 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835075;
        bh=4Ws+Sp41Yeo9XOnxY8Ty3+cUxWw0z2dbbXHuRkpDOK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FB18lF5Rw/KRaGLJ4S7Z+qP/UEC6Ii18s8JxQeiCKOrrKk2Y82VaR3m0huzIy+Cb8
         eK5CWLwH4eUT1vV+C7/yk6UZsPcAXgX54b/N4/79EPX9gZJOIz1jo4HkoZL2fR/r6M
         ByatyeJcGbRyRE8Ibwb05xqS+44IF2eVB+wqjV18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 199/677] arm64: dts: qcom: sm8350: fix number of pins in gpio-ranges
Date:   Wed, 12 May 2021 16:44:05 +0200
Message-Id: <20210512144843.867229277@linuxfoundation.org>
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

[ Upstream commit 790158579c8e663081e7d708d57e8ac6d69dca4e ]

The last cell of 'gpio-ranges' should be number of GPIO pins, and in
case of qcom platform it should match msm_pinctrl_soc_data.ngpio rather
than msm_pinctrl_soc_data.ngpio - 1.

This fixes the problem that when the last GPIO pin in the range is
configured with the following call sequence, it always fails with
-EPROBE_DEFER.

    pinctrl_gpio_set_config()
        pinctrl_get_device_gpio_range()
            pinctrl_match_gpio_range()

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210303033106.549-5-shawn.guo@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index e8bf3f95c674..e2fca420e518 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -382,7 +382,7 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			gpio-ranges = <&tlmm 0 0 203>;
+			gpio-ranges = <&tlmm 0 0 204>;
 
 			qup_uart3_default_state: qup-uart3-default-state {
 				rx {
-- 
2.30.2



