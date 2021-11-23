Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BF745AF5B
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhKWWtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238852AbhKWWtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ADE460F5B;
        Tue, 23 Nov 2021 22:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707562;
        bh=zXXVp68MSRldtqr5wQZSsMIVeZ9La7LEgCi1A16xqQw=;
        h=Date:From:To:Subject:From;
        b=ydf1P4oNmPVWmLiOb4QtMcP143t+kOsSU1qT9TeIBc6DoN/cJhE8QAuw/OuohD3j4
         DhL8Dgo94Uuf5Vgn4drjip4xXCANi2174+4UV1MzDSvGVBR5VB3QbXgTgvJveWK9na
         KXkVIU1LvaLT4gWd/3Z2RbOM5ziVaNuxdHXRZs7U=
Date:   Tue, 23 Nov 2021 14:46:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-damon-dbgfs-use-=5F=5Fgfp=5Fnowarn-for-user-specified-?=
 =?US-ASCII?Q?size-buffer-allocation.patch?= removed from -mm tree
Message-ID: <20211123224602.SFvhJKDXb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

