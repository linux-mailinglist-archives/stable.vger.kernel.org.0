Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A26682990
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjAaJxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjAaJw5 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:52:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FF65B9D
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18C476148B
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6C9C4339C;
        Tue, 31 Jan 2023 09:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158774;
        bh=rpFrcW3jUFXTzVaelUGusokv8V85LrWJBMjBd+m6Cn8=;
        h=Subject:To:From:Date:From;
        b=sQJm7la1kGdlYPqT6eutrjR37IYSHa9YXcv5KTQaqs7A3Kvjs+AJATabjXh8NFDK3
         VXB7fJwWBXORH1tKM55hKtFMoyt7PMuLIRRYc7PEe2YNbx6AicHQtMX/jkCJ4Nh8f0
         OxQUR1lr/M5tFAeCvL7UJC6cEaoxQYlYVIIkE6hw=
Subject: patch "iio: imu: fxos8700: fix swapped ACCEL and MAGN channels readback" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:39 +0100
Message-ID: <167515875961189@kroah.com>
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

    iio: imu: fxos8700: fix swapped ACCEL and MAGN channels readback

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c68b44bc7d9b1469774a1c985ee71d2cbc5ebef5 Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Thu, 8 Dec 2022 15:19:06 +0800
Subject: iio: imu: fxos8700: fix swapped ACCEL and MAGN channels readback

Because ACCEL and MAGN channels data register base address is
swapped the accelerometer and magnetometer channels readback is
swapped.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-3-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/fxos8700_core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index 235b02b2f4e5..977eb7dc7dbd 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -395,9 +395,22 @@ static int fxos8700_get_data(struct fxos8700_data *data, int chan_type,
 {
 	u8 base, reg;
 	int ret;
-	enum fxos8700_sensor type = fxos8700_to_sensor(chan_type);
 
-	base = type ? FXOS8700_OUT_X_MSB : FXOS8700_M_OUT_X_MSB;
+	/*
+	 * Different register base addresses varies with channel types.
+	 * This bug hasn't been noticed before because using an enum is
+	 * really hard to read. Use an a switch statement to take over that.
+	 */
+	switch (chan_type) {
+	case IIO_ACCEL:
+		base = FXOS8700_OUT_X_MSB;
+		break;
+	case IIO_MAGN:
+		base = FXOS8700_M_OUT_X_MSB;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/* Block read 6 bytes of device output registers to avoid data loss */
 	ret = regmap_bulk_read(data->regmap, base, data->buf,
-- 
2.39.1


