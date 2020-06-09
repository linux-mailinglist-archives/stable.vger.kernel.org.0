Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160E31F2BC0
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbgFIASe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730649AbgFHXSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02CAE20885;
        Mon,  8 Jun 2020 23:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658312;
        bh=au9jBL/z5kPeR07FL83D/w4WoL1STfzZW1aw4fFg0+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8ggSl+y1f3OOnOI7Lps8/s71lqeEhkn0U2fYASu7+0fMtF2v6d5w0iJebCo8J0BP
         ZyJ3W6XGQjfmjPv/clG6nw6jP9PKEx6Ajkrn9OYf9i4uHmXegkHRraG7iRv+caoZww
         QBQRJuk3TfHfZH8eJBQXCCA3rkO6xZff1RkF4O7Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 313/606] RDMA/mlx5: Fix NULL pointer dereference in destroy_prefetch_work
Date:   Mon,  8 Jun 2020 19:07:18 -0400
Message-Id: <20200608231211.3363633-313-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

