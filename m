Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDFD3D32A3
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhGWDRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233905AbhGWDRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20AF260F25;
        Fri, 23 Jul 2021 03:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012675;
        bh=ZXrRj46NdyKEbN4vE6KRRjHwnOAl6iXHvmIZKRwE23k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2GUWBt/XfboItCAmcUEgwWLAD4OiAYkkk8ET/Z1GpUHUmpmeVZba8c+XfRf3p2oX
         kgnVaw3ZL0coININETf93u4jdO8j3xrKLe4EmTnPoKMYZR0QdanJwYFNl+/BoHw0r0
         8rZzRir91C8/3ttElf2NC1hwufaMiYFUJMO1tLkxSq2/nzGuDy1A//rFh7AdgtQC4y
         znL4SbZ3miLyCPrOWutZf0JybFjhEBrGLgqDrCppLbLNZ1rpNOOFxCepqAMkhEV+IL
         8uSd9S7Gntqe4OXpPbDdOIjxsKUT+tTnCaTrZeLkOgjRhgZ5z8ffrcf418MNuMjua7
         QY+KVAzg84dkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        "Xu, Yanfei" <yanfei.xu@windriver.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/17] rcu-tasks: Don't delete holdouts within trc_inspect_reader()
Date:   Thu, 22 Jul 2021 23:57:36 -0400
Message-Id: <20210723035748.531594-5-sashal@kernel.org>
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
index 73bbe792fe1e..208acb286ec2 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -879,10 +879,9 @@ static bool trc_inspect_reader(struct task_struct *t, void *arg)
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

