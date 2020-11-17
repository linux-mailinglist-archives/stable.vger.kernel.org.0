Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9492B5C3F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgKQJwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgKQJwu (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81092168B;
        Tue, 17 Nov 2020 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606767;
        bh=bFz1lP4DDjiw0D4NKXP5OwgomPUlFmfll/UiHxqt+Rc=;
        h=Subject:To:From:Date:From;
        b=kiZPoctuc4VC8CQ3wdCk+0RfWJh5H+HGiIJclaXsvYS4wWXaJGZXy917Ujxu3qcQh
         SUVXgNnJ0pvv0oA8yWNQfYJA8AHF6RgdG0bXkdcZhiJikeOL4pveQlIWlwkPu9AQqv
         1UItuB/yQPdoO++WHUqhvieEXRzfz/gwV58O/X5Q=
Subject: patch "iio: imu: st_lsm6dsx: set 10ms as min shub slave timeout" added to staging-linus
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:24 +0100
Message-ID: <1605606804105225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: set 10ms as min shub slave timeout

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fe0b980ffd1dd8b10c09f82385514819ba2a661d Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 1 Nov 2020 17:21:18 +0100
Subject: iio: imu: st_lsm6dsx: set 10ms as min shub slave timeout

Set 10ms as minimum i2c slave configuration timeout since st_lsm6dsx
relies on accel ODR for i2c master clock and at high sample rates
(e.g. 833Hz or 416Hz) the slave sensor occasionally may need more cycles
than i2c master timeout (2s/833Hz + 1 ~ 3ms) to apply the configuration
resulting in an uncomplete slave configuration and a constant reading
from the i2c slave connected to st_lsm6dsx i2c master.

Fixes: 8f9a5249e3d9 ("iio: imu: st_lsm6dsx: enable 833Hz sample frequency for tagged sensors")
Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/a69c8236bf16a1569966815ed71710af2722ed7d.1604247274.git.lorenzo@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index 8c8d8870ca07..99562ba85ee4 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -156,11 +156,13 @@ static const struct st_lsm6dsx_ext_dev_settings st_lsm6dsx_ext_dev_table[] = {
 static void st_lsm6dsx_shub_wait_complete(struct st_lsm6dsx_hw *hw)
 {
 	struct st_lsm6dsx_sensor *sensor;
-	u32 odr;
+	u32 odr, timeout;
 
 	sensor = iio_priv(hw->iio_devs[ST_LSM6DSX_ID_ACC]);
 	odr = (hw->enable_mask & BIT(ST_LSM6DSX_ID_ACC)) ? sensor->odr : 12500;
-	msleep((2000000U / odr) + 1);
+	/* set 10ms as minimum timeout for i2c slave configuration */
+	timeout = max_t(u32, 2000000U / odr + 1, 10);
+	msleep(timeout);
 }
 
 /*
-- 
2.29.2


