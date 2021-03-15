Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6B333C010
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhCOPgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234557AbhCOPfv (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96DBE64E6B;
        Mon, 15 Mar 2021 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822551;
        bh=GJF71u5G4Cqxuaj4AVng+P8JBVjN4whq39jkcfRd3kQ=;
        h=Subject:To:From:Date:From;
        b=TRzcxG2b9wDQFxAJcKpbbU2IrQ2azuf0gVWoWjfysWMw5zxTK7b9WSbuEU6xFWJ9J
         wiLJVINiqZMby0mTsZXwXywdqtVmrsX7NNqEBT2jLclsnWSoMgCnse45u3eO9NiTTO
         rBFOIJ5WzO5P+zRLhsqfU1+1AuUCM7xIL/bLQHBs=
Subject: patch "iio: hid-sensor-humidity: Fix alignment issue of timestamp channel" added to staging-linus
To:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:26 +0100
Message-ID: <161582252651243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: hid-sensor-humidity: Fix alignment issue of timestamp channel

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 37e89e574dc238a4ebe439543c5ab4fbb2f0311b Mon Sep 17 00:00:00 2001
From: Ye Xiang <xiang.ye@intel.com>
Date: Wed, 3 Mar 2021 14:36:12 +0800
Subject: iio: hid-sensor-humidity: Fix alignment issue of timestamp channel

This patch ensures that, there is sufficient space and correct
alignment for the timestamp.

Fixes: d7ed89d5aadf ("iio: hid: Add humidity sensor support")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303063615.12130-2-xiang.ye@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/humidity/hid-sensor-humidity.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/humidity/hid-sensor-humidity.c b/drivers/iio/humidity/hid-sensor-humidity.c
index 52f605114ef7..d62705448ae2 100644
--- a/drivers/iio/humidity/hid-sensor-humidity.c
+++ b/drivers/iio/humidity/hid-sensor-humidity.c
@@ -15,7 +15,10 @@
 struct hid_humidity_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info humidity_attr;
-	s32 humidity_data;
+	struct {
+		s32 humidity_data;
+		u64 timestamp __aligned(8);
+	} scan;
 	int scale_pre_decml;
 	int scale_post_decml;
 	int scale_precision;
@@ -125,9 +128,8 @@ static int humidity_proc_event(struct hid_sensor_hub_device *hsdev,
 	struct hid_humidity_state *humid_st = iio_priv(indio_dev);
 
 	if (atomic_read(&humid_st->common_attributes.data_ready))
-		iio_push_to_buffers_with_timestamp(indio_dev,
-					&humid_st->humidity_data,
-					iio_get_time_ns(indio_dev));
+		iio_push_to_buffers_with_timestamp(indio_dev, &humid_st->scan,
+						   iio_get_time_ns(indio_dev));
 
 	return 0;
 }
@@ -142,7 +144,7 @@ static int humidity_capture_sample(struct hid_sensor_hub_device *hsdev,
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_ATMOSPHERIC_HUMIDITY:
-		humid_st->humidity_data = *(s32 *)raw_data;
+		humid_st->scan.humidity_data = *(s32 *)raw_data;
 
 		return 0;
 	default:
-- 
2.30.2


