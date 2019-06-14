Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94BC467AE
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfFNSlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 14:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNSlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 14:41:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FEC2183E;
        Fri, 14 Jun 2019 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560537708;
        bh=P7i4HwlRR+8GVQPj6JHIVwkQHZsHPKKnCTb3fBwcuKc=;
        h=Date:From:To:Subject:From;
        b=H/s8yIP2Wtmo7lJEyqn7mKCuwHtLTLcSmAtEX6SABXVGc7eLsVCuHJx5YA8b1wxDS
         maX4Ko4kBeSqw424OCDfvNeoF35I8N68B/nOY4wMazwJ+sOmG8vdQEFHkB+/JOXFWt
         wM5vRaK01/vNdSzBfUb0duD//Wt+NzoepIrUeGsc=
Date:   Fri, 14 Jun 2019 11:41:48 -0700
From:   akpm@linux-foundation.org
To:     ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org
Subject:  [merged]
 list_lru-fix-memory-leak-in-__memcg_init_list_lru_node.patch removed from
 -mm tree
Message-ID: <20190614184148.xbqMtqpIO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node
has been removed from the -mm tree.  Its filename was
     list_lru-fix-memory-leak-in-__memcg_init_list_lru_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Syzbot reported following memory leak:

ffffffffda RBX: 0000000000000003 RCX: 0000000000441f79
BUG: memory leak
unreferenced object 0xffff888114f26040 (size 32):
  comm "syz-executor626", pid 7056, jiffies 4294948701 (age 39.410s)
  hex dump (first 32 bytes):
    40 60 f2 14 81 88 ff ff 40 60 f2 14 81 88 ff ff  @`......@`......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000018f36b56>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<0000000018f36b56>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<0000000018f36b56>] slab_alloc mm/slab.c:3326 [inline]
    [<0000000018f36b56>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<0000000055b9a1a5>] kmalloc include/linux/slab.h:547 [inline]
    [<0000000055b9a1a5>] __memcg_init_list_lru_node+0x58/0xf0 mm/list_lru.c:352
    [<000000001356631d>] memcg_init_list_lru_node mm/list_lru.c:375 [inline]
    [<000000001356631d>] memcg_init_list_lru mm/list_lru.c:459 [inline]
    [<000000001356631d>] __list_lru_init+0x193/0x2a0 mm/list_lru.c:626
    [<00000000ce062da3>] alloc_super+0x2e0/0x310 fs/super.c:269
    [<000000009023adcf>] sget_userns+0x94/0x2a0 fs/super.c:609
    [<0000000052182cd8>] sget+0x8d/0xb0 fs/super.c:660
    [<0000000006c24238>] mount_nodev+0x31/0xb0 fs/super.c:1387
    [<0000000006016a76>] fuse_mount+0x2d/0x40 fs/fuse/inode.c:1236
    [<000000009a61ec1d>] legacy_get_tree+0x27/0x80 fs/fs_context.c:661
    [<0000000096cd9ef8>] vfs_get_tree+0x2e/0x120 fs/super.c:1476
    [<000000005b8f472d>] do_new_mount fs/namespace.c:2790 [inline]
    [<000000005b8f472d>] do_mount+0x932/0xc50 fs/namespace.c:3110
    [<00000000afb009b4>] ksys_mount+0xab/0x120 fs/namespace.c:3319
    [<0000000018f8c8ee>] __do_sys_mount fs/namespace.c:3333 [inline]
    [<0000000018f8c8ee>] __se_sys_mount fs/namespace.c:3330 [inline]
    [<0000000018f8c8ee>] __x64_sys_mount+0x26/0x30 fs/namespace.c:3330
    [<00000000f42066da>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<0000000043d74ca0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is a simple off by one bug on the error path.

Link: http://lkml.kernel.org/r/20190528043202.99980-1-shakeelb@google.com
Fixes: 60d3fd32a7a9 ("list_lru: introduce per-memcg lists")
Reported-by: syzbot+f90a420dfe2b1b03cb2c@syzkaller.appspotmail.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~list_lru-fix-memory-leak-in-__memcg_init_list_lru_node
+++ a/mm/list_lru.c
@@ -354,7 +354,7 @@ static int __memcg_init_list_lru_node(st
 	}
 	return 0;
 fail:
-	__memcg_destroy_list_lru_node(memcg_lrus, begin, i - 1);
+	__memcg_destroy_list_lru_node(memcg_lrus, begin, i);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-oom-no-oom-kill-for-__gfp_retry_mayfail.patch
memcg-fsnotify-no-oom-kill-for-remote-memcg-charging.patch
mm-memcg-introduce-memoryeventslocal.patch

