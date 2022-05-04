Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D361251A94A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352205AbiEDRLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357203AbiEDRKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC32249693;
        Wed,  4 May 2022 09:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B171B827A3;
        Wed,  4 May 2022 16:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE30C385A4;
        Wed,  4 May 2022 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683427;
        bh=2R5kitwa1y1l5S4KPY9jcoJ/BPm7iTyVBAWu2sovui0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pfO8fNY7sUOimOUHZIvY3qPnWMdgCj40a7aGpyMGmPGBuSYUohS5e692gF3m+kBs
         cQA51qXV1hNGiuAHmdNbIZnvQel7vFZN7hjkyQHt/WlB2Gdf57MXXng0nxqPbHyjnz
         AECXJfwU+TrNh7aXh5nxpIfxupJ3zzkFZ0mhhA3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 093/225] pinctrl: qcom: sm6350: fix order of UFS & SDC pins
Date:   Wed,  4 May 2022 18:45:31 +0200
Message-Id: <20220504153119.135109608@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit ef0beba1a5fb0c693ddf7d31246bd96c925ffd00 ]

In other places the SDC and UFS pins have been swapped but this was
missed in the PINCTRL_PIN definitions. Fix that.

Fixes: 7d74b55afd27 ("pinctrl: qcom: Add SM6350 pinctrl driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20220318183004.858707-5-luca.weiss@fairphone.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm6350.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm6350.c b/drivers/pinctrl/qcom/pinctrl-sm6350.c
index 4d37b817b232..a91a86628f2f 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6350.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6350.c
@@ -264,14 +264,14 @@ static const struct pinctrl_pin_desc sm6350_pins[] = {
 	PINCTRL_PIN(153, "GPIO_153"),
 	PINCTRL_PIN(154, "GPIO_154"),
 	PINCTRL_PIN(155, "GPIO_155"),
-	PINCTRL_PIN(156, "SDC1_RCLK"),
-	PINCTRL_PIN(157, "SDC1_CLK"),
-	PINCTRL_PIN(158, "SDC1_CMD"),
-	PINCTRL_PIN(159, "SDC1_DATA"),
-	PINCTRL_PIN(160, "SDC2_CLK"),
-	PINCTRL_PIN(161, "SDC2_CMD"),
-	PINCTRL_PIN(162, "SDC2_DATA"),
-	PINCTRL_PIN(163, "UFS_RESET"),
+	PINCTRL_PIN(156, "UFS_RESET"),
+	PINCTRL_PIN(157, "SDC1_RCLK"),
+	PINCTRL_PIN(158, "SDC1_CLK"),
+	PINCTRL_PIN(159, "SDC1_CMD"),
+	PINCTRL_PIN(160, "SDC1_DATA"),
+	PINCTRL_PIN(161, "SDC2_CLK"),
+	PINCTRL_PIN(162, "SDC2_CMD"),
+	PINCTRL_PIN(163, "SDC2_DATA"),
 };
 
 #define DECLARE_MSM_GPIO_PINS(pin) \
-- 
2.35.1



