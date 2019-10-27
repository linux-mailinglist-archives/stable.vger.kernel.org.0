Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80F6E6833
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbfJ0VXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732371AbfJ0VXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:52 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA9921726;
        Sun, 27 Oct 2019 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211431;
        bh=QTc0j71iag6ZSm7a9ZVdtJ4mG3TfhcPEhYId6nEPt3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQaZCiOrrmJ4AwsJuHXz7rox4v6yBr/HHdokBobEApuBATseh7nc3Jf1X8CigerAq
         JibgEYyUjZFmZVtkBmY4zX185b3KGfSX2VJUpvaql/vyHQaAf+jdKSoEY4OD3lnoxS
         ZmwYUcV8/IgRTraaeUqO/TcZDBoPWNmXJBhTubE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dave Chinner <david@fromorbit.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 150/197] mm, compaction: fix wrong pfn handling in __reset_isolation_pfn()
Date:   Sun, 27 Oct 2019 22:01:08 +0100
Message-Id: <20191027203359.790853283@linuxfoundation.org>
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

From: Vlastimil Babka <vbabka@suse.cz>

commit a2e9a5afce080226edbf1882d63d99bf32070e9e upstream.

Florian and Dave reported [1] a NULL pointer dereference in
__reset_isolation_pfn().  While the exact cause is unclear, staring at
the code revealed two bugs, which might be related.

One bug is that if zone starts in the middle of pageblock, block_page
might correspond to different pfn than block_pfn, and then the
pfn_valid_within() checks will check different pfn's than those accessed
via struct page.  This might result in acessing an unitialized page in
CONFIG_HOLES_IN_ZONE configs.

The other bug is that end_page refers to the first page of next
pageblock and not last page of current pageblock.  The online and valid
check is then wrong and with sections, the while (page < end_page) loop
might wander off actual struct page arrays.

[1] https://lore.kernel.org/linux-xfs/87o8z1fvqu.fsf@mid.deneb.enyo.de/

Link: http://lkml.kernel.org/r/20191008152915.24704-1-vbabka@suse.cz
Fixes: 6b0868c820ff ("mm/compaction.c: correct zone boundary handling when resetting pageblock skip hints")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Florian Weimer <fw@deneb.enyo.de>
Reported-by: Dave Chinner <david@fromorbit.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -270,14 +270,15 @@ __reset_isolation_pfn(struct zone *zone,
 
 	/* Ensure the start of the pageblock or zone is online and valid */
 	block_pfn = pageblock_start_pfn(pfn);
-	block_page = pfn_to_online_page(max(block_pfn, zone->zone_start_pfn));
+	block_pfn = max(block_pfn, zone->zone_start_pfn);
+	block_page = pfn_to_online_page(block_pfn);
 	if (block_page) {
 		page = block_page;
 		pfn = block_pfn;
 	}
 
 	/* Ensure the end of the pageblock or zone is online and valid */
-	block_pfn += pageblock_nr_pages;
+	block_pfn = pageblock_end_pfn(pfn) - 1;
 	block_pfn = min(block_pfn, zone_end_pfn(zone) - 1);
 	end_page = pfn_to_online_page(block_pfn);
 	if (!end_page)
@@ -303,7 +304,7 @@ __reset_isolation_pfn(struct zone *zone,
 
 		page += (1 << PAGE_ALLOC_COSTLY_ORDER);
 		pfn += (1 << PAGE_ALLOC_COSTLY_ORDER);
-	} while (page < end_page);
+	} while (page <= end_page);
 
 	return false;
 }


