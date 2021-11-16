Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8784528AB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 04:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhKPDpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 22:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233795AbhKPDpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 22:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F38C361B3E;
        Tue, 16 Nov 2021 03:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637034126;
        bh=wbVxhxKHbMyRyOlaVzpQz0LJjSI1EqUmrW+i1aIDHK0=;
        h=Date:From:To:Subject:From;
        b=MMLuIrzOjtonvvb1FM6Acg20Az3BJYwnddv1R3e7GW3BiX+ML9ROOCKBwP21ZJoW3
         aZR7OBvXfGDIp6YEfBCPVTvRkdxGCRjQ35z/JuaTxa3TilX6L2excbv+JL7CCJ+0vp
         MqNohBKgMnoLIOw0e8kNK3UJP22/5JpJb00nRJ6A=
Date:   Mon, 15 Nov 2021 19:42:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, stable@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-damon-dbgfs-use-=5F=5Fgfp=5Fnowarn-for-user-specified-?=
 =?US-ASCII?Q?size-buffer-allocation.patch?= added to -mm tree
Message-ID: <20211116034205.2g_di_78u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch
mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch

