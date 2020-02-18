Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE9163273
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgBRT7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbgBRT7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89E852465D;
        Tue, 18 Feb 2020 19:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055956;
        bh=MgqphdRf6ThRbqF++Fl6m3INLYeMB7AuJmvMCqboJNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kiqk8RkEGc/zx5rkgLf1sq+Ro0c7IgmhZFG4UC3Fp9dbRQGNrOQqOyL929v4LSSiH
         1CcMKaM4AoMlwi3fHD4Cuvb+nHw0UGO2xeYxVwJmDSouHxp8gog0WM5B4YTPlCLP3h
         DSTqudQlUNOypl5K8EC8MjXrIM72q/EpHP3P3oF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 44/66] RDMA/core: Fix invalid memory access in spec_filter_size
Date:   Tue, 18 Feb 2020 20:55:11 +0100
Message-Id: <20200218190432.081398356@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avihai Horon <avihaih@mellanox.com>

commit a72f4ac1d778f7bde93dfee69bfc23377ec3d74f upstream.

Add a check that the size specified in the flow spec header doesn't cause
an overflow when calculating the filter size, and thus prevent access to
invalid memory.  The following crash from syzkaller revealed it.

  kasan: CONFIG_KASAN_INLINE enabled
  kasan: GPF could be caused by NULL-ptr deref or user memory access
  general protection fault: 0000 [#1] SMP KASAN PTI
  CPU: 1 PID: 17834 Comm: syz-executor.3 Not tainted 5.5.0-rc5 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:memchr_inv+0xd3/0x330
  Code: 89 f9 89 f5 83 e1 07 0f 85 f9 00 00 00 49 89 d5 49 c1 ed 03 45 85
  ed 74 6f 48 89 d9 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 <80> 3c 01
  00 0f 85 0d 02 00 00 44 0f b6 e5 48 b8 01 01 01 01 01 01
  RSP: 0018:ffffc9000a13fa50 EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 7fff88810de9d820 RCX: 0ffff11021bd3b04
  RDX: 000000000000fff8 RSI: 0000000000000000 RDI: 7fff88810de9d820
  RBP: 0000000000000000 R08: ffff888110d69018 R09: 0000000000000009
  R10: 0000000000000001 R11: ffffed10236267cc R12: 0000000000000004
  R13: 0000000000001fff R14: ffff88810de9d820 R15: 0000000000000040
  FS:  00007f9ee0e51700(0000) GS:ffff88811b100000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000115ea0006 CR4: 0000000000360ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   spec_filter_size.part.16+0x34/0x50
   ib_uverbs_kern_spec_to_ib_spec_filter+0x691/0x770
   ib_uverbs_ex_create_flow+0x9ea/0x1b40
   ib_uverbs_write+0xaa5/0xdf0
   __vfs_write+0x7c/0x100
   vfs_write+0x168/0x4a0
   ksys_write+0xc8/0x200
   do_syscall_64+0x9c/0x390
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x465b49
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89
  f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
  f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f9ee0e50c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000465b49
  RDX: 00000000000003a0 RSI: 00000000200007c0 RDI: 0000000000000004
  RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9ee0e516bc
  R13: 00000000004ca2da R14: 000000000070deb8 R15: 00000000ffffffff
  Modules linked in:
  Dumping ftrace buffer:
     (ftrace buffer empty)

Fixes: 94e03f11ad1f ("IB/uverbs: Add support for flow tag")
Link: https://lore.kernel.org/r/20200126171500.4623-1-leon@kernel.org
Signed-off-by: Avihai Horon <avihaih@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_cmd.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2718,12 +2718,6 @@ static int kern_spec_to_ib_spec_action(s
 	return 0;
 }
 
-static size_t kern_spec_filter_sz(const struct ib_uverbs_flow_spec_hdr *spec)
-{
-	/* Returns user space filter size, includes padding */
-	return (spec->size - sizeof(struct ib_uverbs_flow_spec_hdr)) / 2;
-}
-
 static ssize_t spec_filter_size(const void *kern_spec_filter, u16 kern_filter_size,
 				u16 ib_real_filter_sz)
 {
@@ -2867,11 +2861,16 @@ int ib_uverbs_kern_spec_to_ib_spec_filte
 static int kern_spec_to_ib_spec_filter(struct ib_uverbs_flow_spec *kern_spec,
 				       union ib_flow_spec *ib_spec)
 {
-	ssize_t kern_filter_sz;
+	size_t kern_filter_sz;
 	void *kern_spec_mask;
 	void *kern_spec_val;
 
-	kern_filter_sz = kern_spec_filter_sz(&kern_spec->hdr);
+	if (check_sub_overflow((size_t)kern_spec->hdr.size,
+			       sizeof(struct ib_uverbs_flow_spec_hdr),
+			       &kern_filter_sz))
+		return -EINVAL;
+
+	kern_filter_sz /= 2;
 
 	kern_spec_val = (void *)kern_spec +
 		sizeof(struct ib_uverbs_flow_spec_hdr);


