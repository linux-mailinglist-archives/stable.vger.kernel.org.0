Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C29571344
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 09:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiGLHl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 03:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbiGLHlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 03:41:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15C29A5E6
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:41:02 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h17so9994315wrx.0
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXpg/iY82hEm9tokQdYtqJ4gX8iwUMDbB/yvs2d8omo=;
        b=hfD3Z60Vyp2ebK1/oVLfYekTLjmEM4uokftPm7qlCpAyugRjZ8+NglNPS0HCz3ro8s
         RhRCfmEUjEBKhEgOfOLPmgJeZ7mH/qZU2ZDSPlC+OW2FeHoiUMrKFWZBvJ1nzm0prWqC
         tAH4mHgrNRPIX1Cgqv0zxcR983u9EKacVJLurjU2HnM4R/O/GLvC26nmf9nez9Inx76N
         kVyCHCWUwB0xf/9G0Haq9lDHtkto1yudX6xB+1OZsraKscQvym+psv7AXupqBnLldzYH
         Jz6qZwRzKF4lpQDRYFqQ86IwVEVyxwJfLrvZkp2lsd5vpaYh8FTkz/CzDwvrUsq4YCm4
         VOiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXpg/iY82hEm9tokQdYtqJ4gX8iwUMDbB/yvs2d8omo=;
        b=xd68P/2+RtAq0gplrgg6MypSp/7j1OJvq7wUMEXARBH0HFUDe/IYCBgvjwcgI/3Fdl
         wI9qq0kFeNf3HW+GehNzG3fhQXXu9XsvGESFpOi87bIiLCGgzTSoAmyu+ntbcZ6I7EM1
         pnmCSthRA2HFdRDyiNAi+zAwEkV4BzUpvo3/dhBZlbrzjAsYB6a445pOTJba3mGQs5GV
         cmtE4bD7IhjhaJ6RAk0JSMpkArTjrWZUnd0xgf402gBPFf+WkL1o/0ZGiVmMq02rZlYT
         V6oS6TaYshA0w7NqaToc+/9JkiEJlzHNR8IyJBebLcMsWDcQiQ2cRVw8a3wElAZVrZQi
         XGGg==
X-Gm-Message-State: AJIora+hB71BT9FkBkyIrpG2a9iYQiQ2crI0NzlB1doALyGGy3I3f5KN
        IgJO7QS//7tmOIDWWlvFDIY2+A==
X-Google-Smtp-Source: AGRyM1sjO+5Zp5uEx98PsQdY6oBQiAuF6TvxkZBfMtLneoIj5n4eudQALZXKfBo3YT2MZNyOp54vDw==
X-Received: by 2002:adf:f345:0:b0:21d:6a26:6d8f with SMTP id e5-20020adff345000000b0021d6a266d8fmr21114628wrp.538.1657611660742;
        Tue, 12 Jul 2022 00:41:00 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:f331:f20b:d10:e79e])
        by smtp.gmail.com with ESMTPSA id m9-20020a056000024900b0021d9207e6f1sm7725462wrz.34.2022.07.12.00.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:41:00 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kent Gibson <warthog618@gmail.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <brgl@bgdev.pl>, stable@vger.kernel.org
Subject: [PATCH v2] gpio: sim: fix the chip_name configfs item
Date:   Tue, 12 Jul 2022 09:40:55 +0200
Message-Id: <20220712074055.10588-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The chip_name configs attribute always displays the device name of the
first GPIO bank because the logic of the relevant function is simply
wrong.

Fix it by correctly comparing the bank's swnode against the GPIO
device's children.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Cc: stable@vger.kernel.org
Reported-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
---
v1 -> v2:
- use device_match_fwnode for shorter code

 drivers/gpio/gpio-sim.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index 98109839102f..1020c2feb249 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -991,28 +991,22 @@ static struct configfs_attribute *gpio_sim_device_config_attrs[] = {
 };
 
 struct gpio_sim_chip_name_ctx {
-	struct gpio_sim_device *dev;
+	struct fwnode_handle *swnode;
 	char *page;
 };
 
 static int gpio_sim_emit_chip_name(struct device *dev, void *data)
 {
 	struct gpio_sim_chip_name_ctx *ctx = data;
-	struct fwnode_handle *swnode;
-	struct gpio_sim_bank *bank;
 
 	/* This would be the sysfs device exported in /sys/class/gpio. */
 	if (dev->class)
 		return 0;
 
-	swnode = dev_fwnode(dev);
+	if (device_match_fwnode(dev, ctx->swnode))
+		return sprintf(ctx->page, "%s\n", dev_name(dev));
 
-	list_for_each_entry(bank, &ctx->dev->bank_list, siblings) {
-		if (bank->swnode == swnode)
-			return sprintf(ctx->page, "%s\n", dev_name(dev));
-	}
-
-	return -ENODATA;
+	return 0;
 }
 
 static ssize_t gpio_sim_bank_config_chip_name_show(struct config_item *item,
@@ -1020,7 +1014,7 @@ static ssize_t gpio_sim_bank_config_chip_name_show(struct config_item *item,
 {
 	struct gpio_sim_bank *bank = to_gpio_sim_bank(item);
 	struct gpio_sim_device *dev = gpio_sim_bank_get_device(bank);
-	struct gpio_sim_chip_name_ctx ctx = { dev, page };
+	struct gpio_sim_chip_name_ctx ctx = { bank->swnode, page };
 	int ret;
 
 	mutex_lock(&dev->lock);
-- 
2.34.1

