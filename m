Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0159B3442AC
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCVMoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232417AbhCVMmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC35D619C2;
        Mon, 22 Mar 2021 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416815;
        bh=csRO1uHA+ebS1cA/uKv9E8bjpUz3v4a+1scjtSwj9/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWNPvUbpralb3B33IaK1yXHnenK2cEM4HGdoHuCeCVR1nWb1fR2JnTIXmX6cZxi/i
         u4gDIFVlnYpLaOxFgG2j6g79+04oR3fzsMDAqX64NzXUP7zkxNBSS+zs7/Surc3D6H
         IToXg3rE2CxUxv58k2TGroKe3I8ALPD8wu70f3Lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Xiang <xiang.ye@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 132/157] iio: hid-sensor-humidity: Fix alignment issue of timestamp channel
Date:   Mon, 22 Mar 2021 13:28:09 +0100
Message-Id: <20210322121937.945310194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Xiang <xiang.ye@intel.com>

commit 37e89e574dc238a4ebe439543c5ab4fbb2f0311b upstream.

This patch ensures that, there is sufficient space and correct
alignment for the timestamp.

Fixes: d7ed89d5aadf ("iio: hid: Add humidity sensor support")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303063615.12130-2-xiang.ye@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hid-sensor-humidity.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

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
@@ -125,9 +128,8 @@ static int humidity_proc_event(struct hi
 	struct hid_humidity_state *humid_st = iio_priv(indio_dev);
 
 	if (atomic_read(&humid_st->common_attributes.data_ready))
-		iio_push_to_buffers_with_timestamp(indio_dev,
-					&humid_st->humidity_data,
-					iio_get_time_ns(indio_dev));
+		iio_push_to_buffers_with_timestamp(indio_dev, &humid_st->scan,
+						   iio_get_time_ns(indio_dev));
 
 	return 0;
 }
@@ -142,7 +144,7 @@ static int humidity_capture_sample(struc
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_ATMOSPHERIC_HUMIDITY:
-		humid_st->humidity_data = *(s32 *)raw_data;
+		humid_st->scan.humidity_data = *(s32 *)raw_data;
 
 		return 0;
 	default:


