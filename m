Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E006157E9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiKBCle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiKBClb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:41:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C329820993
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A161B82071
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B616C433D7;
        Wed,  2 Nov 2022 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356888;
        bh=G8G3Fnh2g5WLnag3ZM93l3CUm9ueI2vhyO9qnsCgmWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDAifYtNEl64QS3vIGlOeaoYdMDLqkxbawLzHYocXhD0aGaUROTpwnkIh8+An61v6
         KVkx4pA0aBFDB0ASPZZ8IfGAVWsgd9VzBAbx7WG4It5abgqTULWq3tWXlguGSIOd7C
         i2mFEnLBPbvFNDy1bdnSreqHTHZXw5E8dIT1qcdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Aishwarya TCV <Aishwarya.TCV@arm.com>,
        Cristian Marussi <Cristian.Marussi@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Clark <james.clark@arm.com>,
        Mike Leach <mike.leach@linaro.org>
Subject: [PATCH 6.0 077/240] coresight: cti: Fix hang in cti_disable_hw()
Date:   Wed,  2 Nov 2022 03:30:52 +0100
Message-Id: <20221102022113.144227647@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

commit 6746eae4bbaddcc16b40efb33dab79210828b3ce upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-cti-core.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -90,11 +90,9 @@ void cti_write_all_hw_regs(struct cti_dr
 static int cti_enable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 	unsigned long flags;
 	int rc = 0;
 
-	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	/* no need to do anything if enabled or unpowered*/
@@ -119,7 +117,6 @@ cti_state_unchanged:
 	/* cannot enable due to error */
 cti_err_not_enabled:
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	pm_runtime_put(dev->parent);
 	return rc;
 }
 
@@ -153,7 +150,6 @@ cti_hp_not_enabled:
 static int cti_disable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 	struct coresight_device *csdev = drvdata->csdev;
 
 	spin_lock(&drvdata->spinlock);
@@ -175,7 +171,6 @@ static int cti_disable_hw(struct cti_drv
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	pm_runtime_put(dev->parent);
 	return 0;
 
 	/* not disabled this call */


