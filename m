Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D09F682991
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjAaJxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjAaJxB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722379008
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:52:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E16036148B
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BD9C433EF;
        Tue, 31 Jan 2023 09:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158777;
        bh=tcgYKH7qicmUsRN+ILDGY0/PJom+kwSaSnmv7UCMdUU=;
        h=Subject:To:From:Date:From;
        b=TvGXMl3vxYzPW841KPweCj0/Epp0+g77A+XrIUj5PiLpmSfzyjZveNkJ/nM3zs4CE
         1OcwdamITr5k9JxCYNszVCPUFTPlpN67EgzR+lmzhqpPLQ2dBw3ZZLTGLZfVlNSPXr
         KWxZnCPnzmci6xc8i73NPB+E/+DtSglFFOAdYVyg=
Subject: patch "iio: imu: fxos8700: fix map label of channel type to MAGN sensor" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:39 +0100
Message-ID: <16751587596414@kroah.com>
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

    iio: imu: fxos8700: fix map label of channel type to MAGN sensor

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 429e1e8ec696e0e7a0742904e3dc2f83b7b23dfb Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Thu, 8 Dec 2022 15:19:05 +0800
Subject: iio: imu: fxos8700: fix map label of channel type to MAGN sensor

FXOS8700 is an IMU sensor with ACCEL sensor and MAGN sensor.
Sensor type is indexed by corresponding channel type in a switch.
IIO_ANGL_VEL channel type mapped to MAGN sensor has caused confusion.

Fix the mapping label of "IIO_MAGN" channel type instead of
"IIO_ANGL_VEL" channel type to MAGN sensor.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-2-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/fxos8700_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index 423cfe526f2a..235b02b2f4e5 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -320,7 +320,7 @@ static enum fxos8700_sensor fxos8700_to_sensor(enum iio_chan_type iio_type)
 	switch (iio_type) {
 	case IIO_ACCEL:
 		return FXOS8700_ACCEL;
-	case IIO_ANGL_VEL:
+	case IIO_MAGN:
 		return FXOS8700_MAGN;
 	default:
 		return -EINVAL;
-- 
2.39.1


