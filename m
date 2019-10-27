Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30BE6834
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732419AbfJ0VYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfJ0VYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:00 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E51521726;
        Sun, 27 Oct 2019 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211440;
        bh=PBAuqa8bf6EkANw75Ec/0dC2L0rQjMnIEdBZie01Rg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1quUmj5MLL7g5U7yGuCHlnbPUnO55ko3H+5bV6P3csLHHATTgnfmN5P7CR/AmBu6U
         iz6dL12ekIx+n7jE4Sp7EubJF8scCGTkG9bWeWjBxEzHVExcWXbTA+2QHSH2DRfxc8
         nGnhn+ftn2Xl01oxK4W4qAPK+HTWuEDzLFoUyoCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Adam Ford <aford173@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 152/197] mm: memblock: do not enforce current limit for memblock_phys* family
Date:   Sun, 27 Oct 2019 22:01:10 +0100
Message-Id: <20191027203359.893319012@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit f3057ad767542be7bbac44e548cb44017178a163 upstream.

Until commit 92d12f9544b7 ("memblock: refactor internal allocation
functions") the maximal address for memblock allocations was forced to
memblock.current_limit only for the allocation functions returning
virtual address.  The changes introduced by that commit moved the limit
enforcement into the allocation core and as a result the allocation
functions returning physical address also started to limit allocations
to memblock.current_limit.

This caused breakage of etnaviv GPU driver:

  etnaviv etnaviv: bound 130000.gpu (ops gpu_ops)
  etnaviv etnaviv: bound 134000.gpu (ops gpu_ops)
  etnaviv etnaviv: bound 2204000.gpu (ops gpu_ops)
  etnaviv-gpu 130000.gpu: model: GC2000, revision: 5108
  etnaviv-gpu 130000.gpu: command buffer outside valid memory window
  etnaviv-gpu 134000.gpu: model: GC320, revision: 5007
  etnaviv-gpu 134000.gpu: command buffer outside valid memory window
  etnaviv-gpu 2204000.gpu: model: GC355, revision: 1215
  etnaviv-gpu 2204000.gpu: Ignoring GPU with VG and FE2.0

Restore the behaviour of memblock_phys* family so that these functions
will not enforce memblock.current_limit.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memblock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
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


