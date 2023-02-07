Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672A168D81F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjBGNGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjBGNGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:06:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EBB3B3F2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1668EB81995
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5F1C4339C;
        Tue,  7 Feb 2023 13:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775116;
        bh=zw3Ej4DQHnK68ivRbJEMtNpSPtbdX+rbd1524cdgHL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4RLR26+0Nwdw2Gc/bQsU3euV4T0LfbHmX0y0mo5dMG88JWDguaCFPp2kX3veM40/
         b4zt70ZvBh/JMnt1oJ2YqEGQ67XqKK1/Zds3cDm6mdKL7t/jTnaLYBZqup8WAtTjme
         bwJ/qkCnldKvvNumQo94AfW2zqErGTofO+zKaMA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlos Song <carlos.song@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 141/208] iio: imu: fxos8700: fix IMU data bits returned to user space
Date:   Tue,  7 Feb 2023 13:56:35 +0100
Message-Id: <20230207125640.813155230@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Song <carlos.song@nxp.com>

commit a53f945879c0cb9de3a4c05a665f5157884b5208 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -418,6 +418,7 @@ static int fxos8700_get_data(struct fxos
 			     int axis, int *val)
 {
 	u8 base, reg;
+	s16 tmp;
 	int ret;
 	enum fxos8700_sensor type = fxos8700_to_sensor(chan_type);
 
@@ -432,8 +433,33 @@ static int fxos8700_get_data(struct fxos
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


