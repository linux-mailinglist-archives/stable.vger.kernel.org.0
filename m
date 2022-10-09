Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1015F8DF7
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiJIUvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiJIUvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987C922BEC;
        Sun,  9 Oct 2022 13:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1356060CA0;
        Sun,  9 Oct 2022 20:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBE0C433D6;
        Sun,  9 Oct 2022 20:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348704;
        bh=XzQgB09SlnH/faR3zeTC49E6Tva+tqGeBKYN7Hl/Dcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZCC1+v5FyBUjVN+M0deqRgKmV61qEva6nOXi/HRlT2fT8VkfD8iHY1cWkA5Y70ZP
         ioSUg52OD3wrmDwjG+l23EUZc0w6ySfw/AtedRzYnZVGR4Br8M0lYWQriS7Izi+BKU
         0sSsW10CNLidarVTyaCLdaiNCWonpsMKcY1iJzyEAQLRMhVwRi/9f+ERucxR7JV9u+
         m0tC931BsjHtUEnLA78u6A5Vu0z6IU2tZGWzq9BvCTJIPJVzpMFaDtj2htBSs33yxz
         IxjNRsbq7BkuUdmufqSe9F30GI7Y89C0PalWtkOw3LtIMo59LqH6kB3BsUKdnWN7JU
         0ARzfvwQofriw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 04/18] rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()
Date:   Sun,  9 Oct 2022 16:51:21 -0400
Message-Id: <20221009205136.1201774-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
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
index 83c7e6620d40..469bf2a3b505 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -560,7 +560,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	RCU_LOCKDEP_WARN(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
 			 "synchronize_rcu_tasks called too soon");
 
 	// If the grace-period kthread is running, use it.
-- 
2.35.1

