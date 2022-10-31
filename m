Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F3613062
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJaGiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiJaGix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:38:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0700F6550
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95C6A60FD3
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC747C433B5;
        Mon, 31 Oct 2022 06:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198332;
        bh=5lEhlgENiGdKXSoWvwD2ADe65cim5PHLz16H56hJL70=;
        h=Subject:To:Cc:From:Date:From;
        b=Jc/c61Xv8X5fJUfoK+LEKxenwC81SaNzx4CQg1MVXyYvysWhf1eyrBraCh0Fc0jJd
         /fls3pA0BhHPhzi7pSwP7vMnty6My0dGM24RFzHjs4OGwfB2L0T7wE/IG7Jfg1oNx3
         RPOxVUJ0toPWMT/WUDknW0tTd/cal8RPNiIotCqE=
Subject: FAILED: patch "[PATCH] coresight: cti: Fix hang in cti_disable_hw()" failed to apply to 5.10-stable tree
To:     james.clark@arm.com, Aishwarya.TCV@arm.com,
        Cristian.Marussi@arm.com, gregkh@linuxfoundation.org,
        mike.leach@linaro.org, stable@kernel.org, suzuki.poulose@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:39:32 +0100
Message-ID: <16671983722103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6746eae4bbad ("coresight: cti: Fix hang in cti_disable_hw()")
692c9a499b28 ("coresight: cti: Correct the parameter for pm_runtime_put")
8ce0029658ba ("coresight: Convert claim/disclaim operations to use access wrappers")
020052825e49 ("coresight: Convert coresight_timeout to use access abstraction")
4eb1d85cfda8 ("coresight: tpiu: Prepare for using coresight device access abstraction")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6746eae4bbaddcc16b40efb33dab79210828b3ce Mon Sep 17 00:00:00 2001
From: James Clark <james.clark@arm.com>
Date: Tue, 25 Oct 2022 14:10:32 +0100
Subject: [PATCH] coresight: cti: Fix hang in cti_disable_hw()

cti_enable_hw() and cti_disable_hw() are called from an atomic context
so shouldn't use runtime PM because it can result in a sleep when
communicating with firmware.

Since commit 3c6656337852 ("Revert "firmware: arm_scmi: Add clock
management to the SCMI power domain""), this causes a hang on Juno when
running the Perf Coresight tests or running this command:

  perf record -e cs_etm//u -- ls

This was also missed until the revert commit because pm_runtime_put()
was called with the wrong device until commit 692c9a499b28 ("coresight:
cti: Correct the parameter for pm_runtime_put")

With lock and scheduler debugging enabled the following is output:

   coresight cti_sys0: cti_enable_hw -- dev:cti_sys0  parent: 20020000.cti
   BUG: sleeping function called from invalid context at drivers/base/power/runtime.c:1151
   in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 330, name: perf-exec
   preempt_count: 2, expected: 0
   RCU nest depth: 0, expected: 0
   INFO: lockdep is turned off.
   irq event stamp: 0
   hardirqs last  enabled at (0): [<0000000000000000>] 0x0
   hardirqs last disabled at (0): [<ffff80000822b394>] copy_process+0xa0c/0x1948
   softirqs last  enabled at (0): [<ffff80000822b394>] copy_process+0xa0c/0x1948
   softirqs last disabled at (0): [<0000000000000000>] 0x0
   CPU: 3 PID: 330 Comm: perf-exec Not tainted 6.0.0-00053-g042116d99298 #7
   Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Sep 13 2022
   Call trace:
    dump_backtrace+0x134/0x140
    show_stack+0x20/0x58
    dump_stack_lvl+0x8c/0xb8
    dump_stack+0x18/0x34
    __might_resched+0x180/0x228
    __might_sleep+0x50/0x88
    __pm_runtime_resume+0xac/0xb0
    cti_enable+0x44/0x120
    coresight_control_assoc_ectdev+0xc0/0x150
    coresight_enable_path+0xb4/0x288
    etm_event_start+0x138/0x170
    etm_event_add+0x48/0x70
    event_sched_in.isra.122+0xb4/0x280
    merge_sched_in+0x1fc/0x3d0
    visit_groups_merge.constprop.137+0x16c/0x4b0
    ctx_sched_in+0x114/0x1f0
    perf_event_sched_in+0x60/0x90
    ctx_resched+0x68/0xb0
    perf_event_exec+0x138/0x508
    begin_new_exec+0x52c/0xd40
    load_elf_binary+0x6b8/0x17d0
    bprm_execve+0x360/0x7f8
    do_execveat_common.isra.47+0x218/0x238
    __arm64_sys_execve+0x48/0x60
    invoke_syscall+0x4c/0x110
    el0_svc_common.constprop.4+0xfc/0x120
    do_el0_svc+0x34/0xc0
    el0_svc+0x40/0x98
    el0t_64_sync_handler+0x98/0xc0
    el0t_64_sync+0x170/0x174

Fix the issue by removing the runtime PM calls completely. They are not
needed here because it must have already been done when building the
path for a trace.

Fixes: 835d722ba10a ("coresight: cti: Initial CoreSight CTI Driver")
Cc: stable <stable@kernel.org>
Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
Reported-by: Cristian Marussi <Cristian.Marussi@arm.com>
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Mike Leach <mike.leach@linaro.org>
[ Fix build warnings ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20221025131032.1149459-1-suzuki.poulose@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index 1be92342b5b9..c6e8c6542f24 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -90,11 +90,9 @@ void cti_write_all_hw_regs(struct cti_drvdata *drvdata)
 static int cti_enable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 	unsigned long flags;
 	int rc = 0;
 
-	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	/* no need to do anything if enabled or unpowered*/
@@ -119,7 +117,6 @@ static int cti_enable_hw(struct cti_drvdata *drvdata)
 	/* cannot enable due to error */
 cti_err_not_enabled:
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	pm_runtime_put(dev->parent);
 	return rc;
 }
 
@@ -153,7 +150,6 @@ static void cti_cpuhp_enable_hw(struct cti_drvdata *drvdata)
 static int cti_disable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 	struct coresight_device *csdev = drvdata->csdev;
 
 	spin_lock(&drvdata->spinlock);
@@ -175,7 +171,6 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	pm_runtime_put(dev->parent);
 	return 0;
 
 	/* not disabled this call */

