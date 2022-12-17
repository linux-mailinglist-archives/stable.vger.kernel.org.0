Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA51F64F5AA
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiLQALV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiLQAKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:10:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE9476824;
        Fri, 16 Dec 2022 16:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE5DEB81E4C;
        Sat, 17 Dec 2022 00:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899CCC433EF;
        Sat, 17 Dec 2022 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235816;
        bh=JUAeLU86nUvk5bPoxhEtCwSImejOmLGxr2MFOlOWN1M=;
        h=From:To:Cc:Subject:Date:From;
        b=T99aasykFIF8lwCnzafMCg0Lw2kzx1VybzyalEwloVU0cHsFif9EpF3Tz0DrTciOC
         V4bmeCSSvT9/JDYAO4cG7Xoq/G2HKKPzH0vBGydMPuF5uyj0GsDkQ/zdWAdo6pKKH5
         3gEYhpDNlbNBQJ9mfYgIdlpVfkUzdLIJxsMwbJzpbQ8FODzoBqkpZtKiMtIrDBPCLM
         m2L1ehoy6b2x32ypBKHE3W9FjeHrsvYiT606Z2eDjUX37TjLlnaMQH9Fan8T7arobd
         4s7M+uBtb+tO4fW0e+F0mu+U2tL+6t3XnAxtK1BKxqppxf8gl410vIJ+NCWf2xgQMy
         gPGNCRMgTZ75Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 1/8] rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()
Date:   Fri, 16 Dec 2022 19:10:05 -0500
Message-Id: <20221217001013.41239-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit ceb1c8c9b8aa9199da46a0f29d2d5f08d9b44c15 ]

Running rcutorture with non-zero fqs_duration module parameter in a
kernel built with CONFIG_PREEMPTION=y results in the following splat:

BUG: using __this_cpu_read() in preemptible [00000000]
code: rcu_torture_fqs/398
caller is __this_cpu_preempt_check+0x13/0x20
CPU: 3 PID: 398 Comm: rcu_torture_fqs Not tainted 6.0.0-rc1-yoctodev-standard+
Call Trace:
<TASK>
dump_stack_lvl+0x5b/0x86
dump_stack+0x10/0x16
check_preemption_disabled+0xe5/0xf0
__this_cpu_preempt_check+0x13/0x20
rcu_force_quiescent_state.part.0+0x1c/0x170
rcu_force_quiescent_state+0x1e/0x30
rcu_torture_fqs+0xca/0x160
? rcu_torture_boost+0x430/0x430
kthread+0x192/0x1d0
? kthread_complete_and_exit+0x30/0x30
ret_from_fork+0x22/0x30
</TASK>

The problem is that rcu_force_quiescent_state() uses __this_cpu_read()
in preemptible code instead of the proper raw_cpu_read().  This commit
therefore changes __this_cpu_read() to raw_cpu_read().

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 5b52727dcc1c..aedd43e1f21c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2415,7 +2415,7 @@ void rcu_force_quiescent_state(void)
 	struct rcu_node *rnp_old = NULL;
 
 	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = __this_cpu_read(rcu_data.mynode);
+	rnp = raw_cpu_read(rcu_data.mynode);
 	for (; rnp != NULL; rnp = rnp->parent) {
 		ret = (READ_ONCE(rcu_state.gp_flags) & RCU_GP_FLAG_FQS) ||
 		       !raw_spin_trylock(&rnp->fqslock);
-- 
2.35.1

