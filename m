Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A146B138FCA
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgAMLI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgAMLI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 06:08:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF7E2081E;
        Mon, 13 Jan 2020 11:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578913737;
        bh=MvxVJiIw4Ezn6DHBk3kWI1msuF/5/dKr5YuWjzpYU8g=;
        h=Subject:To:From:Date:From;
        b=2elMkpx6gGmkh/NXr9HbPdZg6PZFcI4DoIRASjyonpFkscUeiuG3YOh+m1H9z11qF
         MTJtGfHuwe7pwLjdAOCWAd/ox3PnCX0WNz/SPpt+PVF0UzlN+DWjCELtjxKL66Pajn
         /UqZl2QIt9YK4A0k6ygN5Ok88bX+DYhk/dYsmUSU=
Subject: patch "iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID" added to staging-linus
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        gregkh@linuxfoundation.org, lorenzo@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jan 2020 12:08:51 +0100
Message-ID: <157891373111512@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fb4fbc8904e786537e29329d791147389e1465a2 Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Mon, 16 Dec 2019 13:41:20 +0100
Subject: iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID

At the moment, attempting to probe a device with ST_LSM6DS3_ID
(e.g. using the st,lsm6ds3 compatible) fails with:

    st_lsm6dsx_i2c 1-006b: unsupported whoami [69]

... even though 0x69 is the whoami listed for ST_LSM6DS3_ID.

This happens because st_lsm6dsx_check_whoami() also attempts
to match unspecified (zero-initialized) entries in the "id" array.
ST_LSM6DS3_ID = 0 will therefore match any entry in
st_lsm6dsx_sensor_settings (here: the first), because none of them
actually have all 12 entries listed in the "id" array.

Avoid this by additionally checking if "name" is set,
which is only set for valid entries in the "id" array.

Note: Although the problem was introduced earlier it did not surface until
commit 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")
because ST_LSM6DS3_ID was the first entry in st_lsm6dsx_sensor_settings.

Fixes: d068e4a0f921 ("iio: imu: st_lsm6dsx: add support to multiple devices with the same settings")
Cc: <stable@vger.kernel.org> # 5.4
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index a7d40c02ce6b..b921dd9e108f 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1301,7 +1301,8 @@ static int st_lsm6dsx_check_whoami(struct st_lsm6dsx_hw *hw, int id,
 
 	for (i = 0; i < ARRAY_SIZE(st_lsm6dsx_sensor_settings); i++) {
 		for (j = 0; j < ST_LSM6DSX_MAX_ID; j++) {
-			if (id == st_lsm6dsx_sensor_settings[i].id[j].hw_id)
+			if (st_lsm6dsx_sensor_settings[i].id[j].name &&
+			    id == st_lsm6dsx_sensor_settings[i].id[j].hw_id)
 				break;
 		}
 		if (j < ST_LSM6DSX_MAX_ID)
-- 
2.24.1


