Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA05858760B
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 05:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiHBDnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 23:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiHBDnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 23:43:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D683DDF8C;
        Mon,  1 Aug 2022 20:42:56 -0700 (PDT)
X-UUID: 0ca8b2c3b5e843c8b908ebeeccc10ad8-20220802
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:4a5ce8df-79c2-4797-9e82-b6228ef19010,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:0f94e32,CLOUDID:08230025-a982-4824-82d2-9da3b6056c2a,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 0ca8b2c3b5e843c8b908ebeeccc10ad8-20220802
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1031403654; Tue, 02 Aug 2022 11:42:51 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 2 Aug 2022 11:42:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 2 Aug 2022 11:42:50 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
CC:     <yj.chiang@mediatek.com>,
        Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        <stable@vger.kernel.org>, Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <llvm@lists.linux.dev>
Subject: [PATCH 5.4] thermal: Fix NULL pointer dereferences in of_thermal_ functions
Date:   Tue, 2 Aug 2022 11:42:16 +0800
Message-ID: <20220802034238.27127-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>

commit 96cfe05051fd8543cdedd6807ec59a0e6c409195 upstream.

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
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 drivers/thermal/of-thermal.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 68d0c181ec7b..1f38da5da6e4 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -91,7 +91,7 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_temp)
+	if (!data->ops || !data->ops->get_temp)
 		return -EINVAL;
 
 	return data->ops->get_temp(data->sensor_data, temp);
@@ -188,6 +188,9 @@ static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
+	if (!data->ops || !data->ops->set_emul_temp)
+		return -EINVAL;
+
 	return data->ops->set_emul_temp(data->sensor_data, temp);
 }
 
@@ -196,7 +199,7 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_trend)
+	if (!data->ops || !data->ops->get_trend)
 		return -EINVAL;
 
 	return data->ops->get_trend(data->sensor_data, trip, trend);
@@ -336,7 +339,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
 
-	if (data->ops->set_trip_temp) {
+	if (data->ops && data->ops->set_trip_temp) {
 		int ret;
 
 		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
-- 
2.18.0

