Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6162C433E98
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhJSSlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhJSSlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C026115B;
        Tue, 19 Oct 2021 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668738;
        bh=Ugjk31ISifKqjeT4uOePcDU3gmE0f/9AwNW/K2FcJ+I=;
        h=Date:From:To:Subject:From;
        b=K+CFFkrW24oD41qRSK+f9pdGB6HzgAGj64In66Ts1tWnVNjXUxtFvEV2yYsUXw2aO
         O82PQutn68zSJhbCrDt5JgnPbkADiIxG7Ts0Gm+FneErPyLbDsY7k2QCIrsKaRj0LR
         SWQqXd1fr8rHu985IXHtphcBf6+jzXlk2xsKyzuQ=
Date:   Tue, 19 Oct 2021 11:38:58 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, liwang@redhat.com, mm-commits@vger.kernel.org,
        namit@vmware.com, peterx@redhat.com, stable@vger.kernel.org
Subject:  [merged]
 userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch removed
 from -mm tree
Message-ID: <20211019183858.xSpwgwxAI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: userfaultfd: fix a race between writeprotect and exit_mmap()
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: fix a race between writeprotect and exit_mmap()

A race is possible when a process exits, its VMAs are removed by
exit_mmap() and at the same time userfaultfd_writeprotect() is called.

The race was detected by KASAN on a development kernel, but it appears to
be possible on vanilla kernels as well.

Use mmget_not_zero() to prevent the race as done in other userfaultfd
operations.

Link: https://lkml.kernel.org/r/20210921200247.25749-1-namit@vmware.com
Fixes: 63b2d4174c4ad ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Nadav Amit <namit@vmware.com>
Tested-by: Li  Wang <liwang@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap
+++ a/fs/userfaultfd.c
@@ -1827,9 +1827,15 @@ static int userfaultfd_writeprotect(stru
 	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
-	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, mode_wp,
-				  &ctx->mmap_changing);
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
+					  uffdio_wp.range.len, mode_wp,
+					  &ctx->mmap_changing);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from namit@vmware.com are


