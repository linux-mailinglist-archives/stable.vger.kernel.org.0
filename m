Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0486A8EFC
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 02:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjCCBxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 20:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCCBwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 20:52:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D25E12590;
        Thu,  2 Mar 2023 17:50:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21EDC616F0;
        Fri,  3 Mar 2023 01:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792EFC433EF;
        Fri,  3 Mar 2023 01:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677808207;
        bh=KMaFJLfAn+j/D77dgTy+zM2L5dG6txyu18LJ6+nLHso=;
        h=Date:To:From:Subject:From;
        b=0FQ5N3oZpuQLE1zmN2pO1V5Koh/8A1vs0xdCQgaKHs8361kDcEcLOHKZZwnY3UWUM
         K6N+MQPTYMYhTXGQ3F50LizYiGyVXKjPqIKDqAoNKC9G4yey6Bg1rvJ4cyhcRUEuYi
         3Sa8TCP4wYZFc7AOZDTMcp+SPJI3JCEvVtRBbTno=
Date:   Thu, 02 Mar 2023 17:50:06 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, david@redhat.com, axelrasmussen@google.com,
        jthoughton@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-teach-mincore_hugetlb-about-pte-markers.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303015007.792EFC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: teach mincore_hugetlb about pte markers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-teach-mincore_hugetlb-about-pte-markers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-teach-mincore_hugetlb-about-pte-markers.patch

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
From: James Houghton <jthoughton@google.com>
Subject: mm: teach mincore_hugetlb about pte markers
Date: Thu, 2 Mar 2023 22:24:04 +0000

By checking huge_pte_none(), we incorrectly classify PTE markers as
"present".  Instead, check huge_pte_none_mostly(), classifying PTE markers
the same as if the PTE were completely blank.

PTE markers, unlike other kinds of swap entries, don't reference any
physical page and don't indicate that a physical page was mapped
previously.  As such, treat them as non-present for the sake of mincore().

Link: https://lkml.kernel.org/r/20230302222404.175303-1-jthoughton@google.com
Fixes: 5c041f5d1f23 ("mm: teach core mm about pte markers")
Signed-off-by: James Houghton <jthoughton@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mincore.c~mm-teach-mincore_hugetlb-about-pte-markers
+++ a/mm/mincore.c
@@ -33,7 +33,7 @@ static int mincore_hugetlb(pte_t *pte, u
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
 	 */
-	present = pte && !huge_pte_none(huge_ptep_get(pte));
+	present = pte && !huge_pte_none_mostly(huge_ptep_get(pte));
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-teach-mincore_hugetlb-about-pte-markers.patch

