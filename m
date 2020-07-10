Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9D621C0BE
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 01:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGJX3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 19:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgGJX3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 19:29:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F212065F;
        Fri, 10 Jul 2020 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594423769;
        bh=BfEZy1dZR3hlZ5iLWwsrp8+ABvTwJp6o/EcZNZYYQaw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b/tIq+gkbCfOnVP1Q+jl59OosZqtsDB3+/T7GYd/596fNbE8Als8pZAz/xw5t8cq1
         dlFfSIasgqxYdIL88dkyHwj6b/9Dzn9kem7rH3I7epBHQPY7EloHLNFCZrz8ZgMdVU
         igoLG07PS1q0EZBDqhBIeWW+PuyO66THeliclrXA=
Date:   Fri, 10 Jul 2020 16:29:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, jonathan.cameron@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        stable@vger.kernel.org
Subject:  +
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch added to
 -mm tree
Message-ID: <20200710232929.a4Ps5q8mu%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid hardcoding while checking if cma is enabled
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/hugetlb: avoid hardcoding while checking if cma is enabled

hugetlb_cma[0] can be NULL due to various reasons, for example, node0 has
no memory.  so NULL hugetlb_cma[0] doesn't necessarily mean cma is not
enabled.  gigantic pages might have been reserved on other nodes.  This
patch fixes possible double reservation and CMA leak.

Link: http://lkml.kernel.org/r/20200710005726.36068-1-song.bao.hua@hisilicon.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled
+++ a/mm/hugetlb.c
@@ -46,6 +46,7 @@ unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+static unsigned long hugetlb_cma_size __initdata;
 
 /*
  * Minimum page order among possible hugepage sizes, set to a proper value
@@ -2571,7 +2572,7 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
-			if (IS_ENABLED(CONFIG_CMA) && hugetlb_cma[0]) {
+			if (hugetlb_cma_size) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 				break;
 			}
@@ -5654,7 +5655,6 @@ void move_hugetlb_state(struct page *old
 }
 
 #ifdef CONFIG_CMA
-static unsigned long hugetlb_cma_size __initdata;
 static bool cma_reserve_called __initdata;
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch
mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch

