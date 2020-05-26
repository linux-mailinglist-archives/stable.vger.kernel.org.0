Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B04C1E2A5D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbgEZSzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389363AbgEZSzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92DF8208B3;
        Tue, 26 May 2020 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519313;
        bh=2M33O1g+B+9kR689BYVVVK/Fk67khvaJz+834sBuYn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtLzK9TFFBIanQH7Xy9enYFFmg0xwjDBjKPhYdJSindHe8qfbofPnwG5OAKYTn6ut
         W40mNMj+T9H7UmGDjWxdS72jXTnL1qhs9m0UEgJlRHMVJ4LIy/z33yoKTkwqRnNKCe
         UiVVCuEfX//J9OWC/pcYs8sjywAjjxyMbnuxgm6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erico Nunes <erico.nunes@datacom.ind.br>,
        Wolfram Sang <wsa@the-dreams.de>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/65] i2c: dev: switch from register_chrdev to cdev API
Date:   Tue, 26 May 2020 20:52:39 +0200
Message-Id: <20200526183913.759270679@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erico Nunes <erico.nunes@datacom.ind.br>

commit d6760b14d4a1243f918d983bba1e35c5a5cd5a6d upstream.

i2c-dev had never moved away from the older register_chrdev interface to
implement its char device registration. The register_chrdev API has the
limitation of enabling only up to 256 i2c-dev busses to exist.

Large platforms with lots of i2c devices (i.e. pluggable transceivers)
with dedicated busses may have to exceed that limit.
In particular, there are also platforms making use of the i2c bus
multiplexing API, which instantiates a virtual bus for each possible
multiplexed selection.

This patch removes the register_chrdev usage and replaces it with the
less old cdev API, which takes away the 256 i2c-dev bus limitation.
It should not have any other impact for i2c bus drivers or user space.

This patch has been tested on qemu x86 and qemu powerpc platforms with
the aid of a module which adds and removes 5000 virtual i2c busses, as
well as validated on an existing powerpc hardware platform which makes
use of the i2c bus multiplexing API.
i2c-dev busses with device minor numbers larger than 256 have also been
validated to work with the existing i2c-tools.

Signed-off-by: Erico Nunes <erico.nunes@datacom.ind.br>
[wsa: kept includes sorted]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index e56b774e7cf9..5fecc1d9e0a1 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -22,6 +22,7 @@
 
 /* The I2C_RDWR ioctl code is written by Kolja Waschk <waschk@telos.de> */
 
+#include <linux/cdev.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -47,9 +48,10 @@ struct i2c_dev {
 	struct list_head list;
 	struct i2c_adapter *adap;
 	struct device *dev;
+	struct cdev cdev;
 };
 
-#define I2C_MINORS	256
+#define I2C_MINORS	MINORMASK
 static LIST_HEAD(i2c_dev_list);
 static DEFINE_SPINLOCK(i2c_dev_list_lock);
 
@@ -559,6 +561,12 @@ static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 	if (IS_ERR(i2c_dev))
 		return PTR_ERR(i2c_dev);
 
+	cdev_init(&i2c_dev->cdev, &i2cdev_fops);
+	i2c_dev->cdev.owner = THIS_MODULE;
+	res = cdev_add(&i2c_dev->cdev, MKDEV(I2C_MAJOR, adap->nr), 1);
+	if (res)
+		goto error_cdev;
+
 	/* register this i2c device with the driver core */
 	i2c_dev->dev = device_create(i2c_dev_class, &adap->dev,
 				     MKDEV(I2C_MAJOR, adap->nr), NULL,
@@ -572,6 +580,8 @@ static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 		 adap->name, adap->nr);
 	return 0;
 error:
+	cdev_del(&i2c_dev->cdev);
+error_cdev:
 	return_i2c_dev(i2c_dev);
 	return res;
 }
@@ -591,6 +601,7 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
 
 	return_i2c_dev(i2c_dev);
 	device_destroy(i2c_dev_class, MKDEV(I2C_MAJOR, adap->nr));
+	cdev_del(&i2c_dev->cdev);
 
 	pr_debug("i2c-dev: adapter [%s] unregistered\n", adap->name);
 	return 0;
@@ -627,7 +638,7 @@ static int __init i2c_dev_init(void)
 
 	printk(KERN_INFO "i2c /dev entries driver\n");
 
-	res = register_chrdev(I2C_MAJOR, "i2c", &i2cdev_fops);
+	res = register_chrdev_region(MKDEV(I2C_MAJOR, 0), I2C_MINORS, "i2c");
 	if (res)
 		goto out;
 
@@ -651,7 +662,7 @@ static int __init i2c_dev_init(void)
 out_unreg_class:
 	class_destroy(i2c_dev_class);
 out_unreg_chrdev:
-	unregister_chrdev(I2C_MAJOR, "i2c");
+	unregister_chrdev_region(MKDEV(I2C_MAJOR, 0), I2C_MINORS);
 out:
 	printk(KERN_ERR "%s: Driver Initialisation failed\n", __FILE__);
 	return res;
@@ -662,7 +673,7 @@ static void __exit i2c_dev_exit(void)
 	bus_unregister_notifier(&i2c_bus_type, &i2cdev_notifier);
 	i2c_for_each_dev(NULL, i2cdev_detach_adapter);
 	class_destroy(i2c_dev_class);
-	unregister_chrdev(I2C_MAJOR, "i2c");
+	unregister_chrdev_region(MKDEV(I2C_MAJOR, 0), I2C_MINORS);
 }
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
-- 
2.25.1



