Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2179686DA1
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjBASGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 13:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjBASGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 13:06:48 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D597D2A8;
        Wed,  1 Feb 2023 10:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675274807; x=1706810807;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=217n0jzbEqwc1KMujYEh03wa1IX6hmrZDo8bwPhDwWA=;
  b=Ve0ZUIRrkwq+mIjUZHs9EuTo1IWVHFI2nKxS3LqaKMIKT3dmpGWffElS
   o6N9YckYzS/OyZP8f15jhVUV4joEdlgwP7eCvqdSKGKdQxhxz5KU0XEZU
   HGbYyWM+bRs8GGZX0+KLbugpTk4x13zXF/hu6tireik/F0F8rya8LkU53
   ULKo2vH33QP1ZY7f7lw0/IiZ1Be86fmwRvws0amOKImq0qgFkdLILIG99
   0v90PqyfAQUVfn7/vnzd0rO4WrXfTAcI/XKbr87OrS3BvB+icy51DUJGQ
   UuxKHWeNP8igYtTQel53DhDisro3dgaEutHf5ndzrCzus32s0/pkpyZmi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="311868002"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="311868002"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:06:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="667002139"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="667002139"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga007.fm.intel.com with ESMTP; 01 Feb 2023 10:06:27 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: intel_powerclamp: Fix cur_state for multi package system
Date:   Wed,  1 Feb 2023 10:06:25 -0800
Message-Id: <20230201180625.2156520-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The powerclamp cooling device cur_state shows actual idle observed by
package C-state idle counters. But the implementation is not sufficient
for multi package or multi die system. The cur_state value is incorrect.
On these systems, these counters must be read from each package/die and
somehow aggregate them. But there is no good method for aggregation.

It was not a problem when explicit CPU model addition was required to
enable intel powerclamp. In this way certain CPU models could have
been avoided. But with the removal of CPU model check with the
availability of Package C-state counters, the driver is loaded on most
of the recent systems.

For multi package/die systems, just show the actual target idle state,
the system is trying to achieve. In powerclamp this is the user set
state minus one.

Also there is no use of starting a worker thread for polling package
C-state counters and applying any compensation.

Fixes: b721ca0d1927 ("thermal/powerclamp: remove cpu whitelist")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # 4.14+
---
 drivers/thermal/intel/intel_powerclamp.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index b80e25ec1261..64f082c584b2 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -57,6 +57,7 @@
 
 static unsigned int target_mwait;
 static struct dentry *debug_dir;
+static bool poll_pkg_cstate_enable;
 
 /* user selected target */
 static unsigned int set_target_ratio;
@@ -261,6 +262,9 @@ static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp = 0;
 
+	if (!poll_pkg_cstate_enable)
+		return 0;
+
 	/* we only use compensation if all adjacent ones are good */
 	if (ratio == 1 &&
 		cal_data[ratio].confidence >= CONFIDENCE_OK &&
@@ -519,7 +523,8 @@ static int start_power_clamp(void)
 	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
-	schedule_delayed_work(&poll_pkg_cstate_work, 0);
+	if (poll_pkg_cstate_enable)
+		schedule_delayed_work(&poll_pkg_cstate_work, 0);
 
 	/* start one kthread worker per online cpu */
 	for_each_online_cpu(cpu) {
@@ -585,11 +590,15 @@ static int powerclamp_get_max_state(struct thermal_cooling_device *cdev,
 static int powerclamp_get_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
-	if (true == clamping)
-		*state = pkg_cstate_ratio_cur;
-	else
+	if (true == clamping) {
+		if (poll_pkg_cstate_enable)
+			*state = pkg_cstate_ratio_cur;
+		else
+			*state = set_target_ratio;
+	} else {
 		/* to save power, do not poll idle ratio while not clamping */
 		*state = -1; /* indicates invalid state */
+	}
 
 	return 0;
 }
@@ -712,6 +721,9 @@ static int __init powerclamp_init(void)
 		goto exit_unregister;
 	}
 
+	if (topology_max_packages() == 1 && topology_max_die_per_package() == 1)
+		poll_pkg_cstate_enable = true;
+
 	cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
 						&powerclamp_cooling_ops);
 	if (IS_ERR(cooling_dev)) {
-- 
2.39.1

