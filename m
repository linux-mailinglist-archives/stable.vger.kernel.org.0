Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E9C521A41
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiEJNy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244461AbiEJNqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:46:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643E814AF49;
        Tue, 10 May 2022 06:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D8E061765;
        Tue, 10 May 2022 13:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49407C385A6;
        Tue, 10 May 2022 13:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189488;
        bh=jFjwf+37Eb9UmLxCksgbMDhGLmrjgVyM4X2iBi+3J54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psYfHZDDT/6etDtyOtayZdKZps4MqvJJ52H8K5Fb6yCk2WXEPyxhXjfJYAgC9pWMc
         KNi1l1j2xSAtCgEUXMLtVHQOJsAYzXxs6kYlY6mBMa9xMg1Dy0tKMQV1ObP2h1Baip
         NKQpsbwy6tCbT8Ur7KZJwwSxg91GRHvM7dqgqkuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 040/135] gpio: visconti: Fix fwnode of GPIO IRQ
Date:   Tue, 10 May 2022 15:07:02 +0200
Message-Id: <20220510130741.551259555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

commit 171865dab096da1ab980a32eeea5d1b88cd7bc50 upstream.

The fwnode of GPIO IRQ must be set to its own fwnode, not the fwnode of the
parent IRQ. Therefore, this sets own fwnode instead of the parent IRQ fwnode to
GPIO IRQ's.

Fixes: 2ad74f40dacc ("gpio: visconti: Add Toshiba Visconti GPIO support")
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-visconti.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpio-visconti.c
+++ b/drivers/gpio/gpio-visconti.c
@@ -130,7 +130,6 @@ static int visconti_gpio_probe(struct pl
 	struct gpio_irq_chip *girq;
 	struct irq_domain *parent;
 	struct device_node *irq_parent;
-	struct fwnode_handle *fwnode;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -150,14 +149,12 @@ static int visconti_gpio_probe(struct pl
 	}
 
 	parent = irq_find_host(irq_parent);
+	of_node_put(irq_parent);
 	if (!parent) {
 		dev_err(dev, "No IRQ parent domain\n");
 		return -ENODEV;
 	}
 
-	fwnode = of_node_to_fwnode(irq_parent);
-	of_node_put(irq_parent);
-
 	ret = bgpio_init(&priv->gpio_chip, dev, 4,
 			 priv->base + GPIO_IDATA,
 			 priv->base + GPIO_OSET,
@@ -180,7 +177,7 @@ static int visconti_gpio_probe(struct pl
 
 	girq = &priv->gpio_chip.irq;
 	girq->chip = irq_chip;
-	girq->fwnode = fwnode;
+	girq->fwnode = of_node_to_fwnode(dev->of_node);
 	girq->parent_domain = parent;
 	girq->child_to_parent_hwirq = visconti_gpio_child_to_parent_hwirq;
 	girq->populate_parent_alloc_arg = visconti_gpio_populate_parent_fwspec;


