Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA104CF84F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiCGJwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240622AbiCGJvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:51:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C901D6582B;
        Mon,  7 Mar 2022 01:44:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59469B810CF;
        Mon,  7 Mar 2022 09:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC459C340F6;
        Mon,  7 Mar 2022 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646296;
        bh=XNFfssC4dcywt09vS1FDrDsp4FKO7LtqQ6ia6lOx3UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efK96Z+xXbWq5juTOqlfP2+QztRpbmneHtmjQjDmlMp7kjiUPPvIgbmFSt+FlyuGA
         Arb9LnHEoTW8RB6SknZNJKs8XF77tVRg/NKRtC3G+HwVgq2GY5mTRpAfCqyuSuOrxB
         rAxNmCbaSIeSmGicUz1xO8+W3YhWdKoRDptMuMSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 197/262] pinctrl: sunxi: Use unique lockdep classes for IRQs
Date:   Mon,  7 Mar 2022 10:19:01 +0100
Message-Id: <20220307091708.187406745@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit bac129dbc6560dfeb634c03f0c08b78024e71915 upstream.

This driver, like several others, uses a chained IRQ for each GPIO bank,
and forwards .irq_set_wake to the GPIO bank's upstream IRQ. As a result,
a call to irq_set_irq_wake() needs to lock both the upstream and
downstream irq_desc's. Lockdep considers this to be a possible deadlock
when the irq_desc's share lockdep classes, which they do by default:

 ============================================
 WARNING: possible recursive locking detected
 5.17.0-rc3-00394-gc849047c2473 #1 Not tainted
 --------------------------------------------
 init/307 is trying to acquire lock:
 c2dfe27c (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0

 but task is already holding lock:
 c3c0ac7c (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&irq_desc_lock_class);
   lock(&irq_desc_lock_class);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 4 locks held by init/307:
  #0: c1f29f18 (system_transition_mutex){+.+.}-{3:3}, at: __do_sys_reboot+0x90/0x23c
  #1: c20f7760 (&dev->mutex){....}-{3:3}, at: device_shutdown+0xf4/0x224
  #2: c2e804d8 (&dev->mutex){....}-{3:3}, at: device_shutdown+0x104/0x224
  #3: c3c0ac7c (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0

 stack backtrace:
 CPU: 0 PID: 307 Comm: init Not tainted 5.17.0-rc3-00394-gc849047c2473 #1
 Hardware name: Allwinner sun8i Family
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __lock_acquire+0x1680/0x31a0
  __lock_acquire from lock_acquire+0x148/0x3dc
  lock_acquire from _raw_spin_lock_irqsave+0x50/0x6c
  _raw_spin_lock_irqsave from __irq_get_desc_lock+0x58/0xa0
  __irq_get_desc_lock from irq_set_irq_wake+0x2c/0x19c
  irq_set_irq_wake from irq_set_irq_wake+0x13c/0x19c
    [tail call from sunxi_pinctrl_irq_set_wake]
  irq_set_irq_wake from gpio_keys_suspend+0x80/0x1a4
  gpio_keys_suspend from gpio_keys_shutdown+0x10/0x2c
  gpio_keys_shutdown from device_shutdown+0x180/0x224
  device_shutdown from __do_sys_reboot+0x134/0x23c
  __do_sys_reboot from ret_fast_syscall+0x0/0x1c

However, this can never deadlock because the upstream and downstream
IRQs are never the same (nor do they even involve the same irqchip).

Silence this erroneous lockdep splat by applying what appears to be the
usual fix of moving the GPIO IRQs to separate lockdep classes.

Fixes: a59c99d9eaf9 ("pinctrl: sunxi: Forward calls to irq_set_irq_wake")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220216040037.22730-1-samuel@sholland.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -36,6 +36,13 @@
 #include "../core.h"
 #include "pinctrl-sunxi.h"
 
+/*
+ * These lock classes tell lockdep that GPIO IRQs are in a different
+ * category than their parents, so it won't report false recursion.
+ */
+static struct lock_class_key sunxi_pinctrl_irq_lock_class;
+static struct lock_class_key sunxi_pinctrl_irq_request_class;
+
 static struct irq_chip sunxi_pinctrl_edge_irq_chip;
 static struct irq_chip sunxi_pinctrl_level_irq_chip;
 
@@ -1551,6 +1558,8 @@ int sunxi_pinctrl_init_with_variant(stru
 	for (i = 0; i < (pctl->desc->irq_banks * IRQ_PER_BANK); i++) {
 		int irqno = irq_create_mapping(pctl->domain, i);
 
+		irq_set_lockdep_class(irqno, &sunxi_pinctrl_irq_lock_class,
+				      &sunxi_pinctrl_irq_request_class);
 		irq_set_chip_and_handler(irqno, &sunxi_pinctrl_edge_irq_chip,
 					 handle_edge_irq);
 		irq_set_chip_data(irqno, pctl);


