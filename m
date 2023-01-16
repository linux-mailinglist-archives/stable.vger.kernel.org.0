Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDE066CC22
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbjAPRWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbjAPRV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:21:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CBF274A8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A364A61085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E20C433D2;
        Mon, 16 Jan 2023 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888391;
        bh=lTCxk759y097TWU6AX5P6NF0tamWHgPhBEImCaF1aaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMrY4MNfjQ4M1J8Jign9yJXO8y0qNAj3N6AQJGYEofd0yhr/iHexUK+kq623+3uZn
         LlTFXOOpORuwzSVBHLJ3E758PITSnsJRwQ+aiqFdBiekDff+CknnRul0nKNEhdfuiR
         fmzmNb3P0nuSrJfu8EzCkS5lqG3beNPCLGfEhrvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Morse <james.morse@arm.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 510/521] x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI
Date:   Mon, 16 Jan 2023 16:52:52 +0100
Message-Id: <20230116154910.027388713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit e0ad6dc8969f790f14bddcfd7ea284b7e5f88a16 ]

James reported in [1] that there could be two tasks running on the same CPU
with task_struct->on_cpu set. Using task_struct->on_cpu as a test if a task
is running on a CPU may thus match the old task for a CPU while the
scheduler is running and IPI it unnecessarily.

task_curr() is the correct helper to use. While doing so move the #ifdef
check of the CONFIG_SMP symbol to be a C conditional used to determine
if this helper should be used to ensure the code is always checked for
correctness by the compiler.

[1] https://lore.kernel.org/lkml/a782d2f3-d2f6-795f-f4b1-9462205fd581@arm.com

Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/e9e68ce1441a73401e08b641cc3b9a3cf13fe6d4.1608243147.git.reinette.chatre@intel.com
Stable-dep-of: fe1f0714385f ("x86/resctrl: Fix task CLOSID/RMID update race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index f406e3b85bdb..8c405149c671 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -2140,19 +2140,15 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			t->closid = to->closid;
 			t->rmid = to->mon.rmid;
 
-#ifdef CONFIG_SMP
 			/*
-			 * This is safe on x86 w/o barriers as the ordering
-			 * of writing to task_cpu() and t->on_cpu is
-			 * reverse to the reading here. The detection is
-			 * inaccurate as tasks might move or schedule
-			 * before the smp function call takes place. In
-			 * such a case the function call is pointless, but
+			 * If the task is on a CPU, set the CPU in the mask.
+			 * The detection is inaccurate as tasks might move or
+			 * schedule before the smp function call takes place.
+			 * In such a case the function call is pointless, but
 			 * there is no other side effect.
 			 */
-			if (mask && t->on_cpu)
+			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
 				cpumask_set_cpu(task_cpu(t), mask);
-#endif
 		}
 	}
 	read_unlock(&tasklist_lock);
-- 
2.35.1



