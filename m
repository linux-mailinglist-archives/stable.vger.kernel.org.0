Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D90354452
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbhDEQE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242147AbhDEQE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F8F613C8;
        Mon,  5 Apr 2021 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638690;
        bh=S90Qc4S09UsEM8as6c0miYWhG2tCiQPkyucwsFYFP1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeALLyP4RRammmq88QqlmUNUHdeUcUmzlW3xkfkRjZhi6aOrz8+Se9a+1zRUZdUno
         LMnoLrQFyPO0H22PeO8bAelY44RePjK1cJwTTIfGkXoSXXH+3sOF35cUtMcptjqFp2
         18F1OzcwSkR5U5NvcqLXZVACKy4vNqPKX0A3wx3bQ0Tv/iKG21WVNAJB7mDJlNSoyK
         XjnKy3n3aOG/Xw1J/6EqF966v0xpw1JifmkAMRETqOCO5JaC1fufWP0mYULMXRVeeP
         9yCLEgg1uSy6V8l0QvrAEquEl19E/t5m6rOQgwG4gO805kjlsVABLOC5SFq3pQdLnH
         b+lIk75pEE93Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/22] radix tree test suite: Register the main thread with the RCU library
Date:   Mon,  5 Apr 2021 12:04:24 -0400
Message-Id: <20210405160432.268374-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 1bb4bd266cf39fd2fa711f2d265c558b92df1119 ]

Several test runners register individual worker threads with the
RCU library, but neglect to register the main thread, which can lead
to objects being freed while the main thread is in what appears to be
an RCU critical section.

Reported-by: Chris von Recklinghausen <crecklin@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/idr-test.c   | 2 ++
 tools/testing/radix-tree/multiorder.c | 2 ++
 tools/testing/radix-tree/xarray.c     | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 3b796dd5e577..44ceff95a9b3 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -577,6 +577,7 @@ void ida_tests(void)
 
 int __weak main(void)
 {
+	rcu_register_thread();
 	radix_tree_init();
 	idr_checks();
 	ida_tests();
@@ -584,5 +585,6 @@ int __weak main(void)
 	rcu_barrier();
 	if (nr_allocated)
 		printf("nr_allocated = %d\n", nr_allocated);
+	rcu_unregister_thread();
 	return 0;
 }
diff --git a/tools/testing/radix-tree/multiorder.c b/tools/testing/radix-tree/multiorder.c
index 9eae0fb5a67d..e00520cc6349 100644
--- a/tools/testing/radix-tree/multiorder.c
+++ b/tools/testing/radix-tree/multiorder.c
@@ -224,7 +224,9 @@ void multiorder_checks(void)
 
 int __weak main(void)
 {
+	rcu_register_thread();
 	radix_tree_init();
 	multiorder_checks();
+	rcu_unregister_thread();
 	return 0;
 }
diff --git a/tools/testing/radix-tree/xarray.c b/tools/testing/radix-tree/xarray.c
index e61e43efe463..f20e12cbbfd4 100644
--- a/tools/testing/radix-tree/xarray.c
+++ b/tools/testing/radix-tree/xarray.c
@@ -25,11 +25,13 @@ void xarray_tests(void)
 
 int __weak main(void)
 {
+	rcu_register_thread();
 	radix_tree_init();
 	xarray_tests();
 	radix_tree_cpu_dead(1);
 	rcu_barrier();
 	if (nr_allocated)
 		printf("nr_allocated = %d\n", nr_allocated);
+	rcu_unregister_thread();
 	return 0;
 }
-- 
2.30.2

