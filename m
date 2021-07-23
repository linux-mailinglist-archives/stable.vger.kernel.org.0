Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5EB3D3276
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhGWDRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233637AbhGWDQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA42F60ED4;
        Fri, 23 Jul 2021 03:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012649;
        bh=0fFSBGjMqGrHX5bYIH3e3/ZNEowMOG8J3Zb33Re8/po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l25YwnaECFPTXBWD0kgmWeuu/F/0AoASjnCmskxBuD/kyEinnE6F9eLFUCg8UtVjN
         aCRPMKlhY2bC9aAJ5ddSib6Ag9/ObKw8wXcCI7VtpDOw62N5/BACSJOtuuykpryHCw
         besb2ynlXGKIxhBPyKhuh83fAjm8bzquy44JmNSMcF1JKYNksONU3PKnwsw2CXaF/4
         bsPy070ZV/Vek/1JSxCOgg22kv/eDWx+1mImvJwIuSfi8CoaavTgxePSEihJiCQcfr
         BmxIuM3c3Wa9etztcc/nYLUb0mmTjzkRN29fKWQ6RLZpA/WFP1azewJMWX4cpOx35K
         H2YQ8lMMZSGdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        "Xu, Yanfei" <yanfei.xu@windriver.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 06/19] rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()
Date:   Thu, 22 Jul 2021 23:57:07 -0400
Message-Id: <20210723035721.531372-6-sashal@kernel.org>
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

