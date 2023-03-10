Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3C6B44BE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbjCJO1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCJO1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:27:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E42118BCC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:26:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9280B6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C65C433EF;
        Fri, 10 Mar 2023 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458363;
        bh=3/hLmWewTAnRQ3f5N1F3icsbR+2eZD1EpO5hvcYONSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP/IxTQzHAkBxxnBP/hWotp8Tr7SkY0PkKC95FgsoJZPwf1ExAao0w5n3tEVbUZYK
         Wch4UsrmcyOVdSX8+62iTkzE7+AbQwyGP8PUjDcjNsd9ZtUdKMs9lYlMru1WIXt6ls
         pt4c+GBvbg8I0L0O/19LJ/D0WQ7rCK6FaJTWuwoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 252/252] thermal: intel: powerclamp: Fix cur_state for multi package system
Date:   Fri, 10 Mar 2023 14:40:22 +0100
Message-Id: <20230310133727.289308752@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 8e47363588377e1bdb65e2b020b409cfb44dd260 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel_powerclamp.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -72,6 +72,7 @@
 
 static unsigned int target_mwait;
 static struct dentry *debug_dir;
+static bool poll_pkg_cstate_enable;
 
 /* user selected target */
 static unsigned int set_target_ratio;
@@ -280,6 +281,9 @@ static unsigned int get_compensation(int
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
@@ -621,11 +626,15 @@ static int powerclamp_get_max_state(stru
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


