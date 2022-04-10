Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85014FABE5
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 06:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiDJElZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 00:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiDJElV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 00:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FBD634E;
        Sat,  9 Apr 2022 21:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2169FB80B87;
        Sun, 10 Apr 2022 04:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC07C385A5;
        Sun, 10 Apr 2022 04:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565546;
        bh=eXcEXo0mhuRisakInDEzdxM5D6U9aHrHR81T6Nsf8yk=;
        h=Date:To:From:Subject:From;
        b=BYwUGA9xFKu5a9M4t3gdBwtlfdxx2CBnTuuye7DNihdzmbkcrRdc+l35OqahvHi6b
         6JcOvX6iK+upf8Z46vvEUBzCPQ+HnzfXETrzLa0W5EHT+fBhXHgF8zXVwLwE+YCQW7
         NnMvXDrEYJz12oDnyUp7QWiGvGhW732IiLQ1uzZs=
Date:   Sat, 09 Apr 2022 21:39:06 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch removed from -mm tree
Message-Id: <20220410043906.AAC07C385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)
has been removed from the -mm tree.  Its filename was
     mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

If an mremap() syscall with old_size=0 ends up in move_page_tables(), it
will call invalidate_range_start()/invalidate_range_end() unnecessarily,
i.e.  with an empty range.

This causes a WARN in KVM's mmu_notifier.  In the past, empty ranges have
been diagnosed to be off-by-one bugs, hence the WARNing.  Given the low
(so far) number of unique reports, the benefits of detecting more buggy
callers seem to outweigh the cost of having to fix cases such as this one,
where userspace is doing something silly.  In this particular case, an
early return from move_page_tables() is enough to fix the issue.

Link: https://lkml.kernel.org/r/20220329173155.172439-1-pbonzini@redhat.com
Reported-by: syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mremap.c~mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0
+++ a/mm/mremap.c
@@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
_

Patches currently in -mm which might be from pbonzini@redhat.com are


