Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112AD3F7C9B
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 21:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhHYTSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 15:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhHYTSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Aug 2021 15:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF4BE60EAF;
        Wed, 25 Aug 2021 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629919076;
        bh=9eKVWYxZZwTl0suLazziuyIoja5ndJharWDLiFA0Ob0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zrka7NY7T3o4zSnZpv/rQA/yMEwda7j6ZdxeUV8aHfCnQpHe8XGLTghTc3Q9jY+0E
         20Ez6N1By6iAb6+FSr9BFb+QEpd7zihpqwWnLWvPtt6kqqe594+oqwfsMwsJo1QUWo
         dQSkVFADAKy8v3HVkwRC6bZVs9K7gT5QY9Ss2+VM=
Date:   Wed, 25 Aug 2021 12:17:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cgoldswo@codeaurora.org,
        david@redhat.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 1/2] mm/memory_hotplug: fix potential permanent
 lru cache disable
Message-ID: <20210825191755.q1BM2fgnb%akpm@linux-foundation.org>
In-Reply-To: <20210825121725.0b4f7ca217e22d9750bc6a6d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: fix potential permanent lru cache disable

If offline_pages failed after lru_cache_disable(), it forgot to do
lru_cache_enable() in error path.  So we would have lru cache disabled
permanently in this case.

Link: https://lkml.kernel.org/r/20210821094246.10149-3-linmiaohe@huawei.com
Fixes: d479960e44f2 ("mm: disable LRU pagevec during the migration temporarily")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-potential-permanent-lru-cache-disable
+++ a/mm/memory_hotplug.c
@@ -1731,6 +1731,7 @@ failed_removal_isolated:
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
+	lru_cache_enable();
 	zone_pcp_enable(zone);
 failed_removal:
 	pr_debug("memory offlining [mem %#010llx-%#010llx] failed due to %s\n",
_
