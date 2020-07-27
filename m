Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C249122F026
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbgG0OWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbgG0OWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41AA2070A;
        Mon, 27 Jul 2020 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859735;
        bh=zRyeNmoL3wHIHCpZmIbNx0rdAsjMnQGiXt97sJtg14w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yl7mdC1cZNyQYYaJdojpqQezHcpQcf/pC2fsE+IMv54dxUx89fB7kpsLr/qlsjVgJ
         btwV7T/EmZ8kNsUA711MpJV4OP+52/rzJBuLjrPx6vuMtdLVrDv1+XEbxvQ7QZ71cj
         /4cA0YBVr5NibZ8FtX9DASvALbi3xCL57UeNddjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 054/179] RDMA/core: Fix race in rdma_alloc_commit_uobject()
Date:   Mon, 27 Jul 2020 16:03:49 +0200
Message-Id: <20200727134935.301622638@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 0d1fd39bb27e479fb1de3dd4b4c247c7c9a1fabf ]

The FD should not be installed until all of the setup is completed as the
fd_install() transfers ownership of the kref to the FD table. A thread can
race a close() and trigger concurrent rdma_alloc_commit_uobject() and
uverbs_uobject_fd_release() which, at least, triggers a safety WARN_ON:

  WARNING: CPU: 4 PID: 6913 at drivers/infiniband/core/rdma_core.c:768 uverbs_uobject_fd_release+0x202/0x230
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 4 PID: 6913 Comm: syz-executor.3 Not tainted 5.7.0-rc2 #22
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  [..]
  RIP: 0010:uverbs_uobject_fd_release+0x202/0x230
  Code: fe 4c 89 e7 e8 af 23 fe ff e9 2a ff ff ff e8 c5 fa 61 fe be 03 00 00 00 4c 89 e7 e8 68 eb f5 fe e9 13 ff ff ff e8 ae fa 61 fe <0f> 0b eb ac e8 e5 aa 3c fe e8 50 2b 86 fe e9 6a fe ff ff e8 46 2b
  RSP: 0018:ffffc90008117d88 EFLAGS: 00010293
  RAX: ffff88810e146580 RBX: 1ffff92001022fb1 RCX: ffffffff82d5b902
  RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88811951b040
  RBP: ffff88811951b000 R08: ffffed10232a3609 R09: ffffed10232a3609
  R10: ffff88811951b043 R11: 0000000000000001 R12: ffff888100a7c600
  R13: ffff888100a7c650 R14: ffffc90008117da8 R15: ffffffff82d5b700
   ? __uverbs_cleanup_ufile+0x270/0x270
   ? uverbs_uobject_fd_release+0x202/0x230
   ? uverbs_uobject_fd_release+0x202/0x230
   ? __uverbs_cleanup_ufile+0x270/0x270
   ? locks_remove_file+0x282/0x3d0
   ? security_file_free+0xaa/0xd0
   __fput+0x2be/0x770
   task_work_run+0x10e/0x1b0
   exit_to_usermode_loop+0x145/0x170
   do_syscall_64+0x2d0/0x390
   ? prepare_exit_to_usermode+0x17a/0x230
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x414da7
  Code: 00 00 0f 05 48 3d 00 f0 ff ff 77 3f f3 c3 0f 1f 44 00 00 53 89 fb 48 83 ec 10 e8 f4 fb ff ff 89 df 89 c2 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2b 89 d7 89 44 24 0c e8 36 fc ff ff 8b 44 24
  RSP: 002b:00007fff39d379d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
  RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000414da7
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
  RBP: 00007fff39d37a3c R08: 0000000400000000 R09: 0000000400000000
  R10: 00007fff39d37910 R11: 0000000000000293 R12: 0000000000000001
  R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000003

Reorder so that fd_install() is the last thing done in
rdma_alloc_commit_uobject().

Fixes: aba94548c9e4 ("IB/uverbs: Move the FD uobj type struct file allocation to alloc_commit")
Link: https://lore.kernel.org/r/20200716102059.1420681-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 75bcbc625616e..3ab84fcbaadec 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -638,9 +638,6 @@ void rdma_alloc_commit_uobject(struct ib_uobject *uobj,
 {
 	struct ib_uverbs_file *ufile = attrs->ufile;
 
-	/* alloc_commit consumes the uobj kref */
-	uobj->uapi_object->type_class->alloc_commit(uobj);
-
 	/* kref is held so long as the uobj is on the uobj list. */
 	uverbs_uobject_get(uobj);
 	spin_lock_irq(&ufile->uobjects_lock);
@@ -650,6 +647,9 @@ void rdma_alloc_commit_uobject(struct ib_uobject *uobj,
 	/* matches atomic_set(-1) in alloc_uobj */
 	atomic_set(&uobj->usecnt, 0);
 
+	/* alloc_commit consumes the uobj kref */
+	uobj->uapi_object->type_class->alloc_commit(uobj);
+
 	/* Matches the down_read in rdma_alloc_begin_uobject */
 	up_read(&ufile->hw_destroy_rwsem);
 }
-- 
2.25.1



