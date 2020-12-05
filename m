Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548A12CFD96
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 19:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgLESjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 13:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgLESj2 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 5 Dec 2020 13:39:28 -0500
Subject: patch "iio:imu:bmi160: Fix too large a buffer." added to staging-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183278;
        bh=eef0fHZLeN8Vl56vYEHIwBntrfChIivyIScMP/9N78E=;
        h=To:From:Date:From;
        b=o2PEqUhpZyum9z6t8P8+AMS3GhkgsDGxf5uXUsOvdlDlYd8x3xHjuQXN+6Zs6u40N
         V3vv4JRhE3jXURGyoOIjNCwbnrmUdIW8NmOw1uAhl2YnA0Tblk/pvwfwogS0UpoJYr
         8K1olVjkRh/y5khaVmgZMznalPXUMnue3Gzo4Qr8=
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, daniel.baluta@oss.nxp.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Dec 2020 16:46:03 +0100
Message-ID: <1607183163182255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:imu:bmi160: Fix too large a buffer.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From dc7de42d6b50a07b37feeba4c6b5136290fcee81 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:38 +0100
Subject: iio:imu:bmi160: Fix too large a buffer.

The comment implies this device has 3 sensor types, but it only
has an accelerometer and a gyroscope (both 3D).  As such the
buffer does not need to be as long as stated.

Note I've separated this from the following patch which fixes
the alignment for passing to iio_push_to_buffers_with_timestamp()
as they are different issues even if they affect the same line
of code.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Daniel Baluta <daniel.baluta@oss.nxp.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-5-jic23@kernel.org
---
 drivers/iio/imu/bmi160/bmi160_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index 431076dc0d2c..c8e131c29043 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -427,8 +427,8 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[16];
-	/* 3 sens x 3 axis x __le16 + 3 x __le16 pad + 4 x __le16 tstamp */
+	__le16 buf[12];
+	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
-- 
2.29.2


