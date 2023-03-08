Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39316AFBB8
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 02:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCHBFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 20:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCHBFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 20:05:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92478A4B04;
        Tue,  7 Mar 2023 17:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DF1C615E8;
        Wed,  8 Mar 2023 01:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B5EC433D2;
        Wed,  8 Mar 2023 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237526;
        bh=0myIYbvpfRNwAj3Hs/DhwnagNatdX9XqpN3p3csN2gM=;
        h=Date:To:From:Subject:From;
        b=fh7E+mV+3maD5RIDBeLp4p0TVOHDwHFcxyeqaaGE++ApIHxH+UcBtdMJBK61sGOsq
         pHUDgsp5aB+HUrhvvbEr1yAHnZ/dENNdbElIbWxyjy7VDmEU88HGkhYA3iuDO5ReTI
         Ydy8gTnWQqwS9KRNw2v2C7m1kcynlGeGPJIr31a8=
Date:   Tue, 07 Mar 2023 17:05:25 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, david@redhat.com, axelrasmussen@google.com,
        jthoughton@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-teach-mincore_hugetlb-about-pte-markers.patch removed from -mm tree
Message-Id: <20230308010526.83B5EC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: teach mincore_hugetlb about pte markers
has been removed from the -mm tree.  Its filename was
     mm-teach-mincore_hugetlb-about-pte-markers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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


