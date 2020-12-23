Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F552E1224
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgLWCTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbgLWCTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BCA32336D;
        Wed, 23 Dec 2020 02:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689921;
        bh=tXdszFZAlA7cdXbScifO0QxpNqfwt3jG/ZcEB0Eoo8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZTQsBxMFn3PeFHo9Q7IFhmCKBnlTVQgTOFULaa2INdtRf0NEpKZOG2dNT2IaABlz
         s6j+9FbZow8zzLwK9+aVNlqRj7riTzqlliiTxG4yhFu7sZuCLmEQMGpED3GFCiC/ix
         CR6W3jZUJ+Y+uIwS4Kh0Sv6v49uhU2QhqS9ZmB15/bk5eJj2UZAblUKOMwZ1AU9vr1
         da4Ihy84HtUqwXVKnkzd7dUe79wMRkLLYELDuR2FK7EoAVXw0MRU0wpdNbFju7HnhP
         0WkSXok+aI+3Ib9XyijzZlIiu8nfFTUmBqul2SZtG9mDUS59B+sAzbPKQjSGfz7tm+
         zzn2wXzZa3Dng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 022/130] rcutorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:16:25 -0500
Message-Id: <20201223021813.2791612-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 4994684ce10924a0302567c315c91b0a64eeef46 ]

If an rcutorture torture-test run is given a bad kvm.sh argument, the
test will complain to the console, which is good.  What is bad is that
from the user's perspective, it will just hang for the time specified
by the --duration argument.  This commit therefore forces an immediate
kernel shutdown if a rcu_torture_init()-time error occurs, thus avoiding
the appearance of a hang.  It also forces a console splat in this case
to clearly indicate the presence of an error.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 3c9feca1eab17..27f0c48f46f4e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2347,7 +2347,6 @@ rcu_torture_init(void)
 		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
 			pr_cont(" %s", torture_ops[i]->name);
 		pr_cont("\n");
-		WARN_ON(!IS_MODULE(CONFIG_RCU_TORTURE_TEST));
 		firsterr = -EINVAL;
 		cur_ops = NULL;
 		goto unwind;
@@ -2507,6 +2506,10 @@ rcu_torture_init(void)
 unwind:
 	torture_init_end();
 	rcu_torture_cleanup();
+	if (shutdown_secs) {
+		WARN_ON(!IS_MODULE(CONFIG_RCU_TORTURE_TEST));
+		kernel_power_off();
+	}
 	return firsterr;
 }
 
-- 
2.27.0

