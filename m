Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742E21C9039
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEGO1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgEGO1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E82C2083B;
        Thu,  7 May 2020 14:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861666;
        bh=o+1OCCbzGALcl/wimdQ4aevRKtMRAcGqoaKmYjo2eCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLjXGq3nwq6jNRJY+MSyLIyb1/l8YoMSoq77+oLiTFlBh3Iqqmo0+Y92wtGTxg3nn
         Ilt0iLa1tTjpIuKQ+F9QSYUylTjsEyScfSvfHrSOc03Z5rXs/mISKGJrz+mrEmBmrx
         1aE5dQHkY8/VJQdp+/xSjf9k++To6RHmibJ8b2pI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 15/50] RDMA/core: Fix overwriting of uobj in case of error
Date:   Thu,  7 May 2020 10:26:51 -0400
Message-Id: <20200507142726.25751-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 83a2670212215a569ed133efc10c92055c96cc8c ]

In case of failure to get file, the uobj is overwritten and causes to
supply bad pointer as an input to uverbs_uobject_put().

  BUG: KASAN: null-ptr-deref in atomic_fetch_sub include/asm-generic/atomic-instrumented.h:199 [inline]
  BUG: KASAN: null-ptr-deref in refcount_sub_and_test include/linux/refcount.h:253 [inline]
  BUG: KASAN: null-ptr-deref in refcount_dec_and_test include/linux/refcount.h:281 [inline]
  BUG: KASAN: null-ptr-deref in kref_put include/linux/kref.h:64 [inline]
  BUG: KASAN: null-ptr-deref in uverbs_uobject_put+0x22/0x90 drivers/infiniband/core/rdma_core.c:57
  Write of size 4 at addr 0000000000000030 by task syz-executor.4/1691

  CPU: 1 PID: 1691 Comm: syz-executor.4 Not tainted 5.6.0 #17
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x94/0xce lib/dump_stack.c:118
   __kasan_report+0x10c/0x190 mm/kasan/report.c:515
   kasan_report+0x32/0x50 mm/kasan/common.c:625
   check_memory_region_inline mm/kasan/generic.c:187 [inline]
   check_memory_region+0x16d/0x1c0 mm/kasan/generic.c:193
   atomic_fetch_sub include/asm-generic/atomic-instrumented.h:199 [inline]
   refcount_sub_and_test include/linux/refcount.h:253 [inline]
   refcount_dec_and_test include/linux/refcount.h:281 [inline]
   kref_put include/linux/kref.h:64 [inline]
   uverbs_uobject_put+0x22/0x90 drivers/infiniband/core/rdma_core.c:57
   alloc_begin_fd_uobject+0x1d0/0x250 drivers/infiniband/core/rdma_core.c:486
   rdma_alloc_begin_uobject+0xa8/0xf0 drivers/infiniband/core/rdma_core.c:509
   __uobj_alloc include/rdma/uverbs_std_types.h:117 [inline]
   ib_uverbs_create_comp_channel+0x16d/0x230 drivers/infiniband/core/uverbs_cmd.c:982
   ib_uverbs_write+0xaa5/0xdf0 drivers/infiniband/core/uverbs_main.c:665
   __vfs_write+0x7c/0x100 fs/read_write.c:494
   vfs_write+0x168/0x4a0 fs/read_write.c:558
   ksys_write+0xc8/0x200 fs/read_write.c:611
   do_syscall_64+0x9c/0x390 arch/x86/entry/common.c:295
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x466479
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007efe9f6a7c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000466479
  RDX: 0000000000000018 RSI: 0000000020000040 RDI: 0000000000000003
  RBP: 00007efe9f6a86bc R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
  R13: 0000000000000bf2 R14: 00000000004cb80a R15: 00000000006fefc0

Fixes: 849e149063bd ("RDMA/core: Do not allow alloc_commit to fail")
Link: https://lore.kernel.org/r/20200421082929.311931-3-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 8f480de5596a2..2947f4f83561d 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -474,16 +474,15 @@ alloc_begin_fd_uobject(const struct uverbs_api_object *obj,
 	filp = anon_inode_getfile(fd_type->name, fd_type->fops, NULL,
 				  fd_type->flags);
 	if (IS_ERR(filp)) {
+		uverbs_uobject_put(uobj);
 		uobj = ERR_CAST(filp);
-		goto err_uobj;
+		goto err_fd;
 	}
 	uobj->object = filp;
 
 	uobj->id = new_fd;
 	return uobj;
 
-err_uobj:
-	uverbs_uobject_put(uobj);
 err_fd:
 	put_unused_fd(new_fd);
 	return uobj;
-- 
2.20.1

