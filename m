Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C126DEF37
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjDLItI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjDLIs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96059526C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 228AF6313F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3387CC433D2;
        Wed, 12 Apr 2023 08:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289282;
        bh=aKjCmRs05HOND5WsSbuIlNxEx3voo8h2GS+xIOds+KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJGnqlTIkDJp3yMs+YesWH6lePblsBvGltsWa/w2ziSHfoq86veFSijCx3xe3ZRrn
         1p7hr+vdulc1xt8IBxcdGLmKz1b/XNy1oOPrD/Cj07ztIYZwlcV1UDPMNeqaBf9SQv
         Bd5xmUIMZhgrQs/ZDjDLNYdYwl5jFwsJu8y7WRV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dhruva Gole <d-gole@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 040/173] gpio: davinci: Add irq chip flag to skip set wake
Date:   Wed, 12 Apr 2023 10:32:46 +0200
Message-Id: <20230412082839.715025168@linuxfoundation.org>
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

[ Upstream commit 7b75c4703609a3ebaf67271813521bc0281e1ec1 ]

Add the IRQCHIP_SKIP_SET_WAKE flag since there are no special IRQ Wake
bits that can be set to enable wakeup IRQ.

Fixes: 3d9edf09d452 ("[ARM] 4457/2: davinci: GPIO support")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 39b00855499b2..7a26919ff127b 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -325,7 +325,7 @@ static struct irq_chip gpio_irqchip = {
 	.irq_enable	= gpio_irq_enable,
 	.irq_disable	= gpio_irq_disable,
 	.irq_set_type	= gpio_irq_type,
-	.flags		= IRQCHIP_SET_TYPE_MASKED,
+	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };
 
 static void gpio_irq_handler(struct irq_desc *desc)
-- 
2.39.2



