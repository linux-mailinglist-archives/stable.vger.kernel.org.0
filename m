Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F412B641C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732852AbgKQNon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732839AbgKQNkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C672467A;
        Tue, 17 Nov 2020 13:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620414;
        bh=EHQecxWPq1uWQiw5Yjqw1rkWg0rgmJwKmTJ1M1SfG/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl2kbsXRKR0LRgPm9Cd7iQQgxxDu/Jf/jA+pw52lW27F5f3zIB12pRVWBpqEDhvim
         vlkpDnNXBpu/2/zd2SWXxjAz0ah6JQpDm83mA8MxLfoaxjAOMX6Y4GgdZ4XsLTVSl7
         Pg31Iv5UHyyg8uq4a4GvVMklnQH/QgLegTMA429I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Yang Shi <shy828301@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 210/255] mm/compaction: stop isolation if too many pages are isolated and we have pages to migrate
Date:   Tue, 17 Nov 2020 14:05:50 +0100
Message-Id: <20201117122149.156459162@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

commit d20bdd571ee5c9966191568527ecdb1bd4b52368 upstream.

In isolate_migratepages_block, if we have too many isolated pages and
nr_migratepages is not zero, we should try to migrate what we have
without wasting time on isolating.

In theory it's possible that multiple parallel compactions will cause
too_many_isolated() to become true even if each has isolated less than
COMPACT_CLUSTER_MAX, and loop forever in the while loop.  Bailing
immediately prevents that.

[vbabka@suse.cz: changelog addition]

Fixes: 1da2f328fa64 (“mm,thp,compaction,cma: allow THP migration for CMA allocations”)
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Yang Shi <shy828301@gmail.com>
Link: https://lkml.kernel.org/r/20201030183809.3616803-2-zi.yan@sent.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -818,6 +818,10 @@ isolate_migratepages_block(struct compac
 	 * delay for some time until fewer pages are isolated
 	 */
 	while (unlikely(too_many_isolated(pgdat))) {
+		/* stop isolation if there are still pages not migrated */
+		if (cc->nr_migratepages)
+			return 0;
+
 		/* async migration should just abort */
 		if (cc->mode == MIGRATE_ASYNC)
 			return 0;


