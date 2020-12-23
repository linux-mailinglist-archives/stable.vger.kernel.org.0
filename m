Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41B22E177B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbgLWDKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgLWCS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C599E23357;
        Wed, 23 Dec 2020 02:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689844;
        bh=80HYvolf4JDx7Fbfz2cVwqF4zwQ1oTDwvedPSWV1BV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9P3RuXPpbIZT6QeJYu9zFrVOX5i2u3sRRnHQvT3krFL5Vya8du1ofmrSu0GC6+b7
         +AtOfc1EEwd/iJuYqJpxao1afYixstc69TJFPhQcnSIehFTI+nq7OrGrMdfqixVXTz
         QvbZdiI60Eq/m8imw4AeBxT41w1MIQWtFmWZ6e2Lj+s23l9iMoyAOrpwFosL0AoQq2
         wW4ezv95X8Sfhle/mt42u8wqHRVUHAozfIxcKCqC10Zjc9qLxjbjGTnKY8WnMamXa6
         dM1gffRMMdkhzGu3Y46Oa2RegoyDPrKYIrVqj/W9a0sydbGS4LFBGXE5Dx+uTJv3YW
         64+roO7NNEUyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 044/217] refscale: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:13:33 -0500
Message-Id: <20201223021626.2790791-44-sashal@kernel.org>
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

[ Upstream commit bc80d353b3f565138cda7e95ed4020e6e69360b2 ]

If an refscale torture-test run is given a bad kvm.sh argument, the
test will complain to the console, which is good.  What is bad is that
from the user's perspective, it will just hang for the time specified
by the --duration argument.  This commit therefore forces an immediate
kernel shutdown if a ref_scale_init()-time error occurs, thus avoiding
the appearance of a hang.  It also forces a console splat in this case
to clearly indicate the presence of an error.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/refscale.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/refscale.c b/kernel/rcu/refscale.c
index 952595c678b37..8aa886684b067 100644
--- a/kernel/rcu/refscale.c
+++ b/kernel/rcu/refscale.c
@@ -658,7 +658,6 @@ ref_scale_init(void)
 		for (i = 0; i < ARRAY_SIZE(scale_ops); i++)
 			pr_cont(" %s", scale_ops[i]->name);
 		pr_cont("\n");
-		WARN_ON(!IS_MODULE(CONFIG_RCU_REF_SCALE_TEST));
 		firsterr = -EINVAL;
 		cur_ops = NULL;
 		goto unwind;
@@ -712,6 +711,10 @@ ref_scale_init(void)
 unwind:
 	torture_init_end();
 	ref_scale_cleanup();
+	if (shutdown) {
+		WARN_ON(!IS_MODULE(CONFIG_RCU_REF_SCALE_TEST));
+		kernel_power_off();
+	}
 	return firsterr;
 }
 
-- 
2.27.0

