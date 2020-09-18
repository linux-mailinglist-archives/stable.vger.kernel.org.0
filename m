Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57126F3FE
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgIRDK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgIRCCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A19A208DB;
        Fri, 18 Sep 2020 02:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394558;
        bh=kNFZsopbVyVAJ8OKMfB9Qlukt+X2Zi5I8g5+zko9C/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXJG1FJf52NWQKRws/DivkesxnzcwRmdJXvR5LObG1xih9DnIRF9F+Tmkbm5bWagc
         YJTs7OW8fOCHTmUJ8zIyUbLoWfK5+YrxAYlwbU/bUgU3oYhnhBkhwP3nZG4l2KNofn
         t96fhYLDWQSiX4OvZmVqIrmxQhLEtEGrHcoXzCDY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoming Ni <nixiaoming@huawei.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jeff Layton <jlayton@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Nadia Derbey <Nadia.Derbey@bull.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 072/330] kernel/notifier.c: intercept duplicate registrations to avoid infinite loops
Date:   Thu, 17 Sep 2020 21:56:52 -0400
Message-Id: <20200918020110.2063155-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

[ Upstream commit 1a50cb80f219c44adb6265f5071b81fc3c1deced ]

Registering the same notifier to a hook repeatedly can cause the hook
list to form a ring or lose other members of the list.

  case1: An infinite loop in notifier_chain_register() can cause soft lockup
          atomic_notifier_chain_register(&test_notifier_list, &test1);
          atomic_notifier_chain_register(&test_notifier_list, &test1);
          atomic_notifier_chain_register(&test_notifier_list, &test2);

  case2: An infinite loop in notifier_chain_register() can cause soft lockup
          atomic_notifier_chain_register(&test_notifier_list, &test1);
          atomic_notifier_chain_register(&test_notifier_list, &test1);
          atomic_notifier_call_chain(&test_notifier_list, 0, NULL);

  case3: lose other hook test2
          atomic_notifier_chain_register(&test_notifier_list, &test1);
          atomic_notifier_chain_register(&test_notifier_list, &test2);
          atomic_notifier_chain_register(&test_notifier_list, &test1);

  case4: Unregister returns 0, but the hook is still in the linked list,
         and it is not really registered. If you call
         notifier_call_chain after ko is unloaded, it will trigger oops.

If the system is configured with softlockup_panic and the same hook is
repeatedly registered on the panic_notifier_list, it will cause a loop
panic.

Add a check in notifier_chain_register(), intercepting duplicate
registrations to avoid infinite loops

Link: http://lkml.kernel.org/r/1568861888-34045-2-git-send-email-nixiaoming@huawei.com
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/notifier.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 157d7c29f7207..f6d5ffe4e72ec 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -23,7 +23,10 @@ static int notifier_chain_register(struct notifier_block **nl,
 		struct notifier_block *n)
 {
 	while ((*nl) != NULL) {
-		WARN_ONCE(((*nl) == n), "double register detected");
+		if (unlikely((*nl) == n)) {
+			WARN(1, "double register detected");
+			return 0;
+		}
 		if (n->priority > (*nl)->priority)
 			break;
 		nl = &((*nl)->next);
-- 
2.25.1

