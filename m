Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3BD364276
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhDSNJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239505AbhDSNJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2960061245;
        Mon, 19 Apr 2021 13:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837712;
        bh=v1xujS+gVifQ1wSprDLfya+Wwsux/4TlJGPK3bCdcaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkPwTPAEEnr35XGy6TIJT64zAdH5ebVol7sbEW0Y6BgwqWisS2DH/oMGcB2YN4s7Y
         XP4SsOzdK92VUmFl0+iDhBTkSJJj9Dp1/W9bonRmCmEjLSDWufSa2Yr7gOh5E4QgOy
         x7rfMwLRib2766u+MS5/iKEM8PsI1fENBtNudCcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 006/122] gpio: sysfs: Obey valid_mask
Date:   Mon, 19 Apr 2021 15:04:46 +0200
Message-Id: <20210419130530.386763938@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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
index 26c5466b8179..ae49bb23c6ed 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -458,6 +458,8 @@ static ssize_t export_store(struct class *class,
 	long			gpio;
 	struct gpio_desc	*desc;
 	int			status;
+	struct gpio_chip	*gc;
+	int			offset;
 
 	status = kstrtol(buf, 0, &gpio);
 	if (status < 0)
@@ -469,6 +471,12 @@ static ssize_t export_store(struct class *class,
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



