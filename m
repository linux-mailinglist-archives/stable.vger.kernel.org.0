Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA976AE972
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCGRYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCGRX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:23:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFE79B9AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 968A3B819AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB316C433D2;
        Tue,  7 Mar 2023 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209561;
        bh=0wdxBqjs4Evg2/qMTg+rUeZAjkOMlookhVWkA7DrCQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c93sb4VHz1PYyq0rAEaKzYWX4+EK7CkRl+sHg02B73lanN59OXaZbZi/A312bET8C
         AfSMXjTvxpecvEPYzKoxrSyTm59uANfKNrqaKsuSWZX4L4QpkeJrr6esedO0cx/4Xb
         xDclWsYs0xQzzOblv/7NYGW4lXVNbXHYMSY/HbHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0227/1001] leds: led-class: Add missing put_device() to led_put()
Date:   Tue,  7 Mar 2023 17:49:59 +0100
Message-Id: <20230307170031.732438116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 445110941eb94709216363f9d807d2508e64abd7 ]

led_put() is used to "undo" a successful of_led_get() call,
of_led_get() uses class_find_device_by_of_node() which returns
a reference to the device which must be free-ed with put_device()
when the caller is done with it.

Add a put_device() call to led_put() to free the reference returned
by class_find_device_by_of_node().

And also add a put_device() in the error-exit case of try_module_get()
failing.

Fixes: 699a8c7c4bd3 ("leds: Add of_led_get() and led_put()")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230120114524.408368-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 6a8ea94834fa3..7391d2cf1370a 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -241,8 +241,10 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
 	led_cdev = dev_get_drvdata(led_dev);
 
-	if (!try_module_get(led_cdev->dev->parent->driver->owner))
+	if (!try_module_get(led_cdev->dev->parent->driver->owner)) {
+		put_device(led_cdev->dev);
 		return ERR_PTR(-ENODEV);
+	}
 
 	return led_cdev;
 }
@@ -255,6 +257,7 @@ EXPORT_SYMBOL_GPL(of_led_get);
 void led_put(struct led_classdev *led_cdev)
 {
 	module_put(led_cdev->dev->parent->driver->owner);
+	put_device(led_cdev->dev);
 }
 EXPORT_SYMBOL_GPL(led_put);
 
-- 
2.39.2



