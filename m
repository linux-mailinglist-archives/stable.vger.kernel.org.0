Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF5DF6F0
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbfJUUn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730155AbfJUUnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:43:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACCA2089C;
        Mon, 21 Oct 2019 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690602;
        bh=9af4H2WKz01D+6U7XawJ4WeaRG42jIajxVvou0tot4Q=;
        h=Date:From:To:Subject:From;
        b=XFjhgHkYzKj+HHJ8idYSh3+dnc62H6G3F2Oi0k34GfJ1N3b0Y2xbq4/HMp8PB2sGh
         WOHNPSfpLSR3FePnMVCtcy9q1n5E4QMi0pCjqZVkr5s/NlkOYnfKcXXqNVwMw+5EMY
         LEWXXfRsXYbs/0tOPGhld7IzHKey73hWPVRZgSiM=
Date:   Mon, 21 Oct 2019 13:43:22 -0700
From:   akpm@linux-foundation.org
To:     aford173@gmail.com, catalin.marinas@arm.com, festevam@gmail.com,
        hch@lst.de, l.stach@pengutronix.de, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org
Subject:  [merged]
 mm-memblock-do-not-enforce-current-limit-for-memblock_phys-family.patch
 removed from -mm tree
Message-ID: <20191021204322.Kcc60NDnc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memblock: do not enforce current limit for memblock_phys* family
has been removed from the -mm tree.  Its filename was
     mm-memblock-do-not-enforce-current-limit-for-memblock_phys-family.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: memblock: do not enforce current limit for memblock_phys* family

Until commit 92d12f9544b7 ("memblock: refactor internal allocation
functions") the maximal address for memblock allocations was forced to
memblock.current_limit only for the allocation functions returning virtual
address.  The changes introduced by that commit moved the limit
enforcement into the allocation core and as a result the allocation
functions returning physical address also started to limit allocations to
memblock.current_limit.

This caused breakage of etnaviv GPU driver:

[    3.682347] etnaviv etnaviv: bound 130000.gpu (ops gpu_ops)
[    3.688669] etnaviv etnaviv: bound 134000.gpu (ops gpu_ops)
[    3.695099] etnaviv etnaviv: bound 2204000.gpu (ops gpu_ops)
[    3.700800] etnaviv-gpu 130000.gpu: model: GC2000, revision: 5108
[    3.723013] etnaviv-gpu 130000.gpu: command buffer outside valid
memory window
[    3.731308] etnaviv-gpu 134000.gpu: model: GC320, revision: 5007
[    3.752437] etnaviv-gpu 134000.gpu: command buffer outside valid
memory window
[    3.760583] etnaviv-gpu 2204000.gpu: model: GC355, revision: 1215
[    3.766766] etnaviv-gpu 2204000.gpu: Ignoring GPU with VG and FE2.0

Restore the behaviour of memblock_phys* family so that these functions will
not enforce memblock.current_limit.

Link: http://lkml.kernel.org/r/1570915861-17633-1-git-send-email-rppt@kernel.org
Fixes: 92d12f9544b7 ("memblock: refactor internal allocation functions")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Adam Ford <aford173@gmail.com>
Tested-by: Adam Ford <aford173@gmail.com>	[imx6q-logicpd]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memblock.c~mm-memblock-do-not-enforce-current-limit-for-memblock_phys-family
+++ a/mm/memblock.c
@@ -1356,9 +1356,6 @@ static phys_addr_t __init memblock_alloc
 		align = SMP_CACHE_BYTES;
 	}
 
-	if (end > memblock.current_limit)
-		end = memblock.current_limit;
-
 again:
 	found = memblock_find_in_range_node(size, align, start, end, nid,
 					    flags);
@@ -1469,6 +1466,9 @@ static void * __init memblock_alloc_inte
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, nid);
 
+	if (max_addr > memblock.current_limit)
+		max_addr = memblock.current_limit;
+
 	alloc = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid);
 
 	/* retry allocation without lower limit */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


