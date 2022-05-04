Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686FE51A7DE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355346AbiEDRG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356062AbiEDREv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C8850076;
        Wed,  4 May 2022 09:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC63617D5;
        Wed,  4 May 2022 16:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870F7C385A5;
        Wed,  4 May 2022 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683222;
        bh=NMC99gcqDM2guG2tRry0M7OaVR82LfisPaysCzoEjCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdPszhLigUAqn5bxNmBkHpm1un0YNoLcyHfCqEHjYns/g8OYcd/FDZ2kjOHVPh9lB
         /YN2zvsofwhpyflVcrWUkyh7qoC4bCZxG3/KNIhV2tBGzqjZ69lKGtud0d1R3Ca71J
         pERnd6I9sElkmFxSJc52BRygNok2C5E0D054vb3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/177] pinctrl: mediatek: moore: Fix build error
Date:   Wed,  4 May 2022 18:44:28 +0200
Message-Id: <20220504153059.785244126@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 87950929e2ff2236207bdbe14bff8230558b541b ]

If EINT_MTK is m and PINCTRL_MTK_V2 is y, build fails:

drivers/pinctrl/mediatek/pinctrl-moore.o: In function `mtk_gpio_set_config':
pinctrl-moore.c:(.text+0xa6c): undefined reference to `mtk_eint_set_debounce'
drivers/pinctrl/mediatek/pinctrl-moore.o: In function `mtk_gpio_to_irq':
pinctrl-moore.c:(.text+0xacc): undefined reference to `mtk_eint_find_irq'

Select EINT_MTK for PINCTRL_MTK_V2 to fix this.

Fixes: 8174a8512e3e ("pinctrl: mediatek: make MediaTek pinctrl v2 driver ready for buidling loadable module")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20220409105958.37412-1-yuehaibing@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/mediatek/Kconfig b/drivers/pinctrl/mediatek/Kconfig
index 7040a7a7bd5d..246b0e951e1c 100644
--- a/drivers/pinctrl/mediatek/Kconfig
+++ b/drivers/pinctrl/mediatek/Kconfig
@@ -30,6 +30,7 @@ config PINCTRL_MTK_MOORE
 	select GENERIC_PINMUX_FUNCTIONS
 	select GPIOLIB
 	select OF_GPIO
+	select EINT_MTK
 	select PINCTRL_MTK_V2
 
 config PINCTRL_MTK_PARIS
-- 
2.35.1



