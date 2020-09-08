Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA7261D78
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbgIHThe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730827AbgIHPzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:55:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7032DC0612A7
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 06:08:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a65so17212779wme.5
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 06:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YaYfBY/nWyV15237QqlCB6gaunpe9sapW1LpGGaZFmI=;
        b=PQ9FpH0sWVEYKXkmkpGFj8lM+SXrPTK7FsqwWAXuNeb0DermnRd5fNv24TZMEQMSi5
         6rnR7/UFQT86UeHCZlIojA8tN/1UK70ZR4CuAm+RhnbYsM3fmVkkmKg1u2K/5DZBeIiT
         F7psEX9g30KC4el3BNij5xIoWiLfg4iXkT4JOU8Qu4Gb6/j/dbVe7QckB3toI0QD3NSc
         BUrLpK24R5GNTIAjreSy7244Y94uNWeuiOiXYtS8462EI+6ptbP6VFqS49GWgBIZCar7
         SVF2YJpMvvBMn7pMCG3KmPKUk7WKH6sU65i03kq4p+nCS+6jt62w+QJOPnm4BG/lqnnZ
         X24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YaYfBY/nWyV15237QqlCB6gaunpe9sapW1LpGGaZFmI=;
        b=X/5khsrhDTBcYZ2dSKXWKfAl0somucCBCz3SY9gKda4SH7QaGXyXM4HAWpa3kEqSSk
         LXfkCeAAOJ+6ckELifaTfYbKtQmXnZu4O1ZqFPJ6ydQsSKR5nUALln2SlZnYYUcvXGMy
         NnIrEjxd3tMU4rl6yEZSSb9pq4iVtLuyCHWYUq65tBxrNSjDlg3YPL8tJolJKobS4Sj0
         MaoCoZaauKXQQbt4d9fjCeNgPJSrtIotGME6UaB33qAMhyO6oN+ZW4GQhHaHUdhUcAtz
         2v5kL7njE2M/Vzi84DslOaBZ+lWc7eQZVnkGKk3C/fmEdLRAapMdvqYhJ4srjfCDGm7S
         DYEQ==
X-Gm-Message-State: AOAM530M+JTkVMWf08NJ5amnAzx8WyagpeJZhsnyosCzWsrLitFU6RTO
        fNCKFH+bGkWvifrhpKOZeyxXSg==
X-Google-Smtp-Source: ABdhPJzslhyYw7bWYKOTM5J83rbaOJq0mY3hHSuDFQ686C4hzftuOd+FgwLykWDkYZu4RwLETxv0Sw==
X-Received: by 2002:a1c:9e0e:: with SMTP id h14mr1690491wme.18.1599570482144;
        Tue, 08 Sep 2020 06:08:02 -0700 (PDT)
Received: from debian-brgl.home (lfbn-nic-1-68-20.w2-15.abo.wanadoo.fr. [2.15.159.20])
        by smtp.gmail.com with ESMTPSA id b2sm32254400wmh.47.2020.09.08.06.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 06:08:01 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kent Gibson <warthog618@gmail.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH] gpio: mockup: fix resource leak in error path
Date:   Tue,  8 Sep 2020 15:07:49 +0200
Message-Id: <20200908130749.9948-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

If the module init function fails after creating the debugs directory,
it's never removed. Add proper cleanup calls to avoid this resource
leak.

Fixes: 9202ba2397d1 ("gpio: mockup: implement event injecting over debugfs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpio-mockup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index bc345185db26..1652897fdf90 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -552,6 +552,7 @@ static int __init gpio_mockup_init(void)
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
 		gpio_mockup_err("error registering platform driver\n");
+		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
 
@@ -582,6 +583,7 @@ static int __init gpio_mockup_init(void)
 			gpio_mockup_err("error registering device");
 			platform_driver_unregister(&gpio_mockup_driver);
 			gpio_mockup_unregister_pdevs();
+			debugfs_remove_recursive(gpio_mockup_dbg_dir);
 			return PTR_ERR(pdev);
 		}
 
-- 
2.26.1

