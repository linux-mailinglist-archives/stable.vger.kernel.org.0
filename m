Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858BC38D44A
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhEVHvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHvr (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C47611CB;
        Sat, 22 May 2021 07:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669823;
        bh=VL2p7NF71CvJGD3fc1o+ELF0WTeSID8gBuS6x6BO9Fs=;
        h=Subject:To:From:Date:From;
        b=ZvRj4XLkpu8g7YZuOoIO6/SK0EVZDkwETIp2VLWWmPcZVPMnO871tlnrGJIzg3JgZ
         X6hguo9nXoyWJG4ctF3u0uR8FZU0d+yblSRZjwhabYc3vb7ot85PmvpCfd97Bpvq8J
         GsStRQMCVnj51CWbNK3BMtX+KO3bTVsp6oAty7Uo=
Subject: patch "iio: adc: ad7192: handle regulator voltage error first" added to staging-linus
To:     aardelean@deviqon.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.tachici@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:18 +0200
Message-ID: <1621669818236241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7192: handle regulator voltage error first

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b0f27fca5a6c7652e265aae6a4452ce2f2ed64da Mon Sep 17 00:00:00 2001
From: Alexandru Ardelean <aardelean@deviqon.com>
Date: Thu, 13 May 2021 15:07:44 +0300
Subject: iio: adc: ad7192: handle regulator voltage error first

This change fixes a corner-case, where for a zero regulator value, the
driver would exit early, initializing the driver only partially.
The driver would be in an unknown state.

This change reworks the code to check regulator_voltage() return value
for negative (error) first, and return early. This is the more common
idiom.

Also, this change is removing the 'voltage_uv' variable and using the 'ret'
value directly. The only place where 'voltage_uv' is being used is to
compute the internal reference voltage, and the type of this variable is
'int' (same are for 'ret'). Using only 'ret' avoids having to assign it on
the error path.

Fixes: ab0afa65bbc7 ("staging: iio: adc: ad7192: fail probe on get_voltage")
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/adc/ad7192.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index d3be67aa0522..1141cc13a124 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -912,7 +912,7 @@ static int ad7192_probe(struct spi_device *spi)
 {
 	struct ad7192_state *st;
 	struct iio_dev *indio_dev;
-	int ret, voltage_uv = 0;
+	int ret;
 
 	if (!spi->irq) {
 		dev_err(&spi->dev, "no IRQ?\n");
@@ -949,15 +949,12 @@ static int ad7192_probe(struct spi_device *spi)
 		goto error_disable_avdd;
 	}
 
-	voltage_uv = regulator_get_voltage(st->avdd);
-
-	if (voltage_uv > 0) {
-		st->int_vref_mv = voltage_uv / 1000;
-	} else {
-		ret = voltage_uv;
+	ret = regulator_get_voltage(st->avdd);
+	if (ret < 0) {
 		dev_err(&spi->dev, "Device tree error, reference voltage undefined\n");
 		goto error_disable_avdd;
 	}
+	st->int_vref_mv = ret / 1000;
 
 	spi_set_drvdata(spi, indio_dev);
 	st->chip_info = of_device_get_match_data(&spi->dev);
-- 
2.31.1


