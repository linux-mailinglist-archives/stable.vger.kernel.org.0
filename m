Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1012C2E1672
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgLWCTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgLWCTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D70523159;
        Wed, 23 Dec 2020 02:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689919;
        bh=/RQ+odv6C6F6KozQ1Ju2IwOyhrdivQ0RfNw46pXLhbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2A7jPyf6205CAfntlc4Bpdmt0Pbfq9X6PX+oyKodqW/+Tr5j0wEifULtIm1MzMgp
         2Z1E8ymlMTN6alxT97zQuL8yVCTE1/G5uq6nrXWqt9XCOmJT5AcYx5lk930th3AYBw
         hm3M2xu2hFgoZjMzLevB5r3i24N7HBG0RTT8KAKqF0JEsz0ZBRK5t1imk2aMVwD7ZW
         HQCFBjsvSLmhffnAQ0UajCjMgtQPqNouK85XV3dFUYmsbmUOjrNjhpwKVxtrwgZqdM
         5ToF1Px+78i4w169pKnwQDkBDx7HetJolh8vTm3ITQkxtJP8Iw4V3Zt6XcuabirKhc
         Ivki1T+Wy5ssA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 020/130] locktorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:16:23 -0500
Message-Id: <20201223021813.2791612-20-sashal@kernel.org>
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

[ Upstream commit 6b74fa0a776e3715d385b23d29db469179c825b0 ]

If an locktorture torture-test run is given a bad kvm.sh argument, the
test will complain to the console, which is good.  What is bad is that
from the user's perspective, it will just hang for the time specified
by the --duration argument.  This commit therefore forces an immediate
kernel shutdown if a lock_torture_init()-time error occurs, thus avoiding
the appearance of a hang.  It also forces a console splat in this case
to clearly indicate the presence of an error.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/locktorture.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index e09562818bb74..410b0c586ba83 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/torture.h>
+#include <linux/reboot.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@linux.ibm.com>");
@@ -1044,6 +1045,10 @@ static int __init lock_torture_init(void)
 unwind:
 	torture_init_end();
 	lock_torture_cleanup();
+	if (shutdown_secs) {
+		WARN_ON(!IS_MODULE(CONFIG_LOCK_TORTURE_TEST));
+		kernel_power_off();
+	}
 	return firsterr;
 }
 
-- 
2.27.0

