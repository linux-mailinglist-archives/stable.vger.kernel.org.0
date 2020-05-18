Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944BA1D8086
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgERRkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbgERRkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D76B120874;
        Mon, 18 May 2020 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823610;
        bh=wu0tYu0TTHvg7GYeJXWNFmDKe2/uOXqi3m4LRTZNwUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQL7UfIJOwK+D46r8ShftT2xr21w7xmaOFuL6xvdiS9q5AvcZCA6sWXOvPCXJJXHI
         RW4XpgY2E+LCQE5QE70V3LCh9rG4Nv9IRP2Tl0c51QOYBsppXVPuMrFbTZwExNeZbo
         3jEX7iSGDO3VSylVQBfIo0AdRQ3EGh4dOOtDJIks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 49/86] mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()
Date:   Mon, 18 May 2020 19:36:20 +0200
Message-Id: <20200518173500.525311459@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit d6d8c8a48291b929b2e039f220f0b62958cccfea ]

When mainline introduced commit a96dfddbcc04 ("base/memory, hotplug: fix
a kernel oops in show_valid_zones()"), it obtained the valid start and
end pfn from the given pfn range.  The valid start pfn can fix the
actual issue, but it introduced another issue.  The valid end pfn will
may exceed the given end_pfn.

Although the incorrect overflow will not result in actual problem at
present, but I think it need to be fixed.

[toshi.kani@hpe.com: remove assumption that end_pfn is aligned by MAX_ORDER_NR_PAGES]
Fixes: a96dfddbcc04 ("base/memory, hotplug: fix a kernel oops in show_valid_zones()")
Link: http://lkml.kernel.org/r/1486467299-22648-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 804cbfe9132dd..5fa8a3606f409 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1397,7 +1397,7 @@ int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
 			while ((i < MAX_ORDER_NR_PAGES) &&
 				!pfn_valid_within(pfn + i))
 				i++;
-			if (i == MAX_ORDER_NR_PAGES)
+			if (i == MAX_ORDER_NR_PAGES || pfn + i >= end_pfn)
 				continue;
 			/* Check if we got outside of the zone */
 			if (zone && !zone_spans_pfn(zone, pfn + i))
@@ -1414,7 +1414,7 @@ int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
 
 	if (zone) {
 		*valid_start = start;
-		*valid_end = end;
+		*valid_end = min(end, end_pfn);
 		return 1;
 	} else {
 		return 0;
-- 
2.20.1



