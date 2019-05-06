Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D4E14DC7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfEFOq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbfEFOq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D659221019;
        Mon,  6 May 2019 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153988;
        bh=tkZNyjCJmEXNeB56U5CbHmUrYxxIezFMwWCZ4Upz2Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuJwF64tkxPNgZTKaFyV5+mHpo68z9f6iZCWOyGW7Wioc7uveKqT9rkQRlUma+o4j
         WnakuWYkYRXP2Wve0kWN0eL8KzydKcCTgrIXdshzYwraEa9HVwbmo9E7hvaYylnbZR
         hbSqIc4teGTUqV036gD2WS04u+zwNzhijgo+XudY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 71/75] powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area topdown search
Date:   Mon,  6 May 2019 16:33:19 +0200
Message-Id: <20190506143059.702895487@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 3b4d07d2674f6b4a9281031f99d1f7efd325b16d upstream.

When doing top-down search the low_limit is not PAGE_SIZE but rather
max(PAGE_SIZE, mmap_min_addr). This handle cases in which mmap_min_addr >
PAGE_SIZE.

Fixes: fba2369e6ceb ("mm: use vm_unmapped_area() on powerpc architecture")
Reviewed-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/slice.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/export.h>
 #include <linux/hugetlb.h>
+#include <linux/security.h>
 #include <asm/mman.h>
 #include <asm/mmu.h>
 #include <asm/copro.h>
@@ -328,6 +329,7 @@ static unsigned long slice_find_area_top
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
 	unsigned long addr, found, prev;
 	struct vm_unmapped_area_info info;
+	unsigned long min_addr = max(PAGE_SIZE, mmap_min_addr);
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
@@ -344,7 +346,7 @@ static unsigned long slice_find_area_top
 	if (high_limit  > DEFAULT_MAP_WINDOW)
 		addr += mm->context.addr_limit - DEFAULT_MAP_WINDOW;
 
-	while (addr > PAGE_SIZE) {
+	while (addr > min_addr) {
 		info.high_limit = addr;
 		if (!slice_scan_available(addr - 1, available, 0, &addr))
 			continue;
@@ -356,8 +358,8 @@ static unsigned long slice_find_area_top
 		 * Check if we need to reduce the range, or if we can
 		 * extend it to cover the previous available slice.
 		 */
-		if (addr < PAGE_SIZE)
-			addr = PAGE_SIZE;
+		if (addr < min_addr)
+			addr = min_addr;
 		else if (slice_scan_available(addr - 1, available, 0, &prev)) {
 			addr = prev;
 			goto prev_slice;
@@ -479,7 +481,7 @@ unsigned long slice_get_unmapped_area(un
 		addr = _ALIGN_UP(addr, page_size);
 		slice_dbg(" aligned addr=%lx\n", addr);
 		/* Ignore hint if it's too large or overlaps a VMA */
-		if (addr > high_limit - len ||
+		if (addr > high_limit - len || addr < mmap_min_addr ||
 		    !slice_area_is_free(mm, addr, len))
 			addr = 0;
 	}


