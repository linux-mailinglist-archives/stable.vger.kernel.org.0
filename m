Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB6313B696
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 01:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgAOApo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 19:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgAOApo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 19:45:44 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19A5222C3;
        Wed, 15 Jan 2020 00:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579049144;
        bh=oEXVF7xO2+89AUqSjb3Zp9t/QCQL2oVDTliQmCbthyg=;
        h=Date:From:To:Subject:From;
        b=Ymn1m4GZAuZJ4LkvWiN1wyJlUEydKlzH/JeNbP+7piLLGNNFY2X1nNaog+yy/DFxH
         PgDE7Aj7xhOK74081pfOP0C1VgR/CQj4QMKo8WQKpUXg43JtzEteBgsSxX6Qks/Od7
         XKIbNHti2I2Y1s9ogi/JqeWwXhy3lLZ+TWuzN6wY=
Date:   Tue, 14 Jan 2020 16:45:43 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, otto.g.bruggeman@intel.com,
        stable@vger.kernel.org, thomas.willhalm@intel.com
Subject:  [merged]
 thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment.patch
 removed from -mm tree
Message-ID: <20200115004543.aYcspazI8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment
has been removed from the -mm tree.  Its filename was
     thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment

Shmem/tmpfs tries to provide THP-friendly mappings if huge pages are
enabled.  But it doesn't work well with above-47bit hint address.

Normally, the kernel doesn't create userspace mappings above 47-bit, even
if the machine allows this (such as with 5-level paging on x86-64).  Not
all user space is ready to handle wide addresses.  It's known that at
least some JIT compilers use higher bits in pointers to encode their
information.

Userspace can ask for allocation from full address space by specifying
hint address (with or without MAP_FIXED) above 47-bits.  If the
application doesn't need a particular address, but wants to allocate from
whole address space it can specify -1 as a hint address.

Unfortunately, this trick breaks THP alignment in shmem/tmp:
shmem_get_unmapped_area() would not try to allocate PMD-aligned area if
*any* hint address specified.

This can be fixed by requesting the aligned area if the we failed to
allocated at user-specified hint address.  The request with inflated
length will also take the user-specified hint address.  This way we will
not lose an allocation request from the full address space.

[kirill@shutemov.name: fold in a fixup]
  Link: http://lkml.kernel.org/r/20191223231309.t6bh5hkbmokihpfu@box
Link: http://lkml.kernel.org/r/20191220142548.7118-3-kirill.shutemov@linux.intel.com
Fixes: b569bab78d8d ("x86/mm: Prepare to expose larger address space to userspace")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Willhalm, Thomas" <thomas.willhalm@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment
+++ a/mm/shmem.c
@@ -2107,9 +2107,10 @@ unsigned long shmem_get_unmapped_area(st
 	/*
 	 * Our priority is to support MAP_SHARED mapped hugely;
 	 * and support MAP_PRIVATE mapped hugely too, until it is COWed.
-	 * But if caller specified an address hint, respect that as before.
+	 * But if caller specified an address hint and we allocated area there
+	 * successfully, respect that as before.
 	 */
-	if (uaddr)
+	if (uaddr == addr)
 		return addr;
 
 	if (shmem_huge != SHMEM_HUGE_FORCE) {
@@ -2143,7 +2144,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = get_area(NULL, 0, inflated_len, 0, flags);
+	inflated_addr = get_area(NULL, uaddr, inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-page_alloc-skip-non-present-sections-on-zone-initialization.patch

