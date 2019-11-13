Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B41AFBB02
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 22:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfKMVoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 16:44:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfKMVoP (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 13 Nov 2019 16:44:15 -0500
Received: from localhost (unknown [61.58.47.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26280206E5;
        Wed, 13 Nov 2019 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573681456;
        bh=3NGfwr4tec0qqpkIdNavDU/NoqajQop8LNXsMNreEOQ=;
        h=Subject:To:From:Date:From;
        b=r3rYhUPJD78GHuXtZlhK8omy2dtmKbcznDvrImE1Ny1I1ObecFdPRE1Rl7Agi+8Yx
         YdF8l/a4ZIhCfBl1fhBveq3B2PR7Q/4/ZSQWVzaTSOkcWPp2kwB9t0VnUatwqJXj2I
         4sOF8sqg8XdoquwE/rp+CFlfEMAFyelLajDGDA0s=
Subject: patch "iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw" added to staging-next
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 Nov 2019 05:43:33 +0800
Message-ID: <157368141372196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From fc3f6ad7f5dc6c899fbda0255865737bac88c2e0 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 27 Oct 2019 19:02:30 +0100
Subject: iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw

Since st_lsm6dsx i2c master controller relies on accel device as trigger
and slave devices can run at different ODRs we must select an accel_odr >=
slave_odr. Report real accel ODR in st_lsm6dsx_check_odr() in order to
properly set sensor frequency in st_lsm6dsx_write_raw and avoid to
report unsupported frequency

Fixes: 6ffb55e5009ff ("iio: imu: st_lsm6dsx: introduce ST_LSM6DSX_ID_EXT sensor ids")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index a3333c215339..2f9396745bc8 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1377,8 +1377,7 @@ int st_lsm6dsx_check_odr(struct st_lsm6dsx_sensor *sensor, u16 odr, u8 *val)
 		return -EINVAL;
 
 	*val = odr_table->odr_avl[i].val;
-
-	return 0;
+	return odr_table->odr_avl[i].hz;
 }
 
 static u16 st_lsm6dsx_check_odr_dependency(struct st_lsm6dsx_hw *hw, u16 odr,
@@ -1542,8 +1541,10 @@ static int st_lsm6dsx_write_raw(struct iio_dev *iio_dev,
 	case IIO_CHAN_INFO_SAMP_FREQ: {
 		u8 data;
 
-		err = st_lsm6dsx_check_odr(sensor, val, &data);
-		if (!err)
+		val = st_lsm6dsx_check_odr(sensor, val, &data);
+		if (val < 0)
+			err = val;
+		else
 			sensor->odr = val;
 		break;
 	}
-- 
2.24.0


