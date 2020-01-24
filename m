Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1D148464
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbgAXLHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389024AbgAXLHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:00 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599202077C;
        Fri, 24 Jan 2020 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864019;
        bh=VJaTf0bIBHAPHo5d81+P3os0Sa1rObqPVzeEvZ77Iho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gdYHNxV6bcksWEA99sIUQ98Scs0HU2y4eeLsQMVGvaGtJ8ygnBA1cynIzfdNuWRi
         3zJVkz3NHUJgrLtxEqjLuL1LEDxduz6pYBeQLKjdaje/O7hGcfGj8809xXTGR4Jlkw
         hb9BrkBr5Xd7Y8AJVFUjM1LV3XHb+VH+To2sPMDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/639] net/mlx5: Take lock with IRQs disabled to avoid deadlock
Date:   Fri, 24 Jan 2020 10:25:19 +0100
Message-Id: <20200124093105.887220381@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

[ Upstream commit 33814e5d127e21f53b52e17b0722c1b57d4f4d29 ]

The lock in qp_table might be taken from process context or from
interrupt context. This may lead to a deadlock unless it is taken with
IRQs disabled.

Discovered by lockdep

================================
WARNING: inconsistent lock state
4.20.0-rc6
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W}

python/12572 [HC1[1]:SC0[0]:HE0:SE1] takes:
00000000052a4df4 (&(&table->lock)->rlock#2){?.+.}, /0x50 [mlx5_core]
{HARDIRQ-ON-W} state was registered at:
  _raw_spin_lock+0x33/0x70
  mlx5_get_rsc+0x1a/0x50 [mlx5_core]
  mlx5_ib_eqe_pf_action+0x493/0x1be0 [mlx5_ib]
  process_one_work+0x90c/0x1820
  worker_thread+0x87/0xbb0
  kthread+0x320/0x3e0
  ret_from_fork+0x24/0x30
irq event stamp: 103928
hardirqs last  enabled at (103927): [] nk+0x1a/0x1c
hardirqs last disabled at (103928): [] unk+0x1a/0x1c
softirqs last  enabled at (103924): [] tcp_sendmsg+0x31/0x40
softirqs last disabled at (103922): [] 80

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&table->lock)->rlock#2);

    lock(&(&table->lock)->rlock#2);

 *** DEADLOCK ***

Fixes: 032080ab43ac ("IB/mlx5: Lock QP during page fault handling")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index f33707ce8b6b0..479ac21cdbc69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -44,14 +44,15 @@ static struct mlx5_core_rsc_common *mlx5_get_rsc(struct mlx5_core_dev *dev,
 {
 	struct mlx5_qp_table *table = &dev->priv.qp_table;
 	struct mlx5_core_rsc_common *common;
+	unsigned long flags;
 
-	spin_lock(&table->lock);
+	spin_lock_irqsave(&table->lock, flags);
 
 	common = radix_tree_lookup(&table->tree, rsn);
 	if (common)
 		atomic_inc(&common->refcount);
 
-	spin_unlock(&table->lock);
+	spin_unlock_irqrestore(&table->lock, flags);
 
 	if (!common) {
 		mlx5_core_warn(dev, "Async event for bogus resource 0x%x\n",
-- 
2.20.1



