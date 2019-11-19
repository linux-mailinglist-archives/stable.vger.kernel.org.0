Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66ED102878
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfKSPqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:46:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40434 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728532AbfKSPqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 10:46:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574178409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fKpJzcmqOb0Dq6achzcCkYjRfMAfunTfFUhAGjK8vLI=;
        b=UzgJKLn0nKN+z9kgRldyLceCzb88/oBTxtO+q++RPAc9uNCQ6UAW5b5kh+AHaJYSHMliG8
        agcGW9guSXHUtn9L0rm7ZSfWc6ZYV2taobE3jAGHu1ojAL8IiSl/WWDFqbC+PEnmmfCAF2
        ogwl299GKklix3GMkkoqPwN11EFyKtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-a80S6LXOO_C6aKBUY9ehWA-1; Tue, 19 Nov 2019 10:46:46 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEE5818B9F7F;
        Tue, 19 Nov 2019 15:46:44 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-117-49.ams2.redhat.com [10.36.117.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08B3146E75;
        Tue, 19 Nov 2019 15:46:42 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] pinctrl: baytrail: Really serialize all register accesses
Date:   Tue, 19 Nov 2019 16:46:41 +0100
Message-Id: <20191119154641.202139-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: a80S6LXOO_C6aKBUY9ehWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
added a spinlock around all register accesses because:

"There is a hardware issue in Intel Baytrail where concurrent GPIO register
 access might result reads of 0xffffffff and writes might get dropped
 completely."

Testing has shown that this does not catch all cases, there are still
2 problems remaining

1) The original fix uses a spinlock per byt_gpio device / struct,
additional testing has shown that this is not sufficient concurent
accesses to 2 different GPIO banks also suffer from the same problem.

This commit fixes this by moving to a single global lock.

2) The original fix did not add a lock around the register accesses in
the suspend/resume handling.

Since pinctrl-baytrail.c is using normal suspend/resume handlers,
interrupts are still enabled during suspend/resume handling. Nothing
should be using the GPIOs when they are being taken down, _but_ the
GPIOs themselves may still cause interrupts, which are likely to
use (read) the triggering GPIO. So we need to protect against
concurrent GPIO register accesses in the suspend/resume handlers too.

This commit fixes this by adding the missing spin_lock / unlock calls.

The 2 fixes together fix the Acer Switch 10 SW5-012 getting completely
confused after a suspend resume. The DSDT for this device has a bug
in its _LID method which reprograms the home and power button trigger-
flags requesting both high and low _level_ interrupts so the IRQs for
these 2 GPIOs continuously fire. This combined with the saving of
registers during suspend, triggers concurrent GPIO register accesses
resulting in saving 0xffffffff as pconf0 value during suspend and then
when restoring this on resume the pinmux settings get all messed up,
resulting in various I2C busses being stuck, the wifi no longer working
and often the tablet simply not coming out of suspend at all.

Cc: stable@vger.kernel.org
Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Rename byt_gpio_lock to byt_lock
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 81 +++++++++++++-----------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/int=
el/pinctrl-baytrail.c
index b18336d42252..3a6404b6fd7e 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -111,7 +111,6 @@ struct byt_gpio {
 =09struct platform_device *pdev;
 =09struct pinctrl_dev *pctl_dev;
 =09struct pinctrl_desc pctl_desc;
-=09raw_spinlock_t lock;
 =09const struct intel_pinctrl_soc_data *soc_data;
 =09struct intel_community *communities_copy;
 =09struct byt_gpio_pin_context *saved_context;
@@ -550,6 +549,8 @@ static const struct intel_pinctrl_soc_data *byt_soc_dat=
a[] =3D {
 =09NULL
 };
=20
+static DEFINE_RAW_SPINLOCK(byt_lock);
+
 static struct intel_community *byt_get_community(struct byt_gpio *vg,
 =09=09=09=09=09=09 unsigned int pin)
 {
@@ -659,7 +660,7 @@ static void byt_set_group_simple_mux(struct byt_gpio *v=
g,
 =09unsigned long flags;
 =09int i;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
=20
 =09for (i =3D 0; i < group.npins; i++) {
 =09=09void __iomem *padcfg0;
@@ -679,7 +680,7 @@ static void byt_set_group_simple_mux(struct byt_gpio *v=
g,
 =09=09writel(value, padcfg0);
 =09}
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static void byt_set_group_mixed_mux(struct byt_gpio *vg,
@@ -689,7 +690,7 @@ static void byt_set_group_mixed_mux(struct byt_gpio *vg=
,
 =09unsigned long flags;
 =09int i;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
=20
 =09for (i =3D 0; i < group.npins; i++) {
 =09=09void __iomem *padcfg0;
@@ -709,7 +710,7 @@ static void byt_set_group_mixed_mux(struct byt_gpio *vg=
,
 =09=09writel(value, padcfg0);
 =09}
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static int byt_set_mux(struct pinctrl_dev *pctldev, unsigned int func_sele=
ctor,
@@ -750,11 +751,11 @@ static void byt_gpio_clear_triggering(struct byt_gpio=
 *vg, unsigned int offset)
 =09unsigned long flags;
 =09u32 value;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09value =3D readl(reg);
 =09value &=3D ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
 =09writel(value, reg);
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static int byt_gpio_request_enable(struct pinctrl_dev *pctl_dev,
@@ -766,7 +767,7 @@ static int byt_gpio_request_enable(struct pinctrl_dev *=
pctl_dev,
 =09u32 value, gpio_mux;
 =09unsigned long flags;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
=20
 =09/*
 =09 * In most cases, func pin mux 000 means GPIO function.
@@ -788,7 +789,7 @@ static int byt_gpio_request_enable(struct pinctrl_dev *=
pctl_dev,
 =09=09=09 "pin %u forcibly re-configured as GPIO\n", offset);
 =09}
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09pm_runtime_get(&vg->pdev->dev);
=20
@@ -816,7 +817,7 @@ static int byt_gpio_set_direction(struct pinctrl_dev *p=
ctl_dev,
 =09unsigned long flags;
 =09u32 value;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
=20
 =09value =3D readl(val_reg);
 =09value &=3D ~BYT_DIR_MASK;
@@ -833,7 +834,7 @@ static int byt_gpio_set_direction(struct pinctrl_dev *p=
ctl_dev,
 =09=09     "Potential Error: Setting GPIO with direct_irq_en to output");
 =09writel(value, val_reg);
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09return 0;
 }
@@ -902,11 +903,11 @@ static int byt_pin_config_get(struct pinctrl_dev *pct=
l_dev, unsigned int offset,
 =09u32 conf, pull, val, debounce;
 =09u16 arg =3D 0;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09conf =3D readl(conf_reg);
 =09pull =3D conf & BYT_PULL_ASSIGN_MASK;
 =09val =3D readl(val_reg);
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09switch (param) {
 =09case PIN_CONFIG_BIAS_DISABLE:
@@ -933,9 +934,9 @@ static int byt_pin_config_get(struct pinctrl_dev *pctl_=
dev, unsigned int offset,
 =09=09if (!(conf & BYT_DEBOUNCE_EN))
 =09=09=09return -EINVAL;
=20
-=09=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09=09debounce =3D readl(db_reg);
-=09=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09=09switch (debounce & BYT_DEBOUNCE_PULSE_MASK) {
 =09=09case BYT_DEBOUNCE_PULSE_375US:
@@ -987,7 +988,7 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_=
dev,
 =09u32 conf, val, debounce;
 =09int i, ret =3D 0;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
=20
 =09conf =3D readl(conf_reg);
 =09val =3D readl(val_reg);
@@ -1095,7 +1096,7 @@ static int byt_pin_config_set(struct pinctrl_dev *pct=
l_dev,
 =09if (!ret)
 =09=09writel(conf, conf_reg);
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09return ret;
 }
@@ -1120,9 +1121,9 @@ static int byt_gpio_get(struct gpio_chip *chip, unsig=
ned int offset)
 =09unsigned long flags;
 =09u32 val;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09val =3D readl(reg);
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09return !!(val & BYT_LEVEL);
 }
@@ -1137,13 +1138,13 @@ static void byt_gpio_set(struct gpio_chip *chip, un=
signed int offset, int value)
 =09if (!reg)
 =09=09return;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09old_val =3D readl(reg);
 =09if (value)
 =09=09writel(old_val | BYT_LEVEL, reg);
 =09else
 =09=09writel(old_val & ~BYT_LEVEL, reg);
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int off=
set)
@@ -1156,9 +1157,9 @@ static int byt_gpio_get_direction(struct gpio_chip *c=
hip, unsigned int offset)
 =09if (!reg)
 =09=09return -EINVAL;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09value =3D readl(reg);
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09if (!(value & BYT_OUTPUT_EN))
 =09=09return 0;
@@ -1201,14 +1202,14 @@ static void byt_gpio_dbg_show(struct seq_file *s, s=
truct gpio_chip *chip)
 =09=09const char *label;
 =09=09unsigned int pin;
=20
-=09=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09=09pin =3D vg->soc_data->pins[i].number;
 =09=09reg =3D byt_gpio_reg(vg, pin, BYT_CONF0_REG);
 =09=09if (!reg) {
 =09=09=09seq_printf(s,
 =09=09=09=09   "Could not retrieve pin %i conf0 reg\n",
 =09=09=09=09   pin);
-=09=09=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09=09=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 =09=09=09continue;
 =09=09}
 =09=09conf0 =3D readl(reg);
@@ -1217,11 +1218,11 @@ static void byt_gpio_dbg_show(struct seq_file *s, s=
truct gpio_chip *chip)
 =09=09if (!reg) {
 =09=09=09seq_printf(s,
 =09=09=09=09   "Could not retrieve pin %i val reg\n", pin);
-=09=09=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09=09=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 =09=09=09continue;
 =09=09}
 =09=09val =3D readl(reg);
-=09=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09=09comm =3D byt_get_community(vg, pin);
 =09=09if (!comm) {
@@ -1305,9 +1306,9 @@ static void byt_irq_ack(struct irq_data *d)
 =09if (!reg)
 =09=09return;
=20
-=09raw_spin_lock(&vg->lock);
+=09raw_spin_lock(&byt_lock);
 =09writel(BIT(offset % 32), reg);
-=09raw_spin_unlock(&vg->lock);
+=09raw_spin_unlock(&byt_lock);
 }
=20
 static void byt_irq_mask(struct irq_data *d)
@@ -1331,7 +1332,7 @@ static void byt_irq_unmask(struct irq_data *d)
 =09if (!reg)
 =09=09return;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09value =3D readl(reg);
=20
 =09switch (irqd_get_trigger_type(d)) {
@@ -1354,7 +1355,7 @@ static void byt_irq_unmask(struct irq_data *d)
=20
 =09writel(value, reg);
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static int byt_irq_type(struct irq_data *d, unsigned int type)
@@ -1368,7 +1369,7 @@ static int byt_irq_type(struct irq_data *d, unsigned =
int type)
 =09if (!reg || offset >=3D vg->chip.ngpio)
 =09=09return -EINVAL;
=20
-=09raw_spin_lock_irqsave(&vg->lock, flags);
+=09raw_spin_lock_irqsave(&byt_lock, flags);
 =09value =3D readl(reg);
=20
 =09WARN(value & BYT_DIRECT_IRQ_EN,
@@ -1390,7 +1391,7 @@ static int byt_irq_type(struct irq_data *d, unsigned =
int type)
 =09else if (type & IRQ_TYPE_LEVEL_MASK)
 =09=09irq_set_handler_locked(d, handle_level_irq);
=20
-=09raw_spin_unlock_irqrestore(&vg->lock, flags);
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 =09return 0;
 }
@@ -1417,9 +1418,9 @@ static void byt_gpio_irq_handler(struct irq_desc *des=
c)
 =09=09=09continue;
 =09=09}
=20
-=09=09raw_spin_lock(&vg->lock);
+=09=09raw_spin_lock(&byt_lock);
 =09=09pending =3D readl(reg);
-=09=09raw_spin_unlock(&vg->lock);
+=09=09raw_spin_unlock(&byt_lock);
 =09=09for_each_set_bit(pin, &pending, 32) {
 =09=09=09virq =3D irq_find_mapping(vg->chip.irq.domain, base + pin);
 =09=09=09generic_handle_irq(virq);
@@ -1646,8 +1647,6 @@ static int byt_pinctrl_probe(struct platform_device *=
pdev)
 =09=09return PTR_ERR(vg->pctl_dev);
 =09}
=20
-=09raw_spin_lock_init(&vg->lock);
-
 =09ret =3D byt_gpio_probe(vg);
 =09if (ret)
 =09=09return ret;
@@ -1662,8 +1661,11 @@ static int byt_pinctrl_probe(struct platform_device =
*pdev)
 static int byt_gpio_suspend(struct device *dev)
 {
 =09struct byt_gpio *vg =3D dev_get_drvdata(dev);
+=09unsigned long flags;
 =09int i;
=20
+=09raw_spin_lock_irqsave(&byt_lock, flags);
+
 =09for (i =3D 0; i < vg->soc_data->npins; i++) {
 =09=09void __iomem *reg;
 =09=09u32 value;
@@ -1684,14 +1686,18 @@ static int byt_gpio_suspend(struct device *dev)
 =09=09vg->saved_context[i].val =3D value;
 =09}
=20
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 =09return 0;
 }
=20
 static int byt_gpio_resume(struct device *dev)
 {
 =09struct byt_gpio *vg =3D dev_get_drvdata(dev);
+=09unsigned long flags;
 =09int i;
=20
+=09raw_spin_lock_irqsave(&byt_lock, flags);
+
 =09for (i =3D 0; i < vg->soc_data->npins; i++) {
 =09=09void __iomem *reg;
 =09=09u32 value;
@@ -1729,6 +1735,7 @@ static int byt_gpio_resume(struct device *dev)
 =09=09}
 =09}
=20
+=09raw_spin_unlock_irqrestore(&byt_lock, flags);
 =09return 0;
 }
 #endif
--=20
2.23.0

