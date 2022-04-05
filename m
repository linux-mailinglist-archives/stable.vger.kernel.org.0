Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929884F2EB7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245674AbiDEJMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244765AbiDEIwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26F911C13;
        Tue,  5 Apr 2022 01:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BE560FFC;
        Tue,  5 Apr 2022 08:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9912FC385A0;
        Tue,  5 Apr 2022 08:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148216;
        bh=A2qwBWgC5bulOwxQ9UGNIGesob+YEhfQP+KL/rVuxJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWMZf42Efuw6b2dO5XSFX3qO/3Yo2v9+f7QPKU9ktVEzvAhgOCGuZevwJUB6/dIzW
         91SjF96qTasLutLfh8+3FsXoAzaW4mL1F93NRB38spAyHJx9Jog/TBzg+bSNiCGPuE
         JiSBOgouqptrNrWXQQxSHh1wiQy6Y/0imn7StzKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0277/1017] pinctrl: samsung: Remove EINT handler for Exynos850 ALIVE and CMGP gpios
Date:   Tue,  5 Apr 2022 09:19:50 +0200
Message-Id: <20220405070402.489440084@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 6b77fd24571e..5c00be179082 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
@@ -504,13 +504,11 @@ static const struct samsung_pin_ctrl exynos850_pin_ctrl[] __initconst = {
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



