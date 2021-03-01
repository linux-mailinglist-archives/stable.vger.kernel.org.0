Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BF9327A67
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhCAJGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233703AbhCAJFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 04:05:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8369864E01;
        Mon,  1 Mar 2021 09:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614589508;
        bh=MZS+vEFMJfhOIBzq9iXKTlDqzsIfvu2g36hJM0R+3u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSPNlYQIJ5RPGN2tOwO2XcDRcIq7qsYe6seUFzMl+43ZPfLHt5Qs8Zc9NIAxa3Sd0
         iSeYwM68ZDad+/L1fkJK18PKcNSjr4r03oXhCSQUCzHRRvkFj747loFrXKiG15TM7n
         Uq15eSvrljHoiGg5+S7NwhFv8GnwYAstkMqQQN453h2R3lCbsKOgUKZQbJxhGBpS3W
         yCa36EtVJWTzSzwPz7lOidmb5usLs6W1Ln4Q2Z8XZOHQ3D3i1aC6x6en6V+lJW5r1a
         jpjTwj4RlUlFUKriVtfDjoQQ/eem2gW+hSvkG1zf+R0StEC2+CHXnpo9zvpl2PA9IS
         MmsxXcyg16c7g==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lGeUY-0006pL-8h; Mon, 01 Mar 2021 10:05:26 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] gpio: fix gpio-device list corruption
Date:   Mon,  1 Mar 2021 10:05:19 +0100
Message-Id: <20210301090519.26192-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301090519.26192-1-johan@kernel.org>
References: <20210301090519.26192-1-johan@kernel.org>
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
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 6e0572515d02..4253837f870b 100644
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

