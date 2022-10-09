Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963595F8E7B
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiJIU6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiJIU50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A06D32065;
        Sun,  9 Oct 2022 13:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84AAC60CA0;
        Sun,  9 Oct 2022 20:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0298FC433D6;
        Sun,  9 Oct 2022 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348834;
        bh=oSqopbRO77nvGov1G/esShYNUZjCZlTROPXoWvX/7Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VohpTuQPcB9er0AIM8BWG0dfJAmjYJ7hjkReZMcfdMWWC5anWDl2595h6lfdhQf9G
         hljWY0MTE0rmlANDNxwMIBYFm1EG1CkzQrc36/VhLK0L3AqM456nIkQklKiI2ye082
         S/qdLdwuAJ4MYGGvhp8cMLRDZR5RLA1IFrTLXs7QvPp+dXJlYvrvfB+PCJVf01VAUV
         +83skZD0ooSeGoKsExxQpa6Zih/VLVb0dMzV2lE2zjpIrareHLcsm8e5eQn7y+3ENU
         dxwRGambRrg0KE186kZW4DneIM//hu9Txx6/H/8XT4crJ1P3Qi9j1mWUa6XJ00VVGk
         +g7MOfwBmAdZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/10] rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()
Date:   Sun,  9 Oct 2022 16:53:41 -0400
Message-Id: <20221009205350.1203176-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205350.1203176-1-sashal@kernel.org>
References: <20221009205350.1203176-1-sashal@kernel.org>
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

[ Upstream commit fcd53c8a4dfa38bafb89efdd0b0f718f3a03f884 ]

Kernels built with CONFIG_PROVE_RCU=y and CONFIG_DEBUG_LOCK_ALLOC=y
attempt to emit a warning when the synchronize_rcu_tasks_generic()
function is called during early boot while the rcu_scheduler_active
variable is RCU_SCHEDULER_INACTIVE.  However the warnings is not
actually be printed because the debug_lockdep_rcu_enabled() returns
false, exactly because the rcu_scheduler_active variable is still equal
to RCU_SCHEDULER_INACTIVE.

This commit therefore replaces RCU_LOCKDEP_WARN() with WARN_ONCE()
to force these warnings to actually be printed.

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 14af29fe1377..8b51e6a5b386 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -171,7 +171,7 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	RCU_LOCKDEP_WARN(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
 			 "synchronize_rcu_tasks called too soon");
 
 	/* Wait for the grace period. */
-- 
2.35.1

