Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6718D1450B0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbgAVJkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733311AbgAVJkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 305BC24686;
        Wed, 22 Jan 2020 09:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686004;
        bh=RRVDSkHj/n/gGpkrhRw5hw97NpZbRgTO01K7YXq11PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vm5HXTywiVFCNGstJgzuFIVRCEUadKfyhE2IS0UWgaUo7jODouh432qawIACEYzXd
         uizQ8aDKBDhG5RR1/ah6qCdbvVGYYjae0c06uucm6sio2mwtu6pB8Bttko5qen8yVB
         dP+WNZX/bEhqu7CafCa74B96OvXIx/4Wz+7kqZzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Willhalm <thomas.willhalm@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/65] mm/huge_memory.c: thp: fix conflict of above-47bit hint address and PMD alignment
Date:   Wed, 22 Jan 2020 10:29:19 +0100
Message-Id: <20200122092755.716274773@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

[ Upstream commit 97d3d0f9a1cf132c63c0b8b8bd497b8a56283dd9 ]

Patch series "Fix two above-47bit hint address vs.  THP bugs".

The two get_unmapped_area() implementations have to be fixed to provide
THP-friendly mappings if above-47bit hint address is specified.

This patch (of 2):

Filesystems use thp_get_unmapped_area() to provide THP-friendly
mappings.  For DAX in particular.

Normally, the kernel doesn't create userspace mappings above 47-bit,
even if the machine allows this (such as with 5-level paging on x86-64).
Not all user space is ready to handle wide addresses.  It's known that
at least some JIT compilers use higher bits in pointers to encode their
information.

Userspace can ask for allocation from full address space by specifying
hint address (with or without MAP_FIXED) above 47-bits.  If the
application doesn't need a particular address, but wants to allocate
from whole address space it can specify -1 as a hint address.

Unfortunately, this trick breaks thp_get_unmapped_area(): the function
would not try to allocate PMD-aligned area if *any* hint address
specified.

Modify the routine to handle it correctly:

 - Try to allocate the space at the specified hint address with length
   padding required for PMD alignment.
 - If failed, retry without length padding (but with the same hint
   address);
 - If the returned address matches the hint address return it.
 - Otherwise, align the address as required for THP and return.

The user specified hint address is passed down to get_unmapped_area() so
above-47bit hint address will be taken into account without breaking
alignment requirements.

Link: http://lkml.kernel.org/r/20191220142548.7118-2-kirill.shutemov@linux.intel.com
Fixes: b569bab78d8d ("x86/mm: Prepare to expose larger address space to userspace")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Thomas Willhalm <thomas.willhalm@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6d835535946d..92915cc87549 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -502,13 +502,13 @@ void prep_transhuge_page(struct page *page)
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
-static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
+static unsigned long __thp_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size)
 {
-	unsigned long addr;
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
-	unsigned long len_pad;
+	unsigned long len_pad, ret;
 
 	if (off_end <= off_align || (off_end - off_align) < size)
 		return 0;
@@ -517,30 +517,40 @@ static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long le
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	addr = current->mm->get_unmapped_area(filp, 0, len_pad,
+	ret = current->mm->get_unmapped_area(filp, addr, len_pad,
 					      off >> PAGE_SHIFT, flags);
-	if (IS_ERR_VALUE(addr))
+
+	/*
+	 * The failure might be due to length padding. The caller will retry
+	 * without the padding.
+	 */
+	if (IS_ERR_VALUE(ret))
 		return 0;
 
-	addr += (off - addr) & (size - 1);
-	return addr;
+	/*
+	 * Do not try to align to THP boundary if allocation at the address
+	 * hint succeeds.
+	 */
+	if (ret == addr)
+		return addr;
+
+	ret += (off - ret) & (size - 1);
+	return ret;
 }
 
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
+	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	if (addr)
-		goto out;
 	if (!IS_DAX(filp->f_mapping->host) || !IS_ENABLED(CONFIG_FS_DAX_PMD))
 		goto out;
 
-	addr = __thp_get_unmapped_area(filp, len, off, flags, PMD_SIZE);
-	if (addr)
-		return addr;
-
- out:
+	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE);
+	if (ret)
+		return ret;
+out:
 	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
-- 
2.20.1



