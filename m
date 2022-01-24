Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC72449A512
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370583AbiAYAFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850695AbiAXXah (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:30:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C815EC0AD1AF;
        Mon, 24 Jan 2022 13:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65DB4614CB;
        Mon, 24 Jan 2022 21:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765A0C340E4;
        Mon, 24 Jan 2022 21:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060100;
        bh=Y3b/AAusapEvGqBUnrjEZn2kCsA/rAJP2AKEvANrqow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zve/PpyJAOaHE0zIjdDplWV/Wj4t36U4Tz9hf/Tx+ygX+8/1ZaJryE1cq0LSYbe4I
         ViGtOkmwp5kd7dUfY43pffbMeFHj79RcKjVV5BhZ9ophpQ6YK3ftBnbhzgMeMiTHIT
         5Da9xoGAMSoLvx/E0hKrBKV6ZJcuUFklYWS0dJSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Wandun <chenwandun@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0832/1039] mm/page_isolation: unset migratetype directly for non Buddy page
Date:   Mon, 24 Jan 2022 19:43:41 +0100
Message-Id: <20220124184153.249107968@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>

[ Upstream commit 721fb891ad0b3956d5c168b2931e3e5e4fb7ca40 ]

In unset_migratetype_isolate(), we can bypass the call to
move_freepages_block() for non-buddy pages.

It will save a few cpu cycles for some situations such as cma and
hugetlb when allocating continue pages, in these situation function
alloc_contig_pages will be called.

alloc_contig_pages
	__alloc_contig_migrate_range
	isolate_freepages_range ==> pages has been remove from buddy
	undo_isolate_page_range
		unset_migratetype_isolate ==> can directly set migratetype

[osalvador@suse.de: changelog tweak]

Link: https://lkml.kernel.org/r/20211229033649.2760586-1-chenwandun@huawei.com
Fixes: 3c605096d315 ("mm/page_alloc: restrict max order of merging on isolated pageblock")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f67c4c70f17f6..6a0ddda6b3c53 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -115,7 +115,7 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 	 * onlining - just onlined memory won't immediately be considered for
 	 * allocation.
 	 */
-	if (!isolated_page) {
+	if (!isolated_page && PageBuddy(page)) {
 		nr_pages = move_freepages_block(zone, page, migratetype, NULL);
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
-- 
2.34.1



