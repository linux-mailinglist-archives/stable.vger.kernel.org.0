Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AF48DBBD
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfHNRCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbfHNRCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C8F2084D;
        Wed, 14 Aug 2019 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802153;
        bh=owLJ8Kt3KqQYv81GC2jYEgfih+b3WDTicT2Td+8GpXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DN+KHAajZWJUxoal+H2sulOaqk9LFLDbBB8eT8QFgvEikmrGP8XOOBiYSNELXupJc
         ElG3eOs85lcsT9M5JRj16XzaGToNeMhBjbnb5SPiC/Fa+sFiwIbdB6s2IC6lglLR02
         HybhWFVFKpSFeHBT1MTr5NgKijMTRfV7HqHjqp58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        Enrico Granata <egranata@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Enrico Granata <egranata@google.com>
Subject: [PATCH 5.2 015/144] driver core: platform: return -ENXIO for missing GpioInt
Date:   Wed, 14 Aug 2019 18:59:31 +0200
Message-Id: <20190814165800.551877117@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 46c42d844211ef5902e32aa507beac0817c585e9 upstream.

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
 drivers/base/platform.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -157,8 +157,13 @@ int platform_get_irq(struct platform_dev
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


