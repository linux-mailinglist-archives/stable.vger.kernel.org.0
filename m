Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7107C360D84
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhDOPDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235188AbhDOPA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD28613B4;
        Thu, 15 Apr 2021 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498598;
        bh=A+agapKun2YtQuk0lHEgnbTeI1CbbZ89Ds1z3HMaOKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsmAxF1UTYcNHQ9rji9jqYKc8OMtl+stYqFzTbcb4gZN+Tme8SP34liKibuvMVmg2
         JntSNSyLMBFz+1D/XifEC/3k+n2zFY3RVKwmHk+lWLGzZY85PYdG1uHtzARUMTpQz4
         1Sfy9OOVC6GakRkLwFxfVfdufW9eNA3o57JiKwsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris von Recklinghausen <crecklin@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/18] radix tree test suite: Register the main thread with the RCU library
Date:   Thu, 15 Apr 2021 16:48:01 +0200
Message-Id: <20210415144413.315313016@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

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



