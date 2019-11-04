Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05FEEE15
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390111AbfKDWL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390355AbfKDWL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:27 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D6A320650;
        Mon,  4 Nov 2019 22:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905485;
        bh=/fnF9QQKMvloVp+hOX+a33YssCR2+tqJVk7XpgMm03o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClKwDdETHDdeTNiGpIv3v74HiMjbWVr73C5yrf+HfXNGZk0e++9HC5xkgam8QoZUg
         N7/DO7F3BQCe+csxm3gMTqinZCyFu1sY+PBlg3nAwStpivUUrTk6/YwyfEiy2+oZeB
         PfiBkbPQLjJMKxccltj6DCqxUUlnYi25lHOC8hQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 162/163] RDMA/mlx5: Use irq xarray locking for mkey_table
Date:   Mon,  4 Nov 2019 22:45:52 +0100
Message-Id: <20191104212152.049781479@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 1524b12a6e02a85264af4ed208b034a2239ef374 ]

The mkey_table xarray is touched by the reg_mr_callback() function which
is called from a hard irq. Thus all other uses of xa_lock must use the
_irq variants.

  WARNING: inconsistent lock state
  5.4.0-rc1 #12 Not tainted
  --------------------------------
  inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
  python3/343 [HC0[0]:SC0[0]:HE1:SE1] takes:
  ffff888182be1d40 (&(&xa->xa_lock)->rlock#3){?.-.}, at: xa_erase+0x12/0x30
  {IN-HARDIRQ-W} state was registered at:
    lock_acquire+0xe1/0x200
    _raw_spin_lock_irqsave+0x35/0x50
    reg_mr_callback+0x2dd/0x450 [mlx5_ib]
    mlx5_cmd_exec_cb_handler+0x2c/0x70 [mlx5_core]
    mlx5_cmd_comp_handler+0x355/0x840 [mlx5_core]
   [..]

   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&(&xa->xa_lock)->rlock#3);
    <Interrupt>
      lock(&(&xa->xa_lock)->rlock#3);

   *** DEADLOCK ***

  2 locks held by python3/343:
   #0: ffff88818eb4bd38 (&uverbs_dev->disassociate_srcu){....}, at: ib_uverbs_ioctl+0xe5/0x1e0 [ib_uverbs]
   #1: ffff888176c76d38 (&file->hw_destroy_rwsem){++++}, at: uobj_destroy+0x2d/0x90 [ib_uverbs]

  stack backtrace:
  CPU: 3 PID: 343 Comm: python3 Not tainted 5.4.0-rc1 #12
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  Call Trace:
   dump_stack+0x86/0xca
   print_usage_bug.cold.50+0x2e5/0x355
   mark_lock+0x871/0xb50
   ? match_held_lock+0x20/0x250
   ? check_usage_forwards+0x240/0x240
   __lock_acquire+0x7de/0x23a0
   ? __kasan_check_read+0x11/0x20
   ? mark_lock+0xae/0xb50
   ? mark_held_locks+0xb0/0xb0
   ? find_held_lock+0xca/0xf0
   lock_acquire+0xe1/0x200
   ? xa_erase+0x12/0x30
   _raw_spin_lock+0x2a/0x40
   ? xa_erase+0x12/0x30
   xa_erase+0x12/0x30
   mlx5_ib_dealloc_mw+0x55/0xa0 [mlx5_ib]
   uverbs_dealloc_mw+0x3c/0x70 [ib_uverbs]
   uverbs_free_mw+0x1a/0x20 [ib_uverbs]
   destroy_hw_idr_uobject+0x49/0xa0 [ib_uverbs]
   [..]

Fixes: 0417791536ae ("RDMA/mlx5: Add missing synchronize_srcu() for MW cases")
Link: https://lore.kernel.org/r/20191024234910.GA9038@ziepe.ca
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c15d05f61cc7b..a6198fe7f3768 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1975,8 +1975,8 @@ int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 	int err;
 
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
-		xa_erase(&dev->mdev->priv.mkey_table,
-			 mlx5_base_mkey(mmw->mmkey.key));
+		xa_erase_irq(&dev->mdev->priv.mkey_table,
+			     mlx5_base_mkey(mmw->mmkey.key));
 		/*
 		 * pagefault_single_data_segment() may be accessing mmw under
 		 * SRCU if the user bound an ODP MR to this MW.
-- 
2.20.1



