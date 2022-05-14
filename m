Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD15273D6
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 21:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiENT4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 15:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiENTzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 15:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DC0377F9;
        Sat, 14 May 2022 12:55:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD21BB80B05;
        Sat, 14 May 2022 19:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBC5C340EE;
        Sat, 14 May 2022 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558128;
        bh=768L2okMHovk3QS5/VQ1udhDvYDydu/ER5HnELywfe4=;
        h=Date:To:From:Subject:From;
        b=bCKJ8kgSJZrwdahyvzyW5bgYOSUdOclyMvPo7KhmlLDKGFI5aPLDyjhodZR82Unse
         c2JfJuP+y6jUGllEiRSqx6EJqQKhyrlZ42B1sm67iRMXFYwavvxy1Q2t37HsRKtxcO
         O8/v3+KtfarVH34NgxnIqg6zaz/YBrpMLeyrlD9A=
Date:   Sat, 14 May 2022 12:55:27 -0700
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        stable@vger.kernel.org, osalvador@suse.de,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        ddutile@redhat.com, yamamoto.rei@jp.fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone.patch removed from -mm tree
Message-Id: <20220514195528.4EBC5C340EE@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: fast_find_migrateblock() should return pfn in the target zone
has been removed from the -mm tree.  Its filename was
     mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Subject: mm, compaction: fast_find_migrateblock() should return pfn in the target zone

At present, pages not in the target zone are added to cc->migratepages
list in isolate_migratepages_block().  As a result, pages may migrate
between nodes unintentionally.

This would be a serious problem for older kernels without commit
a984226f457f849e ("mm: memcontrol: remove the pgdata parameter of
mem_cgroup_page_lruvec"), because it can corrupt the lru list by
handling pages in list without holding proper lru_lock.

Avoid returning a pfn outside the target zone in the case that it is
not aligned with a pageblock boundary.  Otherwise
isolate_migratepages_block() will handle pages not in the target zone.

Link: https://lkml.kernel.org/r/20220511044300.4069-1-yamamoto.rei@jp.fujitsu.com
Fixes: 70b44595eafe ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone
+++ a/mm/compaction.c
@@ -1848,6 +1848,8 @@ static unsigned long fast_find_migratebl
 
 				update_fast_start_pfn(cc, free_pfn);
 				pfn = pageblock_start_pfn(free_pfn);
+				if (pfn < cc->zone->zone_start_pfn)
+					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
 				set_pageblock_skip(freepage);
_

Patches currently in -mm which might be from yamamoto.rei@jp.fujitsu.com are


