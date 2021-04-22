Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F85368371
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhDVPhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 11:37:22 -0400
Received: from foss.arm.com ([217.140.110.172]:52876 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236571AbhDVPhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 11:37:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30001106F;
        Thu, 22 Apr 2021 08:36:47 -0700 (PDT)
Received: from e123648.arm.com (unknown [10.57.27.187])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6AECE3F73B;
        Thu, 22 Apr 2021 08:36:45 -0700 (PDT)
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, amitk@kernel.org, rui.zhang@intel.com,
        lukasz.luba@arm.com, stable@vger.kernel.org
Subject: [PATCH 1/3] thermal: fair share: lock thermal zone while looping over instances
Date:   Thu, 22 Apr 2021 16:36:22 +0100
Message-Id: <20210422153624.6074-2-lukasz.luba@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210422153624.6074-1-lukasz.luba@arm.com>
References: <20210422153624.6074-1-lukasz.luba@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The tz->lock must be hold during the looping over the instances in that
thermal zone. This lock was missing in the governor code since the
beginning, so it's hard to point into a particular commit.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
---
 drivers/thermal/gov_fair_share.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/gov_fair_share.c b/drivers/thermal/gov_fair_share.c
index aaa07180ab48..645432ce6365 100644
--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -82,6 +82,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 	int total_instance = 0;
 	int cur_trip_level = get_trip_level(tz);
 
+	mutex_lock(&tz->lock);
+
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
@@ -110,6 +112,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 		mutex_unlock(&instance->cdev->lock);
 		thermal_cdev_update(cdev);
 	}
+
+	mutex_unlock(&tz->lock);
 	return 0;
 }
 
-- 
2.17.1

