Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC8E445CCA
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 00:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhKEAAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 20:00:07 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:17453 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhKEAAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 20:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1636070248; x=1667606248;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=w7rfv40xousbt1y5DD8foHFonHq0uWv+FhqE3aI0HR4=;
  b=Mtb2mY51g+qRAJq652pDgHPwuPTuiCbEYYp+cvq2BfkxPRHib4c3Oprm
   UpOr11S8tRy/QGf30hmAoiNpXCrOE1jfUJCE6+EHnOQSL3zEz4xDZYQoC
   c2FO/9cDulM0ie7uA0n+QCuB4jiGAqNCysyEtPhgjATJAclx3fEtximz/
   U=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 04 Nov 2021 16:57:28 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 16:57:28 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Thu, 4 Nov 2021 16:57:28 -0700
Received: from hu-subbaram-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Thu, 4 Nov 2021 16:57:27 -0700
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        <stable@vger.kernel.org>,
        "Subbaraman Narayanamurthy" <quic_subbaram@quicinc.com>
Subject: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
Date:   Thu, 4 Nov 2021 16:57:07 -0700
Message-ID: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
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

While at it, fix the possible NULL pointer dereference in other
functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
of_thermal_get_trend().

Suggested-by: David Collins <quic_collinsd@quicinc.com>
Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
---
 drivers/thermal/thermal_of.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 6379f26..9233f7e 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -89,7 +89,7 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_temp)
+	if (!data->ops || !data->ops->get_temp)
 		return -EINVAL;
 
 	return data->ops->get_temp(data->sensor_data, temp);
@@ -186,6 +186,9 @@ static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
+	if (!data->ops || !data->ops->set_emul_temp)
+		return -EINVAL;
+
 	return data->ops->set_emul_temp(data->sensor_data, temp);
 }
 
@@ -194,7 +197,7 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_trend)
+	if (!data->ops || !data->ops->get_trend)
 		return -EINVAL;
 
 	return data->ops->get_trend(data->sensor_data, trip, trend);
@@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
 
-	if (data->ops->set_trip_temp) {
+	if (data->ops && data->ops->set_trip_temp) {
 		int ret;
 
 		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
-- 
2.7.4

