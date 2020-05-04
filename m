Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F991C4516
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbgEDSCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731331AbgEDSC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789D520721;
        Mon,  4 May 2020 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615347;
        bh=m6cHdPt4j0P794LQ+Ga018Senh7BkBzJn9+92reSMgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCiyhipg1iox4+zby3IIPo/tSo3TMusc5AHJWczgTIJD3RA7ZvuP0hBAnTHQqmscx
         iI4utxwD4Hh0T2sD5lbzp4eEa/mNY0oVkUTfCY7sRPWRGK+kjlM+2CyXVmttJh9Yb+
         wxLkylB/vBDHHLsVI/yroZwmxkpkXmRJ/ylGLG+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 4.19 19/37] RDMA/core: Prevent mixed use of FDs between shared ufiles
Date:   Mon,  4 May 2020 19:57:32 +0200
Message-Id: <20200504165450.411778103@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit 0fb00941dc63990a10951146df216fc7b0e20bc2 upstream.

FDs can only be used on the ufile that created them, they cannot be mixed
to other ufiles. We are lacking a check to prevent it.

  BUG: KASAN: null-ptr-deref in atomic64_sub_and_test include/asm-generic/atomic-instrumented.h:1547 [inline]
  BUG: KASAN: null-ptr-deref in atomic_long_sub_and_test include/asm-generic/atomic-long.h:460 [inline]
  BUG: KASAN: null-ptr-deref in fput_many+0x1a/0x140 fs/file_table.c:336
  Write of size 8 at addr 0000000000000038 by task syz-executor179/284

  CPU: 0 PID: 284 Comm: syz-executor179 Not tainted 5.5.0-rc5+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x94/0xce lib/dump_stack.c:118
   __kasan_report+0x18f/0x1b7 mm/kasan/report.c:510
   kasan_report+0xe/0x20 mm/kasan/common.c:639
   check_memory_region_inline mm/kasan/generic.c:185 [inline]
   check_memory_region+0x15d/0x1b0 mm/kasan/generic.c:192
   atomic64_sub_and_test include/asm-generic/atomic-instrumented.h:1547 [inline]
   atomic_long_sub_and_test include/asm-generic/atomic-long.h:460 [inline]
   fput_many+0x1a/0x140 fs/file_table.c:336
   rdma_lookup_put_uobject+0x85/0x130 drivers/infiniband/core/rdma_core.c:692
   uobj_put_read include/rdma/uverbs_std_types.h:96 [inline]
   _ib_uverbs_lookup_comp_file drivers/infiniband/core/uverbs_cmd.c:198 [inline]
   create_cq+0x375/0xba0 drivers/infiniband/core/uverbs_cmd.c:1006
   ib_uverbs_create_cq+0x114/0x140 drivers/infiniband/core/uverbs_cmd.c:1089
   ib_uverbs_write+0xaa5/0xdf0 drivers/infiniband/core/uverbs_main.c:769
   __vfs_write+0x7c/0x100 fs/read_write.c:494
   vfs_write+0x168/0x4a0 fs/read_write.c:558
   ksys_write+0xc8/0x200 fs/read_write.c:611
   do_syscall_64+0x9c/0x390 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x44ef99
  Code: 00 b8 00 01 00 00 eb e1 e8 74 1c 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007ffc0b74c028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 00007ffc0b74c030 RCX: 000000000044ef99
  RDX: 0000000000000040 RSI: 0000000020000040 RDI: 0000000000000005
  RBP: 00007ffc0b74c038 R08: 0000000000401830 R09: 0000000000401830
  R10: 00007ffc0b74c038 R11: 0000000000000246 R12: 0000000000000000
  R13: 0000000000000000 R14: 00000000006be018 R15: 0000000000000000

Fixes: cf8966b3477d ("IB/core: Add support for fd objects")
Link: https://lore.kernel.org/r/20200421082929.311931-2-leon@kernel.org
Suggested-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/rdma_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -381,7 +381,7 @@ lookup_get_fd_uobject(const struct uverb
 	 * and the caller is expected to ensure that uverbs_close_fd is never
 	 * done while a call top lookup is possible.
 	 */
-	if (f->f_op != fd_type->fops) {
+	if (f->f_op != fd_type->fops || uobject->ufile != ufile) {
 		fput(f);
 		return ERR_PTR(-EBADF);
 	}


