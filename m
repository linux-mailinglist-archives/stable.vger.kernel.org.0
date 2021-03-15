Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C087133C00A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhCOPgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232995AbhCOPff (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DDAE64E76;
        Mon, 15 Mar 2021 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822535;
        bh=klsHWiyPUdPf1NJnPxJnm72Tm8+41T5uDNZ7mLD9q9U=;
        h=Subject:To:From:Date:From;
        b=JUPWHrp2qWnIz8SuVxo8M4R17x37jRrAmM/WjZQJbxBlDJPwNeA4+45JFLTdJEKKw
         6xs/Z0qsdLoJ4oOGWXeczPNbIU02kR8R78CNsgHvShun0wrW/i79YHlKw3RSggYvHp
         vXdFABp7h9LRYbKGJOfzvyFFKZn6tXHnX+YXgQE0=
Subject: patch "iio:adc:stm32-adc: Add HAS_IOMEM dependency" added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:23 +0100
Message-ID: <161582252382156@kroah.com>
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
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 121875b28e3bd7519a675bf8ea2c2e793452c2bd Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 24 Jan 2021 19:50:34 +0000
Subject: iio:adc:stm32-adc: Add HAS_IOMEM dependency

Seems that there are config combinations in which this driver gets enabled
and hence selects the MFD, but with out HAS_IOMEM getting pulled in
via some other route.  MFD is entirely contained in an
if HAS_IOMEM block, leading to the build issue in this bugzilla.

https://bugzilla.kernel.org/show_bug.cgi?id=209889

Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20210124195034.22576-1-jic23@kernel.org
---
 drivers/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 8d0be5b3029a..be1f73166a32 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -925,6 +925,7 @@ config STM32_ADC_CORE
 	depends on ARCH_STM32 || COMPILE_TEST
 	depends on OF
 	depends on REGULATOR
+	depends on HAS_IOMEM
 	select IIO_BUFFER
 	select MFD_STM32_TIMERS
 	select IIO_STM32_TIMER_TRIGGER
-- 
2.30.2


