Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958006B435C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbjCJON4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjCJONc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A89119959
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:12:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B2FC61947
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58222C433D2;
        Fri, 10 Mar 2023 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457514;
        bh=lLd3GwqCQN1Z4PObDc5PFC/zKDoOs6Z0NR9qkv+5Gv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw3Uo3YYHQoInPkp9e/AoE3XB3TXT1JY7rRCDAkFsBSrssAm2G+VCoL/UxEvCaQyb
         CQAHTJYM9okQykrHTnuvNXBD7IMEjekEfjiAKOrw/H0PQCpu1NlC012hKx3rsAVUGt
         nwIkMM1nggu+wZ9+5I8Rpedy+Hl/CtszbOlXwgtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        Isaac True <isaac.true@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/200] serial: sc16is7xx: setup GPIO controller later in probe
Date:   Fri, 10 Mar 2023 14:39:00 +0100
Message-Id: <20230310133721.212771170@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isaac True <isaac.true@canonical.com>

[ Upstream commit c8f71b49ee4d28930c4a6798d1969fa91dc4ef3e ]

The GPIO controller component of the sc16is7xx driver is setup too
early, which can result in a race condition where another device tries
to utilise the GPIO lines before the sc16is7xx device has finished
initialising.

This issue manifests itself as an Oops when the GPIO lines are configured:

    Unable to handle kernel read from unreadable memory at virtual address
    ...
    pc : sc16is7xx_gpio_direction_output+0x68/0x108 [sc16is7xx]
    lr : sc16is7xx_gpio_direction_output+0x4c/0x108 [sc16is7xx]
    ...
    Call trace:
    sc16is7xx_gpio_direction_output+0x68/0x108 [sc16is7xx]
    gpiod_direction_output_raw_commit+0x64/0x318
    gpiod_direction_output+0xb0/0x170
    create_gpio_led+0xec/0x198
    gpio_led_probe+0x16c/0x4f0
    platform_drv_probe+0x5c/0xb0
    really_probe+0xe8/0x448
    driver_probe_device+0xe8/0x138
    __device_attach_driver+0x94/0x118
    bus_for_each_drv+0x8c/0xe0
    __device_attach+0x100/0x1b8
    device_initial_probe+0x28/0x38
    bus_probe_device+0xa4/0xb0
    deferred_probe_work_func+0x90/0xe0
    process_one_work+0x1c4/0x480
    worker_thread+0x54/0x430
    kthread+0x138/0x150
    ret_from_fork+0x10/0x1c

This patch moves the setup of the GPIO controller functions to later in the
probe function, ensuring the sc16is7xx device has already finished
initialising by the time other devices try to make use of the GPIO lines.
The error handling has also been reordered to reflect the new
initialisation order.

Co-developed-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Signed-off-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Signed-off-by: Isaac True <isaac.true@canonical.com>
Link: https://lore.kernel.org/r/20221130105529.698385-1-isaac.true@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 51 +++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 524921360ca78..93cf5f7888172 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1426,25 +1426,6 @@ static int sc16is7xx_probe(struct device *dev,
 	}
 	sched_set_fifo(s->kworker_task);
 
-#ifdef CONFIG_GPIOLIB
-	if (devtype->nr_gpio) {
-		/* Setup GPIO cotroller */
-		s->gpio.owner		 = THIS_MODULE;
-		s->gpio.parent		 = dev;
-		s->gpio.label		 = dev_name(dev);
-		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
-		s->gpio.get		 = sc16is7xx_gpio_get;
-		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
-		s->gpio.set		 = sc16is7xx_gpio_set;
-		s->gpio.base		 = -1;
-		s->gpio.ngpio		 = devtype->nr_gpio;
-		s->gpio.can_sleep	 = 1;
-		ret = gpiochip_add_data(&s->gpio, s);
-		if (ret)
-			goto out_thread;
-	}
-#endif
-
 	/* reset device, purging any pending irq / data */
 	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG << SC16IS7XX_REG_SHIFT,
 			SC16IS7XX_IOCONTROL_SRESET_BIT);
@@ -1521,6 +1502,25 @@ static int sc16is7xx_probe(struct device *dev,
 				s->p[u].irda_mode = true;
 	}
 
+#ifdef CONFIG_GPIOLIB
+	if (devtype->nr_gpio) {
+		/* Setup GPIO cotroller */
+		s->gpio.owner		 = THIS_MODULE;
+		s->gpio.parent		 = dev;
+		s->gpio.label		 = dev_name(dev);
+		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
+		s->gpio.get		 = sc16is7xx_gpio_get;
+		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
+		s->gpio.set		 = sc16is7xx_gpio_set;
+		s->gpio.base		 = -1;
+		s->gpio.ngpio		 = devtype->nr_gpio;
+		s->gpio.can_sleep	 = 1;
+		ret = gpiochip_add_data(&s->gpio, s);
+		if (ret)
+			goto out_thread;
+	}
+#endif
+
 	/*
 	 * Setup interrupt. We first try to acquire the IRQ line as level IRQ.
 	 * If that succeeds, we can allow sharing the interrupt as well.
@@ -1540,18 +1540,19 @@ static int sc16is7xx_probe(struct device *dev,
 	if (!ret)
 		return 0;
 
-out_ports:
-	for (i--; i >= 0; i--) {
-		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
-	}
-
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
 		gpiochip_remove(&s->gpio);
 
 out_thread:
 #endif
+
+out_ports:
+	for (i--; i >= 0; i--) {
+		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
+		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
+	}
+
 	kthread_stop(s->kworker_task);
 
 out_clk:
-- 
2.39.2



