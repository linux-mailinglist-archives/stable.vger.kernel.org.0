Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A7E419C16
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhI0RZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhI0RWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48746135F;
        Mon, 27 Sep 2021 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762865;
        bh=kgD1e4RoCpFEZjZSZkXNK08KIkUZIuli5LgochcfZEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s12tMjP61SlER5qDVREA2Uv7C2MBEOHWx8kRuBT26repI2OmVPMZquUivddThJYBf
         s95xwZz9OGaReejMS//fn+chdWr9IMUCpm6dqjpHODmy8OgDP8AUqNO1HR6ETTeKZT
         rlZg2jensO3GYDWKwZTV//BM3OXgMQY4J1uNajTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 080/162] gpiolib: acpi: Make set-debounce-timeout failures non fatal
Date:   Mon, 27 Sep 2021 19:02:06 +0200
Message-Id: <20210927170236.222207460@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cef0d022f55364d69017daeb9443bd31510ad6a2 ]

Commit 8dcb7a15a585 ("gpiolib: acpi: Take into account debounce settings")
made the gpiolib-acpi code call gpio_set_debounce_timeout() when requesting
GPIOs.

This in itself is fine, but it also made gpio_set_debounce_timeout()
errors fatal, causing the requesting of the GPIO to fail. This is causing
regressions. E.g. on a HP ElitePad 1000 G2 various _AEI specified GPIO
ACPI event sources specify a debouncy timeout of 20 ms, but the
pinctrl-baytrail.c only supports certain fixed values, the closest
ones being 12 or 24 ms and pinctrl-baytrail.c responds with -EINVAL
when specified a value which is not one of the fixed values.

This is causing the acpi_request_own_gpiod() call to fail for 3
ACPI event sources on the HP ElitePad 1000 G2, which in turn is causing
e.g. the battery charging vs discharging status to never get updated,
even though a charger has been plugged-in or unplugged.

Make gpio_set_debounce_timeout() errors non fatal, warning about the
failure instead, to fix this regression.

Note we should probably also fix various pinctrl drivers to just
pick the first bigger discrete value rather then returning -EINVAL but
this will need to be done on a per driver basis, where as this fix
at least gets us back to where things were before and thus restores
functionality on devices where this was lost due to
gpio_set_debounce_timeout() errors.

Fixes: 8dcb7a15a585 ("gpiolib: acpi: Take into account debounce settings")
Depends-on: 2e2b496cebef ("gpiolib: acpi: Extract acpi_request_own_gpiod() helper")
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 411525ac4cc4..47712b6903b5 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -313,9 +313,11 @@ static struct gpio_desc *acpi_request_own_gpiod(struct gpio_chip *chip,
 
 	ret = gpio_set_debounce_timeout(desc, agpio->debounce_timeout);
 	if (ret)
-		gpiochip_free_own_desc(desc);
+		dev_warn(chip->parent,
+			 "Failed to set debounce-timeout for pin 0x%04X, err %d\n",
+			 pin, ret);
 
-	return ret ? ERR_PTR(ret) : desc;
+	return desc;
 }
 
 static bool acpi_gpio_in_ignore_list(const char *controller_in, int pin_in)
-- 
2.33.0



