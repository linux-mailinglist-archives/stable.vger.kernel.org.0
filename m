Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777053CDD76
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbhGSO6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238181AbhGSO5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E2B6138C;
        Mon, 19 Jul 2021 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708889;
        bh=+/AeZ4SqTWfO/sc6k0LvpSgTqWAF7fTpsGToJETLRoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9nkzrA60ACzYM/F37MkAWWLfB29bx33yNWbgA88iyzTb+d0mcs9MjzsTzJcLKQIj
         i7BdePUR62HyEAlc4HynV57tJs466Ncqjli7rTihHWvyEGhjDMyriIOQsfWHmPsJVJ
         YrHu6ab6ajLqop+GI4Qztie0p1Zu7biJJGPuaWyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/421] iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:41 +0200
Message-Id: <20210719144952.319797358@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit c6559bf796ccdb3a0c79db846af96c8f7046880b ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.
Note this matches what was done in all the other hid sensor drivers.
This one was missed previously due to an extra level of indirection.

Found during an audit of all calls of this function.

Fixes: a96cd0f901ee ("iio: accel: hid-sensor-accel-3d: Add timestamp")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-4-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/hid-sensor-accel-3d.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index 38ff374a3ca4..32d5438d4519 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -42,8 +42,11 @@ struct accel_3d_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info accel[ACCEL_3D_CHANNEL_MAX];
-	/* Reserve for 3 channels + padding + timestamp */
-	u32 accel_val[ACCEL_3D_CHANNEL_MAX + 3];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u32 accel_val[3];
+		s64 timestamp __aligned(8);
+	} scan;
 	int scale_pre_decml;
 	int scale_post_decml;
 	int scale_precision;
@@ -254,8 +257,8 @@ static int accel_3d_proc_event(struct hid_sensor_hub_device *hsdev,
 			accel_state->timestamp = iio_get_time_ns(indio_dev);
 
 		hid_sensor_push_data(indio_dev,
-				     accel_state->accel_val,
-				     sizeof(accel_state->accel_val),
+				     &accel_state->scan,
+				     sizeof(accel_state->scan),
 				     accel_state->timestamp);
 
 		accel_state->timestamp = 0;
@@ -280,7 +283,7 @@ static int accel_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 	case HID_USAGE_SENSOR_ACCEL_Y_AXIS:
 	case HID_USAGE_SENSOR_ACCEL_Z_AXIS:
 		offset = usage_id - HID_USAGE_SENSOR_ACCEL_X_AXIS;
-		accel_state->accel_val[CHANNEL_SCAN_INDEX_X + offset] =
+		accel_state->scan.accel_val[CHANNEL_SCAN_INDEX_X + offset] =
 						*(u32 *)raw_data;
 		ret = 0;
 	break;
-- 
2.30.2



