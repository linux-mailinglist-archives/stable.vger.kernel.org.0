Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B473634A65D
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 12:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCZLS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhCZLSt (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 26 Mar 2021 07:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4060619FC;
        Fri, 26 Mar 2021 11:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616757529;
        bh=KEByPIfE5JUqldBTpPNKjvOarZ53pPOUbE2DjWl5YHs=;
        h=Subject:To:From:Date:From;
        b=GVwjXAHJVwk3M41tlCOORWofOE/lNW8IPRsnt99zmfgfj9DuXT/RdNzmyXRhmqB/1
         SHbVzmB2tz73KC6oNHdH8MlNlsFW1jm+S94kgEHiSpQ8D0tkpByMEsUPi5nUOOZE1C
         5+VV+3G0nFzWT5InKA7FMvHchp9yOUlPQBUgn8Vg=
Subject: patch "iio: hid-sensor-rotation: Fix quaternion data not correct" added to staging-next
To:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 12:18:40 +0100
Message-ID: <161675752011441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: hid-sensor-rotation: Fix quaternion data not correct

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 6c3b615379d7cd90d2f70b3cf9860c5a4910546a Mon Sep 17 00:00:00 2001
From: Ye Xiang <xiang.ye@intel.com>
Date: Sat, 30 Jan 2021 18:25:46 +0800
Subject: iio: hid-sensor-rotation: Fix quaternion data not correct

Because the data of HID_USAGE_SENSOR_ORIENT_QUATERNION defined by ISH FW
is s16, but quaternion data type is in_rot_quaternion_type(le:s16/32X4>>0),
need to transform data type from s16 to s32

May require manual backporting.

Fixes: fc18dddc0625 ("iio: hid-sensors: Added device rotation support")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102546.31397-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/orientation/hid-sensor-rotation.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/orientation/hid-sensor-rotation.c b/drivers/iio/orientation/hid-sensor-rotation.c
index 18e4ef060096..c087d8f72a54 100644
--- a/drivers/iio/orientation/hid-sensor-rotation.c
+++ b/drivers/iio/orientation/hid-sensor-rotation.c
@@ -21,7 +21,7 @@ struct dev_rot_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info quaternion;
 	struct {
-		u32 sampled_vals[4] __aligned(16);
+		s32 sampled_vals[4] __aligned(16);
 		u64 timestamp __aligned(8);
 	} scan;
 	int scale_pre_decml;
@@ -170,8 +170,15 @@ static int dev_rot_capture_sample(struct hid_sensor_hub_device *hsdev,
 	struct dev_rot_state *rot_state = iio_priv(indio_dev);
 
 	if (usage_id == HID_USAGE_SENSOR_ORIENT_QUATERNION) {
-		memcpy(&rot_state->scan.sampled_vals, raw_data,
-		       sizeof(rot_state->scan.sampled_vals));
+		if (raw_len / 4 == sizeof(s16)) {
+			rot_state->scan.sampled_vals[0] = ((s16 *)raw_data)[0];
+			rot_state->scan.sampled_vals[1] = ((s16 *)raw_data)[1];
+			rot_state->scan.sampled_vals[2] = ((s16 *)raw_data)[2];
+			rot_state->scan.sampled_vals[3] = ((s16 *)raw_data)[3];
+		} else {
+			memcpy(&rot_state->scan.sampled_vals, raw_data,
+			       sizeof(rot_state->scan.sampled_vals));
+		}
 
 		dev_dbg(&indio_dev->dev, "Recd Quat len:%zu::%zu\n", raw_len,
 			sizeof(rot_state->scan.sampled_vals));
-- 
2.31.0


