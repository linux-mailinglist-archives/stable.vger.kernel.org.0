Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D7475F14
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbhLOR1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhLOR00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C83C061799;
        Wed, 15 Dec 2021 09:25:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2856661A0D;
        Wed, 15 Dec 2021 17:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B13C36AE0;
        Wed, 15 Dec 2021 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589149;
        bh=UZp9xDPSAfx+QGEPPENPRrdHJT73lpBEv2RgZs0xCXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pO92iPfe9fNUN6pWltaWsAzY7xxBR5AfTSGuo6JWgXr2/BbP9y84mRMKOzEDZ8dOm
         Q/wWTpM9cOiqKdz04dDo4j2B3tkvDzJT6AzqnLxvLM/vvUwzh9PqRcEZqValrnkSA5
         LFM3qLTvxe/0rRCQcKhJ3Svgs+d5JuExf7XhQQwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.10 30/33] memblock: align freed memory map on pageblock boundaries with SPARSEMEM
Date:   Wed, 15 Dec 2021 18:21:28 +0100
Message-Id: <20211215172025.822300554@linuxfoundation.org>
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

[ Upstream commit f921f53e089a12a192808ac4319f28727b35dc0f ]

When CONFIG_SPARSEMEM=y the ranges of the memory map that are freed are not
aligned to the pageblock boundaries which breaks assumptions about
homogeneity of the memory map throughout core mm code.

Make sure that the freed memory map is always aligned on pageblock
boundaries regardless of the memory model selection.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
[backport upstream modification in mm/memblock.c to arch/arm/mm/init.c]
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/init.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -313,14 +313,14 @@ static void __init free_unused_memmap(vo
 		 */
 		start = min(start,
 				 ALIGN(prev_end, PAGES_PER_SECTION));
-#else
+#endif
 		/*
 		 * Align down here since many operations in VM subsystem
 		 * presume that there are no holes in the memory map inside
 		 * a pageblock
 		 */
 		start = round_down(start, pageblock_nr_pages);
-#endif
+
 		/*
 		 * If we had a previous bank, and there is a space
 		 * between the current bank and the previous, free it.
@@ -337,9 +337,11 @@ static void __init free_unused_memmap(vo
 	}
 
 #ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
+	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION)) {
+		prev_end = ALIGN(end, pageblock_nr_pages);
 		free_memmap(prev_end,
 			    ALIGN(prev_end, PAGES_PER_SECTION));
+	}
 #endif
 }
 


