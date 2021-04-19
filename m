Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A4C36440E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbhDSNZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233858AbhDSNW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA8B613AB;
        Mon, 19 Apr 2021 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838299;
        bh=xuEDcflAVxcg4Sc6BZIcLZsTGGyY1kEST9Rau7svftI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KnGANCaOTKI9w9UqxiVwnuc22u7jfXYID/aV1pzRKufUd8lekdoaolgyIkzIa8DD
         OaqYW6CNUlrVn4wX7B1fDlWY1Eb6+7a2UquFjhXfUOerE2//MWuvSFj0g3CMd7PQCH
         PL4G8wAozH4MnXDpN6/M3+XvRJy8H2OMgKETawh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/73] gpio: sysfs: Obey valid_mask
Date:   Mon, 19 Apr 2021 15:06:02 +0200
Message-Id: <20210419130524.184955487@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 23cf00ddd2e1aacf1873e43f5e0c519c120daf7a ]

Do not allow exporting GPIOs which are set invalid
by the driver's valid mask.

Fixes: 726cb3ba4969 ("gpiolib: Support 'gpio-reserved-ranges' property")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index fbf6b1a0a4fa..558cd900d399 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -457,6 +457,8 @@ static ssize_t export_store(struct class *class,
 	long			gpio;
 	struct gpio_desc	*desc;
 	int			status;
+	struct gpio_chip	*gc;
+	int			offset;
 
 	status = kstrtol(buf, 0, &gpio);
 	if (status < 0)
@@ -468,6 +470,12 @@ static ssize_t export_store(struct class *class,
 		pr_warn("%s: invalid GPIO %ld\n", __func__, gpio);
 		return -EINVAL;
 	}
+	gc = desc->gdev->chip;
+	offset = gpio_chip_hwgpio(desc);
+	if (!gpiochip_line_is_valid(gc, offset)) {
+		pr_warn("%s: GPIO %ld masked\n", __func__, gpio);
+		return -EINVAL;
+	}
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
-- 
2.30.2



