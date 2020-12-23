Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C522E175A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgLWDJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbgLWCSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E386B23381;
        Wed, 23 Dec 2020 02:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689847;
        bh=TqoOyum1PkdTKYoqs4bkCyAYkItNvacG/4fXDadPbp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWih1jsw5Zfb9CyxAIiQqaPkKRsUB1GhSwgzsNZnrrKaJuRT5gl2Wvye8N0STfGxo
         xg65oM3oINoLXAJIQv8dHwxuthhU9dHpLO/+kbAXa6XmR0bQeAF5vEjHFx+kukaGFx
         6rAzikaYxo9D9M/lXflRLONY4zQyK+uWGdHFS8FxwtTcfi7cz1lI39k1qW28A0IK6i
         Jn4/G042Sbf0Shrp2snyoYldlj6Tn1LP9FYBtjcAZJl/d1WfiX3YzV+7zA+MsfsbKM
         e0xV1HHazmlVuwk1M1yFP1Sy1qlUqMBE20D78K77JCpcVOeIhGzdJEU0v1oidez7LN
         rx5OiIKQLchIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 047/217] rcutorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:13:36 -0500
Message-Id: <20201223021626.2790791-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 916ea4f66e4b2..db3767110c608 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2647,7 +2647,6 @@ rcu_torture_init(void)
 		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
 			pr_cont(" %s", torture_ops[i]->name);
 		pr_cont("\n");
-		WARN_ON(!IS_MODULE(CONFIG_RCU_TORTURE_TEST));
 		firsterr = -EINVAL;
 		cur_ops = NULL;
 		goto unwind;
@@ -2815,6 +2814,10 @@ rcu_torture_init(void)
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

