Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1784D818F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiCNLmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbiCNLmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:42:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F28048E4A;
        Mon, 14 Mar 2022 04:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B00F8B80DC5;
        Mon, 14 Mar 2022 11:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235C9C340ED;
        Mon, 14 Mar 2022 11:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257991;
        bh=B1z0Mk94B58dvtoO7oaPtiKJAWq3VcQAheMFkCCZn2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggMy4RYbwaghHjh9kSOTMV5JCMzbcVbMDD8XEsFACwfYQK8a6XzyGCLHfbuC8qM4b
         DIZnd+5uPx6A5Cas5NcePRAq6QYfh+ZK9s1i9fOdrtZzkT0jSEPUOeDuVUFZYf4FTd
         ZyHHniWs4toRqhEugejI0hv/tFG78EmxxfMUNiLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Denis Efremov <denis.e.efremov@oracle.com>
Subject: [PATCH 4.19 27/30] btrfs: unlock newly allocated extent buffer after error
Date:   Mon, 14 Mar 2022 12:34:45 +0100
Message-Id: <20220314112732.559680874@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 19ea40dddf1833db868533958ca066f368862211 upstream.

[BUG]
There is a bug report that injected ENOMEM error could leave a tree
block locked while we return to user-space:

  BTRFS info (device loop0): enabling ssd optimizations
  FAULT_INJECTION: forcing a failure.
  name failslab, interval 1, probability 0, space 0, times 0
  CPU: 0 PID: 7579 Comm: syz-executor Not tainted 5.15.0-rc1 #16
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
  Call Trace:
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:106
   fail_dump lib/fault-inject.c:52 [inline]
   should_fail+0x13c/0x160 lib/fault-inject.c:146
   should_failslab+0x5/0x10 mm/slab_common.c:1328
   slab_pre_alloc_hook.constprop.99+0x4e/0xc0 mm/slab.h:494
   slab_alloc_node mm/slub.c:3120 [inline]
   slab_alloc mm/slub.c:3214 [inline]
   kmem_cache_alloc+0x44/0x280 mm/slub.c:3219
   btrfs_alloc_delayed_extent_op fs/btrfs/delayed-ref.h:299 [inline]
   btrfs_alloc_tree_block+0x38c/0x670 fs/btrfs/extent-tree.c:4833
   __btrfs_cow_block+0x16f/0x7d0 fs/btrfs/ctree.c:415
   btrfs_cow_block+0x12a/0x300 fs/btrfs/ctree.c:570
   btrfs_search_slot+0x6b0/0xee0 fs/btrfs/ctree.c:1768
   btrfs_insert_empty_items+0x80/0xf0 fs/btrfs/ctree.c:3905
   btrfs_new_inode+0x311/0xa60 fs/btrfs/inode.c:6530
   btrfs_create+0x12b/0x270 fs/btrfs/inode.c:6783
   lookup_open+0x660/0x780 fs/namei.c:3282
   open_last_lookups fs/namei.c:3352 [inline]
   path_openat+0x465/0xe20 fs/namei.c:3557
   do_filp_open+0xe3/0x170 fs/namei.c:3588
   do_sys_openat2+0x357/0x4a0 fs/open.c:1200
   do_sys_open+0x87/0xd0 fs/open.c:1216
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x46ae99
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
  89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
  01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f46711b9c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
  RAX: ffffffffffffffda RBX: 000000000078c0a0 RCX: 000000000046ae99
  RDX: 0000000000000000 RSI: 00000000000000a1 RDI: 0000000020005800
  RBP: 00007f46711b9c80 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000017
  R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007ffc129da6e0

  ================================================
  WARNING: lock held when returning to user space!
  5.15.0-rc1 #16 Not tainted
  ------------------------------------------------
  syz-executor/7579 is leaving the kernel with locks still held!
  1 lock held by syz-executor/7579:
   #0: ffff888104b73da8 (btrfs-tree-01/1){+.+.}-{3:3}, at:
  __btrfs_tree_lock+0x2e/0x1a0 fs/btrfs/locking.c:112

[CAUSE]
In btrfs_alloc_tree_block(), after btrfs_init_new_buffer(), the new
extent buffer @buf is locked, but if later operations like adding
delayed tree ref fail, we just free @buf without unlocking it,
resulting above warning.

[FIX]
Unlock @buf in out_free_buf: label.

Reported-by: Hao Sun <sunhao.th@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CACkBjsZ9O6Zr0KK1yGn=1rQi6Crh1yeCRdTSBxx9R99L4xdn-Q@mail.gmail.com/
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8327,6 +8327,7 @@ struct extent_buffer *btrfs_alloc_tree_b
 out_free_delayed:
 	btrfs_free_delayed_extent_op(extent_op);
 out_free_buf:
+	btrfs_tree_unlock(buf);
 	free_extent_buffer(buf);
 out_free_reserved:
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 0);


