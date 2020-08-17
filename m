Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7A246B71
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388008AbgHQPzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbgHQPzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:55:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AEBC20729;
        Mon, 17 Aug 2020 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679700;
        bh=Xejuo/PMfWacrzkPzkq/7Z+s+R9YIMiwyxD9Qvi0SFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTW7GpX2773d+WzYe5MvSNvWAvL7M1kjt8HFNUFY3QStV5+1p31WsfcJ3HH9GY4DZ
         KZI8mnEjGVhbOO3buegT08QmJIXWWHEDk+wMyO/thXi60f3IdpxtcQoplbEjnmWZcF
         okr0AKMbQSCBfGn0YqT4Xu7fei3E7NWKs7Ip/+O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 305/393] gpio: dont use same lockdep class for all devm_gpiochip_add_data users
Date:   Mon, 17 Aug 2020 17:15:55 +0200
Message-Id: <20200817143834.409569764@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 5f402bb17533113c21d61c2d4bc4ef4a6fa1c9a5 ]

Commit 959bc7b22bd2 ("gpio: Automatically add lockdep keys") documents
in its commits message its intention to "create a unique class key for
each driver".

It does so by having gpiochip_add_data add in-place the definition of
two static lockdep classes for LOCKDEP use. That way, every caller of
the macro adds their gpiochip with unique lockdep classes.

There are many indirect callers of gpiochip_add_data, however, via
use of devm_gpiochip_add_data. devm_gpiochip_add_data has external
linkage and all its users will share the same lockdep classes, which
probably is not intended.

Fix this by replicating the gpio_chip_add_data statics-in-macro for
the devm_ version as well.

Fixes: 959bc7b22bd2 ("gpio: Automatically add lockdep keys")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20200731123835.8003-1-a.fatoum@pengutronix.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-devres.c | 13 ++++++++-----
 include/linux/gpio/driver.h   | 13 +++++++++++--
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib-devres.c b/drivers/gpio/gpiolib-devres.c
index 5c91c4365da1f..7dbce4c4ebdf4 100644
--- a/drivers/gpio/gpiolib-devres.c
+++ b/drivers/gpio/gpiolib-devres.c
@@ -487,10 +487,12 @@ static void devm_gpio_chip_release(struct device *dev, void *res)
 }
 
 /**
- * devm_gpiochip_add_data() - Resource managed gpiochip_add_data()
+ * devm_gpiochip_add_data_with_key() - Resource managed gpiochip_add_data_with_key()
  * @dev: pointer to the device that gpio_chip belongs to.
  * @gc: the GPIO chip to register
  * @data: driver-private data associated with this chip
+ * @lock_key: lockdep class for IRQ lock
+ * @request_key: lockdep class for IRQ request
  *
  * Context: potentially before irqs will work
  *
@@ -501,8 +503,9 @@ static void devm_gpio_chip_release(struct device *dev, void *res)
  * gc->base is invalid or already associated with a different chip.
  * Otherwise it returns zero as a success code.
  */
-int devm_gpiochip_add_data(struct device *dev, struct gpio_chip *gc,
-			   void *data)
+int devm_gpiochip_add_data_with_key(struct device *dev, struct gpio_chip *gc, void *data,
+				    struct lock_class_key *lock_key,
+				    struct lock_class_key *request_key)
 {
 	struct gpio_chip **ptr;
 	int ret;
@@ -512,7 +515,7 @@ int devm_gpiochip_add_data(struct device *dev, struct gpio_chip *gc,
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = gpiochip_add_data(gc, data);
+	ret = gpiochip_add_data_with_key(gc, data, lock_key, request_key);
 	if (ret < 0) {
 		devres_free(ptr);
 		return ret;
@@ -523,4 +526,4 @@ int devm_gpiochip_add_data(struct device *dev, struct gpio_chip *gc,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(devm_gpiochip_add_data);
+EXPORT_SYMBOL_GPL(devm_gpiochip_add_data_with_key);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index b8fc92c177eba..e4a00bb42427c 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -496,8 +496,16 @@ extern int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 		gpiochip_add_data_with_key(gc, data, &lock_key, \
 					   &request_key);	  \
 	})
+#define devm_gpiochip_add_data(dev, gc, data) ({ \
+		static struct lock_class_key lock_key;	\
+		static struct lock_class_key request_key;	  \
+		devm_gpiochip_add_data_with_key(dev, gc, data, &lock_key, \
+					   &request_key);	  \
+	})
 #else
 #define gpiochip_add_data(gc, data) gpiochip_add_data_with_key(gc, data, NULL, NULL)
+#define devm_gpiochip_add_data(dev, gc, data) \
+	devm_gpiochip_add_data_with_key(dev, gc, data, NULL, NULL)
 #endif /* CONFIG_LOCKDEP */
 
 static inline int gpiochip_add(struct gpio_chip *gc)
@@ -505,8 +513,9 @@ static inline int gpiochip_add(struct gpio_chip *gc)
 	return gpiochip_add_data(gc, NULL);
 }
 extern void gpiochip_remove(struct gpio_chip *gc);
-extern int devm_gpiochip_add_data(struct device *dev, struct gpio_chip *gc,
-				  void *data);
+extern int devm_gpiochip_add_data_with_key(struct device *dev, struct gpio_chip *gc, void *data,
+					   struct lock_class_key *lock_key,
+					   struct lock_class_key *request_key);
 
 extern struct gpio_chip *gpiochip_find(void *data,
 			      int (*match)(struct gpio_chip *gc, void *data));
-- 
2.25.1



