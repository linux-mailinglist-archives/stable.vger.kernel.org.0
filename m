Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F62621D11
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKHTfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKHTfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:35:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B6168C6A;
        Tue,  8 Nov 2022 11:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE83BB81C1B;
        Tue,  8 Nov 2022 19:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB09C433D6;
        Tue,  8 Nov 2022 19:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667936140;
        bh=QGd06ysZZxhN5y9mk6QjHvflnc8VFOAkEOJIwzSTRJI=;
        h=Date:To:From:Subject:From;
        b=NxBOd+GilG/GPQK8Rb+tfX1xtQdg4CENhd3iJms91HbIhDa9yu4NKe/2HwNCReN95
         TZr03k/7JDhKlAPLhozPR1mvsFaL3SuecLqt2EM9U/MadQiGptea20vipT41IIyx0M
         b5PcAtQzlaij7ByCMIipvfQ+veMfkeSlWE0eP1JQ=
Date:   Tue, 08 Nov 2022 11:35:39 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stable@vger.kernel.org, mhocko@suse.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-dont-warn-if-the-node-is-offlined.patch removed from -mm tree
Message-Id: <20221108193540.5DB09C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: don't warn if the node is offlined
has been removed from the -mm tree.  Its filename was
     mm-dont-warn-if-the-node-is-offlined.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: don't warn if the node is offlined
Date: Mon, 31 Oct 2022 11:31:22 -0700

Syzbot reported the below splat:

WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221 __alloc_pages_node include/linux/gfp.h:221 [inline]
WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221 hpage_collapse_alloc_page mm/khugepaged.c:807 [inline]
WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221 alloc_charge_hpage+0x802/0xaa0 mm/khugepaged.c:963
Modules linked in:
CPU: 1 PID: 3646 Comm: syz-executor210 Not tainted 6.1.0-rc1-syzkaller-00454-ga70385240892 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:__alloc_pages_node include/linux/gfp.h:221 [inline]
RIP: 0010:hpage_collapse_alloc_page mm/khugepaged.c:807 [inline]
RIP: 0010:alloc_charge_hpage+0x802/0xaa0 mm/khugepaged.c:963
Code: e5 01 4c 89 ee e8 6e f9 ae ff 4d 85 ed 0f 84 28 fc ff ff e8 70 fc ae ff 48 8d 6b ff 4c 8d 63 07 e9 16 fc ff ff e8 5e fc ae ff <0f> 0b e9 96 fa ff ff 41 bc 1a 00 00 00 e9 86 fd ff ff e8 47 fc ae
RSP: 0018:ffffc90003fdf7d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888077f457c0 RSI: ffffffff81cd8f42 RDI: 0000000000000001
RBP: ffff888079388c0c R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6b48ccf700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6b48a819f0 CR3: 00000000171e7000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 collapse_file+0x1ca/0x5780 mm/khugepaged.c:1715
 hpage_collapse_scan_file+0xd6c/0x17a0 mm/khugepaged.c:2156
 madvise_collapse+0x53a/0xb40 mm/khugepaged.c:2611
 madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1066
 madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1240
 do_madvise.part.0+0x24a/0x340 mm/madvise.c:1419
 do_madvise mm/madvise.c:1432 [inline]
 __do_sys_madvise mm/madvise.c:1432 [inline]
 __se_sys_madvise mm/madvise.c:1430 [inline]
 __x64_sys_madvise+0x113/0x150 mm/madvise.c:1430
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6b48a4eef9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6b48ccf318 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f6b48af0048 RCX: 00007f6b48a4eef9
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
RBP: 00007f6b48af0040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6b48aa53a4
R13: 00007f6b48bffcbf R14: 00007f6b48ccf400 R15: 0000000000022000
 </TASK>

WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221 __alloc_pages_node
include/linux/gfp.h:221 [inline]
WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221
hpage_collapse_alloc_page mm/khugepaged.c:807 [inline]
WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221
alloc_charge_hpage+0x802/0xaa0 mm/khugepaged.c:963
Modules linked in:
CPU: 1 PID: 3646 Comm: syz-executor210 Not tainted
6.1.0-rc1-syzkaller-00454-ga70385240892 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 10/11/2022
RIP: 0010:__alloc_pages_node include/linux/gfp.h:221 [inline]
RIP: 0010:hpage_collapse_alloc_page mm/khugepaged.c:807 [inline]
RIP: 0010:alloc_charge_hpage+0x802/0xaa0 mm/khugepaged.c:963
Code: e5 01 4c 89 ee e8 6e f9 ae ff 4d 85 ed 0f 84 28 fc ff ff e8 70 fc
ae ff 48 8d 6b ff 4c 8d 63 07 e9 16 fc ff ff e8 5e fc ae ff <0f> 0b e9
96 fa ff ff 41 bc 1a 00 00 00 e9 86 fd ff ff e8 47 fc ae
RSP: 0018:ffffc90003fdf7d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888077f457c0 RSI: ffffffff81cd8f42 RDI: 0000000000000001
RBP: ffff888079388c0c R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6b48ccf700(0000) GS:ffff8880b9b00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6b48a819f0 CR3: 00000000171e7000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 collapse_file+0x1ca/0x5780 mm/khugepaged.c:1715
 hpage_collapse_scan_file+0xd6c/0x17a0 mm/khugepaged.c:2156
 madvise_collapse+0x53a/0xb40 mm/khugepaged.c:2611
 madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1066
 madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1240
 do_madvise.part.0+0x24a/0x340 mm/madvise.c:1419
 do_madvise mm/madvise.c:1432 [inline]
 __do_sys_madvise mm/madvise.c:1432 [inline]
 __se_sys_madvise mm/madvise.c:1430 [inline]
 __x64_sys_madvise+0x113/0x150 mm/madvise.c:1430
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6b48a4eef9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 15 00 00 90 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6b48ccf318 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f6b48af0048 RCX: 00007f6b48a4eef9
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
RBP: 00007f6b48af0040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6b48aa53a4
R13: 00007f6b48bffcbf R14: 00007f6b48ccf400 R15: 0000000000022000
 </TASK>

It is because khugepaged allocates pages with __GFP_THISNODE, but the
preferred node is offlined.  The warning was even stronger before commit
8addc2d00fe17 ("mm: do not warn on offline nodes unless the specific node
is explicitly requested").  The commit softened the warning for
__GFP_THISNODE.

But this warning seems not quite useful because:
  * There is no guarantee the node is online for __GFP_THISNODE context
    for all the callsites.
  * Kernel just fails the allocation regardless the warning, and it looks
    all callsites handle the allocation failure gracefully.

So, removing the warning seems like the good move.

Link: https://lkml.kernel.org/r/20221031183122.470962-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: syzbot+0044b22d177870ee974f@syzkaller.appspotmail.com
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/gfp.h~mm-dont-warn-if-the-node-is-offlined
+++ a/include/linux/gfp.h
@@ -218,7 +218,6 @@ static inline struct page *
 __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));
 
 	return __alloc_pages(gfp_mask, order, nid, NULL);
 }
@@ -227,7 +226,6 @@ static inline
 struct folio *__folio_alloc_node(gfp_t gfp, unsigned int order, int nid)
 {
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	VM_WARN_ON((gfp & __GFP_THISNODE) && !node_online(nid));
 
 	return __folio_alloc(gfp, order, nid, NULL);
 }
_

Patches currently in -mm which might be from shy828301@gmail.com are


