Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CF62F7398
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbhAOHRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbhAOHRx (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 Jan 2021 02:17:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C05230FE;
        Fri, 15 Jan 2021 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610695032;
        bh=xS1BxZNKniFKCWf1H9shsw2ie1jeO0dxsP7AkeY0gwI=;
        h=Subject:To:From:Date:From;
        b=IVB3ufw+PqiLFtJjZnsWJn4ef/d8fFTLmMLBc8az7JV5lQ6tnTeGHdPNC8ZGdXrcd
         /hv5kxfJODoiDsIskATnoL2Wu5Qu364EMlpNDJ+qAa5oHUcEZiVHzKG8/XHBtLYwFN
         MQ9Lt4bxazI54klVLR5yGRQsjZ444JJEDNbbro4s=
Subject: patch "iio: adc: ti_am335x_adc: remove omitted iio_kfifo_free()" added to staging-linus
To:     alexandru.ardelean@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 08:17:04 +0100
Message-ID: <1610695024208160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti_am335x_adc: remove omitted iio_kfifo_free()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7e6d9788aa02333a4353058816d52b9a90aae0d3 Mon Sep 17 00:00:00 2001
From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Thu, 3 Dec 2020 09:26:50 +0200
Subject: iio: adc: ti_am335x_adc: remove omitted iio_kfifo_free()

When the conversion was done to use devm_iio_kfifo_allocate(), a call to
iio_kfifo_free() was omitted (to be removed).
This change removes it.

Fixes: 3c5308058899 ("iio: adc: ti_am335x_adc: alloc kfifo & IRQ via devm_ functions")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201203072650.24128-1-alexandru.ardelean@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti_am335x_adc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index b11c8c47ba2a..e946903b0993 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -397,16 +397,12 @@ static int tiadc_iio_buffered_hardware_setup(struct device *dev,
 	ret = devm_request_threaded_irq(dev, irq, pollfunc_th, pollfunc_bh,
 				flags, indio_dev->name, indio_dev);
 	if (ret)
-		goto error_kfifo_free;
+		return ret;
 
 	indio_dev->setup_ops = setup_ops;
 	indio_dev->modes |= INDIO_BUFFER_SOFTWARE;
 
 	return 0;
-
-error_kfifo_free:
-	iio_kfifo_free(indio_dev->buffer);
-	return ret;
 }
 
 static const char * const chan_name_ain[] = {
-- 
2.30.0


