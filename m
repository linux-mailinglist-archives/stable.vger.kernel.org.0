Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E4C33C007
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbhCOPf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233310AbhCOPf1 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06E964E64;
        Mon, 15 Mar 2021 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822527;
        bh=XYrivjzV5+x6p8BFIzAUw0s25QbwOWcT4L2G3G7OOr8=;
        h=Subject:To:From:Date:From;
        b=emCfOT1CUm0QqFGef2q913AyIwUhOQBa4NZyVpwM/XowS6HxVlNPrjVn8df/nYu0j
         ePPHEjf+U0GAjeVfsPnqMNOZb+kWsRB8FNO/juJZXrwosT6aag0KclKMi534G50rv2
         qq0BBbtbqfUx0+YUXUgfV3BKKXu8t+xhQ58hIbQs=
Subject: patch "iio: hid-sensor-prox: Fix scale not correct issue" added to staging-linus
To:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:21 +0100
Message-ID: <1615822521205178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: hid-sensor-prox: Fix scale not correct issue

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d68c592e02f6f49a88e705f13dfc1883432cf300 Mon Sep 17 00:00:00 2001
From: Ye Xiang <xiang.ye@intel.com>
Date: Sat, 30 Jan 2021 18:25:30 +0800
Subject: iio: hid-sensor-prox: Fix scale not correct issue

Currently, the proxy sensor scale is zero because it just return the
exponent directly. To fix this issue, this patch use
hid_sensor_format_scale to process the scale first then return the
output.

Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102530.31064-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/hid-sensor-prox.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-prox.c b/drivers/iio/light/hid-sensor-prox.c
index 330cf359e0b8..e9e00ce0c6d4 100644
--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -23,6 +23,9 @@ struct prox_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info prox_attr;
 	u32 human_presence;
+	int scale_pre_decml;
+	int scale_post_decml;
+	int scale_precision;
 };
 
 /* Channel definitions */
@@ -93,8 +96,9 @@ static int prox_read_raw(struct iio_dev *indio_dev,
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SCALE:
-		*val = prox_state->prox_attr.units;
-		ret_type = IIO_VAL_INT;
+		*val = prox_state->scale_pre_decml;
+		*val2 = prox_state->scale_post_decml;
+		ret_type = prox_state->scale_precision;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = hid_sensor_convert_exponent(
@@ -234,6 +238,11 @@ static int prox_parse_report(struct platform_device *pdev,
 			HID_USAGE_SENSOR_HUMAN_PRESENCE,
 			&st->common_attributes.sensitivity);
 
+	st->scale_precision = hid_sensor_format_scale(
+				hsdev->usage,
+				&st->prox_attr,
+				&st->scale_pre_decml, &st->scale_post_decml);
+
 	return ret;
 }
 
-- 
2.30.2


