Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8832646C
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 15:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBZOzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 09:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhBZOzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 09:55:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B1264EED;
        Fri, 26 Feb 2021 14:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614351303;
        bh=kQ2E8LRIVngf7MiN1WL7eb4nbx+M5mChP1eoPKWYmNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3Yz1Hm3ldU/gxEBbeR1xe5tCSAR14AoMmJGgdQRGYD2FVM2j/7wEuwyfVD4Q8jxz
         fzpmq/bww/aH8EgkWIjrM+NusGPfbsz5g4ljUHqlIlCfD4HnIN7bDneFBIP8l6WTBx
         hQZ3989jCjEVWhsMKr9dAX9R5jFLXgsvEA/fJ5aeZ10JpKmTzxT8P8+o6sXLrH/V2n
         m8EaGA1jooG+XMxAENrSa9kHholgPLIspHpYuhIcxqrgHPRkL3SWWHPrALP4VB99pN
         rAvGzBUFZZFBh++JmGrO8PayqO3O+YiOoFnoFKE10m3hLxR8kzjEBIK6qhOaDFc83N
         62FtyESaZfQbg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lFeWZ-0000K4-G5; Fri, 26 Feb 2021 15:55:23 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] gpio: fix gpio-device list corruption
Date:   Fri, 26 Feb 2021 15:52:46 +0100
Message-Id: <20210226145246.1171-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210226145246.1171-1-johan@kernel.org>
References: <20210226145246.1171-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to hold the gpio_lock when removing the gpio device from the
gpio_devices list (when dropping the last reference) to avoid corrupting
the list when there are concurrent accesses.

Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
Cc: stable@vger.kernel.org      # 4.6
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e1016bc8cf14..42bdc55a15f9 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -475,8 +475,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
 static void gpiodevice_release(struct device *dev)
 {
 	struct gpio_device *gdev = container_of(dev, struct gpio_device, dev);
+	unsigned long flags;
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
 	ida_free(&gpio_ida, gdev->id);
 	kfree_const(gdev->label);
 	kfree(gdev->descs);
-- 
2.26.2

