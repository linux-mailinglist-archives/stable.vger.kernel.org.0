Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A936F273CAB
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 09:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIVHym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 03:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgIVHym (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 22 Sep 2020 03:54:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E06A23A5F;
        Tue, 22 Sep 2020 07:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600761281;
        bh=Cpw4FzHuT0u/aX1n8C53pQ/D7ix5UoFDNxIBRKg9xhg=;
        h=Subject:To:From:Date:From;
        b=vCzPDSBD56wLr6ZyHfy6IJj6yzWQVkWA0FicqnCNcAZ7IsAL+jqsPZNkcg6erqKbi
         JhSQRd7ElRmJr2QmZAqrsbTbcdNkPm0r36QWZZNskTip6LVp/1uYS1HVSSsvvJRP1F
         pXwjtQ6+e0YfZVvJA67NWhi4dhBRBgxzBfdEDySs=
Subject: patch "iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return" added to staging-testing
To:     trix@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Sep 2020 09:47:45 +0200
Message-ID: <16007608656381@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f71e41e23e129640f620b65fc362a6da02580310 Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Sun, 9 Aug 2020 10:55:51 -0700
Subject: iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return

Potential error return is not checked.  This can lead to use
of undefined data.

Detected by clang static analysis.

st_lsm6dsx_shub.c:540:8: warning: Assigned value is garbage or undefined
        *val = (s16)le16_to_cpu(*((__le16 *)data));
             ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Tom Rix <trix@redhat.com
Cc: <Stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20200809175551.6794-1-trix@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index ed83471dc7dd..8c8d8870ca07 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -313,6 +313,8 @@ st_lsm6dsx_shub_read(struct st_lsm6dsx_sensor *sensor, u8 addr,
 
 	err = st_lsm6dsx_shub_read_output(hw, data,
 					  len & ST_LS6DSX_READ_OP_MASK);
+	if (err < 0)
+		return err;
 
 	st_lsm6dsx_shub_master_enable(sensor, false);
 
-- 
2.28.0


