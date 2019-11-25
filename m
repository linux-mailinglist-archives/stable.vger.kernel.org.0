Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203021095E4
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 23:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKYW6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 17:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfKYW6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 17:58:12 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CCEB2075C;
        Mon, 25 Nov 2019 22:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574722691;
        bh=SRUEuGP8FAWIRpCFEaZHndJ9MO2YQjoOKFxwItpuFmg=;
        h=Date:From:To:Subject:From;
        b=0xEh5PbDXJPGJ+/7qSqX/2Wy46KZ5WGIr0dPvWv/Z/N5L/50aBX7w9ljnrdiOXVPn
         MNXT3lQyarjVVPWoKvdjfa2pu40E/OOVft2pf+65RnyideYAZG7n2L2lJA41MJC/gR
         1m8rLIS/SkGwmBywmtuYKJLuigRZXpCvVmZtdQZA=
Date:   Mon, 25 Nov 2019 14:58:11 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, aryabinin@virtuozzo.com, hughd@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch
 removed from -mm tree
Message-ID: <20191125225811.aZ3XZS-pU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()
has been removed from the -mm tree.  Its filename was
     mm-ksm-dont-warn-if-page-is-still-mapped-in-remove_stable_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Hugh Dickins <hughd@google.com>
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

mm-vmscan-remove-unused-lru_pages-argument.patch

