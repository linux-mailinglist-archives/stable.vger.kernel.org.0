Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C79682993
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjAaJxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjAaJxM (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B770E5B9D
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53D4561488
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B709C4339B;
        Tue, 31 Jan 2023 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158784;
        bh=fj005BwQbIrWOQWrtR8OT0e2zZdJr+7K/GkVEQPdMh4=;
        h=Subject:To:From:Date:From;
        b=mB98wWb5F9Qd9uXFLIGel4IGOsYjOHhCcESxTV2mig+Jv/6G5Gwg6cbQyBkrEK7Dl
         BjmuPdtHD2lTk7wxhgE+AlyQnTJeId+rnTjgy9vO0y3SZzjSQ1Q+i1bNvmDuyD7zC6
         nV42OoFAGB0ZRX0i6dBkfaVQw7BBSK32lxWbxI78=
Subject: patch "iio: imu: fxos8700: fix IMU data bits returned to user space" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:40 +0100
Message-ID: <16751587608951@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: fxos8700: fix IMU data bits returned to user space

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a53f945879c0cb9de3a4c05a665f5157884b5208 Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Thu, 8 Dec 2022 15:19:08 +0800
Subject: iio: imu: fxos8700: fix IMU data bits returned to user space

ACCEL output data registers contain the X-axis, Y-axis, and Z-axis
14-bit left-justified sample data and MAGN output data registers
contain the X-axis, Y-axis, and Z-axis 16-bit sample data. The ACCEL
raw register output data should be divided by 4 before sent to
userspace.

Apply a 2 bits signed right shift to the raw data from ACCEL output
data register but keep that from MAGN sensor as the origin.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-5-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/fxos8700_core.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index b62bc92bbacc..06948a8cc315 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -394,6 +394,7 @@ static int fxos8700_get_data(struct fxos8700_data *data, int chan_type,
 			     int axis, int *val)
 {
 	u8 base, reg;
+	s16 tmp;
 	int ret;
 
 	/*
@@ -421,8 +422,33 @@ static int fxos8700_get_data(struct fxos8700_data *data, int chan_type,
 	/* Convert axis to buffer index */
 	reg = axis - IIO_MOD_X;
 
+	/*
+	 * Convert to native endianness. The accel data and magn data
+	 * are signed, so a forced type conversion is needed.
+	 */
+	tmp = be16_to_cpu(data->buf[reg]);
+
+	/*
+	 * ACCEL output data registers contain the X-axis, Y-axis, and Z-axis
+	 * 14-bit left-justified sample data and MAGN output data registers
+	 * contain the X-axis, Y-axis, and Z-axis 16-bit sample data. Apply
+	 * a signed 2 bits right shift to the readback raw data from ACCEL
+	 * output data register and keep that from MAGN sensor as the origin.
+	 * Value should be extended to 32 bit.
+	 */
+	switch (chan_type) {
+	case IIO_ACCEL:
+		tmp = tmp >> 2;
+		break;
+	case IIO_MAGN:
+		/* Nothing to do */
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* Convert to native endianness */
-	*val = sign_extend32(be16_to_cpu(data->buf[reg]), 15);
+	*val = sign_extend32(tmp, 15);
 
 	return 0;
 }
-- 
2.39.1


