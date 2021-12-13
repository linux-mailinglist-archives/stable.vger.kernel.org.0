Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75B24729B5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242751AbhLMKYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245198AbhLMKU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:20:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBE6C09425B;
        Mon, 13 Dec 2021 01:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0B4AB80E0C;
        Mon, 13 Dec 2021 09:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2303C34602;
        Mon, 13 Dec 2021 09:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389514;
        bh=xXCZsi5uY3VQvLDvcPY/ENMVxiwY5nzWphBA4IRnG8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1V3BWxXuGdv5T9rzugd1el55cyQDZ+A7teLS6r7/J8s+z2saHlm41w9z8+HpLe8W
         Dh+RsElwqcq7sizTCpg7VuvyU4SnISb7SzgKtSS0XgW4v/9hP3WlnbDwYIHUyhGD7W
         BQ+yrcGKNUMeGBX7F6+YdbIw2uegrIvmTB6g435o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 117/171] clk: qcom: clk-alpha-pll: Dont reconfigure running Trion
Date:   Mon, 13 Dec 2021 10:30:32 +0100
Message-Id: <20211213092949.000570788@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit a1f0019c342bd83240b05be68c9888549dde7935 upstream.

In the event that the bootloader has configured the Trion PLL as source
for the display clocks, e.g. for the continuous splashscreen, then there
will also be RCGs that are clocked by this instance.

Reconfiguring, and in particular disabling the output of, the PLL will
cause issues for these downstream RCGs and has been shown to prevent
them from being re-parented.

Follow downstream and skip configuration if it's determined that the PLL
is already running.

Fixes: 59128c20a6a9 ("clk: qcom: clk-alpha-pll: Add support for controlling Lucid PLLs")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20211123162508.153711-1-bjorn.andersson@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1429,6 +1429,15 @@ EXPORT_SYMBOL_GPL(clk_alpha_pll_postdiv_
 void clk_trion_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
 			     const struct alpha_pll_config *config)
 {
+	/*
+	 * If the bootloader left the PLL enabled it's likely that there are
+	 * RCGs that will lock up if we disable the PLL below.
+	 */
+	if (trion_pll_is_enabled(pll, regmap)) {
+		pr_debug("Trion PLL is already enabled, skipping configuration\n");
+		return;
+	}
+
 	clk_alpha_pll_write_config(regmap, PLL_L_VAL(pll), config->l);
 	regmap_write(regmap, PLL_CAL_L_VAL(pll), TRION_PLL_CAL_VAL);
 	clk_alpha_pll_write_config(regmap, PLL_ALPHA_VAL(pll), config->alpha);


