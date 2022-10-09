Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C15F8E5A
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiJIU4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJIUzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE33731ECD;
        Sun,  9 Oct 2022 13:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CDC8B80DC5;
        Sun,  9 Oct 2022 20:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24919C433C1;
        Sun,  9 Oct 2022 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348797;
        bh=NnNOle+6GdU/dCal8eZzhfxhUebGvSc2Ta5UO/0MGsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwhSRwlnPUiGW7PkWAFW3iuQaDVUtCxAMw6QlZpIlaF39c7kabY0tgCVXyYKb/IRg
         mRJ1ijpBNSVf6H9m64HA+siG6tmLmcbJOnWDu16TMuDwmB2+Jvd1OzmijieZ6YFTfY
         3TP+MN2G7NYaTWB9MJJlQKBkypZtQGXhc2aLksWgBY18T4HSFEbhc7Eyo4iEqOIb3d
         PTvCQ2G+5E9VIqn4g6k7ty6phMcm4h63ULCnaAnSoGRzVIzggmWoDVWcfReRUTrsPe
         e0tpvCr4ebPklGUgcWB7OE1ixJHA8W+KWZbGeGh4/3ksECRZGuDwDQPoob2sdBlw01
         wWIUpc5Y+oNUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/15] rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()
Date:   Sun,  9 Oct 2022 16:52:57 -0400
Message-Id: <20221009205308.1202627-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205308.1202627-1-sashal@kernel.org>
References: <20221009205308.1202627-1-sashal@kernel.org>
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
index 60c9eacac25b..ae8396032b5d 100644
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

