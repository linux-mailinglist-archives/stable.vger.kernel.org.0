Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17C2441870
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhKAJrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234458AbhKAJpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E10AB61244;
        Mon,  1 Nov 2021 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759017;
        bh=wwMAh70eq1dnyFP5n+sCkeEe08Dsztl3oTURNq8wziA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcRtF3GLj4/iV+t/uW8PgSyHK3FV0ZCBLp4gLRRLLcgR07fKQXc5M4ytWJglRWp3K
         2+JTtmiwLuUgTu9K8DWe9Pd9i70wgVgXYxkmNaZsa/p2Qz0cPbQd6jCXGiSbPFe/1f
         s4BIlQ7WtnH3Zm/UpQuyjL6mhFeIdtGPjc6wMtZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.14 080/125] RDMA/mlx5: Initialize the ODP xarray when creating an ODP MR
Date:   Mon,  1 Nov 2021 10:17:33 +0100
Message-Id: <20211101082548.397215183@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

commit 5508546631a0f555d7088203dec2614e41b5106e upstream.

Normally the zero fill would hide the missing initialization, but an
errant set to desc_size in reg_create() causes a crash:

  BUG: unable to handle page fault for address: 0000000800000000
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  CPU: 5 PID: 890 Comm: ib_write_bw Not tainted 5.15.0-rc4+ #47
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:mlx5_ib_dereg_mr+0x14/0x3b0 [mlx5_ib]
  Code: 48 63 cd 4c 89 f7 48 89 0c 24 e8 37 30 03 e1 48 8b 0c 24 eb a0 90 0f 1f 44 00 00 41 56 41 55 41 54 55 53 48 89 fb 48 83 ec 30 <48> 8b 2f 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 8b 87 c8
  RSP: 0018:ffff88811afa3a60 EFLAGS: 00010286
  RAX: 000000000000001c RBX: 0000000800000000 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000800000000
  RBP: 0000000800000000 R08: 0000000000000000 R09: c0000000fffff7ff
  R10: ffff88811afa38f8 R11: ffff88811afa38f0 R12: ffffffffa02c7ac0
  R13: 0000000000000000 R14: ffff88811afa3cd8 R15: ffff88810772fa00
  FS:  00007f47b9080740(0000) GS:ffff88852cd40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000800000000 CR3: 000000010761e003 CR4: 0000000000370ea0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   mlx5_ib_free_odp_mr+0x95/0xc0 [mlx5_ib]
   mlx5_ib_dereg_mr+0x128/0x3b0 [mlx5_ib]
   ib_dereg_mr_user+0x45/0xb0 [ib_core]
   ? xas_load+0x8/0x80
   destroy_hw_idr_uobject+0x1a/0x50 [ib_uverbs]
   uverbs_destroy_uobject+0x2f/0x150 [ib_uverbs]
   uobj_destroy+0x3c/0x70 [ib_uverbs]
   ib_uverbs_cmd_verbs+0x467/0xb00 [ib_uverbs]
   ? uverbs_finalize_object+0x60/0x60 [ib_uverbs]
   ? ttwu_queue_wakelist+0xa9/0xe0
   ? pty_write+0x85/0x90
   ? file_tty_write.isra.33+0x214/0x330
   ? process_echoes+0x60/0x60
   ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
   __x64_sys_ioctl+0x10d/0x8e0
   ? vfs_write+0x17f/0x260
   do_syscall_64+0x3c/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Add the missing xarray initialization and remove the desc_size set.

Fixes: a639e66703ee ("RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr")
Link: https://lore.kernel.org/r/a4846a11c9de834663e521770da895007f9f0d30.1634642730.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1338,7 +1338,6 @@ static struct mlx5_ib_mr *reg_create(str
 		goto err_2;
 	}
 	mr->mmkey.type = MLX5_MKEY_MR;
-	mr->desc_size = sizeof(struct mlx5_mtt);
 	mr->umem = umem;
 	set_mr_fields(dev, mr, umem->length, access_flags);
 	kvfree(in);
@@ -1532,6 +1531,7 @@ static struct ib_mr *create_user_odp_mr(
 		ib_umem_release(&odp->umem);
 		return ERR_CAST(mr);
 	}
+	xa_init(&mr->implicit_children);
 
 	odp->private = mr;
 	err = mlx5r_store_odp_mkey(dev, &mr->mmkey);


