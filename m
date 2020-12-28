Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D115B2E6647
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393993AbgL1QLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388304AbgL1NWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F89D20728;
        Mon, 28 Dec 2020 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161743;
        bh=59psCabYTQYbmlhcuCeEd+19LfIX8yydJT3WwszLk7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTJdKzZGaHplINonPeWqz6htAaCr9OKH+TmApsqJAtiVXziYxCO37BrP1Bqq35Pii
         2qjXUadOr15femd6N92nNuXUOgnhSQxESS2x517RJLWId2jE4egG98H4Uv70wppJ93
         X8tNIxxOOTYxo4j9N38UuM01hL4z9gk2ZaCipZ2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Amit Matityahu <mitm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/346] RDMA/cm: Fix an attempt to use non-valid pointer when cleaning timewait
Date:   Mon, 28 Dec 2020 13:46:26 +0100
Message-Id: <20201228124923.039230596@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 340b940ea0ed12d9adbb8f72dea17d516b2019e8 ]

If cm_create_timewait_info() fails, the timewait_info pointer will contain
an error value and will be used in cm_remove_remote() later.

  general protection fault, probably for non-canonical address 0xdffffc0000000024: 0000 [#1] SMP KASAN PTI
  KASAN: null-ptr-deref in range [0×0000000000000120-0×0000000000000127]
  CPU: 2 PID: 12446 Comm: syz-executor.3 Not tainted 5.10.0-rc5-5d4c0742a60e #27
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:cm_remove_remote.isra.0+0x24/0×170 drivers/infiniband/core/cm.c:978
  Code: 84 00 00 00 00 00 41 54 55 53 48 89 fb 48 8d ab 2d 01 00 00 e8 7d bf 4b fe 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 48 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 fc 00 00 00
  RSP: 0018:ffff888013127918 EFLAGS: 00010006
  RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: ffffc9000a18b000
  RDX: 0000000000000024 RSI: ffffffff82edc573 RDI: fffffffffffffff4
  RBP: 0000000000000121 R08: 0000000000000001 R09: ffffed1002624f1d
  R10: 0000000000000003 R11: ffffed1002624f1c R12: ffff888107760c70
  R13: ffff888107760c40 R14: fffffffffffffff4 R15: ffff888107760c9c
  FS:  00007fe1ffcc1700(0000) GS:ffff88811a600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000001b2ff21000 CR3: 000000010f504001 CR4: 0000000000370ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   cm_destroy_id+0x189/0×15b0 drivers/infiniband/core/cm.c:1155
   cma_connect_ib drivers/infiniband/core/cma.c:4029 [inline]
   rdma_connect_locked+0x1100/0×17c0 drivers/infiniband/core/cma.c:4107
   rdma_connect+0x2a/0×40 drivers/infiniband/core/cma.c:4140
   ucma_connect+0x277/0×340 drivers/infiniband/core/ucma.c:1069
   ucma_write+0x236/0×2f0 drivers/infiniband/core/ucma.c:1724
   vfs_write+0x220/0×830 fs/read_write.c:603
   ksys_write+0x1df/0×240 fs/read_write.c:658
   do_syscall_64+0x33/0×40 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20201204064205.145795-1-leon@kernel.org
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reported-by: Amit Matityahu <mitm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4ebf63360a697..9bdb3fd97d264 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1443,6 +1443,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 							    id.local_id);
 	if (IS_ERR(cm_id_priv->timewait_info)) {
 		ret = PTR_ERR(cm_id_priv->timewait_info);
+		cm_id_priv->timewait_info = NULL;
 		goto out;
 	}
 
@@ -1969,6 +1970,7 @@ static int cm_req_handler(struct cm_work *work)
 							    id.local_id);
 	if (IS_ERR(cm_id_priv->timewait_info)) {
 		ret = PTR_ERR(cm_id_priv->timewait_info);
+		cm_id_priv->timewait_info = NULL;
 		goto destroy;
 	}
 	cm_id_priv->timewait_info->work.remote_id = req_msg->local_comm_id;
-- 
2.27.0



