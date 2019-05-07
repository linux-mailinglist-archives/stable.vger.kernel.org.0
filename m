Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4931515C43
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfEGGCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfEGFfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85EB2087F;
        Tue,  7 May 2019 05:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207340;
        bh=BS8bQZGoB7uxBqsmLwt1/UFGaXwyTwZEytlGNIEdKnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTyCt+hhs6WDmtMI27GEtirrF94M2dzJBG21bV7pKRoMyZwvzfdt0IrdEKf7521xO
         LsWbUzjZ/+5pBbKmUYxrzFTErGpOfV5rvoDAtwpz+74akzA+kQa2pTXPy/IJFpOH9J
         MdZtf/xco6k/fMksoHQil6jQtOxk9plagM56F9Tg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.0 95/99] mm/page_alloc.c: avoid potential NULL pointer dereference
Date:   Tue,  7 May 2019 01:32:29 -0400
Message-Id: <20190507053235.29900-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

[ Upstream commit 8139ad043d632c0e9e12d760068a7a8e91659aa1 ]

ac.preferred_zoneref->zone passed to alloc_flags_nofragment() can be NULL.
'zone' pointer unconditionally derefernced in alloc_flags_nofragment().
Bail out on NULL zone to avoid potential crash.  Currently we don't see
any crashes only because alloc_flags_nofragment() has another bug which
allows compiler to optimize away all accesses to 'zone'.

Link: http://lkml.kernel.org/r/20190423120806.3503-1-aryabinin@virtuozzo.com
Fixes: 6bb154504f8b ("mm, page_alloc: spread allocations across zones before introducing fragmentation")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eedb57f9b40b..d59be95ba45c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3385,6 +3385,9 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 		alloc_flags |= ALLOC_KSWAPD;
 
 #ifdef CONFIG_ZONE_DMA32
+	if (!zone)
+		return alloc_flags;
+
 	if (zone_idx(zone) != ZONE_NORMAL)
 		goto out;
 
-- 
2.20.1

