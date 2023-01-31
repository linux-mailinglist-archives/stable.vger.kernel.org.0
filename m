Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C953682992
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjAaJxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjAaJxH (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6F411651
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41916612E6
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC0FC4339B;
        Tue, 31 Jan 2023 09:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158781;
        bh=KeiCclvNyfw0tN7sLAlrRK5i2Onc4/kv50EtHPOeakk=;
        h=Subject:To:From:Date:From;
        b=lc7XezlnXPnmPf82g0bJq3NNR8t0MFS0ErdcAfyFI9FugjLVvWGJdR6F4RkycV9Ad
         9hvaDxD5w9ZKL8iATaYAHzqlL6TR6dozRnvOZv9iYU4QY9ajX0M7hst42LVGSvqq8+
         hHGwdPyM7Z5ffnL0/Kgwkr5yYW3+625WIRUiy9ws=
Subject: patch "iio: imu: fxos8700: fix incomplete ACCEL and MAGN channels readback" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:40 +0100
Message-ID: <1675158760176135@kroah.com>
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

    iio: imu: fxos8700: fix incomplete ACCEL and MAGN channels readback

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 37a94d86d7050665d6d01378b2c916c28e454f10 Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Thu, 8 Dec 2022 15:19:07 +0800
Subject: iio: imu: fxos8700: fix incomplete ACCEL and MAGN channels readback

The length of ACCEL and MAGN 3-axis channels output data is 6 byte
individually. However block only read 3 bytes data into buffer from
ACCEL or MAGN output data registers every time. It causes an incomplete
ACCEL and MAGN channels readback.

Set correct value count for regmap_bulk_read to get 6 bytes ACCEL and
MAGN channels readback.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-4-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/fxos8700_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index 977eb7dc7dbd..b62bc92bbacc 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -414,7 +414,7 @@ static int fxos8700_get_data(struct fxos8700_data *data, int chan_type,
 
 	/* Block read 6 bytes of device output registers to avoid data loss */
 	ret = regmap_bulk_read(data->regmap, base, data->buf,
-			       FXOS8700_DATA_BUF_SIZE);
+			       sizeof(data->buf));
 	if (ret)
 		return ret;
 
-- 
2.39.1


