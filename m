Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0165FDF50
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJMRwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJMRwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7803A42D4E;
        Thu, 13 Oct 2022 10:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0CA5618F6;
        Thu, 13 Oct 2022 17:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DD8C433D6;
        Thu, 13 Oct 2022 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683558;
        bh=DLTKqalRL/yJy9k0mwrpTytTh7nTjfk/dDsHA3Kqd40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnFw1An3LeANfoVfG+Nzm9BjQOHY4/p0hZ/lM5z6DeGZieeIHIlVaXwgKPkeA1ely
         SArKtAsDNifOOqGBfUr1VDZDQHwRHrN5y0hKuNHK4N7Bc6fOcmAsqPAwCp6euwAGNT
         nnym1UKfui2UEnBkfkrGtaHWveFrPlXRwZlBnUp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Steven Price <steven.price@arm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 01/38] mm: pagewalk: Fix race between unmap and page walker
Date:   Thu, 13 Oct 2022 19:52:02 +0200
Message-Id: <20221013175144.300652012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

commit 8782fb61cc848364e1e1599d76d3c9dd58a1cc06 upstream.

The mmap lock protects the page walker from changes to the page tables
during the walk.  However a read lock is insufficient to protect those
areas which don't have a VMA as munmap() detaches the VMAs before
downgrading to a read lock and actually tearing down PTEs/page tables.

For users of walk_page_range() the solution is to simply call pte_hole()
immediately without checking the actual page tables when a VMA is not
present. We now never call __walk_page_range() without a valid vma.

For walk_page_range_novma() the locking requirements are tightened to
require the mmap write lock to be taken, and then walking the pgd
directly with 'no_vma' set.

This in turn means that all page walkers either have a valid vma, or
it's that special 'novma' case for page table debugging.  As a result,
all the odd '(!walk->vma && !walk->no_vma)' tests can be removed.

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[manually backported. backport note: walk_page_range_novma() does not exist in
5.4, so I'm omitting it from the backport]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/pagewalk.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -38,7 +38,7 @@ static int walk_pmd_range(pud_t *pud, un
 	do {
 again:
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) || !walk->vma) {
+		if (pmd_none(*pmd)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, walk);
 			if (err)
@@ -84,7 +84,7 @@ static int walk_pud_range(p4d_t *p4d, un
 	do {
  again:
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud) || !walk->vma) {
+		if (pud_none(*pud)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, walk);
 			if (err)
@@ -254,7 +254,7 @@ static int __walk_page_range(unsigned lo
 	int err = 0;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (vma && is_vm_hugetlb_page(vma)) {
+	if (is_vm_hugetlb_page(vma)) {
 		if (walk->ops->hugetlb_entry)
 			err = walk_hugetlb_range(start, end, walk);
 	} else
@@ -324,9 +324,13 @@ int walk_page_range(struct mm_struct *mm
 		if (!vma) { /* after the last vma */
 			walk.vma = NULL;
 			next = end;
+			if (ops->pte_hole)
+				err = ops->pte_hole(start, next, &walk);
 		} else if (start < vma->vm_start) { /* outside vma */
 			walk.vma = NULL;
 			next = min(end, vma->vm_start);
+			if (ops->pte_hole)
+				err = ops->pte_hole(start, next, &walk);
 		} else { /* inside vma */
 			walk.vma = vma;
 			next = min(end, vma->vm_end);
@@ -344,9 +348,8 @@ int walk_page_range(struct mm_struct *mm
 			}
 			if (err < 0)
 				break;
-		}
-		if (walk.vma || walk.ops->pte_hole)
 			err = __walk_page_range(start, next, &walk);
+		}
 		if (err)
 			break;
 	} while (start = next, start < end);


