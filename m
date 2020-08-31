Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62CE257739
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgHaK0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaK0E (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1466F2072D;
        Mon, 31 Aug 2020 10:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869563;
        bh=zfzkGqestFs9nQQhhaXsXXtCtxEXnknSCGnOjZBBgfk=;
        h=Subject:To:From:Date:From;
        b=H21fud3lRhzBXAUnTmNKhRQk40xfNw3h0UwL2BrvMocUaNPWmAYJyZl/b1mzesqlK
         y88r373+vgzflK3R0rBOHa7eh5mdxHN7E/D0JppzYIsOP2vVoAg9maU4qRF4ENrrwe
         qUeUKvIOhPiq68t3sw8xYLhzGW6RLo9l6RJUZLKg=
Subject: patch "iio: cros_ec: Set Gyroscope default frequency to 25Hz" added to staging-linus
To:     gwendal@chromium.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, enric.balletbo@collabora.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:11 +0200
Message-ID: <159886957119230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: cros_ec: Set Gyroscope default frequency to 25Hz

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 336306790b2bbf7ce837625fa3b24ba724d05838 Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Tue, 28 Jul 2020 13:48:25 -0700
Subject: iio: cros_ec: Set Gyroscope default frequency to 25Hz

BMI160 Minimium gyroscope frequency in normal mode is 25Hz.
When older EC firmware do not report their sensors frequencies,
use 25Hz as the minimum for gyroscope to be sure it works on BMI160.

Fixes: ae7b02ad2f32d ("iio: common: cros_ec_sensors: Expose cros_ec_sensors frequency range via iio sysfs")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
index ea480c1d4349..1bc6efa47316 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -72,10 +72,13 @@ static void get_default_min_max_freq(enum motionsensor_type type,
 
 	switch (type) {
 	case MOTIONSENSE_TYPE_ACCEL:
-	case MOTIONSENSE_TYPE_GYRO:
 		*min_freq = 12500;
 		*max_freq = 100000;
 		break;
+	case MOTIONSENSE_TYPE_GYRO:
+		*min_freq = 25000;
+		*max_freq = 100000;
+		break;
 	case MOTIONSENSE_TYPE_MAG:
 		*min_freq = 5000;
 		*max_freq = 25000;
-- 
2.28.0


