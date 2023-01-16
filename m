Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362F566C8A4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjAPQlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbjAPQky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:40:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E85A2CC78
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A6D61077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C340C433EF;
        Mon, 16 Jan 2023 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886546;
        bh=TtP+t4juWJKc17+Jgd9Ch2vvTzR82jar4vvALKbKCVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEc/tRJ923f9FhGMC5E1RrWt+Gj03Wh1maSH8N5FMxU/CptuV832pTH2Q1m8yr2Rn
         QliRibVsO1MVHGGJY0XrPhaksxXzcMpX8P3E8wKwMVunDEvGU8WEaQlVecMA93Nvke
         4dw1SvFUltcwFddAT925PdejWgXsKI2R4Ds6ggls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        NARIBAYASHI Akira <a.naribayashi@fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 471/658] mm, compaction: fix fast_isolate_around() to stay within boundaries
Date:   Mon, 16 Jan 2023 16:49:19 +0100
Message-Id: <20230116154931.043122897@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NARIBAYASHI Akira <a.naribayashi@fujitsu.com>

commit be21b32afe470c5ae98e27e49201158a47032942 upstream.

Depending on the memory configuration, isolate_freepages_block() may scan
pages out of the target range and causes panic.

Panic can occur on systems with multiple zones in a single pageblock.

The reason it is rare is that it only happens in special
configurations.  Depending on how many similar systems there are, it
may be a good idea to fix this problem for older kernels as well.

The problem is that pfn as argument of fast_isolate_around() could be out
of the target range.  Therefore we should consider the case where pfn <
start_pfn, and also the case where end_pfn < pfn.

This problem should have been addressd by the commit 6e2b7044c199 ("mm,
compaction: make fast_isolate_freepages() stay within zone") but there was
an oversight.

 Case1: pfn < start_pfn

  <at memory compaction for node Y>
  |  node X's zone  | node Y's zone
  +-----------------+------------------------------...
   pageblock    ^   ^     ^
  +-----------+-----------+-----------+-----------+...
                ^   ^     ^
                ^   ^      end_pfn
                ^    start_pfn = cc->zone->zone_start_pfn
                 pfn
                <---------> scanned range by "Scan After"

 Case2: end_pfn < pfn

  <at memory compaction for node X>
  |  node X's zone  | node Y's zone
  +-----------------+------------------------------...
   pageblock  ^     ^   ^
  +-----------+-----------+-----------+-----------+...
              ^     ^   ^
              ^     ^    pfn
              ^      end_pfn
               start_pfn
              <---------> scanned range by "Scan Before"

It seems that there is no good reason to skip nr_isolated pages just after
given pfn.  So let perform simple scan from start to end instead of
dividing the scan into "Before" and "After".

Link: https://lkml.kernel.org/r/20221026112438.236336-1-a.naribayashi@fujitsu.com
Fixes: 6e2b7044c199 ("mm, compaction: make fast_isolate_freepages() stay within zone").
Signed-off-by: NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1219,7 +1219,7 @@ move_freelist_tail(struct list_head *fre
 }
 
 static void
-fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
+fast_isolate_around(struct compact_control *cc, unsigned long pfn)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *page = pfn_to_page(pfn);
@@ -1236,21 +1236,13 @@ fast_isolate_around(struct compact_contr
 	start_pfn = pageblock_start_pfn(pfn);
 	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone)) - 1;
 
-	/* Scan before */
-	if (start_pfn != pfn) {
-		isolate_freepages_block(cc, &start_pfn, pfn, &cc->freepages, 1, false);
-		if (cc->nr_freepages >= cc->nr_migratepages)
-			return;
-	}
-
-	/* Scan after */
-	start_pfn = pfn + nr_isolated;
-	if (start_pfn < end_pfn)
-		isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
+	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
 	if (cc->nr_freepages < cc->nr_migratepages)
 		set_pageblock_skip(page);
+
+	return;
 }
 
 /* Search orders in round-robin fashion */
@@ -1422,7 +1414,7 @@ fast_isolate_freepages(struct compact_co
 		return cc->free_pfn;
 
 	low_pfn = page_to_pfn(page);
-	fast_isolate_around(cc, low_pfn, nr_isolated);
+	fast_isolate_around(cc, low_pfn);
 	return low_pfn;
 }
 


