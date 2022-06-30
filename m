Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA771561D6A
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiF3OMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbiF3OLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E90A58FE1;
        Thu, 30 Jun 2022 06:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D75D56211A;
        Thu, 30 Jun 2022 13:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60A3C3411E;
        Thu, 30 Jun 2022 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597350;
        bh=3wnhMYImqIC9HM39V22zzymJJlEVLwXPGIwl/VYjO54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBcHB7iVAnFTDzJGEIgjkzHKASqhZxGr3xxzI4UfFd6JD7BUkL5JaB0TD9amX43KB
         JXuTBzmWvNyUzXhw8RKrFP16MT5e9+5vv361pHSRS1RDUmaUqOOEO6d2/Qn4K1FNBd
         4NPTDO9Sd8XmwDWrwWNnJFrREN09PBH7fW9ISQBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.18 2/6] clocksource/drivers/ixp4xx: Drop boardfile probe path
Date:   Thu, 30 Jun 2022 15:47:28 +0200
Message-Id: <20220630133230.313912598@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
References: <20220630133230.239507521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 41929c9f628b9990d33a200c54bb0c919e089aa8 upstream.

The boardfiles for IXP4xx have been deleted. Delete all the
quirks and code dealing with that boot path and rely solely on
device tree boot.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220406205505.2332821-1-linus.walleij@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/Kconfig                |    2 +-
 drivers/clocksource/timer-ixp4xx.c         |   25 -------------------------
 include/linux/platform_data/timer-ixp4xx.h |   11 -----------
 3 files changed, 1 insertion(+), 37 deletions(-)
 delete mode 100644 include/linux/platform_data/timer-ixp4xx.h

--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -80,7 +80,7 @@ config IXP4XX_TIMER
 	bool "Intel XScale IXP4xx timer driver" if COMPILE_TEST
 	depends on HAS_IOMEM
 	select CLKSRC_MMIO
-	select TIMER_OF if OF
+	select TIMER_OF
 	help
 	  Enables support for the Intel XScale IXP4xx SoC timer.
 
--- a/drivers/clocksource/timer-ixp4xx.c
+++ b/drivers/clocksource/timer-ixp4xx.c
@@ -19,8 +19,6 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
-/* Goes away with OF conversion */
-#include <linux/platform_data/timer-ixp4xx.h>
 
 /*
  * Constants to make it easy to access Timer Control/Status registers
@@ -263,28 +261,6 @@ static struct platform_driver ixp4xx_tim
 };
 builtin_platform_driver(ixp4xx_timer_driver);
 
-/**
- * ixp4xx_timer_setup() - Timer setup function to be called from boardfiles
- * @timerbase: physical base of timer block
- * @timer_irq: Linux IRQ number for the timer
- * @timer_freq: Fixed frequency of the timer
- */
-void __init ixp4xx_timer_setup(resource_size_t timerbase,
-			       int timer_irq,
-			       unsigned int timer_freq)
-{
-	void __iomem *base;
-
-	base = ioremap(timerbase, 0x100);
-	if (!base) {
-		pr_crit("IXP4xx: can't remap timer\n");
-		return;
-	}
-	ixp4xx_timer_register(base, timer_irq, timer_freq);
-}
-EXPORT_SYMBOL_GPL(ixp4xx_timer_setup);
-
-#ifdef CONFIG_OF
 static __init int ixp4xx_of_timer_init(struct device_node *np)
 {
 	void __iomem *base;
@@ -315,4 +291,3 @@ out_unmap:
 	return ret;
 }
 TIMER_OF_DECLARE(ixp4xx, "intel,ixp4xx-timer", ixp4xx_of_timer_init);
-#endif
--- a/include/linux/platform_data/timer-ixp4xx.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __TIMER_IXP4XX_H
-#define __TIMER_IXP4XX_H
-
-#include <linux/ioport.h>
-
-void __init ixp4xx_timer_setup(resource_size_t timerbase,
-			       int timer_irq,
-			       unsigned int timer_freq);
-
-#endif


