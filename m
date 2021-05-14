Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E576938099B
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 14:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhENMeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 08:34:36 -0400
Received: from foss.arm.com ([217.140.110.172]:48884 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhENMef (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 08:34:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E96EF1476;
        Fri, 14 May 2021 05:33:23 -0700 (PDT)
Received: from e123648.arm.com (unknown [10.57.31.97])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7495A3F73B;
        Fri, 14 May 2021 05:33:22 -0700 (PDT)
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, daniel.lezcano@linaro.org,
        rui.zhang@intel.com, lukasz.luba@arm.com
Subject: [STABLE][PATCH 4.19] thermal/core/fair share: Lock the thermal zone while looping over instances
Date:   Fri, 14 May 2021 13:33:12 +0100
Message-Id: <20210514123312.5292-1-lukasz.luba@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fef05776eb02238dcad8d5514e666a42572c3f32 upstream.

The tz->lock must be hold during the looping over the instances in that
thermal zone. This lock was missing in the governor code since the
beginning, so it's hard to point into a particular commit.

CC: stable@vger.kernel.org # 4.19
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
---
Hi all,

I've backported my patch which was sent to LKML:
https://lore.kernel.org/linux-pm/20210422153624.6074-2-lukasz.luba@arm.com/

The upstream patch failed while applying:
https://lore.kernel.org/stable/162063715024633@kroah.com/

This patch should apply to stable v4.19.y, on top of stable tree branch:
linux-4.19.y which head was at:
commit 3c8c23092588 Linux 4.19.190

Regards,
Lukasz Luba

 drivers/thermal/fair_share.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index d3469fbc5207..26d7387f5834 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -94,6 +94,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 	int total_instance = 0;
 	int cur_trip_level = get_trip_level(tz);
 
+	mutex_lock(&tz->lock);
+
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
@@ -122,6 +124,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 		mutex_unlock(&instance->cdev->lock);
 		thermal_cdev_update(cdev);
 	}
+
+	mutex_unlock(&tz->lock);
 	return 0;
 }
 
-- 
2.17.1

