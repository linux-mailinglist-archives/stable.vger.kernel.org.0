Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22E81EAC7F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgFASha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730821AbgFASP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D4D22068D;
        Mon,  1 Jun 2020 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035325;
        bh=au9jBL/z5kPeR07FL83D/w4WoL1STfzZW1aw4fFg0+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRTRY+cpwGFm0+hGjxlsAKDlJsofVaXIAUnURzms95zxdD/3FXYpUR9v/cBk8bPt3
         mklP8JGb6/d3e5ARp8Q3tJrXPac0UDr1Z9K/dwj344Sj+CE8StWFeyf4pNSGylMVOa
         dn6UcQe9QjZ0UAyWpVTeEfaaZzuiGnb/MomTOeBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 109/177] RDMA/mlx5: Fix NULL pointer dereference in destroy_prefetch_work
Date:   Mon,  1 Jun 2020 19:54:07 +0200
Message-Id: <20200601174057.702183031@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 189277f3814c36133f4ff0352f4b5194a38486b6 ]

q_deferred_work isn't initialized when creating an explicit ODP memory
region. This can lead to a NULL pointer dereference when user performs
asynchronous prefetch MR. Fix it by initializing q_deferred_work for
explicit ODP.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  CPU: 4 PID: 6074 Comm: kworker/u16:6 Not tainted 5.7.0-rc1-for-upstream-perf-2020-04-17_07-03-39-64 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  Workqueue: events_unbound mlx5_ib_prefetch_mr_work [mlx5_ib]
  RIP: 0010:__wake_up_common+0x49/0x120
  Code: 04 89 54 24 0c 89 4c 24 08 74 0a 41 f6 01 04 0f 85 8e 00 00 00 48 8b 47 08 48 83 e8 18 4c 8d 67 08 48 8d 50 18 49 39 d4 74 66 <48> 8b 70 18 31 db 4c 8d 7e e8 eb 17 49 8b 47 18 48 8d 50 e8 49 8d
  RSP: 0000:ffffc9000097bd88 EFLAGS: 00010082
  RAX: ffffffffffffffe8 RBX: ffff888454cd9f90 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff888454cd9f90
  RBP: ffffc9000097bdd0 R08: 0000000000000000 R09: ffffc9000097bdd0
  R10: 0000000000000000 R11: 0000000000000001 R12: ffff888454cd9f98
  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
  FS:  0000000000000000(0000) GS:ffff88846fd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000044c19e002 CR4: 0000000000760ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   __wake_up_common_lock+0x7a/0xc0
   destroy_prefetch_work+0x5a/0x60 [mlx5_ib]
   mlx5_ib_prefetch_mr_work+0x64/0x80 [mlx5_ib]
   process_one_work+0x15b/0x360
   worker_thread+0x49/0x3d0
   kthread+0xf5/0x130
   ? rescuer_thread+0x310/0x310
   ? kthread_bind+0x10/0x10
   ret_from_fork+0x1f/0x30

Fixes: de5ed007a03d ("IB/mlx5: Fix implicit ODP race")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200521072504.567406-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6fa0a83c19de..9a1747a97fb6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1319,6 +1319,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	if (is_odp_mr(mr)) {
 		to_ib_umem_odp(mr->umem)->private = mr;
+		init_waitqueue_head(&mr->q_deferred_work);
 		atomic_set(&mr->num_deferred_work, 0);
 		err = xa_err(xa_store(&dev->odp_mkeys,
 				      mlx5_base_mkey(mr->mmkey.key), &mr->mmkey,
-- 
2.25.1



