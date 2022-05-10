Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E67521A44
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244382AbiEJNyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244286AbiEJNwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A246C0F4;
        Tue, 10 May 2022 06:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91098B81DB2;
        Tue, 10 May 2022 13:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1261C385C2;
        Tue, 10 May 2022 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189861;
        bh=jFjwf+37Eb9UmLxCksgbMDhGLmrjgVyM4X2iBi+3J54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hth/wUcKhjtpZu0NGSzFQkQOO0I3ca6nbpalDEMbHYXIA7ZDXLIg0t3QGEalsDC6w
         YuVo6h6tMP8pxdFD/Tq8jNfcC8vxqBgkiWbt4raPsVQAk0kJ4TxasE2AZAyqkpupA2
         fwc0dFBZSoMFJ+vck3WIOyLOsy2hl13Ki3l5C3k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.17 053/140] gpio: visconti: Fix fwnode of GPIO IRQ
Date:   Tue, 10 May 2022 15:07:23 +0200
Message-Id: <20220510130743.137492573@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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


