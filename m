Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C8D603EEA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiJSJXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiJSJWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:22:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA8D63F16;
        Wed, 19 Oct 2022 02:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12ADA61843;
        Wed, 19 Oct 2022 09:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D16C433B5;
        Wed, 19 Oct 2022 09:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170462;
        bh=XzQgB09SlnH/faR3zeTC49E6Tva+tqGeBKYN7Hl/Dcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1evZLMOG7VafyY5fAG2mUTlRkZPg1BTO/Oe/yhkeLZsV6tNra577xO/RH2wArIYnP
         Tgk1xUwK0YeRwfnx4vv1sAdDA+JnAPR+6QZ5gBPTMD3fpbS4rLiqirt1Y/Xci3iqLK
         BvqeOAcfpQvLi5vPVsVsb3HoErtRyoEfFf1CXhdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang1.zhang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 664/862] rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()
Date:   Wed, 19 Oct 2022 10:32:31 +0200
Message-Id: <20221019083319.310438424@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



