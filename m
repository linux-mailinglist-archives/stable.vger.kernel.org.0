Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB9475F13
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245706AbhLOR1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343885AbhLOR0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AC3C061784;
        Wed, 15 Dec 2021 09:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 094ECB8202B;
        Wed, 15 Dec 2021 17:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BD7C36AE0;
        Wed, 15 Dec 2021 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589146;
        bh=Xa29ZIOM+Z+Rso8lrpLwBMWzmS6bfFId4t4I64U/4yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/f86xJpKyXz1aIOozQPm4TJCu7WB+KYbELAkMnsuyo6tC2BamFGZOR7OPMYt8cyp
         wugQVGCzucCWFiuyCvwZYsAL/0U4g8eBqUHbPsEI1x/A4Fc55XPnM8vZqIyU0agcza
         AgdQ+P4E8vWlEjA3u9QRUxGTiXKbnLpM1f54Kt+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.10 29/33] memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
Date:   Wed, 15 Dec 2021 18:21:27 +0100
Message-Id: <20211215172025.789137925@linuxfoundation.org>
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

[ Upstream commit e2a86800d58639b3acde7eaeb9eb393dca066e08 ]

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
@@ -315,11 +315,11 @@ static void __init free_unused_memmap(vo
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
@@ -329,11 +329,11 @@ static void __init free_unused_memmap(vo
 			free_memmap(prev_end, start);
 
 		/*
-		 * Align up here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank end aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align up here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
-		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
+		prev_end = ALIGN(end, pageblock_nr_pages);
 	}
 
 #ifdef CONFIG_SPARSEMEM


