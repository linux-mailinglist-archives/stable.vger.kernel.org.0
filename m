Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FE5526A58
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 21:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383793AbiEMTZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 15:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383843AbiEMTYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 15:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D202C114;
        Fri, 13 May 2022 12:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B34CB8315F;
        Fri, 13 May 2022 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2079DC34113;
        Fri, 13 May 2022 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469748;
        bh=mQ3O+apPyWoj5gZuJjQIm6ocj5UmdZ9qUivZbctvqSw=;
        h=Date:To:From:Subject:From;
        b=wt3s2aKG0JS0N/z6t/NcypfyBKw9LnJnO8/gn3WUsBYiQ6bOPlI6Ir7e1AHnlLNZL
         WesbGU3agSHw0LvtAnEykTMhwyWuuER8JY4sPn+SiicBXycEj01/2/GqZusPPmxvhy
         S2NyWU0E5f5SJ5x17syBDTjIR9Y1jwUTYyXVDaww=
Date:   Fri, 13 May 2022 12:22:27 -0700
To:     mm-commits@vger.kernel.org, syzkaller@googlegroups.com,
        stable@vger.kernel.org, shakeelb@google.com, longman@redhat.com,
        edumazet@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-use-strscpy-instead-of-strlcpy.patch removed from -mm tree
Message-Id: <20220513192228.2079DC34113@smtp.kernel.org>
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
     Subject: mm/page_owner: use strscpy() instead of strlcpy()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-strscpy-instead-of-strlcpy.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/page_owner: use strscpy() instead of strlcpy()

current->comm[] is not a string (no guarantee for a zero byte in it).

strlcpy(s1, s2, l) is calling strlen(s2), potentially
causing out-of-bound access, as reported by syzbot:

detected buffer overflow in __fortify_strlen
------------[ cut here ]------------
kernel BUG at lib/string_helpers.c:980!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 4087 Comm: dhcpcd-run-hooks Not tainted 5.18.0-rc3-syzkaller-01537-g20b87e7c29df #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:fortify_panic+0x18/0x1a lib/string_helpers.c:980
Code: 8c e8 c5 ba e1 fa e9 23 0f bf fa e8 0b 5d 8c f8 eb db 55 48 89 fd e8 e0 49 40 f8 48 89 ee 48 c7 c7 80 f5 26 8a e8 99 09 f1 ff <0f> 0b e8 ca 49 40 f8 48 8b 54 24 18 4c 89 f1 48 c7 c7 00 00 27 8a
RSP: 0018:ffffc900000074a8 EFLAGS: 00010286

RAX: 000000000000002c RBX: ffff88801226b728 RCX: 0000000000000000
RDX: ffff8880198e0000 RSI: ffffffff81600458 RDI: fffff52000000e87
RBP: ffffffff89da2aa0 R08: 000000000000002c R09: 0000000000000000
R10: ffffffff815fae2e R11: 0000000000000000 R12: ffff88801226b700
R13: ffff8880198e0830 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5876ad6ff8 CR3: 000000001a48c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 <IRQ>
 __fortify_strlen include/linux/fortify-string.h:128 [inline]
 strlcpy include/linux/fortify-string.h:143 [inline]
 __set_page_owner_handle+0x2b1/0x3e0 mm/page_owner.c:171
 __set_page_owner+0x3e/0x50 mm/page_owner.c:190
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
 kmem_cache_alloc+0x360/0x3b0 mm/slub.c:3242
 dst_alloc+0x146/0x1f0 net/core/dst.c:92

Link: https://lkml.kernel.org/r/20220509145949.265184-1-eric.dumazet@gmail.com
Fixes: 865ed6a32786 ("mm/page_owner: record task command name")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-use-strscpy-instead-of-strlcpy
+++ a/mm/page_owner.c
@@ -168,7 +168,7 @@ static inline void __set_page_owner_hand
 		page_owner->pid = current->pid;
 		page_owner->tgid = current->tgid;
 		page_owner->ts_nsec = local_clock();
-		strlcpy(page_owner->comm, current->comm,
+		strscpy(page_owner->comm, current->comm,
 			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
_

Patches currently in -mm which might be from edumazet@google.com are


