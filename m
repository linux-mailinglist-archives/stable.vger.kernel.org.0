Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8F6634E0F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 03:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiKWCx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 21:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKWCxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 21:53:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A55E3D0F;
        Tue, 22 Nov 2022 18:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC52A61886;
        Wed, 23 Nov 2022 02:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D575C433C1;
        Wed, 23 Nov 2022 02:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172009;
        bh=SJkVV2GdoHVRIIoz8jhXDp+T4JS6CO6JGAahD7MaDIo=;
        h=Date:To:From:Subject:From;
        b=IGWHKftsQCbcoh29+E+e709oqEJybQ/oDVj9EVG9spCMpqrHqOIkQ0exlUbHMTDu6
         cWOlAnsZ/H2DO99QWqxaBmlPeCzegZYGmnAHbike7Vu1QZrAXJltMG+Rzzc9ShGdhm
         ZSfOEls1T4Vho2q3oVKuSFS112ODUYP5JAYKHkHE=
Date:   Tue, 22 Nov 2022 18:53:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, jgg@nvidia.com, dvyukov@google.com,
        akinobu.mita@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-unexpected-changes-to-failslabfail_page_allocattr.patch removed from -mm tree
Message-Id: <20221123025329.1D575C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: fix unexpected changes to {failslab|fail_page_alloc}.attr
has been removed from the -mm tree.  Its filename was
     mm-fix-unexpected-changes-to-failslabfail_page_allocattr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: fix unexpected changes to {failslab|fail_page_alloc}.attr
Date: Fri, 18 Nov 2022 18:00:11 +0800

When we specify __GFP_NOWARN, we only expect that no warnings will be
issued for current caller.  But in the __should_failslab() and
__should_fail_alloc_page(), the local GFP flags alter the global
{failslab|fail_page_alloc}.attr, which is persistent and shared by all
tasks.  This is not what we expected, let's fix it.

[akpm@linux-foundation.org: unexport should_fail_ex()]
Link: https://lkml.kernel.org/r/20221118100011.2634-1-zhengqi.arch@bytedance.com
Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    7 +++++--
 lib/fault-inject.c           |   13 ++++++++-----
 mm/failslab.c                |   12 ++++++++++--
 mm/page_alloc.c              |    7 +++++--
 4 files changed, 28 insertions(+), 11 deletions(-)

--- a/include/linux/fault-inject.h~mm-fix-unexpected-changes-to-failslabfail_page_allocattr
+++ a/include/linux/fault-inject.h
@@ -20,7 +20,6 @@ struct fault_attr {
 	atomic_t space;
 	unsigned long verbose;
 	bool task_filter;
-	bool no_warn;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
 	unsigned long require_end;
@@ -32,6 +31,10 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
+enum fault_flags {
+	FAULT_NOWARN =	1 << 0,
+};
+
 #define FAULT_ATTR_INITIALIZER {					\
 		.interval = 1,						\
 		.times = ATOMIC_INIT(1),				\
@@ -40,11 +43,11 @@ struct fault_attr {
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
 		.dname = NULL,						\
-		.no_warn = false,					\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
+bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
--- a/lib/fault-inject.c~mm-fix-unexpected-changes-to-failslabfail_page_allocattr
+++ a/lib/fault-inject.c
@@ -41,9 +41,6 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-	if (attr->no_warn)
-		return;
-
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
 		       "name %pd, interval %lu, probability %lu, "
@@ -103,7 +100,7 @@ static inline bool fail_stacktrace(struc
  * http://www.nongnu.org/failmalloc/
  */
 
-bool should_fail(struct fault_attr *attr, ssize_t size)
+bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
 {
 	if (in_task()) {
 		unsigned int fail_nth = READ_ONCE(current->fail_nth);
@@ -146,13 +143,19 @@ bool should_fail(struct fault_attr *attr
 		return false;
 
 fail:
-	fail_dump(attr);
+	if (!(flags & FAULT_NOWARN))
+		fail_dump(attr);
 
 	if (atomic_read(&attr->times) != -1)
 		atomic_dec_not_zero(&attr->times);
 
 	return true;
 }
+
+bool should_fail(struct fault_attr *attr, ssize_t size)
+{
+	return should_fail_ex(attr, size, 0);
+}
 EXPORT_SYMBOL_GPL(should_fail);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
--- a/mm/failslab.c~mm-fix-unexpected-changes-to-failslabfail_page_allocattr
+++ a/mm/failslab.c
@@ -16,6 +16,8 @@ static struct {
 
 bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
+	int flags = 0;
+
 	/* No fault-injection for bootstrap cache */
 	if (unlikely(s == kmem_cache))
 		return false;
@@ -30,10 +32,16 @@ bool __should_failslab(struct kmem_cache
 	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
 		return false;
 
+	/*
+	 * In some cases, it expects to specify __GFP_NOWARN
+	 * to avoid printing any information(not just a warning),
+	 * thus avoiding deadlocks. See commit 6b9dbedbe349 for
+	 * details.
+	 */
 	if (gfpflags & __GFP_NOWARN)
-		failslab.attr.no_warn = true;
+		flags |= FAULT_NOWARN;
 
-	return should_fail(&failslab.attr, s->object_size);
+	return should_fail_ex(&failslab.attr, s->object_size, flags);
 }
 
 static int __init setup_failslab(char *str)
--- a/mm/page_alloc.c~mm-fix-unexpected-changes-to-failslabfail_page_allocattr
+++ a/mm/page_alloc.c
@@ -3887,6 +3887,8 @@ __setup("fail_page_alloc=", setup_fail_p
 
 static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	int flags = 0;
+
 	if (order < fail_page_alloc.min_order)
 		return false;
 	if (gfp_mask & __GFP_NOFAIL)
@@ -3897,10 +3899,11 @@ static bool __should_fail_alloc_page(gfp
 			(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
 
+	/* See comment in __should_failslab() */
 	if (gfp_mask & __GFP_NOWARN)
-		fail_page_alloc.attr.no_warn = true;
+		flags |= FAULT_NOWARN;
 
-	return should_fail(&fail_page_alloc.attr, 1 << order);
+	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
 }
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


