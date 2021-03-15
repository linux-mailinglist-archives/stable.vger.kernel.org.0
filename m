Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E869733C006
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhCOPf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231486AbhCOPf3 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C60F64EB3;
        Mon, 15 Mar 2021 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822529;
        bh=zWWxGxHTmns0CwQHzqZ6Ne2C2xMMBP4sVzeGu/8yJJ8=;
        h=Subject:To:From:Date:From;
        b=R2APQaYiVs3axwHDdbir13gClkHr05jl/aqr+BkkHwFKzVBc1i1zrryqSrvfvm/bT
         5xRsmrZmV3WgeOq1D9VAVJqgJzvsvhr1/c2H/Q8qz9W8H9DftZ6yF70jBC2WpoEDwz
         zoIN1jzVGC823N9r9um017h2gwX8rzt+Xd7wtrkM=
Subject: patch "iio: adc: adi-axi-adc: add proper Kconfig dependencies" added to staging-linus
To:     alexandru.ardelean@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, lkp@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:22 +0100
Message-ID: <1615822522478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: adi-axi-adc: add proper Kconfig dependencies

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From be24c65e9fa2486bb8ec98d9f592bdcf04bedd88 Mon Sep 17 00:00:00 2001
From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Wed, 10 Feb 2021 12:50:44 +0200
Subject: iio: adc: adi-axi-adc: add proper Kconfig dependencies

The ADI AXI ADC driver requires IO mem access and OF to work. This change
adds these dependencies to the Kconfig symbol of the driver.

This was also found via the lkp bot, as the
devm_platform_ioremap_resource() symbol was not found at link-time on the
S390 architecture.

Fixes: ef04070692a21 ("iio: adc: adi-axi-adc: add support for AXI ADC IP core")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210210105044.48914-1-alexandru.ardelean@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 15587a1bc80d..8d0be5b3029a 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -266,6 +266,8 @@ config ADI_AXI_ADC
 	select IIO_BUFFER
 	select IIO_BUFFER_HW_CONSUMER
 	select IIO_BUFFER_DMAENGINE
+	depends on HAS_IOMEM
+	depends on OF
 	help
 	  Say yes here to build support for Analog Devices Generic
 	  AXI ADC IP core. The IP core is used for interfacing with
-- 
2.30.2


