Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA11611C2A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ1VHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJ1VHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:07:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DA9249892;
        Fri, 28 Oct 2022 14:07:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007ECB82B08;
        Fri, 28 Oct 2022 21:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8396EC433D7;
        Fri, 28 Oct 2022 21:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991234;
        bh=p1eDuQy8pEao9PsMpaBCq/3XI4cVhT1exy0JnVG5Q+M=;
        h=Date:To:From:Subject:From;
        b=ap/gjQ4SGa2gUJV17keSx7VNn4Qkb1dUSf4AOjvr89cdRRlXpqVlHyg4uAtVwAKTm
         HrAn5qDFpD/swKzQ/9RvBjLzBpIsi4S1iNF/TM9wS2x8LdToF8Mp/n2h9AZ2W5kJR5
         FPQp/VeOuRhrBQ1b6pQqQzBh0TN/Z1xbc9FnCIU0=
Date:   Fri, 28 Oct 2022 14:07:13 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, david@redhat.com, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmmadvisehugetlb-fix-unexpected-data-loss-with-madv_dontneed-on-hugetlbfs.patch removed from -mm tree
Message-Id: <20221028210714.8396EC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs
has been removed from the -mm tree.  Its filename was
     mmmadvisehugetlb-fix-unexpected-data-loss-with-madv_dontneed-on-hugetlbfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs
Date: Fri, 21 Oct 2022 19:28:05 -0400

A common use case for hugetlbfs is for the application to create
memory pools backed by huge pages, which then get handed over to
some malloc library (eg. jemalloc) for further management.

That malloc library may be doing MADV_DONTNEED calls on memory
that is no longer needed, expecting those calls to happen on
PAGE_SIZE boundaries.

However, currently the MADV_DONTNEED code rounds up any such
requests to HPAGE_PMD_SIZE boundaries. This leads to undesired
outcomes when jemalloc expects a 4kB MADV_DONTNEED, but 2MB of
memory get zeroed out, instead.

Use of pre-built shared libraries means that user code does not
always know the page size of every memory arena in use.

Avoid unexpected data loss with MADV_DONTNEED by rounding up
only to PAGE_SIZE (in do_madvise), and rounding down to huge
page granularity.

That way programs will only get as much memory zeroed out as
they requested.

Link: https://lkml.kernel.org/r/20221021192805.366ad573@imladris.surriel.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/madvise.c~mmmadvisehugetlb-fix-unexpected-data-loss-with-madv_dontneed-on-hugetlbfs
+++ a/mm/madvise.c
@@ -813,7 +813,14 @@ static bool madvise_dontneed_free_valid_
 	if (start & ~huge_page_mask(hstate_vma(vma)))
 		return false;
 
-	*end = ALIGN(*end, huge_page_size(hstate_vma(vma)));
+	/*
+	 * Madvise callers expect the length to be rounded up to PAGE_SIZE
+	 * boundaries, and may be unaware that this VMA uses huge pages.
+	 * Avoid unexpected data loss by rounding down the number of
+	 * huge pages freed.
+	 */
+	*end = ALIGN_DOWN(*end, huge_page_size(hstate_vma(vma)));
+
 	return true;
 }
 
@@ -828,6 +835,9 @@ static long madvise_dontneed_free(struct
 	if (!madvise_dontneed_free_valid_vma(vma, start, &end, behavior))
 		return -EINVAL;
 
+	if (start == end)
+		return 0;
+
 	if (!userfaultfd_remove(vma, start, end)) {
 		*prev = NULL; /* mmap_lock has been dropped, prev is stale */
 
_

Patches currently in -mm which might be from riel@surriel.com are


