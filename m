Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04612E136A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgLWC3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:29:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgLWCZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9EC2222D;
        Wed, 23 Dec 2020 02:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690327;
        bh=5Rmrr2NYy52B8FPRhvpd7VVqAexa1hLrfUuoM9RbG0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ji7/2H+UOKBSxy8rqSE2rV/5Id5Ja0iQuJvqvFgAo/U7dP3TEkKKg2JssX0nbe+3O
         id8N99sCfv0wIQ8hCLKayBpqvW9G/+BbbvfoXVwc85ssED5vqubwG/s5X/4ozpKI7O
         zahfh48bNK3/7ssje2rf7rFLIVbBYrhp65PWhxd+PU86rYDp0bBALPf1gBxkRnjFX3
         sWGHTvzWdqNRXkhvgF2mygemv6rE02r4OXOvxzeEWmbrdkRp47pAYnnq3mwEieZXfT
         sc+dzRJzCIBRjCKOiR85ceG2QDFIyQxE9iY0nB1kR1JEvEB7MYcEPD2SzkvT9GI4wC
         ZrrhJ992clnNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 08/38] locktorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:24:46 -0500
Message-Id: <20201223022516.2794471-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
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
index ad5aea269f76f..081145d6bd697 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/torture.h>
+#include <linux/reboot.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
@@ -966,6 +967,10 @@ static int __init lock_torture_init(void)
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

