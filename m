Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D58D6698
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfJNPxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:53:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32786 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbfJNPxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 11:53:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so20369053wrs.0
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 08:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0t1OM4slpGn/FciwgvtR1ItjOGOzF2p73EE7Lk2KZOE=;
        b=hCyh88laFReOQinVzQBy5MUAHRpJ2PKFi2cIw4C+dRkEimuPFJ8pmqwr1cqICMU94a
         cNLShzKyyXte63Zf3TmFKzQx1yGoIOzv4O5HPpJhNEhKvkhqdztOcpsDR8QBEuwkL3qq
         kKL3BHve8OMiMMhlJxq2E1Qsw1eGldVeRwIBLjrQ2KvOSsGR+FM5sQ1Cfzjq5AMoDqjP
         JrnyLnnkCVdrR1dBpBdPamSrN5lSj8blwq/tF0CsJEaBY2xsJp5klubXhb2d54mcHaPj
         gVo72sAMiQUODCnJhvr/L8H2SeM7e56YElxPH4vWc3Q4ec2mHgTmugBFDZlofQaIkqNP
         2naw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0t1OM4slpGn/FciwgvtR1ItjOGOzF2p73EE7Lk2KZOE=;
        b=mxV1O0CUb5jt1uTPsjYyIfZY80haMpfAnFfM5J01gSo5TNkZNOEpOcvPpXbPankF0O
         O1dK3RDiYGXJEj4ynq2coZ8MtSvRPvi3jrH74ZBZvgkg1DxvkmzB71kXeUaxNAghyuhd
         G9TfabHQCWIJV7BGsFT0yeMU3kH/hEh9eq8MjpOQu+zWQp1AcVypIX7FYT6Xh+E5Q9tM
         ZKm5w5+oyrE1Vm4Z2IOJxSQqi+L8KvnG3EwXFa7aMuAu+pbnE0bM6TpCyWtf9ugMK24P
         LzwmBG6gdIE7nLuY9RCBS/kJsudzTpSoie2PzHqkklei4A8t8WfN8VmwGtNMWMy7/dqt
         s5ig==
X-Gm-Message-State: APjAAAU1FjT7rGl9PToXuma3HTOVqCBrm3KAfRba9xPcwfoLpplqDCSG
        lPZRKxm9zNyW7MCwHBxY1UJlWw==
X-Google-Smtp-Source: APXvYqxBUAz0ltyZJGC9OKxGG3rjoJlKk1X9BzHdCHfcDtM+FNNfeISw9xtUdr+NCPM9Hbr8tlTEMQ==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr22534688wrv.8.1571068425381;
        Mon, 14 Oct 2019 08:53:45 -0700 (PDT)
Received: from localhost.localdomain ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id 5sm17984836wrk.86.2019.10.14.08.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 08:53:44 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        Marco Felsch <m.felsch@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v5.3] gpio: fix getting nonexclusive gpiods from DT
Date:   Mon, 14 Oct 2019 17:53:41 +0200
Message-Id: <20191014155341.13145-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

Since commit ec757001c818 ("gpio: Enable nonexclusive gpiods from DT
nodes") we are able to get GPIOD_FLAGS_BIT_NONEXCLUSIVE marked gpios.
Currently the gpiolib uses the wrong flags variable for the check. We
need to check the gpiod_flags instead of the of_gpio_flags else we
return -EBUSY for GPIOD_FLAGS_BIT_NONEXCLUSIVE marked and requested
gpiod's.

Fixes: ec757001c818 gpio: Enable nonexclusive gpiods from DT nodes
Cc: stable@vger.kernel.org
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
[Bartosz: the function was moved to gpiolib-of.c so updated the patch]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
[Bartosz: backported to v5.3.y]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d9074191edef..e4203c1eb869 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4303,7 +4303,7 @@ struct gpio_desc *gpiod_get_from_of_node(struct device_node *node,
 	transitory = flags & OF_GPIO_TRANSITORY;
 
 	ret = gpiod_request(desc, label);
-	if (ret == -EBUSY && (flags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
+	if (ret == -EBUSY && (dflags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
 		return desc;
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.23.0

