Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382586AEA1E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjCGRay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjCGRah (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:37 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01077A2F1C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678209956; x=1709745956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8KkzJx9zlV35bc9u2zup5EvZ9zHhoEdTO430oOK1BU4=;
  b=ZwRQwcqY0CWej88zLTA1vlV+3vYnKpHzTYWvl4XMON1aNaQJDv1ft+fl
   4FwMu1lKuoTJSwJ8ozJwQBm88pY5I7SVUR+Vz6bSC7X6+/L8/payT3G/a
   wbpqmpX49eyTlyjLPSJPiStjBGhf65bmH9c6gGaW+Rck+sVc0zcIC6PEt
   H37kK5sZ40/VqC973CNrQmykgpJHL/reNtPyVC9SGrLyX4UQlg7rvpHTz
   C3IP7iu9aWifGL8PluWEz64yoOQJ34HDduaOpnVmEGrCL8oTldr7uvpAt
   bDO3iPrjLr1fkdmBEceA9DQNdk5zjd/DYsj5dhC8LyIHkxp4YsK9//pfE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="315572440"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="315572440"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 09:25:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="800460179"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="800460179"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by orsmga004.jf.intel.com with ESMTP; 07 Mar 2023 09:25:56 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14.y] thermal: intel: powerclamp: Fix cur_state for multi package system
Date:   Tue,  7 Mar 2023 09:25:48 -0800
Message-Id: <20230307172548.1533286-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167819253422103@kroah.com>
References: <167819253422103@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
(cherry picked from commit 8e47363588377e1bdb65e2b020b409cfb44dd260)
---
 drivers/thermal/intel_powerclamp.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 68cc88637e06..1f79eca3754e 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -72,6 +72,7 @@
 
 static unsigned int target_mwait;
 static struct dentry *debug_dir;
+static bool poll_pkg_cstate_enable;
 
 /* user selected target */
 static unsigned int set_target_ratio;
@@ -280,6 +281,9 @@ static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp = 0;
 
+	if (!poll_pkg_cstate_enable)
+		return 0;
+
 	/* we only use compensation if all adjacent ones are good */
 	if (ratio == 1 &&
 		cal_data[ratio].confidence >= CONFIDENCE_OK &&
@@ -552,7 +556,8 @@ static int start_power_clamp(void)
 	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
-	schedule_delayed_work(&poll_pkg_cstate_work, 0);
+	if (poll_pkg_cstate_enable)
+		schedule_delayed_work(&poll_pkg_cstate_work, 0);
 
 	/* start one kthread worker per online cpu */
 	for_each_online_cpu(cpu) {
@@ -621,11 +626,15 @@ static int powerclamp_get_max_state(struct thermal_cooling_device *cdev,
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
@@ -770,6 +779,9 @@ static int __init powerclamp_init(void)
 		goto exit_unregister;
 	}
 
+	if (topology_max_packages() == 1)
+		poll_pkg_cstate_enable = true;
+
 	cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
 						&powerclamp_cooling_ops);
 	if (IS_ERR(cooling_dev)) {
-- 
2.39.1

