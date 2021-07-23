Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70203D3273
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhGWDQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233647AbhGWDQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6CCF60C41;
        Fri, 23 Jul 2021 03:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012648;
        bh=k4wVrFHRjuYg0KjJM/VG6cSE88Yr5KP0/jeN4jS92Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbtuyjPPbsfGQSzzFzbhMXMvmvNAVRl7FqPZiKDyqwI9hGcxZDuvSgqMkLdQLNGo1
         g4scH8WRQwJMtJo/GLHEb/LAImvJCB3sQD5vw5xDjXz5eL31o3eQnfkHAepkIKFpTL
         QdBVxNiAlA3Piu0J/3fsHUBGbhM5IT2O83uK564Cju2EJx8e0pROTXIpCaUuR7i/F7
         8HGLD4AZM7h5/FatfOBJ/DKwyXbFlnDKn2wXXI4nbmRxNH8ejynpBiBFV1Gwy++u2D
         1MiG2Z2c/r5LmGiU+7voKYfB3x068y0ys4NgLeBHd4GA8Yo7/K497a/ItuzFjFFf6R
         z7s/TMTC25L4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        "Xu, Yanfei" <yanfei.xu@windriver.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 05/19] rcu-tasks: Don't delete holdouts within trc_inspect_reader()
Date:   Thu, 22 Jul 2021 23:57:06 -0400
Message-Id: <20210723035721.531372-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 1d10bf55d85d34eb73dd8263635f43fd72135d2d ]

As Yanfei pointed out, although invoking trc_del_holdout() is safe
from the viewpoint of the integrity of the holdout list itself,
the put_task_struct() invoked by trc_del_holdout() can result in
use-after-free errors due to later accesses to this task_struct structure
by the RCU Tasks Trace grace-period kthread.

This commit therefore removes this call to trc_del_holdout() from
trc_inspect_reader() in favor of the grace-period thread's existing call
to trc_del_holdout(), thus eliminating that particular class of
use-after-free errors.

Reported-by: "Xu, Yanfei" <yanfei.xu@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 350ebf5051f9..71e9d625371a 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -908,10 +908,9 @@ static bool trc_inspect_reader(struct task_struct *t, void *arg)
 		in_qs = likely(!t->trc_reader_nesting);
 	}
 
-	// Mark as checked.  Because this is called from the grace-period
-	// kthread, also remove the task from the holdout list.
+	// Mark as checked so that the grace-period kthread will
+	// remove it from the holdout list.
 	t->trc_reader_checked = true;
-	trc_del_holdout(t);
 
 	if (in_qs)
 		return true;  // Already in quiescent state, done!!!
-- 
2.30.2

