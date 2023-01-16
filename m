Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3FC66C85B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjAPQi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbjAPQhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:37:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4771B32E68
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:26:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89CC61049
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1C9C433EF;
        Mon, 16 Jan 2023 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886401;
        bh=psW9D7HuHQR8IbgKxb7fKgnTBW7O+7/ybDF+u7UdMx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZNxAvwwJfsnKRDu7F8JmA6IOz9K12KyZgB4kXQCC45z7P0sWIdIhm8q+y2yVQ29T
         ++fwCQQpop68Nxw54OJATz2WDX0bO0BbJFynGfm0bD/4UJ4GIzdk/D29XpSdlQbSao
         NKow8pxdbEAdmf7MkhePJisafaTacACiAb3/20/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zqiang <qiang1.zhang@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 386/658] rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()
Date:   Mon, 16 Jan 2023 16:47:54 +0100
Message-Id: <20230116154927.218408039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 5797cf2909b0..615283404d9d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2317,7 +2317,7 @@ void rcu_force_quiescent_state(void)
 	struct rcu_node *rnp_old = NULL;
 
 	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = __this_cpu_read(rcu_data.mynode);
+	rnp = raw_cpu_read(rcu_data.mynode);
 	for (; rnp != NULL; rnp = rnp->parent) {
 		ret = (READ_ONCE(rcu_state.gp_flags) & RCU_GP_FLAG_FQS) ||
 		      !raw_spin_trylock(&rnp->fqslock);
-- 
2.35.1



