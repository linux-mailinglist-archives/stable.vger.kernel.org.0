Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C934A65E
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 12:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCZLS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhCZLSo (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 26 Mar 2021 07:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E3761581;
        Fri, 26 Mar 2021 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616757524;
        bh=uLd6vBuQDrET9ja1CDiq/opwgtelI3nuYtJVAML0stE=;
        h=Subject:To:From:Date:From;
        b=pjRa/CSWhBbUC7gkawejDm+xNE0rabDXAsO0hxv1n6rH8v1K3Z8uIldTQ8vgIFVZd
         PdFD6z0E2gnLv0Ic8832nYhakz7Y7/taUhWS9rdR0QqiXAu8jRDLaf4mdq3XKscR0y
         /p5JvCbHACx1ICdPFyzh9lY294aK1TEv+psj+2eI=
Subject: patch "iio:adc:stm32-adc: Add HAS_IOMEM dependency" added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 12:18:39 +0100
Message-ID: <161675751922516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:stm32-adc: Add HAS_IOMEM dependency

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c03e2df6e1d51f4e1252318275007214a3bd8e85 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 24 Jan 2021 19:10:22 +0000
Subject: iio:adc:stm32-adc: Add HAS_IOMEM dependency

Seems that there are config combinations in which this driver gets enabled
and hence selects the MFD, but with out HAS_IOMEM getting pulled in
via some other route.  MFD is entirely contained in an
if HAS_IOMEM block, leading to the build issue in this bugzilla.

https://bugzilla.kernel.org/show_bug.cgi?id=209889

Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index bf7d22fa4be2..6605c263949c 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -923,6 +923,7 @@ config STM32_ADC_CORE
 	depends on ARCH_STM32 || COMPILE_TEST
 	depends on OF
 	depends on REGULATOR
+	depends on HAS_IOMEM
 	select IIO_BUFFER
 	select MFD_STM32_TIMERS
 	select IIO_STM32_TIMER_TRIGGER
-- 
2.31.0


