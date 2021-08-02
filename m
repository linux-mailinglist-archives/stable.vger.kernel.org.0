Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC223DD8CD
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhHBNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235684AbhHBNyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58259610A2;
        Mon,  2 Aug 2021 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912347;
        bh=fqyVpTxEudKsY7rBvzaKqtJhdIPBCp0F5YsRiTxn9h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N47usxyX3ZLOY1W2t1StjwHtcKb1Jlscq/fslSYPBgyfs/MYMUiFesyg4vuiEbysY
         Zost2i1h1pRHxLWZKEFuiut08NytmE8fBlDooHQ+LWdeQ4DhEt9SfcRSDxVbmK/rZO
         pF/dHg6VxgHR7KsgJZnZJpd/2o42uztvR3TNdBLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH 5.10 19/67] alpha: register early reserved memory in memblock
Date:   Mon,  2 Aug 2021 15:44:42 +0200
Message-Id: <20210802134339.665823676@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 640b7ea5f888b521dcf28e2564ce75d08a783fd7 upstream.

The memory reserved by console/PALcode or non-volatile memory is not added
to memblock.memory.

Since commit fa3354e4ea39 (mm: free_area_init: use maximal zone PFNs rather
than zone sizes) the initialization of the memory map relies on the
accuracy of memblock.memory to properly calculate zone sizes. The holes in
memblock.memory caused by absent regions reserved by the firmware cause
incorrect initialization of struct pages which leads to BUG() during the
initial page freeing:

BUG: Bad page state in process swapper  pfn:2ffc53
page:fffffc000ecf14c0 refcount:0 mapcount:1 mapping:0000000000000000 index:0x0
flags: 0x0()
raw: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
raw: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
page dumped because: nonzero mapcount
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 5.7.0-03841-gfa3354e4ea39-dirty #26
       fffffc0001b5bd68 fffffc0001b5be80 fffffc00011cd148 fffffc000ecf14c0
       fffffc00019803df fffffc0001b5be80 fffffc00011ce340 fffffc000ecf14c0
       0000000000000000 fffffc0001b5be80 fffffc0001b482c0 fffffc00027d6618
       fffffc00027da7d0 00000000002ff97a 0000000000000000 fffffc0001b5be80
       fffffc00011d1abc fffffc000ecf14c0 fffffc0002d00000 fffffc0001b5be80
       fffffc0001b2350c 0000000000300000 fffffc0001b48298 fffffc0001b482c0
Trace:
[<fffffc00011cd148>] bad_page+0x168/0x1b0
[<fffffc00011ce340>] free_pcp_prepare+0x1e0/0x290
[<fffffc00011d1abc>] free_unref_page+0x2c/0xa0
[<fffffc00014ee5f0>] cmp_ex_sort+0x0/0x30
[<fffffc00014ee5f0>] cmp_ex_sort+0x0/0x30
[<fffffc000101001c>] _stext+0x1c/0x20

Fix this by registering the reserved ranges in memblock.memory.

Link: https://lore.kernel.org/lkml/20210726192311.uffqnanxw3ac5wwi@ivybridge
Fixes: fa3354e4ea39 ("mm: free_area_init: use maximal zone PFNs rather than zone sizes")
Reported-by: Matt Turner <mattst88@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/setup.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -325,18 +325,19 @@ setup_memory(void *kernel_end)
 		       i, cluster->usage, cluster->start_pfn,
 		       cluster->start_pfn + cluster->numpages);
 
-		/* Bit 0 is console/PALcode reserved.  Bit 1 is
-		   non-volatile memory -- we might want to mark
-		   this for later.  */
-		if (cluster->usage & 3)
-			continue;
-
 		end = cluster->start_pfn + cluster->numpages;
 		if (end > max_low_pfn)
 			max_low_pfn = end;
 
 		memblock_add(PFN_PHYS(cluster->start_pfn),
 			     cluster->numpages << PAGE_SHIFT);
+
+		/* Bit 0 is console/PALcode reserved.  Bit 1 is
+		   non-volatile memory -- we might want to mark
+		   this for later.  */
+		if (cluster->usage & 3)
+			memblock_reserve(PFN_PHYS(cluster->start_pfn),
+				         cluster->numpages << PAGE_SHIFT);
 	}
 
 	/*


