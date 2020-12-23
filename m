Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B905D2E12AF
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgLWCX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgLWCX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B10723359;
        Wed, 23 Dec 2020 02:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690186;
        bh=goaIIuZKrLNP7nxSPkB+ROf/ExZZq/+Rhxm/cQUuscU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ1CDAT7+9ApSQAfGcE5UfWkwm//gNuhPTeS70V5Og6bCV8oRjRHTnI9ATOFIX1vI
         PcjvwW9Hv5ymCS8iZOZ9BGn5bwyC/ZgAhqViOU9DobcwKEnQMjs74sTtjUivuklAJc
         A8XKtYg0lPCJeeRnsxxwXWniOeyJh3Zln8o+RJ8XnDOQCkxoi/Qh/sSWJBOJ8sEtRn
         8d0VUEHU2Y1LKiGzGO3DBqYwRtxuBya0j2x18znqkDdy0tqVYZphMfU+Y/68iQlnjM
         Ub/bhgjB26fqAhK4LPZHhb352Om8sb8Y26/d2s5wBF+5o2YsLW8tng+9GoLCCvlUaE
         YQx5SDk0BZMDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 11/66] locktorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:21:57 -0500
Message-Id: <20201223022253.2793452-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index 032868be32594..5b9fde4432cfe 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/torture.h>
+#include <linux/reboot.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
@@ -1062,6 +1063,10 @@ static int __init lock_torture_init(void)
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

