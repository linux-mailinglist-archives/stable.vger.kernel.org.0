Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA22D830E0
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 13:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfHFLl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 07:41:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35350 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfHFLl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 07:41:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so76093239wmg.0
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 04:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DCMYBq+pxZ/Dj8XcN6IF/62A4O2vc3YmFZ6P0x1qdo=;
        b=L/fAQmJ1Gcwovw+x078Z87MKPgpV91JkI70OmcwxZLAhjX/deQD41f6d13FN2SP+yb
         Cj+XsyoBUeJekuCCz2n8/GglW/nX1Djs9dlW0XJzkwypbIkWJQtuYBv9atCoVnnfx9ov
         tpy2muSwklScvqxECXiDMNzfQJiryMULbOTSYeVc/+TgTkDqSjCmDLHS7Y8C1UgQxhhw
         BvcZCdSLnZLTDKsX6mWnEpIDov+X27judMqHS7+CwwLeSVk8nh/CLye6ekEkUW8B+nLH
         3NVCN6JO0ZwqbXVJJoRIwlDmTZt2wb5uzhFkM+F41bTwUPmTDMHkQAJ0JFrdsr/pNSKh
         fCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DCMYBq+pxZ/Dj8XcN6IF/62A4O2vc3YmFZ6P0x1qdo=;
        b=UqjA1n8aP3EI8Qlbx69RS1GggAYMyw+a3JNgUSbGV8gzM/ZTO80HulSOU6ahvDrSoP
         pcnJr5wHrmzY1tuzxK34j+niFZJnkpteH/XcXCkp2R9g6rZv5GqbeMeNCSR0kJpJnDON
         wHy4Q/8QrKkFHfJ9ySFJMYsZYHN9AQSZJ4hwdJNMH4liDNOuZxqOfutQ5oc8zwBfdjQi
         jNVL7B65Gkf95LK/ZI05eGPsusterlwUgROtZA+7UI8IoCURyQFhDbtOLX/xmPUNOYEU
         Q2DhK7yiiEQsR6Eo/b5sLfH2Y0Yjwj7l72ke8QoZPk4pr3tgnrpwsloPKd0WJAPDxOis
         bKaw==
X-Gm-Message-State: APjAAAUJzzH+Il9SDLheR0gSZxg2YjkLj1AxbQ+LnHkJH/ulQKigDnVu
        w2tI+y8FIGgX4nB7AO5J6XooSay4ZEI=
X-Google-Smtp-Source: APXvYqx3uccU6bYsBYdR8MHaUzUGEmX7pclvm00Ym/7OwwysIooUn/qbl7App0I3ZXpofOStV1gz1A==
X-Received: by 2002:a7b:c247:: with SMTP id b7mr4574523wmj.13.1565091715612;
        Tue, 06 Aug 2019 04:41:55 -0700 (PDT)
Received: from debian-brgl.home ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id h1sm68075604wrt.20.2019.08.06.04.41.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 04:41:54 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] gpiolib: never report open-drain/source lines as 'input' to user-space
Date:   Tue,  6 Aug 2019 13:41:51 +0200
Message-Id: <20190806114151.17652-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

If the driver doesn't support open-drain/source config options, we
emulate this behavior when setting the direction by calling
gpiod_direction_input() if the default value is 0 (open-source) or
1 (open-drain), thus not actively driving the line in those cases.

This however clears the FLAG_IS_OUT bit for the GPIO line descriptor
and makes the LINEINFO ioctl() incorrectly report this line's mode as
'input' to user-space.

This commit modifies the ioctl() to always set the GPIOLINE_FLAG_IS_OUT
bit in the lineinfo structure's flags field. Since it's impossible to
use the input mode and open-drain/source options at the same time, we
can be sure the reported information will be correct.

Fixes: 521a2ad6f862 ("gpio: add userspace ABI for GPIO line information")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpiolib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f497003f119c..80a2a2cb673b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1091,9 +1091,11 @@ static long gpio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 			lineinfo.flags |= GPIOLINE_FLAG_ACTIVE_LOW;
 		if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
-			lineinfo.flags |= GPIOLINE_FLAG_OPEN_DRAIN;
+			lineinfo.flags |= (GPIOLINE_FLAG_OPEN_DRAIN |
+					   GPIOLINE_FLAG_IS_OUT);
 		if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
-			lineinfo.flags |= GPIOLINE_FLAG_OPEN_SOURCE;
+			lineinfo.flags |= (GPIOLINE_FLAG_OPEN_SOURCE |
+					   GPIOLINE_FLAG_IS_OUT);
 
 		if (copy_to_user(ip, &lineinfo, sizeof(lineinfo)))
 			return -EFAULT;
-- 
2.21.0

