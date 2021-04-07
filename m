Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC514356623
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhDGIL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhDGIL4 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F2561363;
        Wed,  7 Apr 2021 08:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783107;
        bh=F+/4nFYAdK5fB1mDLvoyFSucTa7g0KQkDvizIMgJg+8=;
        h=Subject:To:From:Date:From;
        b=DV29N/AlHgevGuCnlDSUrE2e/JNjlFonrcvlZxMDgp8dSvXSFKz1mpCG3doXkJ7z4
         8Ri8sTsKX/0GKYFWqp5sGFSJKbmbNZ0mqJ341pjVeH2TsnS2WgyjBC0FYQT9yvKi01
         VdvgcbZL55vELe1xpcAUykrfFLM50mfnSofHAb4U=
Subject: patch "iio:adc:ad7476: Fix remove handling" added to staging-testing
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        ardeleanalex@gmail.com, michael.hennerich@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:09:17 +0200
Message-ID: <1617782957161129@kroah.com>
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
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

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


