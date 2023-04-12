Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7249E6DEE71
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjDLImA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjDLIld (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D596A6D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE38062FE0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12211C433D2;
        Wed, 12 Apr 2023 08:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288849;
        bh=EdpYzf4bxsF/rjNqfm3GUhurqL+YcdYY7WV78Fjr9JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elWybx4UA5neyGiQAsJ8E58dVqTNHWBrdlDj+Oa+/4EQ4yvB/2PD9IRFOZC0No5fC
         pe4ZYLDWh8jA7G5ufhN9a14/BpqkV8vpriUO/p5AjffWFT+mrcjrjs/B25pPwfjPbS
         vGJyTrCjcDFIOhMSkd3Hmx7AnnHeGr30X85FC+KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Devarsh Thakkar <devarsht@ti.com>,
        Dhruva Gole <d-gole@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Keerthy <j-keerthy@ti.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/164] gpio: davinci: Do not clear the bank intr enable bit in save_context
Date:   Wed, 12 Apr 2023 10:32:42 +0200
Message-Id: <20230412082838.562885914@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit fe092498cb9638418c96675be320c74a16306b48 ]

The interrupt enable bits might be set if we want to use the GPIO as
wakeup source. Clearing this will mean disabling of interrupts in the GPIO
banks that we may want to wakeup from.
Thus remove the line that was clearing this bit from the driver's save
context function.

Cc: Devarsh Thakkar <devarsht@ti.com>
Fixes: 0651a730924b ("gpio: davinci: Add support for system suspend/resume PM")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 59c4c48d8296b..7aff8a65002c9 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -645,9 +645,6 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
 		context->set_falling = readl_relaxed(&g->set_falling);
 	}
 
-	/* Clear Bank interrupt enable bit */
-	writel_relaxed(0, base + BINTEN);
-
 	/* Clear all interrupt status registers */
 	writel_relaxed(GENMASK(31, 0), &g->intstat);
 }
-- 
2.39.2



