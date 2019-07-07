Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E14616DB
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfGGTnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:43:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57510 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727592AbfGGTiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:11 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0006jD-Is; Sun, 07 Jul 2019 20:38:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005d9-A0; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Laurent Dufour" <ldufour@linux.vnet.ibm.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.923215258@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 085/129] powerpc/mm/hash: Handle mmap_min_addr
 correctly in get_unmapped_area topdown search
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 3b4d07d2674f6b4a9281031f99d1f7efd325b16d upstream.

When doing top-down search the low_limit is not PAGE_SIZE but rather
max(PAGE_SIZE, mmap_min_addr). This handle cases in which mmap_min_addr >
PAGE_SIZE.

Fixes: fba2369e6ceb ("mm: use vm_unmapped_area() on powerpc architecture")
Reviewed-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/mm/slice.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -30,6 +30,7 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
+#include <linux/security.h>
 #include <asm/mman.h>
 #include <asm/mmu.h>
 #include <asm/spu.h>
@@ -313,6 +314,7 @@ static unsigned long slice_find_area_top
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
 	unsigned long addr, found, prev;
 	struct vm_unmapped_area_info info;
+	unsigned long min_addr = max(PAGE_SIZE, mmap_min_addr);
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
@@ -320,7 +322,7 @@ static unsigned long slice_find_area_top
 	info.align_offset = 0;
 
 	addr = mm->mmap_base;
-	while (addr > PAGE_SIZE) {
+	while (addr > min_addr) {
 		info.high_limit = addr;
 		if (!slice_scan_available(addr - 1, available, 0, &addr))
 			continue;
@@ -332,8 +334,8 @@ static unsigned long slice_find_area_top
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
@@ -415,7 +417,7 @@ unsigned long slice_get_unmapped_area(un
 		addr = _ALIGN_UP(addr, 1ul << pshift);
 		slice_dbg(" aligned addr=%lx\n", addr);
 		/* Ignore hint if it's too large or overlaps a VMA */
-		if (addr > mm->task_size - len ||
+		if (addr > mm->task_size - len || addr < mmap_min_addr ||
 		    !slice_area_is_free(mm, addr, len))
 			addr = 0;
 	}

