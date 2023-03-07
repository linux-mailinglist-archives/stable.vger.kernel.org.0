Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF786ADED3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjCGMfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCGMfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:35:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D087B980
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 04:35:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2401B8184F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 12:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D1CC4339B;
        Tue,  7 Mar 2023 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678192537;
        bh=llxEBkSOnHX9lKpVweaTU/8g5xQaKor6LNfSlnPfj3s=;
        h=Subject:To:Cc:From:Date:From;
        b=lYXIoxfmT1eazHN7Gdy1+oWcA3WJvRUmcXPIp0AlwceMx18fiOC9UklaGoeG7zUac
         feBqFNFX9lS2KPISCGYSMm16qk7cvBu2kib6TBelMYMqlaeDm+KlULb6armPBLLr/F
         dMYV/i6aKI8rDwhYvXRo7I+p1GAdAUD9EO2FPgSM=
Subject: FAILED: patch "[PATCH] thermal: intel: powerclamp: Fix cur_state for multi package" failed to apply to 4.14-stable tree
To:     srinivas.pandruvada@linux.intel.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 13:35:34 +0100
Message-ID: <167819253422103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 8e47363588377e1bdb65e2b020b409cfb44dd260
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167819253422103@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

8e4736358837 ("thermal: intel: powerclamp: Fix cur_state for multi package system")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e47363588377e1bdb65e2b020b409cfb44dd260 Mon Sep 17 00:00:00 2001
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Date: Wed, 1 Feb 2023 12:39:41 -0800
Subject: [PATCH] thermal: intel: powerclamp: Fix cur_state for multi package
 system

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

