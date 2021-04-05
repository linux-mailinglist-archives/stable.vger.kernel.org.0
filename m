Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5779B354424
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241885AbhDEQEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242066AbhDEQEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 034B9613C4;
        Mon,  5 Apr 2021 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638663;
        bh=S90Qc4S09UsEM8as6c0miYWhG2tCiQPkyucwsFYFP1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YY0NhW4GfJJGPQNng7qFYUS5TWYegbbRk9Bi/VsHVJu2Oo+cVcBfBy5kUeZmA+qjS
         T+303ZNKLUjYhv1lpvbOX8k/5gniGRFKM+si9oAjeqkLLTatZhwW+FLAk9AZ3ISFgV
         75+DIkuZ7bcGrJUGXRhoLLTsbAWALQ63PWjbQvrRkpi4zdYzCcyWvXjUO6sRhjK0w1
         nJIRV5dhEgZ2IqZ9T71aJW8kck37nx9AN8Xo+siSzX2vdjMqOlyN/1tvbMnDC1BUMg
         Dy9qPwNM8rUNJrZskIUbjpnvH8F0N6roqHYu4J95C4ylsQUqTULxCmibIWOF7qcna2
         V6jS2IfmCar+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 15/22] radix tree test suite: Register the main thread with the RCU library
Date:   Mon,  5 Apr 2021 12:03:58 -0400
Message-Id: <20210405160406.268132-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
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

