Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937D85902F8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiHKQSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbiHKQSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:18:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A3E217;
        Thu, 11 Aug 2022 09:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F89B82171;
        Thu, 11 Aug 2022 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63416C4347C;
        Thu, 11 Aug 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233610;
        bh=DItYzaaczjuB8O38T/DYjPqEG/vaqcYq5XQwCr1R9JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAYEjHGATw4sL7BIi+mkN6x8QffJ8yqA2fqvCmXBxaLc9a5UVbxR/gaej3ql+zEF7
         C9r5TPir8bfCL2zRHA337i+lgNQ+zUigajoHgwW00NHcbAjNpZinLCGDl7oQ1M3yQW
         9YBZhwDLO6jLRciDmTytha2VMAC7Z0n2HFMkDTpdoY1gjMtOaskfPVmfuKsji4T2VQ
         dP3FVc6JuV6jwy4reJJo+zMegKnpbLnVNekAJy7MEz0i5yaXCJJQP6KxEspGe9VN3U
         QP/dsgtI74M1mqLyUrxOs+RHZqTrwbwnD/7b7ZVn+Hppwl+OHeoI9RyXxR+32JtEwC
         rUACzypOtruxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        frederic@kernel.org, quic_neeraju@quicinc.com,
        josh@joshtriplett.org, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/69] rcu: Apply noinstr to rcu_idle_enter() and rcu_idle_exit()
Date:   Thu, 11 Aug 2022 11:55:38 -0400
Message-Id: <20220811155632.1536867-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit ed4ae5eff4b38797607cbdd80da394149110fb37 ]

This commit applies the "noinstr" tag to the rcu_idle_enter() and
rcu_idle_exit() functions, which are invoked from portions of the idle
loop that cannot be instrumented.  These tags require reworking the
rcu_eqs_enter() and rcu_eqs_exit() functions that these two functions
invoke in order to cause them to use normal assertions rather than
lockdep.  In addition, within rcu_idle_exit(), the raw versions of
local_irq_save() and local_irq_restore() are used, again to avoid issues
with lockdep in uninstrumented code.

This patch is based in part on an earlier patch by Jiri Olsa, discussions
with Peter Zijlstra and Frederic Weisbecker, earlier changes by Thomas
Gleixner, and off-list discussions with Yonghong Song.

Link: https://lore.kernel.org/lkml/20220515203653.4039075-1-jolsa@kernel.org/
Reported-by: Jiri Olsa <jolsa@kernel.org>
Reported-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a4a9d68b1fdc..ef959bc207bc 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -620,8 +620,8 @@ static noinstr void rcu_eqs_enter(bool user)
 		return;
 	}
 
-	lockdep_assert_irqs_disabled();
 	instrumentation_begin();
+	lockdep_assert_irqs_disabled();
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rcu_prepare_for_idle();
@@ -649,9 +649,9 @@ static noinstr void rcu_eqs_enter(bool user)
  * If you add or remove a call to rcu_idle_enter(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_idle_enter(void)
+void noinstr rcu_idle_enter(void)
 {
-	lockdep_assert_irqs_disabled();
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !raw_irqs_disabled());
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -854,7 +854,7 @@ static void noinstr rcu_eqs_exit(bool user)
 	struct rcu_data *rdp;
 	long oldval;
 
-	lockdep_assert_irqs_disabled();
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !raw_irqs_disabled());
 	rdp = this_cpu_ptr(&rcu_data);
 	oldval = rdp->dynticks_nesting;
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && oldval < 0);
@@ -890,13 +890,13 @@ static void noinstr rcu_eqs_exit(bool user)
  * If you add or remove a call to rcu_idle_exit(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_idle_exit(void)
+void noinstr rcu_idle_exit(void)
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	rcu_eqs_exit(false);
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
-- 
2.35.1

