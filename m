Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4343E53F5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhHJG4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 02:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJG4I (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 10 Aug 2021 02:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1469A61019;
        Tue, 10 Aug 2021 06:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628578546;
        bh=tTU8/HxjLEVGtAv1cCcKW/TBszg1Cz8/LZP11fD7bHQ=;
        h=Subject:To:From:Date:From;
        b=FiMysA054m159GZK87T7dNJeWG1zfevl1ON39o3gUfzlnKdapJg48ALrj3rDQoKU6
         YqK63ytYZUt4uXthX9dEURBsniYQRu4yy2xeXknXlxwBGGg/3dT+IMQpThoDjxr+0+
         W7muxandCD3CsJWnh6z776kZs/biLH2oxCQZ8S3M=
Subject: patch "iio: adis: set GPIO reset pin direction" added to staging-linus
To:     detegr@rbx.email, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hannu@hrtk.in, nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Aug 2021 08:55:32 +0200
Message-ID: <162857853212021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis: set GPIO reset pin direction

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7e77ef8b8d600cf8448a2bbd32f682c28884551f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Antti=20Ker=C3=A4nen?= <detegr@rbx.email>
Date: Thu, 8 Jul 2021 12:54:29 +0300
Subject: iio: adis: set GPIO reset pin direction
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Set reset pin direction to output as the reset pin needs to be an active
low output pin.

Co-developed-by: Hannu Hartikainen <hannu@hrtk.in>
Signed-off-by: Hannu Hartikainen <hannu@hrtk.in>
Signed-off-by: Antti Keränen <detegr@rbx.email>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Fixes: ecb010d44108 ("iio: imu: adis: Refactor adis_initial_startup")
Link: https://lore.kernel.org/r/20210708095425.13295-1-detegr@rbx.email
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/adis.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/imu/adis.c b/drivers/iio/imu/adis.c
index a5b421f42287..b9a06ca29bee 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -411,12 +411,11 @@ int __adis_initial_startup(struct adis *adis)
 	int ret;
 
 	/* check if the device has rst pin low */
-	gpio = devm_gpiod_get_optional(&adis->spi->dev, "reset", GPIOD_ASIS);
+	gpio = devm_gpiod_get_optional(&adis->spi->dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(gpio))
 		return PTR_ERR(gpio);
 
 	if (gpio) {
-		gpiod_set_value_cansleep(gpio, 1);
 		msleep(10);
 		/* bring device out of reset */
 		gpiod_set_value_cansleep(gpio, 0);
-- 
2.32.0


