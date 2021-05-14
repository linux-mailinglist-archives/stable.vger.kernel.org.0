Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7253807B3
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhENKum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 06:50:42 -0400
Received: from foss.arm.com ([217.140.110.172]:47190 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhENKum (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 06:50:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB9301713;
        Fri, 14 May 2021 03:49:30 -0700 (PDT)
Received: from e123648.arm.com (unknown [10.57.31.97])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 176B63F73B;
        Fri, 14 May 2021 03:49:28 -0700 (PDT)
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com, lukasz.luba@arm.com
Subject: [STABLE][PATCH 4.4] thermal/core/fair share: Lock the thermal zone while looping over instances
Date:   Fri, 14 May 2021 11:49:16 +0100
Message-Id: <20210514104916.19975-1-lukasz.luba@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fef05776eb02238dcad8d5514e666a42572c3f32 upstream.

The tz->lock must be hold during the looping over the instances in that
thermal zone. This lock was missing in the governor code since the
beginning, so it's hard to point into a particular commit.

CC: stable@vger.kernel.org # 4.4
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
---
Hi all,

I've backported my patch which was sent to LKML:
https://lore.kernel.org/linux-pm/20210422153624.6074-2-lukasz.luba@arm.com/

The upstream patch failed while applying:
https://lore.kernel.org/stable/16206371483193@kroah.com/

This patch should apply to stable v4.4.y, on top of stable tree branch:
linux-4.4.y which head was at:
commit 47127fcd287c ("Linux 4.4.268")

Regards,
Lukasz Luba

 drivers/thermal/fair_share.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index 34fe36504a55..e701356441a9 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -93,6 +93,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 	int total_instance = 0;
 	int cur_trip_level = get_trip_level(tz);
 
+	mutex_lock(&tz->lock);
+
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
@@ -119,6 +121,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 		instance->cdev->updated = false;
 		thermal_cdev_update(cdev);
 	}
+
+	mutex_unlock(&tz->lock);
 	return 0;
 }
 
-- 
2.17.1

