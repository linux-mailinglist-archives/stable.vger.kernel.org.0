Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A82475F12
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbhLOR1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47020 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343870AbhLOR0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DB54619C9;
        Wed, 15 Dec 2021 17:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF60C36AE2;
        Wed, 15 Dec 2021 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589177;
        bh=fAE9/ddDMcBj5ODExvjdGpl9n7pr4qdE04SoHfwEi6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Klk1TP5O/FPPSF402hKLotoPKlfZDvg+ZROuxkVKRDxbe21I7hbzxOF+BPYszBECC
         jRbVMI8Ml//ILfBmphtoAcJ2dgx18YDBoELVT7rwZYyr9U5SrwcPd4u+LXnO102S9M
         2XHXM3gjm6FFH2PtLPM0wW+OLDKgdgBvuUyaiBlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.4 14/18] memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
Date:   Wed, 15 Dec 2021 18:21:35 +0100
Message-Id: <20211215172023.296167632@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit e2a86800d58639b3acde7eaeb9eb393dca066e08 upstream.

The code that frees unused memory map uses rounds start and end of the
holes that are freed to MAX_ORDER_NR_PAGES to preserve continuity of the
memory map for MAX_ORDER regions.

Lots of core memory management functionality relies on homogeneity of the
memory map within each pageblock which size may differ from MAX_ORDER in
certain configurations.

Although currently, for the architectures that use free_unused_memmap(),
pageblock_order and MAX_ORDER are equivalent, it is cleaner to have common
notation thought mm code.

Replace MAX_ORDER_NR_PAGES with pageblock_nr_pages and update the comments
to make it more clear why the alignment to pageblock boundaries is
required.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
[backport upstream modification in mm/memblock.c to arch/arm/mm/init.c]
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/init.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -373,11 +373,11 @@ static void __init free_unused_memmap(vo
 				 ALIGN(prev_end, PAGES_PER_SECTION));
 #else
 		/*
-		 * Align down here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank start aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align down here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
-		start = round_down(start, MAX_ORDER_NR_PAGES);
+		start = round_down(start, pageblock_nr_pages);
 #endif
 		/*
 		 * If we had a previous bank, and there is a space
@@ -387,12 +387,12 @@ static void __init free_unused_memmap(vo
 			free_memmap(prev_end, start);
 
 		/*
-		 * Align up here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank end aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align up here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
 		prev_end = ALIGN(memblock_region_memory_end_pfn(reg),
-				 MAX_ORDER_NR_PAGES);
+				 pageblock_nr_pages);
 	}
 
 #ifdef CONFIG_SPARSEMEM


