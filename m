Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148BD5BDE00
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiITHTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 03:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiITHTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 03:19:00 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E531CFC5
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 00:18:57 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so2296536lfb.6
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=c6V/iqzhYX+7XjCjRngptEhB45APB69/gGkGWTb9bOI=;
        b=REvGdsDQZm/hIli7qRuWBjeWznU/QQbweJf9/Appf9KWcP9UmAloY668RFsZ4KZxeV
         16jZBJ8UhPexJ4YrPE8ny3oHLNOhAEtCe0UiLf8L+oZXbyBiQaaZ5TuNrRWSR/w52wDw
         uE2wAxg4WAWfXzFcGxQbCFyh+eXiB0rVL4DvbB1B6sI2pfRkXofNzlQ3Sx7phmK5Kywl
         LZKTHbY3ALWI70co7zM8vqzvpt5CAIB37yT6xTpBu6hWG4UeQNHiQT8fedY6XnUlMO7U
         yKytGmD0tG4X9EHXwuFkEzhM24XEsIgoUFT7JPTRG4Um7Lg7+CmCdnr6NerKJtZ5oawM
         mTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=c6V/iqzhYX+7XjCjRngptEhB45APB69/gGkGWTb9bOI=;
        b=T+L232WKRUlW9MethshITpuXuOxwfgtY3/PyFfNucASPFl9OJ4YTvuxzGdKao6lsKT
         QW+Af4cGaKjECi+nL0NitMQXv2C0/1WFw81Q9Mng23sosBFYVkBTlZi6Qc5WnM+Pd4+7
         o+3phajlgQKn5Mn+Ukovv8t/oQOKBIeDSC+jUOM+I8jAr78r+0CPlOy3+OZZNqWlNZsk
         tkYdV/i+mQAbiwywxvYT1hYv4k1KMO98vRuUZtj2WYMA1HW4GVoTBomNS+9NbWOVORO6
         J6tfdIQqgGPhAEPIG6NI7fDijomMG7GZQ8n2ysiQjzOZlrQCX0tCwkm+8q32bUT8h3iO
         FLUA==
X-Gm-Message-State: ACrzQf1fAXsgX9ryL26v3jJ/y+EjWifCXVQImOexBIVpLSmt0LOAKjda
        neLrmfwl90LLwaimv+plxetlpA==
X-Google-Smtp-Source: AMsMyM4/qcEPwX2znvCnJnpoJ1Q+PTnrI3VZ+8WxYiL0AEBO11iKm11+i2aefowgxlOJR3W9Mt+elg==
X-Received: by 2002:a05:6512:1101:b0:492:da22:bc58 with SMTP id l1-20020a056512110100b00492da22bc58mr7978158lfg.219.1663658335296;
        Tue, 20 Sep 2022 00:18:55 -0700 (PDT)
Received: from brgl-uxlite.coova.org ([31.0.93.102])
        by smtp.gmail.com with ESMTPSA id k12-20020a192d0c000000b004984ab5956dsm166373lfj.202.2022.09.20.00.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 00:18:54 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Wei Yongjun <weiyongjun1@huawei.com>, stable@vger.kernel.org
Subject: [PATCH] gpio: mockup: fix NULL pointer dereference when removing debugfs
Date:   Tue, 20 Sep 2022 09:18:41 +0200
Message-Id: <20220920071841.204292-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We now remove the device's debugfs entries when unbinding the driver.
This now causes a NULL-pointer dereference on module exit because the
platform devices are unregistered *after* the global debugfs directory
has been recursively removed. Fix it by unregistering the devices first.

Fixes: 303e6da99429 ("gpio: mockup: remove gpio debugfs when remove device")
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
---
 drivers/gpio/gpio-mockup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index a2e505a7545c..ab89cd8ddbd8 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -597,9 +597,9 @@ static int __init gpio_mockup_init(void)
 
 static void __exit gpio_mockup_exit(void)
 {
+	gpio_mockup_unregister_pdevs();
 	debugfs_remove_recursive(gpio_mockup_dbg_dir);
 	platform_driver_unregister(&gpio_mockup_driver);
-	gpio_mockup_unregister_pdevs();
 }
 
 module_init(gpio_mockup_init);
-- 
2.34.1

