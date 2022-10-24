Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF01B60AAF5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbiJXNme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiJXNh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:37:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0735E557;
        Mon, 24 Oct 2022 05:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 851D961314;
        Mon, 24 Oct 2022 12:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD6FC433C1;
        Mon, 24 Oct 2022 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614971;
        bh=79jsZ0oBtI+M1CeCYbIheDgFxoRCzGWfB8gqRJchV44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9ALhwgJ0QSwzwm0Ujg1K4Qp1USVT+66DKxKMuJJZnHrOeP0FiEX4+HTudgdUcggq
         qaYLXnPwkmuv0iprtbK67co1p9sxaxl0Ar2SGdkY4ptOqR4WlGCLf48Z7BKzddEsdr
         Nqsxfb8hTHNPZxSLBZWUpDXeS+sfLFDmsnjYm/uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 073/530] pinctrl: rockchip: add pinmux_ops.gpio_set_direction callback
Date:   Mon, 24 Oct 2022 13:26:57 +0200
Message-Id: <20221024113048.326557989@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

commit 4635c0e2a7f7f3568cbfccae70121f9835efa62c upstream.

Before the split of gpio and pinctrl sections in their own driver,
rockchip_set_mux was called in pinmux_ops.gpio_set_direction for
configuring a pin in its GPIO function.

This is essential for cases where pinctrl is "bypassed" by gpio
consumers otherwise the GPIO function is not configured for the pin and
it does not work. Such was the case for the sysfs/libgpiod userspace
GPIO handling.

Let's re-implement the pinmux_ops.gpio_set_direction callback so that
the gpio subsystem can request from the pinctrl driver to put the pin in
its GPIO function.

Fixes: 9ce9a02039de ("pinctrl/rockchip: drop the gpio related codes")
Cc: stable@vger.kernel.org
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20220930132033.4003377-2-foss+kernel@0leil.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-rockchip.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2072,11 +2072,24 @@ static int rockchip_pmx_set(struct pinct
 	return 0;
 }
 
+static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+					   struct pinctrl_gpio_range *range,
+					   unsigned offset,
+					   bool input)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct rockchip_pin_bank *bank;
+
+	bank = pin_to_bank(info, offset);
+	return rockchip_set_mux(bank, offset - bank->pin_base, RK_FUNC_GPIO);
+}
+
 static const struct pinmux_ops rockchip_pmx_ops = {
 	.get_functions_count	= rockchip_pmx_get_funcs_count,
 	.get_function_name	= rockchip_pmx_get_func_name,
 	.get_function_groups	= rockchip_pmx_get_groups,
 	.set_mux		= rockchip_pmx_set,
+	.gpio_set_direction	= rockchip_pmx_gpio_set_direction,
 };
 
 /*


