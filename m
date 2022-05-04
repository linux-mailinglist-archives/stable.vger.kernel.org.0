Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637E451A90C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355351AbiEDRML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356991AbiEDRJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C594830C;
        Wed,  4 May 2022 09:56:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1394FB8278E;
        Wed,  4 May 2022 16:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CD6C385A4;
        Wed,  4 May 2022 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683411;
        bh=Nk0q8o4ePO6DGGemVBHiX7y2F5IJfBi+FRCmvQla5YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5+jirBitvBb2XypsZn10vpei8CzuLitYjMMGyd7EzcX1N8bae58Vt+KJiEkPX1J4
         jnktGGF5X5c8DGzRooajgZSW3UpQZnKWa7552xYW9diNwbCSwbNMouzIwPUbk8ByiW
         +igpDxwhT9lDwn7QZS5yy876Z066Ui8TSVisNQwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 096/225] pinctrl: mediatek: moore: Fix build error
Date:   Wed,  4 May 2022 18:45:34 +0200
Message-Id: <20220504153119.364330797@linuxfoundation.org>
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
index 66db4ac5d169..c7fa1525e42a 100644
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



