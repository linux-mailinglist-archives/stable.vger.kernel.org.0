Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06441A50E2
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgDKMVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbgDKMVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:21:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC3120692;
        Sat, 11 Apr 2020 12:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607702;
        bh=WAx9wpGx097PHlOi1iR1fM2hZ06Y9lST3LGU68w8ky4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIDmAsGU8+9Fu+GH3lVYhTncQSTaLsRZcwpCMoleDe1KrDHyhbt2y6d9lUZESyHOh
         1C7A+9umfeeCeGY40QNf81BGF9MgTZisOFgT5nd61TrKRl3Mzpu/T8UTgiOElT6AVI
         5vJo4b6b41MxF/Le5n4z8JT84oiamaUcg5lSGfCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.6 34/38] RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow
Date:   Sat, 11 Apr 2020 14:10:11 +0200
Message-Id: <20200411115503.275531544@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115459.324496182@linuxfoundation.org>
References: <20200411115459.324496182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avihai Horon <avihaih@mellanox.com>

commit 987914ab841e2ec281a35b54348ab109b4c0bb4e upstream.

After a successful allocation of path_rec, num_paths is set to 1, but any
error after such allocation will leave num_paths uncleared.

This causes to de-referencing a NULL pointer later on. Hence, num_paths
needs to be set back to 0 if such an error occurs.

The following crash from syzkaller revealed it.

  kasan: CONFIG_KASAN_INLINE enabled
  kasan: GPF could be caused by NULL-ptr deref or user memory access
  general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
  CPU: 0 PID: 357 Comm: syz-executor060 Not tainted 4.18.0+ #311
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
  RIP: 0010:ib_copy_path_rec_to_user+0x94/0x3e0
  Code: f1 f1 f1 f1 c7 40 0c 00 00 f4 f4 65 48 8b 04 25 28 00 00 00 48 89
  45 c8 31 c0 e8 d7 60 24 ff 48 8d 7b 4c 48 89 f8 48 c1 e8 03 <42> 0f b6
  14 30 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85
  RSP: 0018:ffff88006586f980 EFLAGS: 00010207
  RAX: 0000000000000009 RBX: 0000000000000000 RCX: 1ffff1000d5fe475
  RDX: ffff8800621e17c0 RSI: ffffffff820d45f9 RDI: 000000000000004c
  RBP: ffff88006586fa50 R08: ffffed000cb0df73 R09: ffffed000cb0df72
  R10: ffff88006586fa70 R11: ffffed000cb0df73 R12: 1ffff1000cb0df30
  R13: ffff88006586fae8 R14: dffffc0000000000 R15: ffff88006aff2200
  FS: 00000000016fc880(0000) GS:ffff88006d000000(0000)
  knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000020000040 CR3: 0000000063fec000 CR4: 00000000000006b0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
  ? ib_copy_path_rec_from_user+0xcc0/0xcc0
  ? __mutex_unlock_slowpath+0xfc/0x670
  ? wait_for_completion+0x3b0/0x3b0
  ? ucma_query_route+0x818/0xc60
  ucma_query_route+0x818/0xc60
  ? ucma_listen+0x1b0/0x1b0
  ? sched_clock_cpu+0x18/0x1d0
  ? sched_clock_cpu+0x18/0x1d0
  ? ucma_listen+0x1b0/0x1b0
  ? ucma_write+0x292/0x460
  ucma_write+0x292/0x460
  ? ucma_close_id+0x60/0x60
  ? sched_clock_cpu+0x18/0x1d0
  ? sched_clock_cpu+0x18/0x1d0
  __vfs_write+0xf7/0x620
  ? ucma_close_id+0x60/0x60
  ? kernel_read+0x110/0x110
  ? time_hardirqs_on+0x19/0x580
  ? lock_acquire+0x18b/0x3a0
  ? finish_task_switch+0xf3/0x5d0
  ? _raw_spin_unlock_irq+0x29/0x40
  ? _raw_spin_unlock_irq+0x29/0x40
  ? finish_task_switch+0x1be/0x5d0
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  ? security_file_permission+0x172/0x1e0
  vfs_write+0x192/0x460
  ksys_write+0xc6/0x1a0
  ? __ia32_sys_read+0xb0/0xb0
  ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
  ? do_syscall_64+0x1d/0x470
  do_syscall_64+0x9e/0x470
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
Link: https://lore.kernel.org/r/20200318101741.47211-1-leon@kernel.org
Signed-off-by: Avihai Horon <avihaih@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2968,6 +2968,7 @@ static int cma_resolve_iboe_route(struct
 err2:
 	kfree(route->path_rec);
 	route->path_rec = NULL;
+	route->num_paths = 0;
 err1:
 	kfree(work);
 	return ret;


