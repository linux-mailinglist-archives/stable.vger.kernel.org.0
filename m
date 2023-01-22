Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F341676FA3
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjAVPXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjAVPXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0A6EC69
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6DC560BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A8BC433D2;
        Sun, 22 Jan 2023 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401015;
        bh=/q6rBZOT3WgoBAtjuHryok5+JLfH9kF2NqsGIKwugmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2I+E7+VMwI9t3yVVdpwAcvJ+zG0Gwk3dbT9eGFTRFp5ezca9EyT5FeJVd8M43pSwi
         s2YVzl4y2rhUjEFF1XiNXUrGZVrfO3QmMx88V8i5SzXoh3/r8AQfAXQ60f8/gBQuBG
         QbacgAgrqf/wjgnGyaiwththiVBuonsOXyg+mAt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 078/193] mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects
Date:   Sun, 22 Jan 2023 16:03:27 +0100
Message-Id: <20230122150249.919860960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit fed15f1345dc8a7fc8baa81e8b55c3ba010d7f4b upstream.

Userfaultfd-wp uses pte markers to mark wr-protected pages for both shmem
and hugetlb.  Shmem has pre-allocation ready for markers, but hugetlb path
was overlooked.

Doing so by calling huge_pte_alloc() if the initial pgtable walk fails to
find the huge ptep.  It's possible that huge_pte_alloc() can fail with
high memory pressure, in that case stop the loop immediately and fail
silently.  This is not the most ideal solution but it matches with what we
do with shmem meanwhile it avoids the splat in dmesg.

Link: https://lkml.kernel.org/r/20230104225207.1066932-2-peterx@redhat.com
Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6604,8 +6604,17 @@ unsigned long hugetlb_change_protection(
 		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address, psize);
 		if (!ptep) {
-			address |= last_addr_mask;
-			continue;
+			if (!uffd_wp) {
+				address |= last_addr_mask;
+				continue;
+			}
+			/*
+			 * Userfaultfd wr-protect requires pgtable
+			 * pre-allocations to install pte markers.
+			 */
+			ptep = huge_pte_alloc(mm, vma, address, psize);
+			if (!ptep)
+				break;
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, address, ptep)) {


