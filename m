Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214457A73F
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 13:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfG3LrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 07:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbfG3LrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 07:47:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935AC206E0;
        Tue, 30 Jul 2019 11:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564487244;
        bh=1bsdeP/g+8k7Cj4LK69MQXAH5EbCd8urViJAWo4aS1I=;
        h=Subject:To:From:Date:From;
        b=vPvC36nA98Lr/mBIC4bworIKCmnUnx+AQWl0omaKkOU6tYBcExpBqw3BhgWiiSWgH
         ofz3xHRmbFtFkmv1WrYqwRIuo7HMVkHlmbCeGfdwazw/+t/VfC4xpj97V+Zz6Z+ZTO
         GqIsr9CUNziZXVZ6rDn/5d+tDUlpkHCwNso5Qvr8=
Subject: patch "driver core: platform: return -ENXIO for missing GpioInt" added to driver-core-linus
To:     briannorris@chromium.org, andriy.shevchenko@linux.intel.com,
        egranata@chromium.org, egranata@google.com,
        gregkh@linuxfoundation.org, salvatore.bellizzi@linux.seppia.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 30 Jul 2019 13:47:21 +0200
Message-ID: <156448724115555@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: platform: return -ENXIO for missing GpioInt

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 46c42d844211ef5902e32aa507beac0817c585e9 Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 29 Jul 2019 13:49:54 -0700
Subject: driver core: platform: return -ENXIO for missing GpioInt

Commit daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in
platform_get_irq()") broke the Embedded Controller driver on most LPC
Chromebooks (i.e., most x86 Chromebooks), because cros_ec_lpc expects
platform_get_irq() to return -ENXIO for non-existent IRQs.
Unfortunately, acpi_dev_gpio_irq_get() doesn't follow this convention
and returns -ENOENT instead. So we get this error from cros_ec_lpc:

   couldn't retrieve IRQ number (-2)

I see a variety of drivers that treat -ENXIO specially, so rather than
fix all of them, let's fix up the API to restore its previous behavior.

I reported this on v2 of this patch:

https://lore.kernel.org/lkml/20190220180538.GA42642@google.com/

but apparently the patch had already been merged before v3 got sent out:

https://lore.kernel.org/lkml/20190221193429.161300-1-egranata@chromium.org/

and the result is that the bug landed and remains unfixed.

I differ from the v3 patch by:
 * allowing for ret==0, even though acpi_dev_gpio_irq_get() specifically
   documents (and enforces) that 0 is not a valid return value (noted on
   the v3 review)
 * adding a small comment

Reported-by: Brian Norris <briannorris@chromium.org>
Reported-by: Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>
Cc: Enrico Granata <egranata@chromium.org>
Cc: <stable@vger.kernel.org>
Fixes: daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in platform_get_irq()")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Enrico Granata <egranata@google.com>
Link: https://lore.kernel.org/r/20190729204954.25510-1-briannorris@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 506a0175a5a7..ec974ba9c0c4 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -157,8 +157,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 	 * the device will only expose one IRQ, and this fallback
 	 * allows a common code path across either kind of resource.
 	 */
-	if (num == 0 && has_acpi_companion(&dev->dev))
-		return acpi_dev_gpio_irq_get(ACPI_COMPANION(&dev->dev), num);
+	if (num == 0 && has_acpi_companion(&dev->dev)) {
+		int ret = acpi_dev_gpio_irq_get(ACPI_COMPANION(&dev->dev), num);
+
+		/* Our callers expect -ENXIO for missing IRQs. */
+		if (ret >= 0 || ret == -EPROBE_DEFER)
+			return ret;
+	}
 
 	return -ENXIO;
 #endif
-- 
2.22.0


