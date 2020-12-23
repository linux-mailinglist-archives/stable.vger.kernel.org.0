Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC252E13CB
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgLWCfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730297AbgLWCYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E540D2256F;
        Wed, 23 Dec 2020 02:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690268;
        bh=Y6ROb1cp61Ehq9Cdpu+4+Mbp2r0wpt5Izz1VEHtEBJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duoJ/ex5QXG3raHOCtKCI4WJ7DdZ/72u/Iowx/7sQC/0Ln2ulN6arv7RfBKGH5zsV
         LcM0opaTzmUJ2hlkAPqnkj+rHwTZXAmzz49RaQeJwSnt+ZQqPy32Wuv7JXFY6n06Hr
         lurpKMggTSQqWL1yOf/wSk6BbuA+LTZd+1u9r9QpKCq1Cc0lPd/JPp3pb6X2pRzz7T
         WERWupeS7tZ7vIwxJYuC02mNnrv3qscSvKUser/NQxbOSujvWbSrWX/sUBfP7fER0N
         zN5shzCvd+EmCFx4eDs4yoNwUtfAoxdB+KDOXgF5NRnVgALdLih0fVKcU13XSmNsP/
         PtsA1kxP5lvXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 09/48] locktorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:23:37 -0500
Message-Id: <20201223022417.2794032-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index b0e41c312c15f..176a2a059ead4 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/torture.h>
+#include <linux/reboot.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
@@ -987,6 +988,10 @@ static int __init lock_torture_init(void)
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

