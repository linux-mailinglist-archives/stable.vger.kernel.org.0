Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDF937CAF0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhELQdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241300AbhELQ1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F249061625;
        Wed, 12 May 2021 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834691;
        bh=6QQ2TqVHf3CmrVi6DFUE6LljiPYNFvr21qXvzOq5xl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ws5nK61lmRXuXnOeXQ1EqkmFheAi1Qoa78wQ5BDbrWJ9jESYThjPqbbaP6PAyBy7T
         6thekljS+tKqkSOSg54yPOfujoTtCZGjw3N5Hf0ayXMUbcRbKrMt6KBueJv79WAaDx
         Fy/KSGBrxs5tUshPV8F3pOLp0W3rt6kMTjF5O2w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Xiang <xiang.ye@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 046/677] iio: hid-sensor-rotation: Fix quaternion data not correct
Date:   Wed, 12 May 2021 16:41:32 +0200
Message-Id: <20210512144838.738510534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Xiang <xiang.ye@intel.com>

commit 6c3b615379d7cd90d2f70b3cf9860c5a4910546a upstream.

Because the data of HID_USAGE_SENSOR_ORIENT_QUATERNION defined by ISH FW
is s16, but quaternion data type is in_rot_quaternion_type(le:s16/32X4>>0),
need to transform data type from s16 to s32

May require manual backporting.

Fixes: fc18dddc0625 ("iio: hid-sensors: Added device rotation support")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102546.31397-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/orientation/hid-sensor-rotation.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

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
@@ -170,8 +170,15 @@ static int dev_rot_capture_sample(struct
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


