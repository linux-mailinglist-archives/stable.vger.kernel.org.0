Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F8437C431
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhELP3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234021AbhELPV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88DDC61442;
        Wed, 12 May 2021 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832139;
        bh=owQbf+PSt5OKVn1E/PhdCSNZLKS5BbRIRVEbkVi3/SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PixLzBu6Q3eUSHMHxL+TnPwnK9P3r8GWkVPoSMmiLfxSTmTsw35dSQOXVEQBlnrGJ
         jOOvQ5f62WutFRTykpMA2bkYz6yiapypblvQu4LGhf6pjQKwy5R1LgYhTaMWFjcYM3
         xi25k0UTGJrX6VuduIZ8CL96rjm8NGlRFopUTI3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/530] arm64: dts: qcom: sm8150: fix number of pins in gpio-ranges
Date:   Wed, 12 May 2021 16:44:28 +0200
Message-Id: <20210512144825.037930240@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit de3abdf3d15c6e7f456e2de3f9da78f3a31414cc ]

The last cell of 'gpio-ranges' should be number of GPIO pins, and in
case of qcom platform it should match msm_pinctrl_soc_data.ngpio rather
than msm_pinctrl_soc_data.ngpio - 1.

This fixes the problem that when the last GPIO pin in the range is
configured with the following call sequence, it always fails with
-EPROBE_DEFER.

    pinctrl_gpio_set_config()
        pinctrl_get_device_gpio_range()
            pinctrl_match_gpio_range()

Fixes: e13c6d144fa0 ("arm64: dts: qcom: sm8150: Add base dts file")
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210303033106.549-3-shawn.guo@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index f0a872e02686..1aec54590a11 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -748,7 +748,7 @@
 			      <0x0 0x03D00000 0x0 0x300000>;
 			reg-names = "west", "east", "north", "south";
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
-			gpio-ranges = <&tlmm 0 0 175>;
+			gpio-ranges = <&tlmm 0 0 176>;
 			gpio-controller;
 			#gpio-cells = <2>;
 			interrupt-controller;
-- 
2.30.2



