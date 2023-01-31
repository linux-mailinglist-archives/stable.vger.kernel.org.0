Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABA4682996
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjAaJxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAaJxd (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F69547405
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EC4FB81AB3
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55327C433EF;
        Tue, 31 Jan 2023 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158793;
        bh=7zJtu5AnlKF3ncQizJYt7P1Idp3jbb+0PZry/7fn1b4=;
        h=Subject:To:From:Date:From;
        b=ZrxOxUlIpBuIpjXAFjFNTCxPPy7MTPRqtM0E365WjUKSycohcHq56OeT5xzAqj231
         AV0xd4Cn3UJLyrqVuiotSx1GdXj8m591VqX7F0PydcgsbHO36a0FbFKrMqwyH/7S2W
         2YubfIPj8c8bTj3S1p+2q3g0IpIbRJDYiwlzUROw=
Subject: patch "iio: imu: st_lsm6dsx: fix build when CONFIG_IIO_TRIGGERED_BUFFER=m" added to char-misc-linus
To:     vladimir.oltean@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:42 +0100
Message-ID: <1675158762129151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: fix build when CONFIG_IIO_TRIGGERED_BUFFER=m

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c9c1d6d82091f05b4dabf2c624bdaeba19bdf893 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 3 Jan 2023 15:03:48 +0200
Subject: iio: imu: st_lsm6dsx: fix build when CONFIG_IIO_TRIGGERED_BUFFER=m

The following kernel linkage error:

st_lsm6dsx_core.o: in function `st_lsm6dsx_sw_buffers_setup':
st_lsm6dsx_core.c:2578: undefined reference to `devm_iio_triggered_buffer_setup_ext'

is caused by the fact that the object owning devm_iio_triggered_buffer_setup_ext()
(drivers/iio/buffer/industrialio-triggered-buffer.o) is allowed to be
built as module when its user (drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c)
is built-in.

The st_lsm6dsx driver already has a "select IIO_BUFFER", so add another
select for IIO_TRIGGERED_BUFFER, to make that option follow what is set
for the st_lsm6dsx driver. This is similar to what other iio drivers do.

Fixes: 2cfb2180c3e8 ("iio: imu: st_lsm6dsx: introduce sw trigger support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20230103130348.1733467-1-vladimir.oltean@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/imu/st_lsm6dsx/Kconfig b/drivers/iio/imu/st_lsm6dsx/Kconfig
index f6660847fb58..8c16cdacf2f2 100644
--- a/drivers/iio/imu/st_lsm6dsx/Kconfig
+++ b/drivers/iio/imu/st_lsm6dsx/Kconfig
@@ -4,6 +4,7 @@ config IIO_ST_LSM6DSX
 	tristate "ST_LSM6DSx driver for STM 6-axis IMU MEMS sensors"
 	depends on (I2C || SPI || I3C)
 	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	select IIO_KFIFO_BUF
 	select IIO_ST_LSM6DSX_I2C if (I2C)
 	select IIO_ST_LSM6DSX_SPI if (SPI_MASTER)
-- 
2.39.1


