Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB481CEA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfHENX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbfHENX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9EA420651;
        Mon,  5 Aug 2019 13:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011437;
        bh=2dV29HuRuOlz9HEttHe888mggps3eMwaMjTI0L7q6n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+uJs0ItxR96sgP25e8R8FyoWrlYVajgw7w0GWG/r2KK2pvuVpre2Gz3GXqIZUuvO
         1FFQa73W0wVAbtmqiyXCR9/s1/m3GScG2IpdVOWkCFAQAqUZ+Yo9FhFWTEtdbP9h+T
         oxiCmErkVEWHK4mwsnBv+4XWidcrEMv92eoUND44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Claus H. Stovgaard" <cst@phaseone.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.2 088/131] gpio: dont WARN() on NULL descs if gpiolib is disabled
Date:   Mon,  5 Aug 2019 15:02:55 +0200
Message-Id: <20190805124957.860372906@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit ffe0bbabb0cffceceae07484fde1ec2a63b1537c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/gpio/consumer.h |   64 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -247,7 +247,7 @@ static inline void gpiod_put(struct gpio
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 
 static inline void devm_gpiod_unhinge(struct device *dev,
@@ -256,7 +256,7 @@ static inline void devm_gpiod_unhinge(st
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 
 static inline void gpiod_put_array(struct gpio_descs *descs)
@@ -264,7 +264,7 @@ static inline void gpiod_put_array(struc
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(descs);
 }
 
 static inline struct gpio_desc *__must_check
@@ -317,7 +317,7 @@ static inline void devm_gpiod_put(struct
 	might_sleep();
 
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 }
 
 static inline void devm_gpiod_put_array(struct device *dev,
@@ -326,32 +326,32 @@ static inline void devm_gpiod_put_array(
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
 
@@ -359,7 +359,7 @@ static inline int gpiod_direction_output
 static inline int gpiod_get_value(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_array_value(unsigned int array_size,
@@ -368,13 +368,13 @@ static inline int gpiod_get_array_value(
 					unsigned long *value_bitmap)
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
 static inline int gpiod_set_array_value(unsigned int array_size,
 					struct gpio_desc **desc_array,
@@ -382,13 +382,13 @@ static inline int gpiod_set_array_value(
 					unsigned long *value_bitmap)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 static inline int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_raw_array_value(unsigned int array_size,
@@ -397,13 +397,13 @@ static inline int gpiod_get_raw_array_va
 					    unsigned long *value_bitmap)
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
@@ -411,14 +411,14 @@ static inline int gpiod_set_raw_array_va
 					    unsigned long *value_bitmap)
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
@@ -427,13 +427,13 @@ static inline int gpiod_get_array_value_
 				     unsigned long *value_bitmap)
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
 static inline int gpiod_set_array_value_cansleep(unsigned int array_size,
 					    struct gpio_desc **desc_array,
@@ -441,13 +441,13 @@ static inline int gpiod_set_array_value_
 					    unsigned long *value_bitmap)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc_array);
 	return 0;
 }
 static inline int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return 0;
 }
 static inline int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
@@ -456,14 +456,14 @@ static inline int gpiod_get_raw_array_va
 					       unsigned long *value_bitmap)
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
@@ -471,41 +471,41 @@ static inline int gpiod_set_raw_array_va
 						unsigned long *value_bitmap)
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
 
@@ -513,7 +513,7 @@ static inline int gpiod_set_consumer_nam
 					  const char *name)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -EINVAL;
 }
 
@@ -525,7 +525,7 @@ static inline struct gpio_desc *gpio_to_
 static inline int desc_to_gpio(const struct gpio_desc *desc)
 {
 	/* GPIO can never have been requested */
-	WARN_ON(1);
+	WARN_ON(desc);
 	return -EINVAL;
 }
 


