Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A2360C2A
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhDOOtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhDOOtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:49:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88EEE6137D;
        Thu, 15 Apr 2021 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498121;
        bh=Cl7ZrAP3yiXg+iRi11uR14V76FtA/bB7uBrf4q6kP/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDAnYIoOOlCFptFmDNiEgIy4LqXKxiE5Vr49do0K6jDM0vrWwvBglB5JSNfQH2WYp
         eoy6/YJNWqFIQDUL6kVqbOjR0L0pmhVOegi/uelSMUc8gbeuWiNK12r0wRRdd9mSrV
         D7p+wY4ESyXgREx1+4vC0XFpYe2/JSIY8UFBb/YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Xiang <xiang.ye@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 01/38] iio: hid-sensor-prox: Fix scale not correct issue
Date:   Thu, 15 Apr 2021 16:46:55 +0200
Message-Id: <20210415144413.407579678@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Xiang <xiang.ye@intel.com>

commit d68c592e02f6f49a88e705f13dfc1883432cf300 upstream

Currently, the proxy sensor scale is zero because it just return the
exponent directly. To fix this issue, this patch use
hid_sensor_format_scale to process the scale first then return the
output.

Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102530.31064-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -37,6 +37,9 @@ struct prox_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info prox_attr;
 	u32 human_presence;
+	int scale_pre_decml;
+	int scale_post_decml;
+	int scale_precision;
 };
 
 /* Channel definitions */
@@ -105,8 +108,9 @@ static int prox_read_raw(struct iio_dev
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
@@ -240,6 +244,12 @@ static int prox_parse_report(struct plat
 			st->common_attributes.sensitivity.index,
 			st->common_attributes.sensitivity.report_id);
 	}
+
+	st->scale_precision = hid_sensor_format_scale(
+				hsdev->usage,
+				&st->prox_attr,
+				&st->scale_pre_decml, &st->scale_post_decml);
+
 	return ret;
 }
 


