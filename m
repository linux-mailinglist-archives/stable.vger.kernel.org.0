Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D25475F1F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbhLOR1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbhLOR0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B925C07E5DC;
        Wed, 15 Dec 2021 09:25:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C4FDB82048;
        Wed, 15 Dec 2021 17:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0430C36AE2;
        Wed, 15 Dec 2021 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589155;
        bh=EqvERww/BhaFO8YwmR4L98PI41/pt+NmCmNRM0huSQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMq+WTnIwnk04mlZjznTERJb439tRwzBo8M+L/WxrO3CPvR1cKh/iiItamD4/kGD7
         ifR9zagFUdUNP7rQULlpnMs1UlY8ied6Ge5ynmIVAC5nw5aMhdhW+rbqtSeo0kbBPF
         fwaicDNgWlUO5esYWi/6bbMGW9OuMOa7YyFM8lIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.10 32/33] arm: extend pfn_valid to take into account freed memory map alignment
Date:   Wed, 15 Dec 2021 18:21:30 +0100
Message-Id: <20211215172025.908681012@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit a4d5613c4dc6d413e0733e37db9d116a2a36b9f3 ]

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
@@ -125,11 +125,22 @@ static void __init zone_sizes_init(unsig
 int pfn_valid(unsigned long pfn)
 {
 	phys_addr_t addr = __pfn_to_phys(pfn);
+	unsigned long pageblock_size = PAGE_SIZE * pageblock_nr_pages;
 
 	if (__phys_to_pfn(addr) != pfn)
 		return 0;
 
-	return memblock_is_map_memory(addr);
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


