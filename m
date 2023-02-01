Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86356686FC2
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 21:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBAUj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 15:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBAUjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 15:39:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353FF5CD26;
        Wed,  1 Feb 2023 12:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675283983; x=1706819983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CIUf85ECHrLs7jYFIV4Z9a6KYQcONf8mKzLBNRpgQ9w=;
  b=mc3fxK5iSRAr38qD9jQV66JLSW6zGHw6CuE7EAPfOFxLFAo5RDZ/LSy5
   3LEgDgM3uJ7Do7KnCWA6xmOg6CwRrmprFwLsZJzg7tW1kOoPRx99/9cdn
   Z0H+S7H6+p5pYjurtdzoRJfR/flPx/+1dQGzd8H2Dt0H1bXn0GjF0S5fW
   jQm9fY1u/xMjVXbipiAwELc+RX72csYOJdEiQRfoe5KcLzdm7PoCk26Tn
   uRftivbrnOmKtigRzztMhPR43Fdx5we5cCW/dLsAgAYw1awq+OWnNxg0W
   tCA7zMxfRDrqDjUFMNYWDughjL9xp0uifwPfXsmZWqKQKWfnEtTqhb3hD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="329561835"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="329561835"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 12:39:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="614985941"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="614985941"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by orsmga003.jf.intel.com with ESMTP; 01 Feb 2023 12:39:42 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] thermal: intel_powerclamp: Fix cur_state for multi package system
Date:   Wed,  1 Feb 2023 12:39:41 -0800
Message-Id: <20230201203941.2166530-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
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
C-state counters and applying any compensation for multiple package
or multiple die systems.

Fixes: b721ca0d1927 ("thermal/powerclamp: remove cpu whitelist")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # 4.14+
---
v2:
Changed: (true == clamping) to (clamping)
Updated commit description for the last paragraph

 drivers/thermal/intel/intel_powerclamp.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index b80e25ec1261..2f4cbfdf26a0 100644
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
+	if (clamping) {
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

