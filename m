Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAC466761F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbjALO3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbjALO2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:28:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906D958820
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3BC60AB3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240E9C433EF;
        Thu, 12 Jan 2023 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533151;
        bh=KIH72uI4TLQYi5JpgYDvWMGpctY769nbI78JnbEJASg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVmy4Va3zZXGidlGosEUqO7pHMmXujuUFn5Cc1pCF7Ah2WZay7FuC1uqcKW5Qcm7F
         G4pAlD5qR+iLRwtwMQgZ2HZ7xrHk6fabpf2KyoEFP2PEYGuOO4l5bOd0lacT6d+kxt
         crtHNqZjJ3MAl+cyaWqLGIn1Qtb+FeL6byPMzMVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/783] gpiolib: cdev: fix NULL-pointer dereferences
Date:   Thu, 12 Jan 2023 14:51:43 +0100
Message-Id: <20230112135542.242498464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 533aae7c94dbc2b14301cfd68ae7e0e90f0c8438 ]

There are several places where we can crash the kernel by requesting
lines, unbinding the GPIO device, then calling any of the system calls
relevant to the GPIO character device's annonymous file descriptors:
ioctl(), read(), poll().

While I observed it with the GPIO simulator, it will also happen for any
of the GPIO devices that can be hot-unplugged - for instance any HID GPIO
expander (e.g. CP2112).

This affects both v1 and v2 uAPI.

This fixes it partially by checking if gdev->chip is not NULL but it
doesn't entirely remedy the situation as we still have a race condition
in which another thread can remove the device after the check.

Fixes: d7c51b47ac11 ("gpio: userspace ABI for reading/writing GPIO lines")
Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Fixes: aad955842d1c ("gpiolib: cdev: support GPIO_V2_GET_LINEINFO_IOCTL and GPIO_V2_GET_LINEINFO_WATCH_IOCTL")
Fixes: a54756cb24ea ("gpiolib: cdev: support GPIO_V2_LINE_SET_CONFIG_IOCTL")
Fixes: 7b8e00d98168 ("gpiolib: cdev: support GPIO_V2_LINE_SET_VALUES_IOCTL")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index b51b4d7a611e..40d0196d8bdc 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -200,6 +200,9 @@ static long linehandle_ioctl(struct file *file, unsigned int cmd,
 	unsigned int i;
 	int ret;
 
+	if (!lh->gdev->chip)
+		return -ENODEV;
+
 	switch (cmd) {
 	case GPIOHANDLE_GET_LINE_VALUES_IOCTL:
 		/* NOTE: It's okay to read values of output lines */
@@ -1165,6 +1168,9 @@ static long linereq_ioctl(struct file *file, unsigned int cmd,
 	struct linereq *lr = file->private_data;
 	void __user *ip = (void __user *)arg;
 
+	if (!lr->gdev->chip)
+		return -ENODEV;
+
 	switch (cmd) {
 	case GPIO_V2_LINE_GET_VALUES_IOCTL:
 		return linereq_get_values(lr, ip);
@@ -1191,6 +1197,9 @@ static __poll_t linereq_poll(struct file *file,
 	struct linereq *lr = file->private_data;
 	__poll_t events = 0;
 
+	if (!lr->gdev->chip)
+		return EPOLLHUP | EPOLLERR;
+
 	poll_wait(file, &lr->wait, wait);
 
 	if (!kfifo_is_empty_spinlocked_noirqsave(&lr->events,
@@ -1210,6 +1219,9 @@ static ssize_t linereq_read(struct file *file,
 	ssize_t bytes_read = 0;
 	int ret;
 
+	if (!lr->gdev->chip)
+		return -ENODEV;
+
 	if (count < sizeof(le))
 		return -EINVAL;
 
@@ -1475,6 +1487,9 @@ static __poll_t lineevent_poll(struct file *file,
 	struct lineevent_state *le = file->private_data;
 	__poll_t events = 0;
 
+	if (!le->gdev->chip)
+		return EPOLLHUP | EPOLLERR;
+
 	poll_wait(file, &le->wait, wait);
 
 	if (!kfifo_is_empty_spinlocked_noirqsave(&le->events, &le->wait.lock))
@@ -1510,6 +1525,9 @@ static ssize_t lineevent_read(struct file *file,
 	ssize_t ge_size;
 	int ret;
 
+	if (!le->gdev->chip)
+		return -ENODEV;
+
 	/*
 	 * When compatible system call is being used the struct gpioevent_data,
 	 * in case of at least ia32, has different size due to the alignment
@@ -1588,6 +1606,9 @@ static long lineevent_ioctl(struct file *file, unsigned int cmd,
 	void __user *ip = (void __user *)arg;
 	struct gpiohandle_data ghd;
 
+	if (!le->gdev->chip)
+		return -ENODEV;
+
 	/*
 	 * We can get the value for an event line but not set it,
 	 * because it is input by definition.
@@ -2168,6 +2189,9 @@ static __poll_t lineinfo_watch_poll(struct file *file,
 	struct gpio_chardev_data *cdev = file->private_data;
 	__poll_t events = 0;
 
+	if (!cdev->gdev->chip)
+		return EPOLLHUP | EPOLLERR;
+
 	poll_wait(file, &cdev->wait, pollt);
 
 	if (!kfifo_is_empty_spinlocked_noirqsave(&cdev->events,
@@ -2186,6 +2210,9 @@ static ssize_t lineinfo_watch_read(struct file *file, char __user *buf,
 	int ret;
 	size_t event_size;
 
+	if (!cdev->gdev->chip)
+		return -ENODEV;
+
 #ifndef CONFIG_GPIO_CDEV_V1
 	event_size = sizeof(struct gpio_v2_line_info_changed);
 	if (count < event_size)
-- 
2.35.1



