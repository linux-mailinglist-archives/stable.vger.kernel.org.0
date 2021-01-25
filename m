Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD57F303398
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbhAZE7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbhAYSuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB5C22D50;
        Mon, 25 Jan 2021 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600602;
        bh=BpmRgW/A5rbWegvQN1v9Adt5ErDSiFWBDcc1tyLVPrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyiLGYlHFDo61vYc9YiuHGGktAhqEpIS860BjQTOsO+Vr0MMLN9W6psIhdLHKEEjk
         88E96ntCQVy/KVlDpp/XFaj3kWelHHIDfu7FV/5j8W9V5k1Zuqn60EJkBYa3AZ78pJ
         5Jmnm0DCjPVcHmWHj22i8xS8av9x3oNiLm4Gtcnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kent Gibson <warthog618@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/199] gpiolib: cdev: fix frame size warning in gpio_ioctl()
Date:   Mon, 25 Jan 2021 19:38:20 +0100
Message-Id: <20210125183219.554531892@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit 2e202ad873365513c6ad72e29a531071dffa498a ]

The kernel test robot reports the following warning in [1]:

 drivers/gpio/gpiolib-cdev.c: In function 'gpio_ioctl':
 >>drivers/gpio/gpiolib-cdev.c:1437:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Refactor gpio_ioctl() to handle each ioctl in its own helper function
and so reduce the variables stored on the stack to those explicitly
required to service the ioctl at hand.

The lineinfo_get_v1() helper handles both the GPIO_GET_LINEINFO_IOCTL
and GPIO_GET_LINEINFO_WATCH_IOCTL, as per the corresponding v2
implementation - lineinfo_get().

[1] https://lore.kernel.org/lkml/202012270910.VW3qc1ER-lkp@intel.com/

Fixes: aad955842d1c ("gpiolib: cdev: support GPIO_V2_GET_LINEINFO_IOCTL and GPIO_V2_GET_LINEINFO_WATCH_IOCTL")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 145 ++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 72 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index e9faeaf65d14f..689c06cbbb457 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1960,6 +1960,21 @@ struct gpio_chardev_data {
 #endif
 };
 
+static int chipinfo_get(struct gpio_chardev_data *cdev, void __user *ip)
+{
+	struct gpio_device *gdev = cdev->gdev;
+	struct gpiochip_info chipinfo;
+
+	memset(&chipinfo, 0, sizeof(chipinfo));
+
+	strscpy(chipinfo.name, dev_name(&gdev->dev), sizeof(chipinfo.name));
+	strscpy(chipinfo.label, gdev->label, sizeof(chipinfo.label));
+	chipinfo.lines = gdev->ngpio;
+	if (copy_to_user(ip, &chipinfo, sizeof(chipinfo)))
+		return -EFAULT;
+	return 0;
+}
+
 #ifdef CONFIG_GPIO_CDEV_V1
 /*
  * returns 0 if the versions match, else the previously selected ABI version
@@ -1974,6 +1989,41 @@ static int lineinfo_ensure_abi_version(struct gpio_chardev_data *cdata,
 
 	return abiv;
 }
+
+static int lineinfo_get_v1(struct gpio_chardev_data *cdev, void __user *ip,
+			   bool watch)
+{
+	struct gpio_desc *desc;
+	struct gpioline_info lineinfo;
+	struct gpio_v2_line_info lineinfo_v2;
+
+	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
+		return -EFAULT;
+
+	/* this doubles as a range check on line_offset */
+	desc = gpiochip_get_desc(cdev->gdev->chip, lineinfo.line_offset);
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+
+	if (watch) {
+		if (lineinfo_ensure_abi_version(cdev, 1))
+			return -EPERM;
+
+		if (test_and_set_bit(lineinfo.line_offset, cdev->watched_lines))
+			return -EBUSY;
+	}
+
+	gpio_desc_to_lineinfo(desc, &lineinfo_v2);
+	gpio_v2_line_info_to_v1(&lineinfo_v2, &lineinfo);
+
+	if (copy_to_user(ip, &lineinfo, sizeof(lineinfo))) {
+		if (watch)
+			clear_bit(lineinfo.line_offset, cdev->watched_lines);
+		return -EFAULT;
+	}
+
+	return 0;
+}
 #endif
 
 static int lineinfo_get(struct gpio_chardev_data *cdev, void __user *ip,
@@ -2011,6 +2061,22 @@ static int lineinfo_get(struct gpio_chardev_data *cdev, void __user *ip,
 	return 0;
 }
 
+static int lineinfo_unwatch(struct gpio_chardev_data *cdev, void __user *ip)
+{
+	__u32 offset;
+
+	if (copy_from_user(&offset, ip, sizeof(offset)))
+		return -EFAULT;
+
+	if (offset >= cdev->gdev->ngpio)
+		return -EINVAL;
+
+	if (!test_and_clear_bit(offset, cdev->watched_lines))
+		return -EBUSY;
+
+	return 0;
+}
+
 /*
  * gpio_ioctl() - ioctl handler for the GPIO chardev
  */
@@ -2018,80 +2084,24 @@ static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct gpio_chardev_data *cdev = file->private_data;
 	struct gpio_device *gdev = cdev->gdev;
-	struct gpio_chip *gc = gdev->chip;
 	void __user *ip = (void __user *)arg;
-	__u32 offset;
 
 	/* We fail any subsequent ioctl():s when the chip is gone */
-	if (!gc)
+	if (!gdev->chip)
 		return -ENODEV;
 
 	/* Fill in the struct and pass to userspace */
 	if (cmd == GPIO_GET_CHIPINFO_IOCTL) {
-		struct gpiochip_info chipinfo;
-
-		memset(&chipinfo, 0, sizeof(chipinfo));
-
-		strscpy(chipinfo.name, dev_name(&gdev->dev),
-			sizeof(chipinfo.name));
-		strscpy(chipinfo.label, gdev->label,
-			sizeof(chipinfo.label));
-		chipinfo.lines = gdev->ngpio;
-		if (copy_to_user(ip, &chipinfo, sizeof(chipinfo)))
-			return -EFAULT;
-		return 0;
+		return chipinfo_get(cdev, ip);
 #ifdef CONFIG_GPIO_CDEV_V1
-	} else if (cmd == GPIO_GET_LINEINFO_IOCTL) {
-		struct gpio_desc *desc;
-		struct gpioline_info lineinfo;
-		struct gpio_v2_line_info lineinfo_v2;
-
-		if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
-			return -EFAULT;
-
-		/* this doubles as a range check on line_offset */
-		desc = gpiochip_get_desc(gc, lineinfo.line_offset);
-		if (IS_ERR(desc))
-			return PTR_ERR(desc);
-
-		gpio_desc_to_lineinfo(desc, &lineinfo_v2);
-		gpio_v2_line_info_to_v1(&lineinfo_v2, &lineinfo);
-
-		if (copy_to_user(ip, &lineinfo, sizeof(lineinfo)))
-			return -EFAULT;
-		return 0;
 	} else if (cmd == GPIO_GET_LINEHANDLE_IOCTL) {
 		return linehandle_create(gdev, ip);
 	} else if (cmd == GPIO_GET_LINEEVENT_IOCTL) {
 		return lineevent_create(gdev, ip);
-	} else if (cmd == GPIO_GET_LINEINFO_WATCH_IOCTL) {
-		struct gpio_desc *desc;
-		struct gpioline_info lineinfo;
-		struct gpio_v2_line_info lineinfo_v2;
-
-		if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
-			return -EFAULT;
-
-		/* this doubles as a range check on line_offset */
-		desc = gpiochip_get_desc(gc, lineinfo.line_offset);
-		if (IS_ERR(desc))
-			return PTR_ERR(desc);
-
-		if (lineinfo_ensure_abi_version(cdev, 1))
-			return -EPERM;
-
-		if (test_and_set_bit(lineinfo.line_offset, cdev->watched_lines))
-			return -EBUSY;
-
-		gpio_desc_to_lineinfo(desc, &lineinfo_v2);
-		gpio_v2_line_info_to_v1(&lineinfo_v2, &lineinfo);
-
-		if (copy_to_user(ip, &lineinfo, sizeof(lineinfo))) {
-			clear_bit(lineinfo.line_offset, cdev->watched_lines);
-			return -EFAULT;
-		}
-
-		return 0;
+	} else if (cmd == GPIO_GET_LINEINFO_IOCTL ||
+		   cmd == GPIO_GET_LINEINFO_WATCH_IOCTL) {
+		return lineinfo_get_v1(cdev, ip,
+				       cmd == GPIO_GET_LINEINFO_WATCH_IOCTL);
 #endif /* CONFIG_GPIO_CDEV_V1 */
 	} else if (cmd == GPIO_V2_GET_LINEINFO_IOCTL ||
 		   cmd == GPIO_V2_GET_LINEINFO_WATCH_IOCTL) {
@@ -2100,16 +2110,7 @@ static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	} else if (cmd == GPIO_V2_GET_LINE_IOCTL) {
 		return linereq_create(gdev, ip);
 	} else if (cmd == GPIO_GET_LINEINFO_UNWATCH_IOCTL) {
-		if (copy_from_user(&offset, ip, sizeof(offset)))
-			return -EFAULT;
-
-		if (offset >= cdev->gdev->ngpio)
-			return -EINVAL;
-
-		if (!test_and_clear_bit(offset, cdev->watched_lines))
-			return -EBUSY;
-
-		return 0;
+		return lineinfo_unwatch(cdev, ip);
 	}
 	return -EINVAL;
 }
-- 
2.27.0



