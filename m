Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A98356632
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbhDGIPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhDGIPU (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D38D61363;
        Wed,  7 Apr 2021 08:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783310;
        bh=OESLXNgWXlGr9B+MzQDu29Lw74VYH1wI2Qwlxn3VFu8=;
        h=Subject:To:From:Date:From;
        b=FPa4CfCVFu4/PKv245eWfV4PSv5B5wq2T2mox57xrpSC/KSnC74etNXKLpO8GrqAv
         s6UDAEag0o+QNeSSOIvIgbW2ZO9QnySUvZoIlBrlYu15t2UH55sLEqx2XyIzLASnQn
         8ywDIsvkq6hWtNnZEV9wMllUlr1YR+HQYKKk2eTU=
Subject: patch "iio:adc:ad7476: Fix remove handling" added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        ardeleanalex@gmail.com, michael.hennerich@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:10:37 +0200
Message-ID: <1617783037237118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:ad7476: Fix remove handling

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 6baee4bd63f5fdf1716f88e95c21a683e94fe30d Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Thu, 1 Apr 2021 18:17:57 +0100
Subject: iio:adc:ad7476: Fix remove handling

This driver was in an odd half way state between devm based cleanup
and manual cleanup (most of which was missing).
I would guess something went wrong with a rebase or similar.
Anyhow, this basically finishes the job as a precursor to improving
the regulator handling.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 4bb2b8f94ace3 ("iio: adc: ad7476: implement devm_add_action_or_reset")
Cc: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210401171759.318140-2-jic23@kernel.org
---
 drivers/iio/adc/ad7476.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/iio/adc/ad7476.c b/drivers/iio/adc/ad7476.c
index 17402714b387..9e9ff07cf972 100644
--- a/drivers/iio/adc/ad7476.c
+++ b/drivers/iio/adc/ad7476.c
@@ -321,25 +321,15 @@ static int ad7476_probe(struct spi_device *spi)
 	spi_message_init(&st->msg);
 	spi_message_add_tail(&st->xfer, &st->msg);
 
-	ret = iio_triggered_buffer_setup(indio_dev, NULL,
-			&ad7476_trigger_handler, NULL);
+	ret = devm_iio_triggered_buffer_setup(&spi->dev, indio_dev, NULL,
+					      &ad7476_trigger_handler, NULL);
 	if (ret)
-		goto error_disable_reg;
+		return ret;
 
 	if (st->chip_info->reset)
 		st->chip_info->reset(st);
 
-	ret = iio_device_register(indio_dev);
-	if (ret)
-		goto error_ring_unregister;
-	return 0;
-
-error_ring_unregister:
-	iio_triggered_buffer_cleanup(indio_dev);
-error_disable_reg:
-	regulator_disable(st->reg);
-
-	return ret;
+	return devm_iio_device_register(&spi->dev, indio_dev);
 }
 
 static const struct spi_device_id ad7476_id[] = {
-- 
2.31.1


