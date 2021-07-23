Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8061F3D32A1
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhGWDRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233907AbhGWDRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42CDA60EC0;
        Fri, 23 Jul 2021 03:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012676;
        bh=HedbqYOwtJgtT87gQwfoGpMF3fJHIkxZjqthmxIeju8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IR/Zm0f7QMFSaJYRAwV0d0kuL6QjezpMB3y+mbUPyZ0fPe9oUxdXJrjKw+bjbWNeM
         M/aqpx0eW38UTE4s+/+ubhx8KbdAcAo88amrH6vbUesqCMATJCzlysvU0D+q5n2Iv+
         jknYdnQOwGCf0+PFa2CSAQpKTkbvhhHnWyf+KmhinA2YwS1lRJFdSNaZQOa3wT9U7K
         Nkw3qx5NxS2UmKXVd2bfPZWF4fm97GZ1LKJuBrGXvamXWOOiWPPfgpmxIRmXdgRc9W
         qbDUAiRbIDoTitm/d/EaVWfnIN6Kb0uHhO4xyfiYDaIPh0nKwH/dH8AMIW7jOFp89z
         PWty14mSE75Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        "Xu, Yanfei" <yanfei.xu@windriver.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/17] rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()
Date:   Thu, 22 Jul 2021 23:57:37 -0400
Message-Id: <20210723035748.531594-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035748.531594-1-sashal@kernel.org>
References: <20210723035748.531594-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

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
index 208acb286ec2..b338f514ee5a 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -908,7 +908,6 @@ static void trc_wait_for_one_reader(struct task_struct *t,
 	// The current task had better be in a quiescent state.
 	if (t == current) {
 		t->trc_reader_checked = true;
-		trc_del_holdout(t);
 		WARN_ON_ONCE(t->trc_reader_nesting);
 		return;
 	}
-- 
2.30.2

