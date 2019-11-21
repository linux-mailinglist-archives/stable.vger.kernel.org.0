Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C031051B3
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 12:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfKULtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 06:49:32 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38066 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfKULta (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 06:49:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id v8so2871305ljh.5
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 03:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=EBZzEvpC+qRcWY/3j7f9XCxXtBQTNBQwmN4ELbmpAo0=;
        b=G8XY2uiTkxcapPVOdegvQGBEBKo+TuSxquatn9UATWXsMHy1qB9/wo5c1fBHQcpIDS
         2KHLU6wV3KdQza6Bnd4hk6EkTtJt4MVo1O2vl37VppEzWVesLz20smNOdHOHOHITdDx3
         5YPn4dCTzN6RcHERjby1szl79xnSfZzjEYdyMYD7Ir8NhmhSqsA7S1kygs+CNvfRRazv
         VNg1okfXejc38zzru5b6ffkthtnyj7hao4jVlJXAwBKh83s/x2lgYI0CShroLWiIIjIq
         axms0VqsrBj/bMxABC4nWWYeMfk1MfcLjfVx0A+PLCz7JZp8uaLLb2it/tWZFWqAq8qX
         jvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=EBZzEvpC+qRcWY/3j7f9XCxXtBQTNBQwmN4ELbmpAo0=;
        b=GIJxhEPZL3H/E0RDHwXqYGeULrlmOV8sjBxbkSy9ZXOvrVViBa8g0tFk15QUWUr8eO
         0LQM+0YIZzL0/8neZfsnL2kdcvYWqoSq+v+lJLFHpIKESa9L579sXxp8ETAKvz7J99yD
         rjpRZuVS4QkcgLAqKeYwMoX385ADoZY+GxbxpUZ3zVZuOnfQmnS0Ja4Vjbvm05PcEOrR
         zXnUU8bSj1TKD2MnWOxFkidN4qUbgFk37LRvnrfm3fMgNXtECIWIh+pwW3lcWhmhJcQO
         7F6h3/4TJ4p/nsEtRrpCvEgMQ1AFTb4BZPgvjIY+vFHjs4gpamWBW/PoKolJ8yoNbv4C
         iREw==
X-Gm-Message-State: APjAAAXeVmou3Lw5HaJsMylZDSTAWVAtn4H94ZCpPUWowDuw6i+v1Bn+
        Oc/5aoYRAwBc61tteUL20Ef/8rj015ophgAaIWotnUn2
X-Google-Smtp-Source: APXvYqxE3GFTtAGgpgdzHV4AdB67yBpECLB8frl2FuDW4sZc60C7mo3vI4bZ92mEj796e1j5DkZvCwHGPknyO5yM9HE=
X-Received: by 2002:a2e:b4eb:: with SMTP id s11mr7113146ljm.38.1574336964372;
 Thu, 21 Nov 2019 03:49:24 -0800 (PST)
MIME-Version: 1.0
From:   Yama Modo <zero19850401@gmail.com>
Date:   Thu, 21 Nov 2019 19:47:37 +0800
Message-ID: <CACgcjHEHxzBkiE6hH3OEUw6V+PZHX7MAKht61OZPbAyAVRDQiQ@mail.gmail.com>
Subject: [PATCH 4.4] gpio: make the gpiochip a real device
To:     linus.walleij@linaro.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Linus Walleij,

I want to backport commit ff2b13592299 "gpio: make the gpiochip a real
device" to linux 4.4.y. Could you please review the following patch? I
will improve this later if something need to take care. Thanks!

From ed8a24f8207b328c89880372c3ddf46e907b2085 Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 21 Nov 2019 18:24:26 +0800
Subject: [PATCH] gpio: make the gpiochip a real device
commit ff2b1359229927563addbf2f5ad480660c350903 upstream
GPIO chips have been around for years, but were never real devices,
instead they were piggy-backing on a parent device (such as a
platform_device or amba_device) but this was always optional.
GPIO chips could also exist without any device at all, with its
struct device *parent (ex *dev) pointer being set to null.
When sysfs was in use, a mock device would be created, with the
optional parent assigned, or just floating orphaned with NULL
as parent.
If sysfs is active, it will use this device as parent.
We now create a gpio_device struct containing a real
struct device and move the subsystem over to using that. The
list of struct gpio_chip:s is augmented to hold struct
gpio_device:s and we find gpio_chips:s by first looking up
the struct gpio_device.
The struct gpio_device is designed to stay around even if the
gpio_chip is removed, so as to satisfy users in userspace
that need a backing data structure to hold the state of the
session initiated with e.g. a character device even if there is
no physical chip anymore.
From this point on, gpiochips are devices.
backport to linux 4.4.y. gpiochip_add() will be changed to
gpiochip_add_data() completely in future because many drivers in
linux 4.4.y still use gpiochip_add(). Besides, it still use
"struct device *dev" in gpio_chip as parent to avoid conflicts for
many drivers.
Cc: Johan Hovold <johan@kernel.org>
Cc: Michael Welling <mwelling@ieee.org>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Johnson Chen <johnsonch.chen@moxa.com>
---
 drivers/gpio/gpiolib-sysfs.c |  12 +-
 drivers/gpio/gpiolib.c       | 278 +++++++++++++++++++++++++++++++------------
 drivers/gpio/gpiolib.h       |  28 ++++-
 include/linux/gpio/driver.h  |  11 +-
 4 files changed, 246 insertions(+), 83 deletions(-)
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index b57ed8e55ab5..5ac9e9b66372 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -547,6 +547,7 @@ static struct class gpio_class = {
 int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 {
  struct gpio_chip *chip;
+ struct gpio_device *gdev;
  struct gpiod_data *data;
  unsigned long  flags;
  int   status;
@@ -566,6 +567,7 @@ int gpiod_export(struct gpio_desc *desc, bool
direction_may_change)
  }

  chip = desc->chip;
+ gdev = chip->gpiodev;

  mutex_lock(&sysfs_lock);

@@ -605,7 +607,7 @@ int gpiod_export(struct gpio_desc *desc, bool
direction_may_change)
  if (chip->names && chip->names[offset])
   ioname = chip->names[offset];

- dev = device_create_with_groups(&gpio_class, chip->dev,
+ dev = device_create_with_groups(&gpio_class, &gdev->dev,
      MKDEV(0, 0), data, gpio_groups,
      ioname ? ioname : "gpio%u",
      desc_to_gpio(desc));
@@ -770,7 +772,7 @@ static int __init gpiolib_sysfs_init(void)
 {
  int  status;
  unsigned long flags;
- struct gpio_chip *chip;
+    struct gpio_device *gdev;

  status = class_register(&gpio_class);
  if (status < 0)
@@ -783,8 +785,8 @@ static int __init gpiolib_sysfs_init(void)
   * registered, and so arch_initcall() can always gpio_export().
   */
  spin_lock_irqsave(&gpio_lock, flags);
- list_for_each_entry(chip, &gpio_chips, list) {
-  if (chip->cdev)
+ list_for_each_entry(gdev, &gpio_devices, list) {
+  if (gdev->chip->cdev)
    continue;

   /*
@@ -797,7 +799,7 @@ static int __init gpiolib_sysfs_init(void)
    * gpio_lock prevents us from doing this.
    */
   spin_unlock_irqrestore(&gpio_lock, flags);
-  status = gpiochip_sysfs_register(chip);
+  status = gpiochip_sysfs_register(gdev->chip);
   spin_lock_irqsave(&gpio_lock, flags);
  }
  spin_unlock_irqrestore(&gpio_lock, flags);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index fe89fd56eabf..90333cd092fc 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -16,7 +16,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/gpio/machine.h>
 #include <linux/pinctrl/consumer.h>
-
+#include <linux/idr.h>
 #include "gpiolib.h"

 #define CREATE_TRACE_POINTS
@@ -42,6 +42,10 @@
 #define extra_checks 0
 #endif

+/* Device and char device-related information */
+static DEFINE_IDA(gpio_ida);
+
+
 /* gpio_lock prevents conflicts during gpio_desc[] table updates.
  * While any GPIO is requested, its gpio_chip is not removable;
  * each GPIO's "requested" flag serves as a lock and refcount.
@@ -50,7 +54,7 @@ DEFINE_SPINLOCK(gpio_lock);

 static DEFINE_MUTEX(gpio_lookup_lock);
 static LIST_HEAD(gpio_lookup_list);
-LIST_HEAD(gpio_chips);
+LIST_HEAD(gpio_devices);


 static void gpiochip_free_hogs(struct gpio_chip *chip);
@@ -67,15 +71,16 @@ static inline void desc_set_label(struct gpio_desc
*d, const char *label)
  */
 struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
- struct gpio_chip *chip;
+ struct gpio_device *gdev;
  unsigned long flags;

  spin_lock_irqsave(&gpio_lock, flags);

- list_for_each_entry(chip, &gpio_chips, list) {
-  if (chip->base <= gpio && chip->base + chip->ngpio > gpio) {
+ list_for_each_entry(gdev, &gpio_devices, list) {
+  if (gdev->chip->base <= gpio &&
+      gdev->chip->base + gdev->chip->ngpio > gpio) {
    spin_unlock_irqrestore(&gpio_lock, flags);
-   return &chip->desc[gpio - chip->base];
+   return &gdev->chip->desc[gpio - gdev->chip->base];
   }
  }

@@ -125,16 +130,16 @@ EXPORT_SYMBOL_GPL(gpiod_to_chip);
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
 static int gpiochip_find_base(int ngpio)
 {
- struct gpio_chip *chip;
+ struct gpio_device *gdev;
  int base = ARCH_NR_GPIOS - ngpio;

- list_for_each_entry_reverse(chip, &gpio_chips, list) {
+ list_for_each_entry_reverse(gdev, &gpio_devices, list) {
   /* found a free space? */
-  if (chip->base + chip->ngpio <= base)
+  if (gdev->chip->base + gdev->chip->ngpio <= base)
    break;
   else
    /* nope, check the space right before the chip */
-   base = chip->base - ngpio;
+   base = gdev->chip->base - ngpio;
  }

  if (gpio_is_valid(base)) {
@@ -182,39 +187,72 @@ EXPORT_SYMBOL_GPL(gpiod_get_direction);

 /*
  * Add a new chip to the global chips list, keeping the list of chips sorted
- * by base order.
+ * by range(means [base, base + ngpio - 1]) order.
  *
  * Return -EBUSY if the new chip overlaps with some other chip's integer
  * space.
  */
-static int gpiochip_add_to_list(struct gpio_chip *chip)
+static int gpiodev_add_to_list(struct gpio_device *gdev)
 {
- struct list_head *pos;
- struct gpio_chip *_chip;
- int err = 0;
+ struct gpio_device *iterator;
+ struct gpio_device *previous = NULL;

- /* find where to insert our chip */
- list_for_each(pos, &gpio_chips) {
-  _chip = list_entry(pos, struct gpio_chip, list);
-  /* shall we insert before _chip? */
-  if (_chip->base >= chip->base + chip->ngpio)
-   break;
+ if (!gdev->chip)
+  return -EINVAL;
+
+ if (list_empty(&gpio_devices)) {
+  list_add_tail(&gdev->list, &gpio_devices);
+  return 0;
  }

- /* are we stepping on the chip right before? */
- if (pos != &gpio_chips && pos->prev != &gpio_chips) {
-  _chip = list_entry(pos->prev, struct gpio_chip, list);
-  if (_chip->base + _chip->ngpio > chip->base) {
-   dev_err(chip->dev,
-          "GPIO integer space overlap, cannot add chip\n");
-   err = -EBUSY;
+ list_for_each_entry(iterator, &gpio_devices, list) {
+  /*
+   * The list may contain dangling GPIO devices with no
+   * live chip assigned.
+   */
+  if (!iterator->chip)
+   continue;
+  if (iterator->chip->base >=
+      gdev->chip->base + gdev->chip->ngpio) {
+   /*
+    * Iterator is the first GPIO chip so there is no
+    * previous one
+    */
+   if (!previous) {
+    goto found;
+   } else {
+    /*
+     * We found a valid range(means
+     * [base, base + ngpio - 1]) between previous
+     * and iterator chip.
+     */
+    if (previous->chip->base + previous->chip->ngpio
+      <= gdev->chip->base)
+     goto found;
+   }
   }
+  previous = iterator;
  }

- if (!err)
-  list_add_tail(&chip->list, pos);
+ /*
+  * We are beyond the last chip in the list and iterator now
+  * points to the head.
+  * Let iterator point to the last chip in the list.
+  */

- return err;
+ iterator = list_last_entry(&gpio_devices, struct gpio_device, list);
+ if (iterator->chip->base + iterator->chip->ngpio <= gdev->chip->base) {
+  list_add(&gdev->list, &iterator->list);
+  return 0;
+ }
+
+ dev_err(&gdev->dev,
+        "GPIO integer space overlap, cannot add chip\n");
+ return -EBUSY;
+
+found:
+ list_add_tail(&gdev->list, &iterator->list);
+ return 0;
 }

 /**
@@ -222,16 +260,16 @@ static int gpiochip_add_to_list(struct gpio_chip *chip)
  */
 static struct gpio_desc *gpio_name_to_desc(const char * const name)
 {
- struct gpio_chip *chip;
+ struct gpio_device *gdev;
  unsigned long flags;

  spin_lock_irqsave(&gpio_lock, flags);

- list_for_each_entry(chip, &gpio_chips, list) {
+ list_for_each_entry(gdev, &gpio_devices, list) {
   int i;

-  for (i = 0; i != chip->ngpio; ++i) {
-   struct gpio_desc *gpio = &chip->desc[i];
+  for (i = 0; i != gdev->chip->ngpio; ++i) {
+   struct gpio_desc *gpio = &gdev->chip->desc[i];

    if (!gpio->name || !name)
     continue;
@@ -279,6 +317,14 @@ static int gpiochip_set_desc_names(struct gpio_chip *gc)
  return 0;
 }

+static void gpiodevice_release(struct device *dev)
+{
+ struct gpio_device *gdev = dev_get_drvdata(dev);
+
+ list_del(&gdev->list);
+ ida_simple_remove(&gpio_ida, gdev->id);
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -296,17 +342,67 @@ static int gpiochip_set_desc_names(struct gpio_chip *gc)
  * If chip->base is negative, this requests dynamic assignment of
  * a range of valid GPIOs.
  */
+//TODO:Change to gpiochip_add_data(struct gpio_chip *chip, void *data)
 int gpiochip_add(struct gpio_chip *chip)
 {
  unsigned long flags;
  int  status = 0;
- unsigned id;
+ unsigned i;
  int  base = chip->base;
  struct gpio_desc *descs;
+ struct gpio_device *gdev;

- descs = kcalloc(chip->ngpio, sizeof(descs[0]), GFP_KERNEL);
- if (!descs)
+ /*
+  * First: allocate and populate the internal stat container, and
+  * set up the struct device.
+  */
+ gdev = kmalloc(sizeof(*gdev), GFP_KERNEL);
+ if (!gdev)
   return -ENOMEM;
+ gdev->chip = chip;
+ chip->gpiodev = gdev;
+ if (chip->dev) {
+  gdev->dev.parent = chip->dev;
+  gdev->dev.of_node = chip->dev->of_node;
+ } else {
+#ifdef CONFIG_OF_GPIO
+ /* If the gpiochip has an assigned OF node this takes precedence */
+  if (chip->of_node)
+   gdev->dev.of_node = chip->of_node;
+#endif
+ }
+ gdev->id = ida_simple_get(&gpio_ida, 0, 0, GFP_KERNEL);
+ if (gdev->id < 0) {
+  status = gdev->id;
+  goto err_free_gdev;
+ }
+ dev_set_name(&gdev->dev, "gpiochip%d", gdev->id);
+ device_initialize(&gdev->dev);
+ dev_set_drvdata(&gdev->dev, gdev);
+ if (chip->dev && chip->dev->driver)
+  gdev->owner = chip->dev->driver->owner;
+ else if (chip->owner)
+  /* TODO: remove chip->owner */
+  gdev->owner = chip->owner;
+ else
+  gdev->owner = THIS_MODULE;
+
+ /* FIXME: devm_kcalloc() these and move to gpio_device */
+ descs = kcalloc(chip->ngpio, sizeof(descs[0]), GFP_KERNEL);
+ if (!descs) {
+  status = -ENOMEM;
+  goto err_free_gdev;
+ }
+
+ /* FIXME: move driver data into gpio_device dev_set_drvdata() */
+ /* FIXME: should save data when using gpiochip_add_data() rather
than gpiochip_add() */
+ //chip->data = data;
+
+ if (chip->ngpio == 0) {
+  chip_err(chip, "tried to insert a GPIO chip with zero lines\n");
+  status = -EINVAL;
+  goto err_free_descs;
+ }

  spin_lock_irqsave(&gpio_lock, flags);

@@ -320,15 +416,16 @@ int gpiochip_add(struct gpio_chip *chip)
   chip->base = base;
  }

- status = gpiochip_add_to_list(chip);
+ status = gpiodev_add_to_list(gdev);
  if (status) {
   spin_unlock_irqrestore(&gpio_lock, flags);
   goto err_free_descs;
  }

- for (id = 0; id < chip->ngpio; id++) {
-  struct gpio_desc *desc = &descs[id];
+ for (i = 0; i < chip->ngpio; i++) {
+  struct gpio_desc *desc = &descs[i];

+  /* REVISIT: maybe a pointer to gpio_device is better */
   desc->chip = chip;

   /* REVISIT: most hardware initializes GPIOs as inputs (often
@@ -339,18 +436,15 @@ int gpiochip_add(struct gpio_chip *chip)
    */
   desc->flags = !chip->direction_input ? (1 << FLAG_IS_OUT) : 0;
  }
-
  chip->desc = descs;

  spin_unlock_irqrestore(&gpio_lock, flags);

 #ifdef CONFIG_PINCTRL
+ /* FIXME: move pin ranges to gpio_device */
  INIT_LIST_HEAD(&chip->pin_ranges);
 #endif

- if (!chip->owner && chip->dev && chip->dev->driver)
-  chip->owner = chip->dev->driver->owner;
-
  status = gpiochip_set_desc_names(chip);
  if (status)
   goto err_remove_from_list;
@@ -361,28 +455,39 @@ int gpiochip_add(struct gpio_chip *chip)

  acpi_gpiochip_add(chip);

- status = gpiochip_sysfs_register(chip);
+ status = device_add(&gdev->dev);
  if (status)
   goto err_remove_chip;

+ status = gpiochip_sysfs_register(chip);
+ if (status)
+  goto err_remove_device;
+
+ /* From this point, the .release() function cleans up gpio_device */
+ gdev->dev.release = gpiodevice_release;
+ get_device(&gdev->dev);
  pr_debug("%s: registered GPIOs %d to %d on device: %s\n", __func__,
   chip->base, chip->base + chip->ngpio - 1,
   chip->label ? : "generic");

  return 0;

+err_remove_device:
+ device_del(&gdev->dev);
 err_remove_chip:
  acpi_gpiochip_remove(chip);
  gpiochip_free_hogs(chip);
  of_gpiochip_remove(chip);
 err_remove_from_list:
  spin_lock_irqsave(&gpio_lock, flags);
- list_del(&chip->list);
+ list_del(&gdev->list);
  spin_unlock_irqrestore(&gpio_lock, flags);
  chip->desc = NULL;
 err_free_descs:
  kfree(descs);
-
+err_free_gdev:
+ ida_simple_remove(&gpio_ida, gdev->id);
+ kfree(gdev);
  /* failures here can mean systems won't boot... */
  pr_err("%s: GPIOs %d..%d (%s) failed to register\n", __func__,
   chip->base, chip->base + chip->ngpio - 1,
@@ -399,13 +504,17 @@ EXPORT_SYMBOL_GPL(gpiochip_add);
  */
 void gpiochip_remove(struct gpio_chip *chip)
 {
+    struct gpio_device *gdev = chip->gpiodev;
  struct gpio_desc *desc;
  unsigned long flags;
  unsigned id;
  bool  requested = false;

- gpiochip_sysfs_unregister(chip);
+ /* Numb the device, cancelling all outstanding operations */
+ gdev->chip = NULL;

+ /* FIXME: should the legacy sysfs handling be moved to gpio_device? */
+ gpiochip_sysfs_unregister(chip);
  gpiochip_irqchip_remove(chip);

  acpi_gpiochip_remove(chip);
@@ -420,14 +529,23 @@ void gpiochip_remove(struct gpio_chip *chip)
   if (test_bit(FLAG_REQUESTED, &desc->flags))
    requested = true;
  }
- list_del(&chip->list);
+
  spin_unlock_irqrestore(&gpio_lock, flags);

  if (requested)
   dev_crit(chip->dev, "REMOVING GPIOCHIP WITH GPIOS STILL REQUESTED\n");

+    /* FIXME: need to be moved to gpio_device and held there */
  kfree(chip->desc);
  chip->desc = NULL;
+
+ /*
+  * The gpiochip side puts its use of the device to rest here:
+  * if there are no userspace clients, the chardev and device will
+  * be removed, else it will be dangling until the last user is
+  * gone.
+  */
+ put_device(&gdev->dev);
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);

@@ -446,17 +564,21 @@ struct gpio_chip *gpiochip_find(void *data,
     int (*match)(struct gpio_chip *chip,
           void *data))
 {
+    struct gpio_device *gdev;
  struct gpio_chip *chip;
  unsigned long flags;

  spin_lock_irqsave(&gpio_lock, flags);
- list_for_each_entry(chip, &gpio_chips, list)
-  if (match(chip, data))
+ list_for_each_entry(gdev, &gpio_devices, list)
+  if (match(gdev->chip, data))
    break;

  /* No match? */
- if (&chip->list == &gpio_chips)
+ if (&gdev->list == &gpio_devices)
   chip = NULL;
+ else
+  chip = gdev->chip;
+
  spin_unlock_irqrestore(&gpio_lock, flags);

  return chip;
@@ -586,14 +708,14 @@ static int gpiochip_irq_reqres(struct irq_data *d)
 {
  struct gpio_chip *chip = irq_data_get_irq_chip_data(d);

- if (!try_module_get(chip->owner))
+ if (!try_module_get(chip->gpiodev->owner))
   return -ENODEV;

  if (gpiochip_lock_as_irq(chip, d->hwirq)) {
   chip_err(chip,
    "unable to lock HW IRQ %lu for IRQ\n",
    d->hwirq);
-  module_put(chip->owner);
+  module_put(chip->gpiodev->owner);
   return -EINVAL;
  }
  return 0;
@@ -604,7 +726,7 @@ static void gpiochip_irq_relres(struct irq_data *d)
  struct gpio_chip *chip = irq_data_get_irq_chip_data(d);

  gpiochip_unlock_as_irq(chip, d->hwirq);
- module_put(chip->owner);
+ module_put(chip->gpiodev->owner);
 }

 static int gpiochip_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -945,10 +1067,10 @@ int gpiod_request(struct gpio_desc *desc, const
char *label)
  if (!chip)
   goto done;

- if (try_module_get(chip->owner)) {
+ if (try_module_get(chip->gpiodev->owner)) {
   status = __gpiod_request(desc, label);
   if (status < 0)
-   module_put(chip->owner);
+   module_put(chip->gpiodev->owner);
  }

 done:
@@ -994,7 +1116,7 @@ static bool __gpiod_free(struct gpio_desc *desc)
 void gpiod_free(struct gpio_desc *desc)
 {
  if (desc && __gpiod_free(desc))
-  module_put(desc->chip->owner);
+  module_put(desc->chip->gpiodev->owner);
  else
   WARN_ON(extra_checks);
 }
@@ -2449,16 +2571,16 @@ static void gpiolib_dbg_show(struct seq_file
*s, struct gpio_chip *chip)
 static void *gpiolib_seq_start(struct seq_file *s, loff_t *pos)
 {
  unsigned long flags;
- struct gpio_chip *chip = NULL;
+ struct gpio_device *gdev = NULL;
  loff_t index = *pos;

  s->private = "";

  spin_lock_irqsave(&gpio_lock, flags);
- list_for_each_entry(chip, &gpio_chips, list)
+ list_for_each_entry(gdev, &gpio_devices, list)
   if (index-- == 0) {
    spin_unlock_irqrestore(&gpio_lock, flags);
-   return chip;
+   return gdev;
   }
  spin_unlock_irqrestore(&gpio_lock, flags);

@@ -2468,14 +2590,14 @@ static void *gpiolib_seq_start(struct seq_file
*s, loff_t *pos)
 static void *gpiolib_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
  unsigned long flags;
- struct gpio_chip *chip = v;
+ struct gpio_device *gdev = v;
  void *ret = NULL;

  spin_lock_irqsave(&gpio_lock, flags);
- if (list_is_last(&chip->list, &gpio_chips))
+ if (list_is_last(&gdev->list, &gpio_devices))
   ret = NULL;
  else
-  ret = list_entry(chip->list.next, struct gpio_chip, list);
+  ret = list_entry(gdev->list.next, struct gpio_device, list);
  spin_unlock_irqrestore(&gpio_lock, flags);

  s->private = "\n";
@@ -2490,15 +2612,25 @@ static void gpiolib_seq_stop(struct seq_file
*s, void *v)

 static int gpiolib_seq_show(struct seq_file *s, void *v)
 {
- struct gpio_chip *chip = v;
- struct device *dev;
+ struct gpio_device *gdev = v;
+ struct gpio_chip *chip = gdev->chip;
+ struct device *parent;
+
+ if (!chip) {
+  seq_printf(s, "%s%s: (dangling chip)", (char *)s->private,
+      dev_name(&gdev->dev));
+  return 0;
+ }
+
+ seq_printf(s, "%s%s: GPIOs %d-%d", (char *)s->private,
+     dev_name(&gdev->dev),
+     chip->base, chip->base + chip->ngpio - 1);
+ parent = chip->dev;
+ if (parent)
+  seq_printf(s, ", parent: %s/%s",
+      parent->bus ? parent->bus->name : "no-bus",
+      dev_name(parent));

- seq_printf(s, "%sGPIOs %d-%d", (char *)s->private,
-   chip->base, chip->base + chip->ngpio - 1);
- dev = chip->dev;
- if (dev)
-  seq_printf(s, ", %s/%s", dev->bus ? dev->bus->name : "no-bus",
-   dev_name(dev));
  if (chip->label)
   seq_printf(s, ", %s", chip->label);
  if (chip->can_sleep)
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 07541c5670e6..9f73641f484b 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -12,13 +12,39 @@
 #ifndef GPIOLIB_H
 #define GPIOLIB_H

+#include <linux/gpio/driver.h>
 #include <linux/err.h>
 #include <linux/device.h>
+#include <linux/module.h>
+#include <linux/cdev.h>

 enum of_gpio_flags;

 struct acpi_device;

+ /**
+ * struct gpio_device - internal state container for GPIO devices
+ * @id: numerical ID number for the GPIO chip
+ * @dev: the GPIO device struct
+ * @owner: helps prevent removal of modules exporting active GPIOs
+ * @chip: pointer to the corresponding gpiochip, holding static
+ * data for this device
+ * @list: links gpio_device:s together for traversal
+ *
+ * This state container holds most of the runtime variable data
+ * for a GPIO device and can hold references and live on after the
+ * GPIO chip has been removed, if it is still being used from
+ * userspace.
+ */
+struct gpio_device {
+ int   id;
+ struct device  dev;
+ struct module  *owner;
+ struct gpio_chip *chip;
+ struct list_head        list;
+};
+
+
 /**
  * struct acpi_gpio_info - ACPI GPIO specific information
  * @gpioint: if %true this GPIO is of type GpioInt otherwise type is GpioIo
@@ -81,7 +107,7 @@ struct gpio_desc *of_get_named_gpiod_flags(struct
device_node *np,
 struct gpio_desc *gpiochip_get_desc(struct gpio_chip *chip, u16 hwnum);

 extern struct spinlock gpio_lock;
-extern struct list_head gpio_chips;
+extern struct list_head gpio_devices;

 struct gpio_desc {
  struct gpio_chip *chip;
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index d1baebf350d8..a6cfe844f6e0 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -8,8 +8,9 @@
 #include <linux/irqdomain.h>
 #include <linux/lockdep.h>
 #include <linux/pinctrl/pinctrl.h>
+#include <linux/device.h>

-struct device;
+struct gpio_device;
 struct gpio_desc;
 struct of_phandle_args;
 struct device_node;
@@ -20,10 +21,11 @@ struct seq_file;
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
- * @dev: optional device providing the GPIOs
+ * @dev: optional parent device providing the GPIOs
+ * @gpiodev: the internal state holder, opaque struct
  * @cdev: class device used by sysfs interface (may be NULL)
  * @owner: helps prevent removal of modules exporting active GPIOs
- * @list: links gpio_chips together for traversal
+ * @data: per-instance data assigned by the driver
  * @request: optional hook for chip-specific activation, such as
  * enabling module power and clock; may sleep
  * @free: optional hook for chip-specific deactivation, such as
@@ -89,10 +91,11 @@ struct seq_file;
  */
 struct gpio_chip {
  const char  *label;
+ struct gpio_device *gpiodev;
  struct device  *dev;
  struct device  *cdev;
  struct module  *owner;
- struct list_head        list;
+ void                    *data;

  int   (*request)(struct gpio_chip *chip,
       unsigned offset);
-- 
2.11.0

Best regards,
Johnson
