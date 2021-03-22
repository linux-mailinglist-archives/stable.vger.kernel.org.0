Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2091344338
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhCVMtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbhCVMrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B648E60C3D;
        Mon, 22 Mar 2021 12:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416996;
        bh=R4WIYEhC1BKBbmCob2bSPx5SevjcQwQV18i32/yGP1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLzuMG4rij93drM9bE84n0jy8mefyxHW7QIbsj4aVeryLP8hNP4I9FortIeR3e5Qc
         oi1X+okC0Ml0Vz1Fs1Hhu5gjpLpl3+Oqsb7SAt+xYM/wjAHZigl5niqhBIlR4+nl6p
         5DdAEjg9AjKnSwimLQeqyyP0bm5tcQmWfaLLvnL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Xiang <xiang.ye@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 46/60] iio: hid-sensor-temperature: Fix issues of timestamp channel
Date:   Mon, 22 Mar 2021 13:28:34 +0100
Message-Id: <20210322121923.912938670@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
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
@@ -17,7 +17,10 @@
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
@@ -34,7 +37,7 @@ static const struct iio_chan_spec temper
 			BIT(IIO_CHAN_INFO_SAMP_FREQ) |
 			BIT(IIO_CHAN_INFO_HYSTERESIS),
 	},
-	IIO_CHAN_SOFT_TIMESTAMP(3),
+	IIO_CHAN_SOFT_TIMESTAMP(1),
 };
 
 /* Adjust channel real bits based on report descriptor */
@@ -125,9 +128,8 @@ static int temperature_proc_event(struct
 	struct temperature_state *temp_st = iio_priv(indio_dev);
 
 	if (atomic_read(&temp_st->common_attributes.data_ready))
-		iio_push_to_buffers_with_timestamp(indio_dev,
-				&temp_st->temperature_data,
-				iio_get_time_ns(indio_dev));
+		iio_push_to_buffers_with_timestamp(indio_dev, &temp_st->scan,
+						   iio_get_time_ns(indio_dev));
 
 	return 0;
 }
@@ -142,7 +144,7 @@ static int temperature_capture_sample(st
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_DATA_ENVIRONMENTAL_TEMPERATURE:
-		temp_st->temperature_data = *(s32 *)raw_data;
+		temp_st->scan.temperature_data = *(s32 *)raw_data;
 		return 0;
 	default:
 		return -EINVAL;


