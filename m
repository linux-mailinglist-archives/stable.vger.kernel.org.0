Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99F334428E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhCVMnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhCVMkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2704D619A5;
        Mon, 22 Mar 2021 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416746;
        bh=acqiuRMNu10I9R3sQ0etgTbGyqr7Mmv4Ft6MRwNK6AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOOxUYp81ybCEccs1ZxEjuCw1IjDWPyTGiK8SP3vkAcpm/ChGX84xv9z4CCiyyeOY
         JFBLIuBtq5zrk6nommFRw9fFBbW6jTajF28ubjiZ0vAabPsKN3T8Mt8Ijyu/sLHduV
         Bzl0uUzmU2+4GKp9UlVnluUbEJlVT7IDdMe4ESow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/157] RDMA/rtrs: Fix KASAN: stack-out-of-bounds bug
Date:   Mon, 22 Mar 2021 13:27:08 +0100
Message-Id: <20210322121936.015528539@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 7fbc3c373eefc291ff96d48496106c106b7f81c6 ]

When KASAN is enabled, we notice warning below:
[  483.436975] ==================================================================
[  483.437234] BUG: KASAN: stack-out-of-bounds in _mlx5_ib_post_send+0x188a/0x2560 [mlx5_ib]
[  483.437430] Read of size 4 at addr ffff88a195fd7d30 by task kworker/1:3/6954

[  483.437731] CPU: 1 PID: 6954 Comm: kworker/1:3 Kdump: loaded Tainted: G           O      5.4.82-pserver #5.4.82-1+feature+linux+5.4.y+dbg+20201210.1532+987e7a6~deb10
[  483.437976] Hardware name: Supermicro Super Server/X11DDW-L, BIOS 3.3 02/21/2020
[  483.438168] Workqueue: rtrs_server_wq hb_work [rtrs_core]
[  483.438323] Call Trace:
[  483.438486]  dump_stack+0x96/0xe0
[  483.438646]  ? _mlx5_ib_post_send+0x188a/0x2560 [mlx5_ib]
[  483.438802]  print_address_description.constprop.6+0x1b/0x220
[  483.438966]  ? _mlx5_ib_post_send+0x188a/0x2560 [mlx5_ib]
[  483.439133]  ? _mlx5_ib_post_send+0x188a/0x2560 [mlx5_ib]
[  483.439285]  __kasan_report.cold.9+0x1a/0x32
[  483.439444]  ? _mlx5_ib_post_send+0x188a/0x2560 [mlx5_ib]
[  483.439597]  kasan_report+0x10/0x20
[  483.439752]  _mlx5_ib_post_send+0x188a/0x2560 [mlx5_ib]
[  483.439910]  ? update_sd_lb_stats+0xfb1/0xfc0
[  483.440073]  ? set_reg_wr+0x520/0x520 [mlx5_ib]
[  483.440222]  ? update_group_capacity+0x340/0x340
[  483.440377]  ? find_busiest_group+0x314/0x870
[  483.440526]  ? update_sd_lb_stats+0xfc0/0xfc0
[  483.440683]  ? __bitmap_and+0x6f/0x100
[  483.440832]  ? __lock_acquire+0xa2/0x2150
[  483.440979]  ? __lock_acquire+0xa2/0x2150
[  483.441128]  ? __lock_acquire+0xa2/0x2150
[  483.441279]  ? debug_lockdep_rcu_enabled+0x23/0x60
[  483.441430]  ? lock_downgrade+0x390/0x390
[  483.441582]  ? __lock_acquire+0xa2/0x2150
[  483.441729]  ? __lock_acquire+0xa2/0x2150
[  483.441876]  ? newidle_balance+0x425/0x8f0
[  483.442024]  ? __lock_acquire+0xa2/0x2150
[  483.442172]  ? debug_lockdep_rcu_enabled+0x23/0x60
[  483.442330]  hb_work+0x15d/0x1d0 [rtrs_core]
[  483.442479]  ? schedule_hb+0x50/0x50 [rtrs_core]
[  483.442627]  ? lock_downgrade+0x390/0x390
[  483.442781]  ? process_one_work+0x40d/0xa50
[  483.442931]  process_one_work+0x4ee/0xa50
[  483.443082]  ? pwq_dec_nr_in_flight+0x110/0x110
[  483.443231]  ? do_raw_spin_lock+0x119/0x1d0
[  483.443383]  worker_thread+0x65/0x5c0
[  483.443532]  ? process_one_work+0xa50/0xa50
[  483.451839]  kthread+0x1e2/0x200
[  483.451983]  ? kthread_create_on_node+0xc0/0xc0
[  483.452139]  ret_from_fork+0x3a/0x50

The problem is we use wrong type when send wr, hw driver expect the type
of IB_WR_RDMA_WRITE_WITH_IMM wr should be ib_rdma_wr, and doing
container_of to access member. The fix is simple use ib_rdma_wr instread
of ib_send_wr.

Fixes: c0894b3ea69d ("RDMA/rtrs: core: lib functions shared between client and server modules")
Link: https://lore.kernel.org/r/20201217141915.56989-20-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 97af8f0bb806..d13aff0aa816 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -182,16 +182,16 @@ int rtrs_post_rdma_write_imm_empty(struct rtrs_con *con, struct ib_cqe *cqe,
 				    u32 imm_data, enum ib_send_flags flags,
 				    struct ib_send_wr *head)
 {
-	struct ib_send_wr wr;
+	struct ib_rdma_wr wr;
 
-	wr = (struct ib_send_wr) {
-		.wr_cqe	= cqe,
-		.send_flags	= flags,
-		.opcode	= IB_WR_RDMA_WRITE_WITH_IMM,
-		.ex.imm_data	= cpu_to_be32(imm_data),
+	wr = (struct ib_rdma_wr) {
+		.wr.wr_cqe	= cqe,
+		.wr.send_flags	= flags,
+		.wr.opcode	= IB_WR_RDMA_WRITE_WITH_IMM,
+		.wr.ex.imm_data	= cpu_to_be32(imm_data),
 	};
 
-	return rtrs_post_send(con->qp, head, &wr);
+	return rtrs_post_send(con->qp, head, &wr.wr);
 }
 EXPORT_SYMBOL_GPL(rtrs_post_rdma_write_imm_empty);
 
-- 
2.30.1



