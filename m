Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A703DA577
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbhG2OCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238226AbhG2OA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 10:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA43F6108C;
        Thu, 29 Jul 2021 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567185;
        bh=ehVN1lUmJP5gTZ3vI5IQKKSPb1DWaFucAs0vsktFrAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhvLuVkKGLhXJjumFnTY/RhT1AfWIrozlzTQ5d86QY/wogTpqmHjRPp4koOd9TVLh
         FT7AqTIOypF+RCwdc8T4gEAb0z3J58YP8MKqosfZrrz+oGgRBLiqaQAKMFFXScxdtO
         rRQHt5f7uDHZSUUMZN5QvnKi/S+0H/7GwhIrlcMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xu, Yanfei" <yanfei.xu@windriver.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 09/22] rcu-tasks: Dont delete holdouts within trc_wait_for_one_reader()
Date:   Thu, 29 Jul 2021 15:54:40 +0200
Message-Id: <20210729135137.632633169@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit a9ab9cce9367a2cc02a3c7eb57a004dc0b8f380d ]

Invoking trc_del_holdout() from within trc_wait_for_one_reader() is
only a performance optimization because the RCU Tasks Trace grace-period
kthread will eventually do this within check_all_holdout_tasks_trace().
But it is not a particularly important performance optimization because
it only applies to the grace-period kthread, of which there is but one.
This commit therefore removes this invocation of trc_del_holdout() in
favor of the one in check_all_holdout_tasks_trace() in the grace-period
kthread.

Reported-by: "Xu, Yanfei" <yanfei.xu@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 71e9d625371a..fcef5f0c60b8 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -937,7 +937,6 @@ static void trc_wait_for_one_reader(struct task_struct *t,
 	// The current task had better be in a quiescent state.
 	if (t == current) {
 		t->trc_reader_checked = true;
-		trc_del_holdout(t);
 		WARN_ON_ONCE(t->trc_reader_nesting);
 		return;
 	}
-- 
2.30.2



