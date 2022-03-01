Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4AB4C9615
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbiCAUSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238331AbiCAUSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:18:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E949D344FA;
        Tue,  1 Mar 2022 12:17:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43AEFCE1A6D;
        Tue,  1 Mar 2022 20:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C734BC340EE;
        Tue,  1 Mar 2022 20:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165864;
        bh=aJAR/+mBtgQgWJLbXKojdE/Icw0j1zI4ZLZ9dkmrKhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNFWhclsN2tQaLSrLcZoVJodhYbrTdkrYHXyhiFqHZ9pZH1CrA0U9VT/3/U0fWz8b
         Y6XTNLOFIlTeQBIk5f8SKmqA65xS4TCjuGuM5Ncmx6GAnWbvTrAD82dcnA0fIA8di7
         Hp3P64pJhazGvFFRT2GYUIs4rhvR7R5YAPzgcwtTrgEz8Xv/Q+2j2iyOHjVfG2eIRM
         qcS/+IY/fZ+N3LWpnAE3HhqjwY21N2O1PhSdy4M7Ir2DzZdWXLcaJ6foxYZzcEsgE6
         l2hk0CW7xFNNGX5D8+Q/D2CiJUp/lLFcmHy/OqYdVOVX4Mf4hkl0TeDNxLvW2RzxAk
         +hoXvwzxrPhjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shreeya Patel <shreeya.patel@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/23] gpio: Return EPROBE_DEFER if gc->to_irq is NULL
Date:   Tue,  1 Mar 2022 15:16:14 -0500
Message-Id: <20220301201629.18547-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Shreeya Patel <shreeya.patel@collabora.com>

[ Upstream commit ae42f9288846353982e2eab181fb41e7fd8bf60f ]

We are racing the registering of .to_irq when probing the
i2c driver. This results in random failure of touchscreen
devices.

Following explains the race condition better.

[gpio driver] gpio driver registers gpio chip
[gpio consumer] gpio is acquired
[gpio consumer] gpiod_to_irq() fails with -ENXIO
[gpio driver] gpio driver registers irqchip
gpiod_to_irq works at this point, but -ENXIO is fatal

We could see the following errors in dmesg logs when gc->to_irq is NULL

[2.101857] i2c_hid i2c-FTS3528:00: HID over i2c has not been provided an Int IRQ
[2.101953] i2c_hid: probe of i2c-FTS3528:00 failed with error -22

To avoid this situation, defer probing until to_irq is registered.
Returning -EPROBE_DEFER would be the first step towards avoiding
the failure of devices due to the race in registration of .to_irq.
Final solution to this issue would be to avoid using gc irq members
until they are fully initialized.

This issue has been reported many times in past and people have been
using workarounds like changing the pinctrl_amd to built-in instead
of loading it as a module or by adding a softdep for pinctrl_amd into
the config file.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209413
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d1b9b721218f2..08525988e64f2 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3106,6 +3106,16 @@ int gpiod_to_irq(const struct gpio_desc *desc)
 
 		return retirq;
 	}
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+	if (gc->irq.chip) {
+		/*
+		 * Avoid race condition with other code, which tries to lookup
+		 * an IRQ before the irqchip has been properly registered,
+		 * i.e. while gpiochip is still being brought up.
+		 */
+		return -EPROBE_DEFER;
+	}
+#endif
 	return -ENXIO;
 }
 EXPORT_SYMBOL_GPL(gpiod_to_irq);
-- 
2.34.1

