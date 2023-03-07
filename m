Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D516AF370
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCGTEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjCGTEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:04:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9099D1623
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70CE8B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12D6C433D2;
        Tue,  7 Mar 2023 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215006;
        bh=2vjIpf5zAHEPy6IFEG8tyq+dyDMx93bJpxc8Bblw5F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGahzxdjLG0UFjlxMkna8rjXPpb69y8jSEDSQGDIWm6JZgilqCKLsP7DEghdWaGgX
         XmKqY4q+S3deZuNM2X1D/cnpdlSXNalDjzB9FyfALbikBscgHNWX6R8fFvGPVqY3Gg
         raHXI6odRnNZsh9PVNa1im4YdLApnTE75UivVhbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/567] rcu-tasks: Remove preemption disablement around srcu_read_[un]lock() calls
Date:   Tue,  7 Mar 2023 17:57:05 +0100
Message-Id: <20230307165909.743714264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 44757092958bdd749775022f915b7ac974384c2a ]

Ever since the following commit:

	5a41344a3d83 ("srcu: Simplify __srcu_read_unlock() via this_cpu_dec()")

SRCU doesn't rely anymore on preemption to be disabled in order to
modify the per-CPU counter. And even then it used to be done from the API
itself.

Therefore and after checking further, it appears to be safe to remove
the preemption disablement around __srcu_read_[un]lock() in
exit_tasks_rcu_start() and exit_tasks_rcu_finish()

Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Suggested-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 28319d6dc5e2 ("rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index d937bacf27b68..2408ca633872a 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -632,9 +632,7 @@ EXPORT_SYMBOL_GPL(show_rcu_tasks_classic_gp_kthread);
  */
 void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 {
-	preempt_disable();
 	current->rcu_tasks_idx = __srcu_read_lock(&tasks_rcu_exit_srcu);
-	preempt_enable();
 }
 
 /*
@@ -646,9 +644,7 @@ void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
 {
 	struct task_struct *t = current;
 
-	preempt_disable();
 	__srcu_read_unlock(&tasks_rcu_exit_srcu, t->rcu_tasks_idx);
-	preempt_enable();
 	exit_tasks_rcu_finish_trace(t);
 }
 
-- 
2.39.2



