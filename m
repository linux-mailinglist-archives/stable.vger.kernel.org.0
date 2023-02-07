Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE34068D8E3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjBGNOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjBGNNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:13:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C643BD8D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C15D56143A
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE21BC433D2;
        Tue,  7 Feb 2023 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775570;
        bh=Co39vqHw1caTdOO0x1RYgwYCTJJk5eaLWGt6vCErSVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKYJB2QWgotXS3oEt9OU0lXc65shP/P/ZSSt2wz3bDKYQJ91L2QeUAzTo/XD8Z1mv
         72C6+YtY65N4HpYmDP+zPvR+TmwBnP1sVeIFQD8BQFhfKpwthSxPMORTEbX4Z/pnXu
         ikht3qSC4kuBfo/EFquSWaSD5Ojfx2Fd8HbBeBZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlos Song <carlos.song@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 085/120] iio: imu: fxos8700: fix MAGN sensor scale and unit
Date:   Tue,  7 Feb 2023 13:57:36 +0100
Message-Id: <20230207125622.363873348@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

commit 2acd031347f645871959a799238a7caf6803aa18 upstream.

+/-1200uT is a MAGN sensor full measurement range. Magnetometer scale
is the magnetic sensitivity parameter. It is referenced as 0.1uT
according to datasheet and magnetometer channel unit is Gauss in
sysfs-bus-iio documentation. Gauss and uTesla unit conversion
relationship as follows: 0.1uT = 0.001Gs.

Set magnetometer scale and available magnetometer scale as fixed 0.001Gs.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-5-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -351,7 +351,7 @@ static int fxos8700_set_scale(struct fxo
 	struct device *dev = regmap_get_device(data->regmap);
 
 	if (t == FXOS8700_MAGN) {
-		dev_err(dev, "Magnetometer scale is locked at 1200uT\n");
+		dev_err(dev, "Magnetometer scale is locked at 0.001Gs\n");
 		return -EINVAL;
 	}
 
@@ -396,7 +396,7 @@ static int fxos8700_get_scale(struct fxo
 	static const int scale_num = ARRAY_SIZE(fxos8700_accel_scale);
 
 	if (t == FXOS8700_MAGN) {
-		*uscale = 1200; /* Magnetometer is locked at 1200uT */
+		*uscale = 1000; /* Magnetometer is locked at 0.001Gs */
 		return 0;
 	}
 
@@ -588,7 +588,7 @@ static IIO_CONST_ATTR(in_accel_sampling_
 static IIO_CONST_ATTR(in_magn_sampling_frequency_available,
 		      "1.5625 6.25 12.5 50 100 200 400 800");
 static IIO_CONST_ATTR(in_accel_scale_available, "0.000244 0.000488 0.000976");
-static IIO_CONST_ATTR(in_magn_scale_available, "0.000001200");
+static IIO_CONST_ATTR(in_magn_scale_available, "0.001000");
 
 static struct attribute *fxos8700_attrs[] = {
 	&iio_const_attr_in_accel_sampling_frequency_available.dev_attr.attr,


