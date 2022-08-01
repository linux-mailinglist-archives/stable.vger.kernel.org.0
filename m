Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F6F586A8E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiHAMSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiHAMRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:17:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D056E785B1;
        Mon,  1 Aug 2022 04:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E949B81163;
        Mon,  1 Aug 2022 11:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B42C433C1;
        Mon,  1 Aug 2022 11:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355149;
        bh=R8xRDyc8IDTC5wOZ0hqq+pKX1t9BRLJ7EvV+0yyX6Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZuE6Q1wasWUGZRcVG9ZnjQnehOBaU/zlrsfv7WdRINFkW4yN8o2Qtn9DTTSBxuny
         zanZQfE2UBBqA6k+pGfrfIJUMZK5bxK7Xa7jcErKTtjAmL5tNHA6sMzK5FSBxFNbvb
         DS1tYRy4q9cCGJgFNQ0dc8L/1vA2eSIh+RJwVNU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaewon Kim <jaewon31.kim@samsung.com>,
        GyeongHwan Hong <gh21.hong@samsung.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Minchan Kim <minchan@kernel.org>, Baoquan He <bhe@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Yong-Taek Lee <ytk.lee@samsung.com>, stable@vger.kerenl.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 80/88] page_alloc: fix invalid watermark check on a negative value
Date:   Mon,  1 Aug 2022 13:47:34 +0200
Message-Id: <20220801114141.657732633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaewon Kim <jaewon31.kim@samsung.com>

commit 9282012fc0aa248b77a69f5eb802b67c5a16bb13 upstream.

There was a report that a task is waiting at the
throttle_direct_reclaim. The pgscan_direct_throttle in vmstat was
increasing.

This is a bug where zone_watermark_fast returns true even when the free
is very low. The commit f27ce0e14088 ("page_alloc: consider highatomic
reserve in watermark fast") changed the watermark fast to consider
highatomic reserve. But it did not handle a negative value case which
can be happened when reserved_highatomic pageblock is bigger than the
actual free.

If watermark is considered as ok for the negative value, allocating
contexts for order-0 will consume all free pages without direct reclaim,
and finally free page may become depleted except highatomic free.

Then allocating contexts may fall into throttle_direct_reclaim. This
symptom may easily happen in a system where wmark min is low and other
reclaimers like kswapd does not make free pages quickly.

Handle the negative case by using MIN.

Link: https://lkml.kernel.org/r/20220725095212.25388-1-jaewon31.kim@samsung.com
Fixes: f27ce0e14088 ("page_alloc: consider highatomic reserve in watermark fast")
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reported-by: GyeongHwan Hong <gh21.hong@samsung.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: <stable@vger.kerenl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3953,11 +3953,15 @@ static inline bool zone_watermark_fast(s
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free;
+		long usable_free;
+		long reserved;
 
-		fast_free = free_pages;
-		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
-		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
+		usable_free = free_pages;
+		reserved = __zone_watermark_unusable_free(z, 0, alloc_flags);
+
+		/* reserved may over estimate high-atomic reserves. */
+		usable_free -= min(usable_free, reserved);
+		if (usable_free > mark + z->lowmem_reserve[highest_zoneidx])
 			return true;
 	}
 


