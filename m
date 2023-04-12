Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2C26DEF36
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjDLItI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjDLIs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AEE76B2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B02630A6
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFB9C433D2;
        Wed, 12 Apr 2023 08:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289279;
        bh=O64lCElcQJ0NlJ6c/MfLfDB06IvxX4u6IdtzLIoKKZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Maz+d0suvbcUJ8syDwglGfDIiY1ze07wBrcL+YAP9qdPklbHDShJluMPhZz/WK57f
         6enRmnrLcJTph0Dv7wTM94mu1r9/SwFE4lMoYEVhJ4K6D44cvv4qEsnBy4PKOZtE9s
         GUFV9h05CFVFeeT6FJAUGWmkRDiTQFNeIBTnyVOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Devarsh Thakkar <devarsht@ti.com>,
        Dhruva Gole <d-gole@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Keerthy <j-keerthy@ti.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 039/173] gpio: davinci: Do not clear the bank intr enable bit in save_context
Date:   Wed, 12 Apr 2023 10:32:45 +0200
Message-Id: <20230412082839.679490607@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
index fa51a91afa54f..39b00855499b2 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -642,9 +642,6 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
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



