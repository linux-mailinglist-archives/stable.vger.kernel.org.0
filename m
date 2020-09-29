Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1F27C9ED
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgI2MPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0D3523B21;
        Tue, 29 Sep 2020 11:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379226;
        bh=kNFZsopbVyVAJ8OKMfB9Qlukt+X2Zi5I8g5+zko9C/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+XR4WAilYBvma41mD61p+qAc5yn3qPoMoOcUC29Yc790Pf8YAsWFbYhjkABh68DT
         TSpK1RGwAD1v2HXRkXH5R+BOMYRtVKVOF3q1AreJGrjlnpJ1owE/5dcLcFocyzL7Qf
         M2ZNVE0KvU6A6J8DJ20RAOUNqCDdySnnDftwqzhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH 5.4 069/388] kernel/notifier.c: intercept duplicate registrations to avoid infinite loops
Date:   Tue, 29 Sep 2020 12:56:40 +0200
Message-Id: <20200929110013.833689836@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



