Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9E922F126
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbgG0OWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbgG0OWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43EED20775;
        Mon, 27 Jul 2020 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859737;
        bh=1jTd4mP9Kp0Q+Ra+NKGh9D3DRYxacAOgHWvixrj71Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtdPh3YpEQk20SaorRAHFt521QJ5c47qv0ZlcBKV2h5RG4kk5Bd4OMFf+Bm5p7g6C
         +03i+8ze3BGjPSGZ/I/skuNb4D0dWgNLiGEGMNcGkaIZpuLVZla6raCdwmmupa6f8e
         dhDPghE9drhyjNWRzOOT6P2MZ48xwzgtiy4aHKGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 055/179] RDMA/cm: Protect access to remote_sidr_table
Date:   Mon, 27 Jul 2020 16:03:50 +0200
Message-Id: <20200727134935.350953965@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 87c4c774cbef5c68b3df96827c2fb07f1aa80152 ]

cm.lock must be held while accessing remote_sidr_table. This fixes the
below NULL pointer dereference.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP PTI
  CPU: 2 PID: 7288 Comm: udaddy Not tainted 5.7.0_for_upstream_perf_2020_06_09_15_14_20_38 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:rb_erase+0x10d/0x360
  Code: 00 00 00 48 89 c1 48 89 d0 48 8b 50 08 48 39 ca 74 48 f6 02 01 75 af 48 8b 7a 10 48 89 c1 48 83 c9 01 48 89 78 08 48 89 42 10 <48> 89 0f 48 8b 08 48 89 0a 48 83 e1 fc 48 89 10 0f 84 b1 00 00 00
  RSP: 0018:ffffc90000f77c30 EFLAGS: 00010086
  RAX: ffff8883df27d458 RBX: ffff8883df27da58 RCX: ffff8883df27d459
  RDX: ffff8883d183fa58 RSI: ffffffffa01e8d00 RDI: 0000000000000000
  RBP: ffff8883d62ac800 R08: 0000000000000000 R09: 00000000000000ce
  R10: 000000000000000a R11: 0000000000000000 R12: ffff8883df27da00
  R13: ffffc90000f77c98 R14: 0000000000000130 R15: 0000000000000000
  FS:  00007f009f877740(0000) GS:ffff8883f1a00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 00000003d467e003 CR4: 0000000000160ee0
  Call Trace:
   cm_send_sidr_rep_locked+0x15a/0x1a0 [ib_cm]
   ib_send_cm_sidr_rep+0x2b/0x50 [ib_cm]
   cma_send_sidr_rep+0x8b/0xe0 [rdma_cm]
   __rdma_accept+0x21d/0x2b0 [rdma_cm]
   ? ucma_get_ctx+0x2b/0xe0 [rdma_ucm]
   ? _copy_from_user+0x30/0x60
   ucma_accept+0x13e/0x1e0 [rdma_ucm]
   ucma_write+0xb4/0x130 [rdma_ucm]
   vfs_write+0xad/0x1a0
   ksys_write+0x9d/0xb0
   do_syscall_64+0x48/0x130
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f009ef60924
  Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 80 00 00 00 00 8b 05 2a ef 2c 00 48 63 ff 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 55 53 48 89 d5 48 89 f3 48 83
  RSP: 002b:00007fff843edf38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000055743042e1d0 RCX: 00007f009ef60924
  RDX: 0000000000000130 RSI: 00007fff843edf40 RDI: 0000000000000003
  RBP: 00007fff843ee0e0 R08: 0000000000000000 R09: 0000557430433090
  R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
  R13: 00007fff843edf40 R14: 000000000000038c R15: 00000000ffffff00
  CR2: 0000000000000000

Fixes: 6a8824a74bc9 ("RDMA/cm: Allow ib_send_cm_sidr_rep() to be done under lock")
Link: https://lore.kernel.org/r/20200716105519.1424266-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1c2bf18cda9f6..83b66757c7ae2 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3723,10 +3723,12 @@ static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
 		return ret;
 	}
 	cm_id_priv->id.state = IB_CM_IDLE;
+	spin_lock_irq(&cm.lock);
 	if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
 		rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
 		RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
 	}
+	spin_unlock_irq(&cm.lock);
 	return 0;
 }
 
-- 
2.25.1



