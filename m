Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FC34439E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCVMxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhCVMtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91D77619F9;
        Mon, 22 Mar 2021 12:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417116;
        bh=Ukbblig6Eo+6n/L/daDVL2pKRT46kywiNyPycDq+CPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnZIALmCDdR9IR4pNmf+YVESWgfpXzGjELiqGtWgcKq6vUVdY5w0H7QxSjuWBNjeZ
         Q0fficSUNo1lgKGylPLAta3Y4RQGOxv8YyktV0+tn8USUQYvA9Z20tSmxWLT3HtOEO
         eMWekGF5ZK0pLwbb1pCKkup2FWDBgWDp/SjTvGdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Xiang <xiang.ye@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 32/43] iio: hid-sensor-temperature: Fix issues of timestamp channel
Date:   Mon, 22 Mar 2021 13:28:46 +0100
Message-Id: <20210322121920.946558418@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Xiang <xiang.ye@intel.com>

commit 141e7633aa4d2838d1f6ad5c74cccc53547c16ac upstream.

This patch fixes 2 issues of timestamp channel:
1. This patch ensures that there is sufficient space and correct
alignment for the timestamp.
2. Correct the timestamp channel scan index.

Fixes: 59d0f2da3569 ("iio: hid: Add temperature sensor support")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303063615.12130-4-xiang.ye@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/hid-sensor-temperature.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/iio/temperature/hid-sensor-temperature.c
+++ b/drivers/iio/temperature/hid-sensor-temperature.c
@@ -28,7 +28,10 @@
 struct temperature_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info temperature_attr;
-	s32 temperature_data;
+	struct {
+		s32 temperature_data;
+		u64 timestamp __aligned(8);
+	} scan;
 	int scale_pre_decml;
 	int scale_post_decml;
 	int scale_precision;
@@ -45,7 +48,7 @@ static const struct iio_chan_spec temper
 			BIT(IIO_CHAN_INFO_SAMP_FREQ) |
 			BIT(IIO_CHAN_INFO_HYSTERESIS),
 	},
-	IIO_CHAN_SOFT_TIMESTAMP(3),
+	IIO_CHAN_SOFT_TIMESTAMP(1),
 };
 
 /* Adjust channel real bits based on report descriptor */
@@ -136,9 +139,8 @@ static int temperature_proc_event(struct
 	struct temperature_state *temp_st = iio_priv(indio_dev);
 
 	if (atomic_read(&temp_st->common_attributes.data_ready))
-		iio_push_to_buffers_with_timestamp(indio_dev,
-				&temp_st->temperature_data,
-				iio_get_time_ns(indio_dev));
+		iio_push_to_buffers_with_timestamp(indio_dev, &temp_st->scan,
+						   iio_get_time_ns(indio_dev));
 
 	return 0;
 }
@@ -153,7 +155,7 @@ static int temperature_capture_sample(st
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_DATA_ENVIRONMENTAL_TEMPERATURE:
-		temp_st->temperature_data = *(s32 *)raw_data;
+		temp_st->scan.temperature_data = *(s32 *)raw_data;
 		return 0;
 	default:
 		return -EINVAL;


