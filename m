Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34023D7F55
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 22:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhG0Uie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 16:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhG0Uic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 16:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FBF6056B;
        Tue, 27 Jul 2021 20:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627418312;
        bh=m4pTLRxNjQ5nrW4+WylpHblD4H7E+5v4AVz71ixTU7U=;
        h=From:To:Cc:Subject:Date:From;
        b=jFFIcxi7MiAGoX1FaofoGp1RfNm/xlAaCEtXz2oOyuj+wsOwyHZt7ziSZWTza7yVA
         yuvEvuL0XvwoePf25ipmXSDhc9RArOpGOt5oPIx8udzt71emuyQhyFp8ILQEMnYePk
         ihKjfE4b9WZab2EG3TkDTO+EokRokdHIPIy30oy1BwLm+1ITa88OmWHjZ0nnYRfHXR
         Z3OJ6vNOZSPoYjfkxd8i2NTt6yywGFWGJ48lA0To48MMezxXV2HtcvtT6gknQxWBLj
         aG9g5xniVbVSNGtbGWs7KR0iKogwE3+FRA3RZWMml3ZdcuXK6u4rLnzaycTqneD1Cb
         nh9xtn0nMtvGw==
From:   Mike Rapoport <rppt@kernel.org>
To:     Matt Turner <mattst88@gmail.com>
Cc:     Michael Cree <mcree@orcon.net.nz>, Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH] alpha: register early reserved memory in memblock
Date:   Tue, 27 Jul 2021 23:38:24 +0300
Message-Id: <20210727203824.12312-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

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
---
 arch/alpha/kernel/setup.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 7d56c217b235..b4fbbba30aa2 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -319,18 +319,19 @@ setup_memory(void *kernel_end)
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

base-commit: d8079fac168168b25677dc16c00ffaf9fb7df723
-- 
2.28.0

