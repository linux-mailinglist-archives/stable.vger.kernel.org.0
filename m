Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D684F2819
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiDEIKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiDEH6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACCB98F7B;
        Tue,  5 Apr 2022 00:52:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A7DB81B9C;
        Tue,  5 Apr 2022 07:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6885BC34111;
        Tue,  5 Apr 2022 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145121;
        bh=PJWGIhznlwDa6zonBzMyklkj0mkLnKHkQDd53wid34U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hh0Q+0gjXqHPvDH+NNdZrUvUpk5O5RM3IWk7TTYGgkyvH3PQnpRp8VWvvTOYKknlY
         j7ug96k8TbstnExRNX8v8jh8opSvX9KZ8gnE4nGPIoXoZYigsWXrH+PLpJ9eLBfpAB
         Or4bKvk65Elhee2ci+hWF6gzw/1qel4XfUecRa4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0291/1126] pinctrl: samsung: Remove EINT handler for Exynos850 ALIVE and CMGP gpios
Date:   Tue,  5 Apr 2022 09:17:18 +0200
Message-Id: <20220405070416.156152781@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Protsenko <semen.protsenko@linaro.org>

[ Upstream commit 96f79935015cf3d7ca6fabf63cd13b8af45a7713 ]

GPIO_ALIVE and GPIO_CMGP blocks in Exynos850 SoC don't have EINT
capabilities (like EINT_SVC register), and there are no corresponding
interrupts wired to GIC. Instead those blocks have wake-up interrupts
for each pin. The ".eint_gpio_init" callbacks were specified by mistake
for these blocks, when porting pinctrl code from downstream kernel. That
leads to error messages like this:

    samsung-pinctrl 11850000.pinctrl: irq number not available

Remove ".eint_gpio_init" for pinctrl_alive and pinctrl_gpmc to fix this
error. This change doesn't affect proper interrupt handling for related
pins, as all those pins are handled in ".eint_wkup_init".

Fixes: cdd3d945dcec ("pinctrl: samsung: Add Exynos850 SoC specific data")
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20220114203757.4860-1-semen.protsenko@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
index 2e490e7696f4..4102ce955bd7 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
@@ -585,13 +585,11 @@ static const struct samsung_pin_ctrl exynos850_pin_ctrl[] __initconst = {
 		/* pin-controller instance 0 ALIVE data */
 		.pin_banks	= exynos850_pin_banks0,
 		.nr_banks	= ARRAY_SIZE(exynos850_pin_banks0),
-		.eint_gpio_init = exynos_eint_gpio_init,
 		.eint_wkup_init = exynos_eint_wkup_init,
 	}, {
 		/* pin-controller instance 1 CMGP data */
 		.pin_banks	= exynos850_pin_banks1,
 		.nr_banks	= ARRAY_SIZE(exynos850_pin_banks1),
-		.eint_gpio_init = exynos_eint_gpio_init,
 		.eint_wkup_init = exynos_eint_wkup_init,
 	}, {
 		/* pin-controller instance 2 AUD data */
-- 
2.34.1



