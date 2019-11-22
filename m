Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3553C105E66
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 02:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKVByE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 20:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfKVByE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 20:54:04 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49931206DA;
        Fri, 22 Nov 2019 01:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574387642;
        bh=EsdBhVEjhAGhB+ttu3hBaGhwQ4Q0+rsLVS9kMNRTn2E=;
        h=Date:From:To:Subject:From;
        b=HAehkxSoZY5pr1Salw1CWfgkBZD2HyyKxDaJsY7IfQlTsEHUI7XJHh2rll1BaZrrp
         CLQuQ6jJa9ZfnqzOjmiqL/1dukNN7WTMWN20dRYf20YgSamjrYHiOU47npfgOfZwAu
         erAsaQI2pkTeUFiJtAy+fSi3nQLr6IddVAqVB2h0=
Date:   Thu, 21 Nov 2019 17:54:01 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        aryabinin@virtuozzo.com, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 4/4] mm/ksm.c: don't WARN if page is still mapped
 in remove_stable_node()
Message-ID: <20191122015401.XFgHUZogP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
