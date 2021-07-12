Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29543C4EE0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbhGLHWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344547AbhGLHUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D5E613EE;
        Mon, 12 Jul 2021 07:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074270;
        bh=eX4oCGx2MCHjUvDY1DlMOq6WjNHKlId38b/8R0XyqrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3+4zU/shzsOq7w9uQE2CvtCOF5jCf8f1o4TaaT3XL3TC8bls95YLoJdtC1w3B77J
         SHrM2AOMEGaXNnbdYmKjeFYXRvraE8UoVqmjimDSWxxjHDaxXYJ6pjIjNHjYuNI52h
         TMaAjsYeHa2q/vT6Ui/1Hi/Rp/FZoWj8CM4lXxbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 522/700] rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()
Date:   Mon, 12 Jul 2021 08:10:05 +0200
Message-Id: <20210712061031.995908101@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 7356764e49a0..a274622ed6fa 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2911,7 +2911,6 @@ static int __init rcu_spawn_core_kthreads(void)
 		  "%s: Could not start rcuc kthread, OOM is now expected behavior\n", __func__);
 	return 0;
 }
-early_initcall(rcu_spawn_core_kthreads);
 
 /*
  * Handle any core-RCU processing required by a call_rcu() invocation.
@@ -4392,6 +4391,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	wake_up_process(t);
 	rcu_spawn_nocb_kthreads();
 	rcu_spawn_boost_kthreads();
+	rcu_spawn_core_kthreads();
 	return 0;
 }
 early_initcall(rcu_spawn_gp_kthread);
-- 
2.30.2



