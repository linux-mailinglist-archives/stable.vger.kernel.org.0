Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C6B561D65
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiF3OEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiF3ODC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:03:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEDE65D5C;
        Thu, 30 Jun 2022 06:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 188F7620E4;
        Thu, 30 Jun 2022 13:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2503AC34115;
        Thu, 30 Jun 2022 13:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597188;
        bh=tUbC9P3+yubDDefe29H5IMHi8x/o38Uf9ZD+Vi3xwK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4kSRKftcA3DvsUAqJjhoA+u9DP3C4e31sfevO67+d/HX7fUm2W1M90S9mIDjpsqJ
         MsA4hWGh/NreHZ8mB8M6dew7LY6qh2MgE04PL1jxSPMhX+q+YDbf/JppW6eP28L3Uj
         E7M3XTgR0+3do2Ed4qY5B25o1wM0R7tpZU5sd60I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 02/16] clocksource/drivers/ixp4xx: remove __init from ixp4xx_timer_setup()
Date:   Thu, 30 Jun 2022 15:46:56 +0200
Message-Id: <20220630133231.009464890@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
References: <20220630133230.936488203@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

ixp4xx_timer_setup is exported, and so can not be an __init function.
Remove the __init marking as the build system is rightfully claiming
this is an error in older kernels.

This is fixed "properly" in commit 41929c9f628b
("clocksource/drivers/ixp4xx: Drop boardfile probe path") but that can
not be backported to older kernels as the reworking of the IXP4xx
codebase is not suitable for stable releases.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/mmio.c                 |    2 +-
 drivers/clocksource/timer-ixp4xx.c         |   10 ++++------
 include/linux/platform_data/timer-ixp4xx.h |    5 ++---
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -46,7 +46,7 @@ u64 clocksource_mmio_readw_down(struct c
  * @bits:	Number of valid bits
  * @read:	One of clocksource_mmio_read*() above
  */
-int __init clocksource_mmio_init(void __iomem *base, const char *name,
+int clocksource_mmio_init(void __iomem *base, const char *name,
 	unsigned long hz, int rating, unsigned bits,
 	u64 (*read)(struct clocksource *))
 {
--- a/drivers/clocksource/timer-ixp4xx.c
+++ b/drivers/clocksource/timer-ixp4xx.c
@@ -170,9 +170,8 @@ static int ixp4xx_resume(struct clock_ev
  * We use OS timer1 on the CPU for the timer tick and the timestamp
  * counter as a source of real clock ticks to account for missed jiffies.
  */
-static __init int ixp4xx_timer_register(void __iomem *base,
-					int timer_irq,
-					unsigned int timer_freq)
+static int ixp4xx_timer_register(void __iomem *base, int timer_irq,
+				 unsigned int timer_freq)
 {
 	struct ixp4xx_timer *tmr;
 	int ret;
@@ -245,9 +244,8 @@ static __init int ixp4xx_timer_register(
  * @timer_irq: Linux IRQ number for the timer
  * @timer_freq: Fixed frequency of the timer
  */
-void __init ixp4xx_timer_setup(resource_size_t timerbase,
-			       int timer_irq,
-			       unsigned int timer_freq)
+void ixp4xx_timer_setup(resource_size_t timerbase, int timer_irq,
+			unsigned int timer_freq)
 {
 	void __iomem *base;
 
--- a/include/linux/platform_data/timer-ixp4xx.h
+++ b/include/linux/platform_data/timer-ixp4xx.h
@@ -4,8 +4,7 @@
 
 #include <linux/ioport.h>
 
-void __init ixp4xx_timer_setup(resource_size_t timerbase,
-			       int timer_irq,
-			       unsigned int timer_freq);
+void ixp4xx_timer_setup(resource_size_t timerbase, int timer_irq,
+			unsigned int timer_freq);
 
 #endif


