Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22798681102
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbjA3OJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjA3OJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16D2303E7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7450CB8117B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C1C4339E;
        Mon, 30 Jan 2023 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087767;
        bh=CoMBIWZh2nc6hmc4RpAbb0anYRiillD8eNH+xCgTBss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1baoJ5ezgy9UQo/1MH8CC0yrvENaR6nCjviIIrLGCApafbYrQt01V8Mry5B3bW1W
         vdLdZ8y7mqb6RFpJUFXMCB1vq4/SLJAtnbuUMxRTfWagXnGArLZideC3eOY0JZp0uV
         x/7XPvtv+x+CnStR2LXlVquWzdUzPDnpD94TX1Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pedro Falcato <pedro.falcato@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 303/313] Revert "mm/compaction: fix set skip in fast_find_migrateblock"
Date:   Mon, 30 Jan 2023 14:52:18 +0100
Message-Id: <20230130134350.854978519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Vlastimil Babka <vbabka@suse.cz>

commit 95e7a450b8190673675836bfef236262ceff084a upstream.

This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.

We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
stalling CPU for long periods of time.  Investigation of tracepoint data
shows that compaction is stuck in repeating fast_find_migrateblock()
based migrate page isolation, and then fails to migrate all isolated
pages.

Commit 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
was suspected as it was merged in 6.1 and in theory can indeed remove a
termination condition for fast_find_migrateblock() under certain
conditions, as it removes a place that always marks a scanned pageblock
from being re-scanned.  There are other such places, but those can be
skipped under certain conditions, which seems to match the tracepoint
data.

Testing of revert also appears to have resolved the issue, thus revert
the commit until a more robust solution for the original problem is
developed.

It's also likely this will fix qemu stalls with 6.1 kernel reported in
Link 2, but that is not yet confirmed.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
Link: https://lore.kernel.org/lkml/20230125134434.18017-1-mgorman@techsingularity.net/
Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
Cc: <stable@vger.kernel.org>
Tested-by: Pedro Falcato <pedro.falcato@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index ca1603524bbe..8238e83385a7 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1839,6 +1839,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
+				set_pageblock_skip(freepage);
 				break;
 			}
 		}
-- 
2.39.1



