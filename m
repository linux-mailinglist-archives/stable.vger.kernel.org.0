Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1245F1450C0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgAVJsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:48:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgAVJld (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:41:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F33924684;
        Wed, 22 Jan 2020 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686092;
        bh=0BtmGPs22M/KN4vGklPBEDBxRLyDfhHLM8jbiNuJg5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTXheWnD7G7mgt6ZMvfm0+scsbXDLv4Gizga19rP3I9wrfSRI8pG2U19zWxHKd8lo
         Tq2INDtJZnzKTV76mvXLYUFw+s24O6lmj8lyWGRL+yGjuDiSAtdHvCNE5N1uwhZWkp
         63ASbdWb4j70B5zpfVFYYpSq1ahlmN7LbwHNRybo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Willhalm, Thomas" <thomas.willhalm@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 040/103] mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment
Date:   Wed, 22 Jan 2020 10:28:56 +0100
Message-Id: <20200122092809.942698826@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

commit 991589974d9c9ecb24ee3799ec8c415c730598a2 upstream.

Shmem/tmpfs tries to provide THP-friendly mappings if huge pages are
enabled.  But it doesn't work well with above-47bit hint address.

Normally, the kernel doesn't create userspace mappings above 47-bit,
even if the machine allows this (such as with 5-level paging on x86-64).
Not all user space is ready to handle wide addresses.  It's known that
at least some JIT compilers use higher bits in pointers to encode their
information.

Userspace can ask for allocation from full address space by specifying
hint address (with or without MAP_FIXED) above 47-bits.  If the
application doesn't need a particular address, but wants to allocate
from whole address space it can specify -1 as a hint address.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2072,9 +2072,10 @@ unsigned long shmem_get_unmapped_area(st
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
@@ -2108,7 +2109,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = get_area(NULL, 0, inflated_len, 0, flags);
+	inflated_addr = get_area(NULL, uaddr, inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)


