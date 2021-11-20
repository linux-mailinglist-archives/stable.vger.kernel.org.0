Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC25457A48
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 01:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhKTAqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 19:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235910AbhKTAqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1496E61A07;
        Sat, 20 Nov 2021 00:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369030;
        bh=3zIXQHUAdko0JzwPReohAQ9tWI0lXL0OyFB88zx9MB0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v+0xaKRNnQ7F7lcZO+zj9DuE6k0TNFJLqqRBIqzP4GuXsxejcY4GKWDAfQgDtFsD3
         vh5n//0jxobX5cw8HVUaeoNyaT/GHoYMTEvy6lNYeiaS59hkH8/0fZ8MmMtxUca8nH
         DJ1rV+y538SqiYq6CEyYRB0q+v5szgLY+6SyMpE8=
Date:   Fri, 19 Nov 2021 16:43:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 12/15] mm/damon/dbgfs: use '__GFP_NOWARN' for
 user-specified size buffer allocation
Message-ID: <20211120004349.yLSlmi7Jb%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation

Patch series "DAMON fixes".


This patch (of 2):

DAMON users can trigger below warning in '__alloc_pages()' by invoking
write() to some DAMON debugfs files with arbitrarily high count argument,
because DAMON debugfs interface allocates some buffers based on the
user-specified 'count'.

        if (unlikely(order >= MAX_ORDER)) {
                WARN_ON_ONCE(!(gfp & __GFP_NOWARN));
                return NULL;
        }

Because the DAMON debugfs interface code checks failure of the
'kmalloc()', this commit simply suppresses the warnings by adding
'__GFP_NOWARN' flag.

Link: https://lkml.kernel.org/r/20211110145758.16558-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211110145758.16558-2-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation
+++ a/mm/damon/dbgfs.c
@@ -32,7 +32,7 @@ static char *user_input_str(const char _
 	if (*ppos)
 		return ERR_PTR(-EINVAL);
 
-	kbuf = kmalloc(count + 1, GFP_KERNEL);
+	kbuf = kmalloc(count + 1, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return ERR_PTR(-ENOMEM);
 
@@ -133,7 +133,7 @@ static ssize_t dbgfs_schemes_read(struct
 	char *kbuf;
 	ssize_t len;
 
-	kbuf = kmalloc(count, GFP_KERNEL);
+	kbuf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return -ENOMEM;
 
@@ -452,7 +452,7 @@ static ssize_t dbgfs_init_regions_read(s
 	char *kbuf;
 	ssize_t len;
 
-	kbuf = kmalloc(count, GFP_KERNEL);
+	kbuf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return -ENOMEM;
 
@@ -578,7 +578,7 @@ static ssize_t dbgfs_kdamond_pid_read(st
 	char *kbuf;
 	ssize_t len;
 
-	kbuf = kmalloc(count, GFP_KERNEL);
+	kbuf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return -ENOMEM;
 
_
