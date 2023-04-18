Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D516E6CDE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 21:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjDRTS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 15:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjDRTSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 15:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFD9C176;
        Tue, 18 Apr 2023 12:18:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 741B262E93;
        Tue, 18 Apr 2023 19:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EDDC433D2;
        Tue, 18 Apr 2023 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681845425;
        bh=sf6j5o39eZfMskQIap6GE3sEXHVmJeRWH2mzEHNAxkY=;
        h=Date:To:From:Subject:From;
        b=HOxfOzIP8xGvZr4CXGsKOVGWramKIuq4yf6WXGYUjg9QQ04hL4tVNUs3sLE9q8sDs
         3m0Qyf4woCcyFSf2dwi7GLv5ppmGw03h3fhqVJEFkCx3gKtqKbyaBD41iKzZaTvSnr
         spZQ3bCrMBEY19Klb9hqm7k5ufwwb7KlW+FJ0j/c=
Date:   Tue, 18 Apr 2023 12:17:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        suleiman@google.com, stable@vger.kernel.org, stevensd@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch added to mm-hotfixes-unstable branch
Message-Id: <20230418191705.B9EDDC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/shmem: Fix race in shmem_undo_range w/THP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/shmem: Fix race in shmem_undo_range w/THP
Date: Tue, 18 Apr 2023 17:40:31 +0900

Split folios during the second loop of shmem_undo_range.  It's not
sufficient to only split folios when dealing with partial pages, since
it's possible for a THP to be faulted in after that point.  Calling
truncate_inode_folio in that situation can result in throwing away data
outside of the range being targeted.

Link: https://lkml.kernel.org/r/20230418084031.3439795-1-stevensd@google.com
Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Signed-off-by: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-race-in-shmem_undo_range-w-thp
+++ a/mm/shmem.c
@@ -1022,7 +1022,22 @@ whole_folios:
 				}
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
-				truncate_inode_folio(mapping, folio);
+
+				if (!folio_test_large(folio)) {
+					truncate_inode_folio(mapping, folio);
+				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+					/*
+					 * If we split a page, reset the loop so that we
+					 * pick up the new sub pages. Otherwise the THP
+					 * was entirely dropped or the target range was
+					 * zeroed, so just continue the loop as is.
+					 */
+					if (!folio_test_large(folio)) {
+						folio_unlock(folio);
+						index = start;
+						break;
+					}
+				}
 			}
 			folio_unlock(folio);
 		}
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch
mm-khugepaged-drain-lru-after-swapping-in-shmem.patch
mm-khugepaged-refactor-collapse_file-control-flow.patch
mm-khugepaged-skip-shmem-with-userfaultfd.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

