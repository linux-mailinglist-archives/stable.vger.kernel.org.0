Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1501A37C418
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhELP2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233894AbhELPVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B1A961462;
        Wed, 12 May 2021 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832136;
        bh=zRPrOU9WSvHbwkuoPrVWOKzV9Ybny2HbBMfRJlkdlow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUkZPGe4cVLEUzLKsM7JDT+pfOMKSYcQN8W3PGrOMWAnOApIppmQRIi1GBRNRYuHv
         rHU6xHcnOvwdq5IlhwCCdxsvdvqvRajf62Hxhj3M/T5nvjj3GisEwbKZRvV1JeQ3im
         SUknr3IlVrAINy3pj08DWjbTXyyTMTeP3459SE+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/530] arm64: dts: qcom: sdm845: fix number of pins in gpio-ranges
Date:   Wed, 12 May 2021 16:44:27 +0200
Message-Id: <20210512144825.005356808@linuxfoundation.org>
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

[ Upstream commit 02058fc3839df65ff64de2a6b1c5de8c9fd705c1 ]

The last cell of 'gpio-ranges' should be number of GPIO pins, and in
case of qcom platform it should match msm_pinctrl_soc_data.ngpio rather
than msm_pinctrl_soc_data.ngpio - 1.

This fixes the problem that when the last GPIO pin in the range is
configured with the following call sequence, it always fails with
-EPROBE_DEFER.

    pinctrl_gpio_set_config()
        pinctrl_get_device_gpio_range()
            pinctrl_match_gpio_range()

Fixes: bc2c806293c6 ("arm64: dts: qcom: sdm845: Add gpio-ranges to TLMM node")
Cc: Evan Green <evgreen@chromium.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210303033106.549-2-shawn.guo@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index f97f354af86f..ea6e3a11e641 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2192,7 +2192,7 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			gpio-ranges = <&tlmm 0 0 150>;
+			gpio-ranges = <&tlmm 0 0 151>;
 			wakeup-parent = <&pdc_intc>;
 
 			cci0_default: cci0-default {
-- 
2.30.2



