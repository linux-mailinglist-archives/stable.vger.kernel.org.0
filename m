Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C06088FE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiJVI1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiJVI1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:27:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071B01E8BA6;
        Sat, 22 Oct 2022 01:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E63EA60B09;
        Sat, 22 Oct 2022 07:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10ACC433C1;
        Sat, 22 Oct 2022 07:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425561;
        bh=6Njtknf8o9zV3FzGqR/rcsTSKjOQy+EbRF2tsLSqiFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxd41uYsqOcfFU6uLFxfRCcHRcD/wZHr3OX8uqOE0pQvC3gLAQl77eobA40x2tfQ5
         291ZRVfBv+2k9iA/Ahn+j4ufCC641eo5kZ+7sFUwUF+Zx4jtnpZ/LRalj5VzourcBc
         UP2m5wolorP61tiWuLxxzb1UqRcHcfNdKbYzvNX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang1.zhang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 541/717] rcu: Avoid triggering strict-GP irq-work when RCU is idle
Date:   Sat, 22 Oct 2022 09:27:00 +0200
Message-Id: <20221022072522.277132672@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit 621189a1fe93cb2b34d62c5cdb9e258bca044813 ]

Kernels built with PREEMPT_RCU=y and RCU_STRICT_GRACE_PERIOD=y trigger
irq-work from rcu_read_unlock(), and the resulting irq-work handler
invokes rcu_preempt_deferred_qs_handle().  The point of this triggering
is to force grace periods to end quickly in order to give tools like KASAN
a better chance of detecting RCU usage bugs such as leaking RCU-protected
pointers out of an RCU read-side critical section.

However, this irq-work triggering is unconditional.  This works, but
there is no point in doing this irq-work unless the current grace period
is waiting on the running CPU or task, which is not the common case.
After all, in the common case there are many rcu_read_unlock() calls
per CPU per grace period.

This commit therefore triggers the irq-work only when the current grace
period is waiting on the running CPU or task.

This change was tested as follows on a four-CPU system:

	echo rcu_preempt_deferred_qs_handler > /sys/kernel/debug/tracing/set_ftrace_filter
	echo 1 > /sys/kernel/debug/tracing/function_profile_enabled
	insmod rcutorture.ko
	sleep 20
	rmmod rcutorture.ko
	echo 0 > /sys/kernel/debug/tracing/function_profile_enabled
	echo > /sys/kernel/debug/tracing/set_ftrace_filter

This procedure produces results in this per-CPU set of files:

	/sys/kernel/debug/tracing/trace_stat/function*

Sample output from one of these files is as follows:

  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---
  rcu_preempt_deferred_qs_handle      838746    182650.3 us     0.217 us        0.004 us

The baseline sum of the "Hit" values (the number of calls to this
function) was 3,319,015.  With this commit, that sum was 1,140,359,
for a 2.9x reduction.  The worst-case variance across the CPUs was less
than 25%, so this large effect size is statistically significant.

The raw data is available in the Link: URL.

Link: https://lore.kernel.org/all/20220808022626.12825-1-qiang1.zhang@intel.com/
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c8ba0fe17267..d164938528cd 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -641,7 +641,8 @@ static void rcu_read_unlock_special(struct task_struct *t)
 
 		expboost = (t->rcu_blocked_node && READ_ONCE(t->rcu_blocked_node->exp_tasks)) ||
 			   (rdp->grpmask & READ_ONCE(rnp->expmask)) ||
-			   IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD) ||
+			   (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD) &&
+			   ((rdp->grpmask & READ_ONCE(rnp->qsmask)) || t->rcu_blocked_node)) ||
 			   (IS_ENABLED(CONFIG_RCU_BOOST) && irqs_were_disabled &&
 			    t->rcu_blocked_node);
 		// Need to defer quiescent state until everything is enabled.
-- 
2.35.1



