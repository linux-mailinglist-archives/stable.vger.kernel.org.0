Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B394359BBDE
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiHVImb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiHVImO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD5D2DA97
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9086104E
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D68C433D6;
        Mon, 22 Aug 2022 08:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661157731;
        bh=HunUAXJqZNFxCzNNLVK+QlF1SdghyAEy3kcGZRW1N90=;
        h=Subject:To:Cc:From:Date:From;
        b=wgpUbCUOghtzWh9vyQL3KZuicFYUdQVYeKQhGwPJExSlkkQzSsTCn755x40Zph9ZP
         C0qlODfjxdI89f3znAn8HzHFfe3RcbUIVUPhU/TUgj6xbULMqeaRlmMZwWrCAg+RsC
         1ihh/Q+6dzQ1bY7dNnGlhDiKoE3O/EZ+HT4ZRjC4=
Subject: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore interrupt status and wake" failed to apply to 5.10-stable tree
To:     Basavaraj.Natikar@amd.com, linus.walleij@linaro.org,
        mario.limonciello@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:42:08 +0200
Message-ID: <166115772810989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b8c824a869f220c6b46df724f85794349bafbf23 Mon Sep 17 00:00:00 2001
From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Date: Mon, 13 Jun 2022 12:11:26 +0530
Subject: [PATCH] pinctrl: amd: Don't save/restore interrupt status and wake
 status bits

Saving/restoring interrupt and wake status bits across suspend can
cause the suspend to fail if an IRQ is serviced across the
suspend cycle.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Fixes: 79d2c8bede2c ("pinctrl/amd: save pin registers over suspend/resume")
Link: https://lore.kernel.org/r/20220613064127.220416-3-Basavaraj.Natikar@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index e497df89a4a7..9ec97c6db5e9 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -918,6 +918,7 @@ static int amd_gpio_suspend(struct device *dev)
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -926,7 +927,9 @@ static int amd_gpio_suspend(struct device *dev)
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
@@ -936,6 +939,7 @@ static int amd_gpio_resume(struct device *dev)
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -944,7 +948,10 @@ static int amd_gpio_resume(struct device *dev)
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
+		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin * 4);
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;

