Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC3493EF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfFQVYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfFQVYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4402070B;
        Mon, 17 Jun 2019 21:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806661;
        bh=ZaxbKxuDo9b9NHacMWb7xXuPgMvT1zufacV2xQ1U+U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc5sxgnixpK96YkPh0j8snPf56LipipkEGZUQIjX49CLmWNOnZx55s3SyqT6ft4eS
         NkOVwqxm9t/RQ52mZbKHqgL6Ecp2fLKEDHTRDohlG6m431K+gVlRzQmW7K0PxC81cV
         Sp/Br7D2RMbkXEcbF5+ymRS3Tbkc7q7TbNV6+TNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f90a420dfe2b1b03cb2c@syzkaller.appspotmail.com,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 14/75] mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node
Date:   Mon, 17 Jun 2019 23:09:25 +0200
Message-Id: <20190617210753.425090475@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit 3510955b327176fd4cbab5baa75b449f077722a2 upstream.

Syzbot reported following memory leak:

ffffffffda RBX: 0000000000000003 RCX: 0000000000441f79
BUG: memory leak
unreferenced object 0xffff888114f26040 (size 32):
  comm "syz-executor626", pid 7056, jiffies 4294948701 (age 39.410s)
  hex dump (first 32 bytes):
    40 60 f2 14 81 88 ff ff 40 60 f2 14 81 88 ff ff  @`......@`......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
     slab_post_alloc_hook mm/slab.h:439 [inline]
     slab_alloc mm/slab.c:3326 [inline]
     kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     kmalloc include/linux/slab.h:547 [inline]
     __memcg_init_list_lru_node+0x58/0xf0 mm/list_lru.c:352
     memcg_init_list_lru_node mm/list_lru.c:375 [inline]
     memcg_init_list_lru mm/list_lru.c:459 [inline]
     __list_lru_init+0x193/0x2a0 mm/list_lru.c:626
     alloc_super+0x2e0/0x310 fs/super.c:269
     sget_userns+0x94/0x2a0 fs/super.c:609
     sget+0x8d/0xb0 fs/super.c:660
     mount_nodev+0x31/0xb0 fs/super.c:1387
     fuse_mount+0x2d/0x40 fs/fuse/inode.c:1236
     legacy_get_tree+0x27/0x80 fs/fs_context.c:661
     vfs_get_tree+0x2e/0x120 fs/super.c:1476
     do_new_mount fs/namespace.c:2790 [inline]
     do_mount+0x932/0xc50 fs/namespace.c:3110
     ksys_mount+0xab/0x120 fs/namespace.c:3319
     __do_sys_mount fs/namespace.c:3333 [inline]
     __se_sys_mount fs/namespace.c:3330 [inline]
     __x64_sys_mount+0x26/0x30 fs/namespace.c:3330
     do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is a simple off by one bug on the error path.

Link: http://lkml.kernel.org/r/20190528043202.99980-1-shakeelb@google.com
Fixes: 60d3fd32a7a9 ("list_lru: introduce per-memcg lists")
Reported-by: syzbot+f90a420dfe2b1b03cb2c@syzkaller.appspotmail.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -353,7 +353,7 @@ static int __memcg_init_list_lru_node(st
 	}
 	return 0;
 fail:
-	__memcg_destroy_list_lru_node(memcg_lrus, begin, i - 1);
+	__memcg_destroy_list_lru_node(memcg_lrus, begin, i);
 	return -ENOMEM;
 }
 


