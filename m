Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A757475F34
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343956AbhLOR2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344115AbhLOR1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:27:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F8C061223;
        Wed, 15 Dec 2021 09:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8697E61A1E;
        Wed, 15 Dec 2021 17:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676C7C36AE0;
        Wed, 15 Dec 2021 17:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589186;
        bh=sJ41gabWO8bBl42PJ5QxtocqtbnYycvo0KydMNJ5724=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM7gUgrPA7eR6oj4cF9LEiIs+VRKJtsDgLGpr6npP5xZbhfxZz9W2ocyqp5eTTMx3
         wcZiMNJx/icgQL9dcvJIX3Nb3CV0w2xMftGYiJGxcmEGXw6x68/qKSyo7yTOfyBCvJ
         UJlxAo6p72WFqv8C7rKss8ALZNkAb+9NCUo6CITE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.4 17/18] arm: extend pfn_valid to take into account freed memory map alignment
Date:   Wed, 15 Dec 2021 18:21:38 +0100
Message-Id: <20211215172023.403037125@linuxfoundation.org>
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

commit a4d5613c4dc6d413e0733e37db9d116a2a36b9f3 upstream.

When unused memory map is freed the preserved part of the memory map is
extended to match pageblock boundaries because lots of core mm
functionality relies on homogeneity of the memory map within pageblock
boundaries.

Since pfn_valid() is used to check whether there is a valid memory map
entry for a PFN, make it return true also for PFNs that have memory map
entries even if there is no actual memory populated there.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/init.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -176,11 +176,22 @@ static void __init zone_sizes_init(unsig
 int pfn_valid(unsigned long pfn)
 {
 	phys_addr_t addr = __pfn_to_phys(pfn);
+	unsigned long pageblock_size = PAGE_SIZE * pageblock_nr_pages;
 
 	if (__phys_to_pfn(addr) != pfn)
 		return 0;
 
-	return memblock_is_map_memory(__pfn_to_phys(pfn));
+	/*
+	 * If address less than pageblock_size bytes away from a present
+	 * memory chunk there still will be a memory map entry for it
+	 * because we round freed memory map to the pageblock boundaries.
+	 */
+	if (memblock_overlaps_region(&memblock.memory,
+				     ALIGN_DOWN(addr, pageblock_size),
+				     pageblock_size))
+		return 1;
+
+	return 0;
 }
 EXPORT_SYMBOL(pfn_valid);
 #endif


