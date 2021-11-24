Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7541945C5A1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350541AbhKXN7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348152AbhKXN45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EAB6337E;
        Wed, 24 Nov 2021 13:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759255;
        bh=vbk96TVPHrCBHHxaznKHIcVwSqrwfxRkZJU59UNVbSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Al3HwemqCJv3cSuG9jjrYMHT7IHbsjVuAoxJU3oEcT8W+sLMB6/Iwn0CyBdHaN1Dl
         hf96kYlLlHndCVaOGTL1bEiajJFGsgi90QrFmBunAK1zKeN7XM8TYQwrHawQrfTR6f
         XtRGE9zMA/qKnwxUKQ70tUZcNa4lWsvofPNWUrio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/279] pinctrl: qcom: sdm845: Enable dual edge errata
Date:   Wed, 24 Nov 2021 12:57:47 +0100
Message-Id: <20211124115724.963613197@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 3a3a100473d2f6ebf9bdfe6efedd7e18de724388 ]

It has been observed that dual edge triggered wakeirq GPIOs on SDM845
doesn't trigger interrupts on the falling edge.

Enabling wakeirq_dual_edge_errata for SDM845 indicates that the PDC in
SDM845 suffers from the same problem described, and worked around, by
Doug in 'c3c0c2e18d94 ("pinctrl: qcom: Handle broken/missing PDC dual
edge IRQs on sc7180")', so enable the workaround for SDM845 as well.

The specific problem seen without this is that gpio-keys does not detect
the falling edge of the LID gpio on the Lenovo Yoga C630 and as such
consistently reports the LID as closed.

Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-By: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20211102034115.1946036-1-bjorn.andersson@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sdm845.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-sdm845.c b/drivers/pinctrl/qcom/pinctrl-sdm845.c
index c51793f6546f1..fdfd7b8f3a76d 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm845.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm845.c
@@ -1310,6 +1310,7 @@ static const struct msm_pinctrl_soc_data sdm845_pinctrl = {
 	.ngpios = 151,
 	.wakeirq_map = sdm845_pdc_map,
 	.nwakeirq_map = ARRAY_SIZE(sdm845_pdc_map),
+	.wakeirq_dual_edge_errata = true,
 };
 
 static const struct msm_pinctrl_soc_data sdm845_acpi_pinctrl = {
-- 
2.33.0



