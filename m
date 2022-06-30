Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADA561D7B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiF3OG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiF3OGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0B86EEA9;
        Thu, 30 Jun 2022 06:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA176211C;
        Thu, 30 Jun 2022 13:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48116C34115;
        Thu, 30 Jun 2022 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597248;
        bh=tUbC9P3+yubDDefe29H5IMHi8x/o38Uf9ZD+Vi3xwK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUE8/8qagHcuvBzXf6NoH0yN3Jj4ZAmCTCIckudkX2FSUGcJsrySNKnk93i21osaB
         wgRltucYMpbCATxhU+7SAUCLWs1HqhUERNukD0YpeJ4Rbi7mxBeOB5Ue0H9hqDzuwE
         ujelhR/6ChSvkP0O7j6cNhP6f+92teAJralnhojI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 04/12] clocksource/drivers/ixp4xx: remove __init from ixp4xx_timer_setup()
Date:   Thu, 30 Jun 2022 15:47:09 +0200
Message-Id: <20220630133230.813883677@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
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


