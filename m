Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C88680243
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 23:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbjA2Wbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 17:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjA2Wbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 17:31:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520E61BACE;
        Sun, 29 Jan 2023 14:31:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9C0BB80DBE;
        Sun, 29 Jan 2023 22:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B04C433EF;
        Sun, 29 Jan 2023 22:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675031500;
        bh=1VOnSHDXide58kUAGqn4zaPQphp/QWoizDibKjpJw0k=;
        h=Date:To:From:Subject:From;
        b=0sRapblDWWbU2C4gPX298sJA9b/x5tUn3S88QiTAGoWGZOsXTZDs3hrmbkxjiiFM1
         mMhmb2jePBnC07nfVJTxyUYB7sKesY62jsMlEoSVUziRpBeCcAb8jcmpGOP0HMVMu2
         1dnwykK57Tx1yZguNSMgNKkFmcPVYGoMPvGxRdek=
Date:   Sun, 29 Jan 2023 14:31:39 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        stable@vger.kernel.org, regressions@leemhuis.info,
        pedro.falcato@gmail.com, pbonzini@redhat.com, mlevitsk@redhat.com,
        mhocko@kernel.org, mgorman@techsingularity.net,
        jirislaby@kernel.org, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch removed from -mm tree
Message-Id: <20230129223140.79B04C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm/compaction: fix set skip in fast_find_migrateblock"
has been removed from the -mm tree.  Its filename was
     revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: Revert "mm/compaction: fix set skip in fast_find_migrateblock"
Date: Fri, 13 Jan 2023 18:33:45 +0100

This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.

We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
stalling CPU for long periods of time.  Investigation of tracepoint data
shows that compaction is stuck in repeating fast_find_migrateblock() based
migrate page isolation, and then fails to migrate all isolated pages. 
Commit 7efc3b726103 ("mm/compaction: fix set skip in
fast_find_migrateblock") was suspected as it was merged in 6.1 and in
theory can indeed remove a termination condition for
fast_find_migrateblock() under certain conditions, as it removes a place
that always marks a scanned pageblock from being re-scanned.  There are
other such places, but those can be skipped under certain conditions,
which seems to match the tracepoint data.

Testing of revert also appears to have resolved the issue, thus revert the
commit until a more robust solution for the original problem is developed.

It's also likely this will fix qemu stalls with 6.1 kernel reported in
Link 2, but that is not yet confirmed.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
Link: https://lkml.kernel.org/r/20230113173345.9692-1-vbabka@suse.cz
Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock
+++ a/mm/compaction.c
@@ -1839,6 +1839,7 @@ static unsigned long fast_find_migratebl
 					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
+				set_pageblock_skip(freepage);
 				break;
 			}
 		}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch
mm-use-stack_depot_early_init-for-kmemleak-fix.patch

