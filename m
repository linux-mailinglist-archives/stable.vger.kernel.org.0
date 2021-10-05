Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A0942221E
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhJEJXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhJEJXW (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C65F61526;
        Tue,  5 Oct 2021 09:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425692;
        bh=aI4ecJuyigHxqGLVRX5xoixhuKqi/6Zvz0k/3cFkOZ0=;
        h=Subject:To:From:Date:From;
        b=GYRCOYjy4j4cA3aKFBoi4MtdwgWM+h1xX6kWB/YzqkfKSYlLrDLkZxQjBhJWQgYZd
         7Z6kd9WdQ3ns2e40CLVRQ27+FXkc+L/AXRnMkVW+M9YeorcCg9ofFU64YF59ZsO9sO
         y30cQYMtZdB41+dDT10lD20epgqRuDbI71GRKMv4=
Subject: patch "iio: adc128s052: Fix the error handling path of 'adc128_probe()'" added to staging-linus
To:     christophe.jaillet@wanadoo.fr, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:21 +0200
Message-ID: <163342568199131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc128s052: Fix the error handling path of 'adc128_probe()'

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bbcf40816b547b3c37af49168950491d20d81ce1 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 21 Aug 2021 12:37:24 +0200
Subject: iio: adc128s052: Fix the error handling path of 'adc128_probe()'

A successful 'regulator_enable()' call should be balanced by a
corresponding 'regulator_disable()' call in the error handling path of the
probe, as already done in the remove function.

Update the error handling path accordingly.

Fixes: 913b86468674 ("iio: adc: Add TI ADC128S052")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/85189f1cfcf6f5f7b42d8730966f2a074b07b5f5.1629542160.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-adc128s052.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 3143f35a6509..83c1ae07b3e9 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -171,7 +171,13 @@ static int adc128_probe(struct spi_device *spi)
 	mutex_init(&adc->lock);
 
 	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_disable_regulator;
 
+	return 0;
+
+err_disable_regulator:
+	regulator_disable(adc->reg);
 	return ret;
 }
 
-- 
2.33.0


