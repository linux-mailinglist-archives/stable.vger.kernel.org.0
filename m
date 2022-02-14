Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81504B4BA6
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344602AbiBNKHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:07:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345883AbiBNKHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:07:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB2674DE6;
        Mon, 14 Feb 2022 01:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4C6D61238;
        Mon, 14 Feb 2022 09:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F0C340F4;
        Mon, 14 Feb 2022 09:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832187;
        bh=ConjnUoJ0g0xGyfJNWwrU/GygfPMqHV4ZaFCx5Ndfkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ti+shNCmqz46nE+1cGIDGK3ApVtKlLW28rmelY5xnYszYtUzBaavjDcf4MhiJ8cn6
         HWaYaQCDDRWWAWlRt3aBxNVT5OCAqaR6F9V4e3GPLd6astK4lWc88HRB6MzSHl9E0T
         s41by2JvXbKKDDkBwIWASByWQJg9DaNC0Hfv+LvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suresh Balakrishnan <suresh.balakrishnan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/172] gpiolib: Never return internal error codes to user space
Date:   Mon, 14 Feb 2022 10:26:05 +0100
Message-Id: <20220214092510.113389427@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 95a4eed7dd5b7c1c3664a626174290686ddbee9f ]

Currently it's possible that character device interface may return
the error codes which are not supposed to be seen by user space.
In this case it's EPROBE_DEFER.

Wrap it to return -ENODEV instead as sysfs does.

Fixes: d7c51b47ac11 ("gpio: userspace ABI for reading/writing GPIO lines")
Fixes: 61f922db7221 ("gpio: userspace ABI for reading GPIO line events")
Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Reported-by: Suresh Balakrishnan <suresh.balakrishnan@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c  |  6 +++---
 drivers/gpio/gpiolib-sysfs.c |  7 ++-----
 drivers/gpio/gpiolib.h       | 12 ++++++++++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index c7b5446d01fd2..ffa0256cad5a0 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -330,7 +330,7 @@ static int linehandle_create(struct gpio_device *gdev, void __user *ip)
 			goto out_free_lh;
 		}
 
-		ret = gpiod_request(desc, lh->label);
+		ret = gpiod_request_user(desc, lh->label);
 		if (ret)
 			goto out_free_lh;
 		lh->descs[i] = desc;
@@ -1378,7 +1378,7 @@ static int linereq_create(struct gpio_device *gdev, void __user *ip)
 			goto out_free_linereq;
 		}
 
-		ret = gpiod_request(desc, lr->label);
+		ret = gpiod_request_user(desc, lr->label);
 		if (ret)
 			goto out_free_linereq;
 
@@ -1764,7 +1764,7 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 		}
 	}
 
-	ret = gpiod_request(desc, le->label);
+	ret = gpiod_request_user(desc, le->label);
 	if (ret)
 		goto out_free_le;
 	le->desc = desc;
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 4098bc7f88b7e..44c1ad51b3fe9 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -475,12 +475,9 @@ static ssize_t export_store(struct class *class,
 	 * they may be undone on its behalf too.
 	 */
 
-	status = gpiod_request(desc, "sysfs");
-	if (status) {
-		if (status == -EPROBE_DEFER)
-			status = -ENODEV;
+	status = gpiod_request_user(desc, "sysfs");
+	if (status)
 		goto done;
-	}
 
 	status = gpiod_set_transitory(desc, false);
 	if (!status) {
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 30bc3f80f83e6..c31f4626915de 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -135,6 +135,18 @@ struct gpio_desc {
 
 int gpiod_request(struct gpio_desc *desc, const char *label);
 void gpiod_free(struct gpio_desc *desc);
+
+static inline int gpiod_request_user(struct gpio_desc *desc, const char *label)
+{
+	int ret;
+
+	ret = gpiod_request(desc, label);
+	if (ret == -EPROBE_DEFER)
+		ret = -ENODEV;
+
+	return ret;
+}
+
 int gpiod_configure_flags(struct gpio_desc *desc, const char *con_id,
 		unsigned long lflags, enum gpiod_flags dflags);
 int gpio_set_debounce_timeout(struct gpio_desc *desc, unsigned int debounce);
-- 
2.34.1



