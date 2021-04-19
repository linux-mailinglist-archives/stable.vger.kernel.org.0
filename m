Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7BE3643A2
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbhDSNVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240810AbhDSNSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80A48613EC;
        Mon, 19 Apr 2021 13:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838091;
        bh=I8dRn/9AxOCx/sjYCzLNEaia4bgiL2+/oOCTYbJWbdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTtSlNzlms3st513jK2vEs1uaMRBHJg6aUntO70HKggduE7BJB0WFppuE8agYUkel
         ny8r93im4QTIa6z25O4stfx9E885p3IABEGoL/jsBQxI4Ivpgd7gH/xkiofaGIYNfA
         fAKnlYiO/mOopZYw0AbMPsMwKbxZA8ndNiCxbxao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/103] gpio: sysfs: Obey valid_mask
Date:   Mon, 19 Apr 2021 15:05:15 +0200
Message-Id: <20210419130527.933470612@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
index 728f6c687182..fa5d945b2f28 100644
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



