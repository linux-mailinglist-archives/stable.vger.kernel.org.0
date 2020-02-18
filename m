Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45F3163166
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBRUAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbgBRUAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2421B24673;
        Tue, 18 Feb 2020 20:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056004;
        bh=5Jf8cI4nOoxx6xZKEeoBi7W0xsvsAYOX+Lc69C/Hte8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+F57eAKINOvVqmdN2PQALTddwKwjDEfu+8T4pSOQ538uM97fSqjsUOSXVMuPyfPe
         p4uc7l9iY4P9huWwFsuJizrT97UbgwDQPq9x2zp7RquxIdCvEGOUKLAdDlUpT25jpQ
         TmwoyhtIepJGANrrC9LGg6VvL/Ln+z/58yKYlFSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 65/66] gpio: add gpiod_toggle_active_low()
Date:   Tue, 18 Feb 2020 20:55:32 +0100
Message-Id: <20200218190434.273604722@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit d3a5bcb4a17f1ad072484bb92c42519ff3aba6e1 ]

Add possibility to toggle active-low flag of a gpio descriptor. This is
useful for compatibility code, where defaults are inverted vs DT gpio
flags or the active-low flag is taken from elsewhere.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/7ce0338e01ad17fa5a227176813941b41a7c35c1.1576031637.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c        | 11 +++++++++++
 include/linux/gpio/consumer.h |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2476306e7030e..22506e4614b3f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3220,6 +3220,17 @@ int gpiod_is_active_low(const struct gpio_desc *desc)
 }
 EXPORT_SYMBOL_GPL(gpiod_is_active_low);
 
+/**
+ * gpiod_toggle_active_low - toggle whether a GPIO is active-low or not
+ * @desc: the gpio descriptor to change
+ */
+void gpiod_toggle_active_low(struct gpio_desc *desc)
+{
+	VALIDATE_DESC_VOID(desc);
+	change_bit(FLAG_ACTIVE_LOW, &desc->flags);
+}
+EXPORT_SYMBOL_GPL(gpiod_toggle_active_low);
+
 /* I/O calls are only valid after configuration completed; the relevant
  * "is this a valid GPIO" error checks should already have been done.
  *
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index b70af921c6145..803bb63dd5ffb 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -158,6 +158,7 @@ int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 
 int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
 int gpiod_set_transitory(struct gpio_desc *desc, bool transitory);
+void gpiod_toggle_active_low(struct gpio_desc *desc);
 
 int gpiod_is_active_low(const struct gpio_desc *desc);
 int gpiod_cansleep(const struct gpio_desc *desc);
@@ -479,6 +480,12 @@ static inline int gpiod_set_transitory(struct gpio_desc *desc, bool transitory)
 	return -ENOSYS;
 }
 
+static inline void gpiod_toggle_active_low(struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(desc);
+}
+
 static inline int gpiod_is_active_low(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-- 
2.20.1



