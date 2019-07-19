Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B905F6DFB1
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfGSD7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbfGSD73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8E421873;
        Fri, 19 Jul 2019 03:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508768;
        bh=ZQ3WWzSDhz3Qb1WmYN7C9YZY6kD2OJayrXx0bEgbiUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfB1GatYlURKFt5r51m31XsyTry31v2XrT1qCC/h5Rxtp4ZYcWuZR70DDht2CU766
         LS9783YYRl9njmzaTqtShLqTL8xIj9e9c+0Uc1c+UkoLYp0lfve5t+GD6mFGI+Q6WG
         OesBbx+1ew8HeGfrdLqe3WV8IEBMjvt+0HqdpH64=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Roese <sr@denx.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 079/171] serial: mctrl_gpio: Check if GPIO property exisits before requesting it
Date:   Thu, 18 Jul 2019 23:55:10 -0400
Message-Id: <20190719035643.14300-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roese <sr@denx.de>

[ Upstream commit d99482673f950817b30caf3fcdfb31179b050ce1 ]

This patch adds a check for the GPIOs property existence, before the
GPIO is requested. This fixes an issue seen when the 8250 mctrl_gpio
support is added (2nd patch in this patch series) on x86 platforms using
ACPI.

Here Mika's comments from 2016-08-09:

"
I noticed that with v4.8-rc1 serial console of some of our Broxton
systems does not work properly anymore. I'm able to see output but input
does not work.

I bisected it down to commit 4ef03d328769eddbfeca1f1c958fdb181a69c341
("tty/serial/8250: use mctrl_gpio helpers").

The reason why it fails is that in ACPI we do not have names for GPIOs
(except when _DSD is used) so we use the "idx" to index into _CRS GPIO
resources. Now mctrl_gpio_init_noauto() goes through a list of GPIOs
calling devm_gpiod_get_index_optional() passing "idx" of 0 for each. The
UART device in Broxton has following (simplified) ACPI description:

    Device (URT4)
    {
        ...
        Name (_CRS, ResourceTemplate () {
            GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
                    "\\_SB.GPO0", 0x00, ResourceConsumer)
            {
                0x003A
            }
            GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
                    "\\_SB.GPO0", 0x00, ResourceConsumer)
            {
                0x003D
            }
        })

In this case it finds the first GPIO (0x003A which happens to be RX pin
for that UART), turns it into GPIO which then breaks input for the UART
device. This also breaks systems with bluetooth connected to UART (those
typically have some GPIOs in their _CRS).

Any ideas how to fix this?

We cannot just drop the _CRS index lookup fallback because that would
break many existing machines out there so maybe we can limit this to
only DT enabled machines. Or alternatively probe if the property first
exists before trying to acquire the GPIOs (using
device_property_present()).
"

This patch implements the fix suggested by Mika in his statement above.

Signed-off-by: Stefan Roese <sr@denx.de>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_mctrl_gpio.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/tty/serial/serial_mctrl_gpio.c b/drivers/tty/serial/serial_mctrl_gpio.c
index 39ed56214cd3..2b400189be91 100644
--- a/drivers/tty/serial/serial_mctrl_gpio.c
+++ b/drivers/tty/serial/serial_mctrl_gpio.c
@@ -12,6 +12,7 @@
 #include <linux/termios.h>
 #include <linux/serial_core.h>
 #include <linux/module.h>
+#include <linux/property.h>
 
 #include "serial_mctrl_gpio.h"
 
@@ -116,6 +117,19 @@ struct mctrl_gpios *mctrl_gpio_init_noauto(struct device *dev, unsigned int idx)
 
 	for (i = 0; i < UART_GPIO_MAX; i++) {
 		enum gpiod_flags flags;
+		char *gpio_str;
+		bool present;
+
+		/* Check if GPIO property exists and continue if not */
+		gpio_str = kasprintf(GFP_KERNEL, "%s-gpios",
+				     mctrl_gpios_desc[i].name);
+		if (!gpio_str)
+			continue;
+
+		present = device_property_present(dev, gpio_str);
+		kfree(gpio_str);
+		if (!present)
+			continue;
 
 		if (mctrl_gpios_desc[i].dir_out)
 			flags = GPIOD_OUT_LOW;
-- 
2.20.1

