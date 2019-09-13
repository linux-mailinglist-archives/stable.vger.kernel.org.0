Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5FB1F6C
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbfIMNT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389470AbfIMNTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:25 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 890F220CC7;
        Fri, 13 Sep 2019 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380765;
        bh=M6Y2GPm5GkYCYKq/U3sgL7XcihZDnAQFosxCIlj2vjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMMMVm8rfb+x9d5535oX42UhT4dbm8Tk7h+QXE0+6gZwGv1Z1RsbK3UTm3RGIelzE
         mxugMAbJYIr2UZqTi7zqs0nXVz8DqMNWfxMT0MFh/8g1v7tcE4SmkqR6Msb8rGRd6H
         CMpltvHWid0kjbfwxZE0d6KQg6axYlsVcSVdVQms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Claus H. Stovgaard" <cst@phaseone.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/190] gpio: dont WARN() on NULL descs if gpiolib is disabled
Date:   Fri, 13 Sep 2019 14:07:06 +0100
Message-Id: <20190913130613.448204999@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ffe0bbabb0cffceceae07484fde1ec2a63b1537c ]

If gpiolib is disabled, we use the inline stubs from gpio/consumer.h
instead of regular definitions of GPIO API. The stubs for 'optional'
variants of gpiod_get routines return NULL in this case as if the
relevant GPIO wasn't found. This is correct so far.

Calling other (non-gpio_get) stubs from this header triggers a warning
because the GPIO descriptor couldn't have been requested. The warning
however is unconditional (WARN_ON(1)) and is emitted even if the passed
descriptor pointer is NULL.

We don't want to force the users of 'optional' gpio_get to check the
returned pointer before calling e.g. gpiod_set_value() so let's only
WARN on non-NULL descriptors.

Cc: stable@vger.kernel.org
Reported-by: Claus H. Stovgaard <cst@phaseone.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/consumer.h | 62 +++++++++++++++++------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index acc4279ad5e3f..412098b24f58b 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -222,7 +222,7 @@ static inline void gpiod_put(struct gpio_desc *desc)
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 
 static inline void gpiod_put_array(struct gpio_descs *descs)
@@ -230,7 +230,7 @@ static inline void gpiod_put_array(struct gpio_descs *descs)
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(descs);
 }
 
 static inline struct gpio_desc *__must_check
@@ -283,7 +283,7 @@ static inline void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 
 static inline void devm_gpiod_put_array(struct device *dev,
@@ -292,32 +292,32 @@ static inline void devm_gpiod_put_array(struct device *dev,
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(descs);
 }
 
 
 static inline int gpiod_get_direction(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -ENOSYS;
 }
 static inline int gpiod_direction_input(struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -ENOSYS;
 }
 static inline int gpiod_direction_output(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -ENOSYS;
 }
 static inline int gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -ENOSYS;
 }
 
@@ -325,7 +325,7 @@ static inline int gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 static inline int gpiod_get_value(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_array_value(unsigned int array_size,
@@ -333,25 +333,25 @@ static inline int gpiod_get_array_value(unsigned int array_size,
 					int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 static inline void gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 static inline void gpiod_set_array_value(unsigned int array_size,
 					 struct gpio_desc **desc_array,
 					 int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 }
 static inline int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_raw_array_value(unsigned int array_size,
@@ -359,27 +359,27 @@ static inline int gpiod_get_raw_array_value(unsigned int array_size,
 					    int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 static inline void gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 static inline int gpiod_set_raw_array_value(unsigned int array_size,
 					     struct gpio_desc **desc_array,
 					     int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 
 static inline int gpiod_get_value_cansleep(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_array_value_cansleep(unsigned int array_size,
@@ -387,25 +387,25 @@ static inline int gpiod_get_array_value_cansleep(unsigned int array_size,
 				     int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 static inline void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 static inline void gpiod_set_array_value_cansleep(unsigned int array_size,
 					    struct gpio_desc **desc_array,
 					    int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 }
 static inline int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
@@ -413,55 +413,55 @@ static inline int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
 					       int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 static inline void gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
 						int value)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 static inline int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 						struct gpio_desc **desc_array,
 						int *value_array)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 
 static inline int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -ENOSYS;
 }
 
 static inline int gpiod_set_transitory(struct gpio_desc *desc, bool transitory)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -ENOSYS;
 }
 
 static inline int gpiod_is_active_low(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_cansleep(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 
 static inline int gpiod_to_irq(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -EINVAL;
 }
 
@@ -469,7 +469,7 @@ static inline int gpiod_set_consumer_name(struct gpio_desc *desc,
 					  const char *name)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -EINVAL;
 }
 
@@ -481,7 +481,7 @@ static inline struct gpio_desc *gpio_to_desc(unsigned gpio)
 static inline int desc_to_gpio(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -EINVAL;
 }
 
-- 
2.20.1



