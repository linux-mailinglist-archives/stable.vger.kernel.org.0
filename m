Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE338EF78
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhEXP55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhEXP4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F79C6144B;
        Mon, 24 May 2021 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870988;
        bh=SH5S3FgX9A/3XtD3ZKNuapzsxNl8pGfFsXABySE+mf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiOEkq61K1yq6vlq5D+ypB/xxC9UQE4qyacw3SF5rGncH34X7+FQEpJwzYhJT+Pxj
         vckLSwnInXstYevy9hjlEoACpVrDZjfcrBhbEP8J2mdFHglbO39Oz/zvRan20mn8oF
         MABO98z+BxMhraqZIkX2xjxZOlzxTqoCqod04CKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 022/127] platform/x86: intel_int0002_vgpio: Only call enable_irq_wake() when using s2idle
Date:   Mon, 24 May 2021 17:25:39 +0200
Message-Id: <20210524152335.605114979@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b68e182a3062e326b891f47152a3a1b84abccf0f ]

Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement
irq_set_wake on Bay Trail") stopped passing irq_set_wake requests on to
the parents IRQ because this was breaking suspend (causing immediate
wakeups) on an Asus E202SA.

This workaround for the Asus E202SA is causing wakeup by USB keyboard to
not work on other devices with Airmont CPU cores such as the Medion Akoya
E1239T. In hindsight the problem with the Asus E202SA has nothing to do
with Silvermont vs Airmont CPU cores, so the differentiation between the
2 types of CPU cores introduced by the previous fix is wrong.

The real issue at hand is s2idle vs S3 suspend where the suspend is
mostly handled by firmware. The parent IRQ for the INT0002 device is shared
with the ACPI SCI and the real problem is that the INT0002 code should not
be messing with the wakeup settings of that IRQ when suspend/resume is
being handled by the firmware.

Note that on systems which support both s2idle and S3 suspend, which
suspend method to use can be changed at runtime.

This patch fixes both the Asus E202SA spurious wakeups issue as well as
the wakeup by USB keyboard not working on the Medion Akoya E1239T issue.

These are both fixed by replacing the old workaround with delaying the
enable_irq_wake(parent_irq) call till system-suspend time and protecting
it with a !pm_suspend_via_firmware() check so that we still do not call
it on devices using firmware-based (S3) suspend such as the Asus E202SA.

Note rather then adding #ifdef CONFIG_PM_SLEEP, this commit simply adds
a "depends on PM_SLEEP" to the Kconfig since this drivers whole purpose
is to deal with wakeup events, so using it without CONFIG_PM_SLEEP makes
no sense.

Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement irq_set_wake on Bay Trail")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20210512125523.55215-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig               |  2 +-
 drivers/platform/x86/intel_int0002_vgpio.c | 80 +++++++++++++++-------
 2 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 461ec61530eb..205a096e9cee 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -688,7 +688,7 @@ config INTEL_HID_EVENT
 
 config INTEL_INT0002_VGPIO
 	tristate "Intel ACPI INT0002 Virtual GPIO driver"
-	depends on GPIOLIB && ACPI
+	depends on GPIOLIB && ACPI && PM_SLEEP
 	select GPIOLIB_IRQCHIP
 	help
 	  Some peripherals on Bay Trail and Cherry Trail platforms signal a
diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
index 289c6655d425..569342aa8926 100644
--- a/drivers/platform/x86/intel_int0002_vgpio.c
+++ b/drivers/platform/x86/intel_int0002_vgpio.c
@@ -51,6 +51,12 @@
 #define GPE0A_STS_PORT			0x420
 #define GPE0A_EN_PORT			0x428
 
+struct int0002_data {
+	struct gpio_chip chip;
+	int parent_irq;
+	int wake_enable_count;
+};
+
 /*
  * As this is not a real GPIO at all, but just a hack to model an event in
  * ACPI the get / set functions are dummy functions.
@@ -98,14 +104,16 @@ static void int0002_irq_mask(struct irq_data *data)
 static int int0002_irq_set_wake(struct irq_data *data, unsigned int on)
 {
 	struct gpio_chip *chip = irq_data_get_irq_chip_data(data);
-	struct platform_device *pdev = to_platform_device(chip->parent);
-	int irq = platform_get_irq(pdev, 0);
+	struct int0002_data *int0002 = container_of(chip, struct int0002_data, chip);
 
-	/* Propagate to parent irq */
+	/*
+	 * Applying of the wakeup flag to our parent IRQ is delayed till system
+	 * suspend, because we only want to do this when using s2idle.
+	 */
 	if (on)
-		enable_irq_wake(irq);
+		int0002->wake_enable_count++;
 	else
-		disable_irq_wake(irq);
+		int0002->wake_enable_count--;
 
 	return 0;
 }
@@ -135,7 +143,7 @@ static bool int0002_check_wake(void *data)
 	return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
 }
 
-static struct irq_chip int0002_byt_irqchip = {
+static struct irq_chip int0002_irqchip = {
 	.name			= DRV_NAME,
 	.irq_ack		= int0002_irq_ack,
 	.irq_mask		= int0002_irq_mask,
@@ -143,21 +151,9 @@ static struct irq_chip int0002_byt_irqchip = {
 	.irq_set_wake		= int0002_irq_set_wake,
 };
 
-static struct irq_chip int0002_cht_irqchip = {
-	.name			= DRV_NAME,
-	.irq_ack		= int0002_irq_ack,
-	.irq_mask		= int0002_irq_mask,
-	.irq_unmask		= int0002_irq_unmask,
-	/*
-	 * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
-	 * and we don't want to mess with the ACPI SCI irq settings.
-	 */
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
 static const struct x86_cpu_id int0002_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&int0002_byt_irqchip),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&int0002_cht_irqchip),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT, NULL),
 	{}
 };
 
@@ -172,8 +168,9 @@ static int int0002_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	const struct x86_cpu_id *cpu_id;
-	struct gpio_chip *chip;
+	struct int0002_data *int0002;
 	struct gpio_irq_chip *girq;
+	struct gpio_chip *chip;
 	int irq, ret;
 
 	/* Menlow has a different INT0002 device? <sigh> */
@@ -185,10 +182,13 @@ static int int0002_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip)
+	int0002 = devm_kzalloc(dev, sizeof(*int0002), GFP_KERNEL);
+	if (!int0002)
 		return -ENOMEM;
 
+	int0002->parent_irq = irq;
+
+	chip = &int0002->chip;
 	chip->label = DRV_NAME;
 	chip->parent = dev;
 	chip->owner = THIS_MODULE;
@@ -214,7 +214,7 @@ static int int0002_probe(struct platform_device *pdev)
 	}
 
 	girq = &chip->irq;
-	girq->chip = (struct irq_chip *)cpu_id->driver_data;
+	girq->chip = &int0002_irqchip;
 	/* This let us handle the parent IRQ in the driver */
 	girq->parent_handler = NULL;
 	girq->num_parents = 0;
@@ -230,6 +230,7 @@ static int int0002_probe(struct platform_device *pdev)
 
 	acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
 	device_init_wakeup(dev, true);
+	dev_set_drvdata(dev, int0002);
 	return 0;
 }
 
@@ -240,6 +241,36 @@ static int int0002_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int int0002_suspend(struct device *dev)
+{
+	struct int0002_data *int0002 = dev_get_drvdata(dev);
+
+	/*
+	 * The INT0002 parent IRQ is often shared with the ACPI GPE IRQ, don't
+	 * muck with it when firmware based suspend is used, otherwise we may
+	 * cause spurious wakeups from firmware managed suspend.
+	 */
+	if (!pm_suspend_via_firmware() && int0002->wake_enable_count)
+		enable_irq_wake(int0002->parent_irq);
+
+	return 0;
+}
+
+static int int0002_resume(struct device *dev)
+{
+	struct int0002_data *int0002 = dev_get_drvdata(dev);
+
+	if (!pm_suspend_via_firmware() && int0002->wake_enable_count)
+		disable_irq_wake(int0002->parent_irq);
+
+	return 0;
+}
+
+static const struct dev_pm_ops int0002_pm_ops = {
+	.suspend = int0002_suspend,
+	.resume = int0002_resume,
+};
+
 static const struct acpi_device_id int0002_acpi_ids[] = {
 	{ "INT0002", 0 },
 	{ },
@@ -250,6 +281,7 @@ static struct platform_driver int0002_driver = {
 	.driver = {
 		.name			= DRV_NAME,
 		.acpi_match_table	= int0002_acpi_ids,
+		.pm			= &int0002_pm_ops,
 	},
 	.probe	= int0002_probe,
 	.remove	= int0002_remove,
-- 
2.30.2



