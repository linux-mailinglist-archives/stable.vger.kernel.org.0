Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED88766A922
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 05:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjANELX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 23:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjANELU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 23:11:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2976797;
        Fri, 13 Jan 2023 20:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87BAD600E1;
        Sat, 14 Jan 2023 04:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B372AC43392;
        Sat, 14 Jan 2023 04:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669477;
        bh=svvecmSBQB3NYQN2JoKDtzN4cHQuA1l/Zz1iGDPyI6A=;
        h=Date:To:From:Subject:From;
        b=YdpZTV2rg9obXE6c0MWCR2RjyHsYqlgXbwp9dyZRoVPnSUoO8FO9B3IFDl7Q1NYP4
         2glrI4lZqLuzOH2+N6dJMg1gTO931d5cFuQtXsbcDcHRue/tUcIOaPfI+nBqwjUFZb
         xUL3fQ84gInmJcLUE3NpE1KR1i6n5vWRzCiUDxLM=
Date:   Fri, 13 Jan 2023 20:11:17 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        stable@vger.kernel.org, regressions@leemhuis.info,
        pbonzini@redhat.com, mlevitsk@redhat.com, mhocko@kernel.org,
        mgorman@techsingularity.net, jirislaby@kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch added to mm-hotfixes-unstable branch
Message-Id: <20230114041117.B372AC43392@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm/compaction: fix set skip in fast_find_migrateblock"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
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

revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

