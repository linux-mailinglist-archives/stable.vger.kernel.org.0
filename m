Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7A14329A1
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhJRWRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:17:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FE960F57;
        Mon, 18 Oct 2021 22:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595326;
        bh=Qh3cL2hpltSfSLG9YVQ1P6hvrN7nTImK0OB36heMILA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GAKA8zwzkGlDwYZof4xZKLCz2kiGeJ6uM75LhR+MsRLi/1UOvO4bcN0iMrGaVYAy1
         O8BLCOCCO9HbvdJhs5byruPBpIbKZVJloyRV0jzR3/zTIojKXCTcLPkjQKlWiwPmoo
         /yWTES2y8kV8sRnhhNMdNo2Vdeu+O/aW1Qr1KiP4=
Date:   Mon, 18 Oct 2021 15:15:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        liwang@redhat.com, mm-commits@vger.kernel.org, namit@vmware.com,
        peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/19] userfaultfd: fix a race between
 writeprotect and exit_mmap()
Message-ID: <20211018221525.vqm6hS1Ya%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
