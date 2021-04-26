Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD46436AE92
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhDZHpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhDZHoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23DD8613D0;
        Mon, 26 Apr 2021 07:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422837;
        bh=ZSIV6EfmfdBbXH07lCCcvvGyqMlIcdnfqUW7qPzowoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hR+U8WsuVxQVZIYsspHoMv/NE9CVKQ5E4joGjH0xPltIportKxBfC96ZmX659aocg
         5yIAHlamRrigoWzQPJxHR0WPhstMyuhkJOG20P29xf9eAb/X+fBeuapHN4uYqqTdXB
         tqYWdXDwmzOnRYrpAe1IeoYYsPzN5HXSEIPQplS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Fustini <drew@beagleboard.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 12/41] pinctrl: core: Show pin numbers for the controllers with base = 0
Date:   Mon, 26 Apr 2021 09:29:59 +0200
Message-Id: <20210426072820.099698719@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 482715ff0601c836152b792f06c353464d826b9b ]

The commit f1b206cf7c57 ("pinctrl: core: print gpio in pins debugfs file")
enabled GPIO pin number and label in debugfs for pin controller. However,
it limited that feature to the chips where base is positive number. This,
in particular, excluded chips where base is 0 for the historical or backward
compatibility reasons. Refactor the code to include the latter as well.

Fixes: f1b206cf7c57 ("pinctrl: core: print gpio in pins debugfs file")
Cc: Drew Fustini <drew@beagleboard.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Drew Fustini <drew@beagleboard.org>
Reviewed-by: Drew Fustini <drew@beagleboard.org>
Link: https://lore.kernel.org/r/20210415130356.15885-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 9fc4433fece4..20b477cd5a30 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1604,8 +1604,8 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 	unsigned i, pin;
 #ifdef CONFIG_GPIOLIB
 	struct pinctrl_gpio_range *range;
-	unsigned int gpio_num;
 	struct gpio_chip *chip;
+	int gpio_num;
 #endif
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
@@ -1625,7 +1625,7 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 		seq_printf(s, "pin %d (%s) ", pin, desc->name);
 
 #ifdef CONFIG_GPIOLIB
-		gpio_num = 0;
+		gpio_num = -1;
 		list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 			if ((pin >= range->pin_base) &&
 			    (pin < (range->pin_base + range->npins))) {
@@ -1633,10 +1633,12 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 				break;
 			}
 		}
-		chip = gpio_to_chip(gpio_num);
-		if (chip && chip->gpiodev && chip->gpiodev->base)
-			seq_printf(s, "%u:%s ", gpio_num -
-				chip->gpiodev->base, chip->label);
+		if (gpio_num >= 0)
+			chip = gpio_to_chip(gpio_num);
+		else
+			chip = NULL;
+		if (chip)
+			seq_printf(s, "%u:%s ", gpio_num - chip->gpiodev->base, chip->label);
 		else
 			seq_puts(s, "0:? ");
 #endif
-- 
2.30.2



