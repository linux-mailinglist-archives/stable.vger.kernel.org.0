Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA88B6B4575
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjCJOd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjCJOdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A622C168A2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D839A617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9BFC433D2;
        Fri, 10 Mar 2023 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458807;
        bh=KOXnq/ZGzYbXe5yukVoh4jIAH6bIVpYRK589NZtmF1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6nRYImK7bYfPeDC/p+J0zMEepvYtvZssGfGo3w8O76OhJGbxaE3CAm4y0Qe1Zc8z
         a2o2dZT0RAU8NO8UL/yAAs2gRGl4yLGTn3OwNT1sfmcI/bF73PjHMCRFHkAkpYy8WO
         jlWNP2dtteyD6ketPwB0o4ZAGxd4TttGLywnELMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Clark Wang <xiaoning.wang@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/357] gpio: vf610: connect GPIO label to dev name
Date:   Fri, 10 Mar 2023 14:36:50 +0100
Message-Id: <20230310133740.007405055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 6f8ecb7f85f441eb7d78ba2a4df45ee8a821934e ]

Current GPIO label is fixed, so can't distinguish different GPIO
controllers through labels. Use dev name instead.

Fixes: 7f2691a19627 ("gpio: vf610: add gpiolib/IRQ chip driver for Vybrid")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 1ae612c796eef..396a687e020f5 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -304,7 +304,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	gc = &port->gc;
 	gc->of_node = np;
 	gc->parent = dev;
-	gc->label = "vf610-gpio";
+	gc->label = dev_name(dev);
 	gc->ngpio = VF610_GPIO_PER_PORT;
 	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
 
-- 
2.39.2



