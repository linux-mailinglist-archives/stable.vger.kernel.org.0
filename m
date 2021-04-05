Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B753544A7
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbhDEQFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242194AbhDEQFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCFB0613C9;
        Mon,  5 Apr 2021 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638710;
        bh=S90Qc4S09UsEM8as6c0miYWhG2tCiQPkyucwsFYFP1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+vGVduBov+DAvGfWKTYp2KkR80V9FuvAY+89/gGDyuRpLdZxymD+odxjjoTB0Gvs
         8ANEGkro3ZT1BS/v7DsZ7fyi97CSY3Ff0R5qt4gQBeivDHC4jz6v7TmBWQ8gLJtOZy
         Kj+fBZuOEct1yUNy47ggXIJTbbORP5m4afHSB0mZLwfgNfm++7aQ1ypUPbk8Dws1fI
         yvTxPG0pJo5nnMcTr4Csi+MacqEB5eioOMupStwqYNtEGLCg3l7RzPobggsxeeE3/X
         iTp0rzk7KY7J3eHBpk4QSs7fsxD2t59OhOdPv+1Z3WTXvQknZccPUMCMyTrrUnbOns
         6rqvfPv8OGhMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/13] radix tree test suite: Register the main thread with the RCU library
Date:   Mon,  5 Apr 2021 12:04:54 -0400
Message-Id: <20210405160459.268794-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160459.268794-1-sashal@kernel.org>
References: <20210405160459.268794-1-sashal@kernel.org>
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

