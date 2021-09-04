Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C70D4008D1
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 03:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241754AbhIDAfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 20:35:37 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:12191 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350596AbhIDAfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 20:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1630715674; x=1662251674;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=H+0sThsCk1GXhtCO6un41ezE/YNTdH11kjUn+GY8Vz8=;
  b=oBQrAE/3lJKyeLyhnDmuMQHqYSWtU2GdiC+VlBkNOqciFUrpqnKTn2KO
   Rtx08n6mqfbImVK27LVPANNjQW9kiDYFw51jKhXspEtCpTimU01I3o7Q0
   ZWvh+lfMy63ragmxYnZq0NTAvGXLhNO7t5OaT95Ilc3LSxAyJGvzsN2hJ
   I=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 03 Sep 2021 17:34:33 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 17:34:33 -0700
Received: from hu-subbaram-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Fri, 3 Sep 2021 17:34:32 -0700
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
To:     Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Subbaraman Narayanamurthy" <quic_subbaram@quicinc.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] thermal: Fix a NULL pointer dereference
Date:   Fri, 3 Sep 2021 17:34:19 -0700
Message-ID: <1630715659-5058-1-git-send-email-quic_subbaram@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

of_parse_thermal_zones() parses the thermal-zones node and registers a
thermal_zone device for each subnode. However, if a thermal zone is
consuming a thermal sensor and that thermal sensor device hasn't probed
yet, an attempt to set trip_point_*_temp for that thermal zone device
can cause a NULL pointer dereference. Fix it.

 console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
 ...
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
 ...
 Call trace:
  of_thermal_set_trip_temp+0x40/0xc4
  trip_point_temp_store+0xc0/0x1dc
  dev_attr_store+0x38/0x88
  sysfs_kf_write+0x64/0xc0
  kernfs_fop_write_iter+0x108/0x1d0
  vfs_write+0x2f4/0x368
  ksys_write+0x7c/0xec
  __arm64_sys_write+0x20/0x30
  el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
  do_el0_svc+0x28/0xa0
  el0_svc+0x14/0x24
  el0_sync_handler+0x88/0xec
  el0_sync+0x1c0/0x200

Cc: stable@vger.kernel.org
Suggested-by: David Collins <quic_collinsd@quicinc.com>
Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
---
 drivers/thermal/thermal_of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 6379f26..ba53252 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -301,7 +301,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
 
-	if (data->ops->set_trip_temp) {
+	if (data->ops && data->ops->set_trip_temp) {
 		int ret;
 
 		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
-- 
2.7.4

