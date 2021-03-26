Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3242134A62A
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 12:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhCZLMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 07:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhCZLMF (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 26 Mar 2021 07:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98AE61A14;
        Fri, 26 Mar 2021 11:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616757114;
        bh=0IDYvuhlYdTHX7dol0V3H3EOyc1wEfgwthwtjNM4xFg=;
        h=Subject:To:From:Date:From;
        b=BUIVmY3Vp4yL19VHBP1alpsp6r2kurt+t/KVO6mFh4orYhu4+fGB5TJ7k2VpOBrJl
         tzrF3NHCPAIWi1WI9EB20ypMj96yMNkHCYUQhl+qNWfRa5S1kRkdUjN6MHTqZg7O9R
         udiCL2qgoLTKtrlfmQ1Y0gxNBnPKYhPugGZMa614=
Subject: patch "iio:adc:stm32-adc: Add HAS_IOMEM dependency" added to staging-testing
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 12:11:48 +0100
Message-ID: <1616757108595@kroah.com>
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
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

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


