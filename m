Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBAD2E1775
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgLWDK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:10:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgLWCS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC33F23359;
        Wed, 23 Dec 2020 02:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689845;
        bh=ZXy97GQGeZ+Cib/Zh12FUBMabK4SNhjvzFTAHaB2Njo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVKc3NA0cvGXAacyUrCWUyP3g3RqU7Lm7XfYLWK0X2aS2zeM60qw7LaH397PSxjrT
         GBIcMgQbsA4uu6wxciDwmJnsLXI05ir6czi6qaIlAMRcG5pZI/2ClnhR1NW+DbixPw
         WDWFBvZUepisFaWL9xggZU+/SiQgTCYm0XTwOSgAvtJU8wCr1fuaxNk8qTkGEwEhFx
         3sRa5z2R0JVCzQPB7MIUZlNs7KuTCXy4OWjc6VDKCuBqDoyHeGZ2lL1bNfB/OL/kdQ
         io33Wfv0UFKHmOxcgp1sA9Uxy1IOlnr0DPAfolnryM9Pug6zFvksTVDf9yQhSDwlht
         m6mjHmBKakxVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 045/217] locktorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:13:34 -0500
Message-Id: <20201223021626.2790791-45-sashal@kernel.org>
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
index 62d215b2e39f6..8bcb6a75cb9c0 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/torture.h>
+#include <linux/reboot.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@linux.ibm.com>");
@@ -1038,6 +1039,10 @@ static int __init lock_torture_init(void)
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

