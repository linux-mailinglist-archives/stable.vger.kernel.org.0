Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B37139E32
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 01:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgANA3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 19:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:15 -0500
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC5F21556;
        Tue, 14 Jan 2020 00:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578961754;
        bh=M+GCJ9ZbOzKdOKsRoSA73gXAdnJpzww7MsikwWw/RMU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eSmmal3o6L9/IqdGGxxc39S0a5UMOWwLpJUiztJdgvvRa+WhMqo8AbnB5r3kEXvoX
         sh6bEOA2gqVYfmV1EJo88un1OAs4XKtx8Q331uMYpi/afi5+ShoOBBreZ4EWPaQOsw
         YLNdc3dWSa80DNfIYSdOf6QLuuQkHREKquBR+q2s=
Date:   Mon, 13 Jan 2020 16:29:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     thomas.willhalm@intel.com, stable@vger.kernel.org,
        otto.g.bruggeman@intel.com, kirill.shutemov@linux.intel.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.vnet.ibm.com,
        kirill@shutemov.name, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/11] mm/shmem.c: thp, shmem: fix conflict of
 above-47bit hint address and PMD alignment
Message-ID: <20200114002913.UR5H3%akpm@linux-foundation.org>
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
User-Agent: s-nail v14.9.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
