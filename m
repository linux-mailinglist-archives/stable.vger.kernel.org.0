Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3268C541580
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376504AbiFGUgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377964AbiFGUem (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BF41E7BEC;
        Tue,  7 Jun 2022 11:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20DC96156D;
        Tue,  7 Jun 2022 18:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F92FC385A5;
        Tue,  7 Jun 2022 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627016;
        bh=Ok82NdQlu5FkySxI5+3ZGfOpXbcVehWXEJPOChoCMOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NjxCZRds+jo03YNixxLNiGLO5LQR2WJmqEOHHZTBP+wUA5Q1JGgDxj/cIuVzDs4n
         t3FchtEu9tOK2twZ8soa+oBw2GjuLw/msdWLhpxmBPLIBBl58TTNGrWl4ZaXZSNPXn
         lYPEqydVipa3qSLjhtiIIq6KRckEbFN2aL44zY24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 560/772] pinctrl: apple: Use a raw spinlock for the regmap
Date:   Tue,  7 Jun 2022 19:02:32 +0200
Message-Id: <20220607165005.460613670@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 83969805cc716a7dc6b296c3fb1bc7e5cd7ca321 ]

The irqchip ops are called with a raw spinlock held, so the subsequent
regmap usage cannot use a plain spinlock.

spi-hid-apple-of spi0.0: spihid_apple_of_probe:74

=============================
[ BUG: Invalid wait context ]
5.18.0-asahi-00176-g0fa3ab03bdea #1337 Not tainted
-----------------------------
kworker/u20:3/86 is trying to lock:
ffff8000166b5018 (pinctrl_apple_gpio:462:(&regmap_config)->lock){....}-{3:3}, at: regmap_lock_spinlock+0x18/0x30
other info that might help us debug this:
context-{5:5}
7 locks held by kworker/u20:3/86:
 #0: ffff800017725d48 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c8/0x670
 #1: ffff80001e33bdd0 (deferred_probe_work){+.+.}-{0:0}, at: process_one_work+0x1c8/0x670
 #2: ffff800017d629a0 (&dev->mutex){....}-{4:4}, at: __device_attach+0x30/0x17c
 #3: ffff80002414e618 (&ctlr->add_lock){+.+.}-{4:4}, at: spi_add_device+0x40/0x80
 #4: ffff800024116990 (&dev->mutex){....}-{4:4}, at: __device_attach+0x30/0x17c
 #5: ffff800022d4be58 (request_class){+.+.}-{4:4}, at: __setup_irq+0xa8/0x720
 #6: ffff800022d4bcc8 (lock_class){....}-{2:2}, at: __setup_irq+0xcc/0x720

Fixes: a0f160ffcb83 ("pinctrl: add pinctrl/GPIO driver for Apple SoCs")
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20220524142206.18833-1-marcan@marcan.st
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-apple-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-apple-gpio.c b/drivers/pinctrl/pinctrl-apple-gpio.c
index 72f4dd2466e1..6d1bff9588d9 100644
--- a/drivers/pinctrl/pinctrl-apple-gpio.c
+++ b/drivers/pinctrl/pinctrl-apple-gpio.c
@@ -72,6 +72,7 @@ struct regmap_config regmap_config = {
 	.max_register = 512 * sizeof(u32),
 	.num_reg_defaults_raw = 512,
 	.use_relaxed_mmio = true,
+	.use_raw_spinlock = true,
 };
 
 /* No locking needed to mask/unmask IRQs as the interrupt mode is per pin-register. */
-- 
2.35.1



