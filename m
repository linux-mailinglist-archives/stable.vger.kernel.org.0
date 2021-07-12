Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFCA3C4B4A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbhGLG4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239188AbhGLGta (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F989610FA;
        Mon, 12 Jul 2021 06:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072392;
        bh=Iq+o5OeMMpRVe3gVKnWsaNnrPxGYSR9SQp7q+a1GDsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNK/Nb5fwxviO3eA4gaAFQyjVfHY1MHJOqbJFn85uKbKhzB+rxvZWDf0tb33VnC1g
         scW6KqfzWYXFjwaYfU/c3ucXtVeFbDDQzDXOqZrBVouOlQV3Ho2rh7Ieqlk80X0JcZ
         cipxwRaW7uHESxGMI2Rsr8LPkHLIS37Xj0ORzWVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/593] rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()
Date:   Mon, 12 Jul 2021 08:09:56 +0200
Message-Id: <20210712060936.633734952@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 8e4b1d2bc198e34b48fc7cc3a3c5a2fcb269e271 ]

Currently, rcu_spawn_core_kthreads() is invoked via an early_initcall(),
which works, except that rcu_spawn_gp_kthread() is also invoked via an
early_initcall() and rcu_spawn_core_kthreads() relies on adjustments to
kthread_prio that are carried out by rcu_spawn_gp_kthread().  There is
no guaranttee of ordering among early_initcall() handlers, and thus no
guarantee that kthread_prio will be properly checked and range-limited
at the time that rcu_spawn_core_kthreads() needs it.

In most cases, this bug is harmless.  After all, the only reason that
rcu_spawn_gp_kthread() adjusts the value of kthread_prio is if the user
specified a nonsensical value for this boot parameter, which experience
indicates is rare.

Nevertheless, a bug is a bug.  This commit therefore causes the
rcu_spawn_core_kthreads() function to be invoked directly from
rcu_spawn_gp_kthread() after any needed adjustments to kthread_prio have
been carried out.

Fixes: 48d07c04b4cc ("rcu: Enable elimination of Tree-RCU softirq processing")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 61e250cdd7c9..45b60e997461 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2837,7 +2837,6 @@ static int __init rcu_spawn_core_kthreads(void)
 		  "%s: Could not start rcuc kthread, OOM is now expected behavior\n", __func__);
 	return 0;
 }
-early_initcall(rcu_spawn_core_kthreads);
 
 /*
  * Handle any core-RCU processing required by a call_rcu() invocation.
@@ -4273,6 +4272,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	wake_up_process(t);
 	rcu_spawn_nocb_kthreads();
 	rcu_spawn_boost_kthreads();
+	rcu_spawn_core_kthreads();
 	return 0;
 }
 early_initcall(rcu_spawn_gp_kthread);
-- 
2.30.2



