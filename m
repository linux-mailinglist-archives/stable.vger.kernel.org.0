Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C3102DE4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 22:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfKSVCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 16:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfKSVCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 16:02:20 -0500
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64972245B;
        Tue, 19 Nov 2019 21:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574197339;
        bh=MgeNnAjFeQsQ0hYQpdXYYybm4fGfiOsaz4xFfqL6j9U=;
        h=Date:From:To:Subject:From;
        b=XiFC4gU6/q7P5HdP9d4tm5086q2KLVU7y2H2nXpk+3ElDls/i32IFVrO0Tf/HA3zL
         /WXtp+u98Co90jDvz1FNdDemecuh6EZK035BxXV29TAn1IJqrbBo0nQ50B60kPadtw
         2JYQshNq9px5z7uQBPpQ0k68cZmWsyU+StqoGPiQ=
Date:   Tue, 19 Nov 2019 13:02:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        hughd@google.com, aarcange@redhat.com, aryabinin@virtuozzo.com
Subject:  +
 mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch added to
 -mm tree
Message-ID: <20191119210218.LGoMg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()
has been added to the -mm tree.  Its filename is
     mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()

It's possible to hit the WARN_ON_ONCE(page_mapped(page)) in
remove_stable_node() when it races with __mmput() and squeezes in between
ksm_exit() and exit_mmap().

 WARNING: CPU: 0 PID: 3295 at mm/ksm.c:888 remove_stable_node+0x10c/0x150

 Call Trace:
  remove_all_stable_nodes+0x12b/0x330
  run_store+0x4ef/0x7b0
  kernfs_fop_write+0x200/0x420
  vfs_write+0x154/0x450
  ksys_write+0xf9/0x1d0
  do_syscall_64+0x99/0x510
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Remove the warning as there is nothing scary going on.

Link: http://lkml.kernel.org/r/20191119131850.5675-1-aryabinin@virtuozzo.com
Fixes: cbf86cfe04a6 ("ksm: remove old stable nodes more thoroughly")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node
+++ a/mm/ksm.c
@@ -885,13 +885,13 @@ static int remove_stable_node(struct sta
 		return 0;
 	}
 
-	if (WARN_ON_ONCE(page_mapped(page))) {
-		/*
-		 * This should not happen: but if it does, just refuse to let
-		 * merge_across_nodes be switched - there is no need to panic.
-		 */
-		err = -EBUSY;
-	} else {
+	/*
+	 * Page could be still mapped if this races with __mmput() running in
+	 * between ksm_exit() and exit_mmap(). Just refuse to let
+	 * merge_across_nodes/max_page_sharing be switched.
+	 */
+	err = -EBUSY;
+	if (!page_mapped(page)) {
 		/*
 		 * The stable node did not yet appear stale to get_ksm_page(),
 		 * since that allows for an unmapped ksm page to be recognized
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch
mm-vmscan-remove-unused-lru_pages-argument.patch

