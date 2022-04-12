Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD474FD51D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbiDLHpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353862AbiDLHZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6D2E09D;
        Tue, 12 Apr 2022 00:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369F260B65;
        Tue, 12 Apr 2022 07:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F800C385A6;
        Tue, 12 Apr 2022 07:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747100;
        bh=nixB3c9ysBwrhtGSDitgq3s8EgiWl03CMJTTQJF6RHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzTuy/a36OJjqBruwFtNHqNs9zfQF1y9T3aW04XE6G/UQMAYRmixDpzwnYV/Rn6dI
         ET3NmKr0BTY2oZanMYuGAlwxpdVw3RxMhGWfI0seaC7zay8z9loaKbwfzDi2JpZAZq
         /Bedhnpl816FDr0a9u1fd2mZZdkkx0wpV7iK0AJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.16 241/285] gpio: Restrict usage of GPIO chip irq members before initialization
Date:   Tue, 12 Apr 2022 08:31:38 +0200
Message-Id: <20220412062950.617893187@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Shreeya Patel <shreeya.patel@collabora.com>

commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320 upstream.

GPIO chip irq members are exposed before they could be completely
initialized and this leads to race conditions.

One such issue was observed for the gc->irq.domain variable which
was accessed through the I2C interface in gpiochip_to_irq() before
it could be initialized by gpiochip_add_irqchip(). This resulted in
Kernel NULL pointer dereference.

Following are the logs for reference :-

kernel: Call Trace:
kernel:  gpiod_to_irq+0x53/0x70
kernel:  acpi_dev_gpio_irq_get_by+0x113/0x1f0
kernel:  i2c_acpi_get_irq+0xc0/0xd0
kernel:  i2c_device_probe+0x28a/0x2a0
kernel:  really_probe+0xf2/0x460
kernel: RIP: 0010:gpiochip_to_irq+0x47/0xc0

To avoid such scenarios, restrict usage of GPIO chip irq members before
they are completely initialized.

Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c      |   19 +++++++++++++++++++
 include/linux/gpio/driver.h |    9 +++++++++
 2 files changed, 28 insertions(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1368,6 +1368,16 @@ static int gpiochip_to_irq(struct gpio_c
 {
 	struct irq_domain *domain = gc->irq.domain;
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+	/*
+	 * Avoid race condition with other code, which tries to lookup
+	 * an IRQ before the irqchip has been properly registered,
+	 * i.e. while gpiochip is still being brought up.
+	 */
+	if (!gc->irq.initialized)
+		return -EPROBE_DEFER;
+#endif
+
 	if (!gpiochip_irqchip_irq_valid(gc, offset))
 		return -ENXIO;
 
@@ -1557,6 +1567,15 @@ static int gpiochip_add_irqchip(struct g
 
 	acpi_gpiochip_request_interrupts(gc);
 
+	/*
+	 * Using barrier() here to prevent compiler from reordering
+	 * gc->irq.initialized before initialization of above
+	 * GPIO chip irq members.
+	 */
+	barrier();
+
+	gc->irq.initialized = true;
+
 	return 0;
 }
 
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -219,6 +219,15 @@ struct gpio_irq_chip {
 	bool per_parent_data;
 
 	/**
+	 * @initialized:
+	 *
+	 * Flag to track GPIO chip irq member's initialization.
+	 * This flag will make sure GPIO chip irq members are not used
+	 * before they are initialized.
+	 */
+	bool initialized;
+
+	/**
 	 * @init_hw: optional routine to initialize hardware before
 	 * an IRQ chip will be added. This is quite useful when
 	 * a particular driver wants to clear IRQ related registers


