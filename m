Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21E5EEE8D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389865AbfKDWPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389861AbfKDWFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:41 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D5E20650;
        Mon,  4 Nov 2019 22:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905140;
        bh=ZN/G0DCHvmoMD9ezTpP+BUSAzatO5A2Gky/EnJq3BiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxnxZ83xgubDV/4D5rhhFjRdUoS7VnPZ0yvmEZ/ybuzEBsSiSqgxUeGZh8LPm8JUk
         033jhslRSXAbdOc+kFPP8dc/q0oVQY+g5RR9C2yKwsqKlXqRKKy7vVbSErHIBr9cWN
         S0sQkEE7KZ6u2PE9EG18ORdbhBFUHKSnEEvNBACI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artemy Kovalyov <artemyko@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 041/163] RDMA/mlx5: Order num_pending_prefetch properly with synchronize_srcu
Date:   Mon,  4 Nov 2019 22:43:51 +0100
Message-Id: <20191104212143.254999850@linuxfoundation.org>
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

[ Upstream commit aa116b810ac9077a263ed8679fb4d595f180e0eb ]

During destroy setting live = 0 and then synchronize_srcu() prevents
num_pending_prefetch from incrementing, and also, ensures that all work
holding that count is queued on the WQ. Testing before causes races of the
form:

    CPU0                                         CPU1
  dereg_mr()
                                          mlx5_ib_advise_mr_prefetch()
            				   srcu_read_lock()
                                            num_pending_prefetch_inc()
					      if (!live)
   live = 0
   atomic_read() == 0
     // skip flush_workqueue()
                                              atomic_inc()
 					      queue_work();
            				   srcu_read_unlock()
   WARN_ON(atomic_read())  // Fails

Swap the order so that the synchronize_srcu() prevents this.

Fixes: a6bc3875f176 ("IB/mlx5: Protect against prefetch of invalid MR")
Link: https://lore.kernel.org/r/20191001153821.23621-5-jgg@ziepe.ca
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c4ba8838d2c46..96c8a6835592d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1591,13 +1591,14 @@ static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		 */
 		mr->live = 0;
 
+		/* Wait for all running page-fault handlers to finish. */
+		synchronize_srcu(&dev->mr_srcu);
+
 		/* dequeue pending prefetch requests for the mr */
 		if (atomic_read(&mr->num_pending_prefetch))
 			flush_workqueue(system_unbound_wq);
 		WARN_ON(atomic_read(&mr->num_pending_prefetch));
 
-		/* Wait for all running page-fault handlers to finish. */
-		synchronize_srcu(&dev->mr_srcu);
 		/* Destroy all page mappings */
 		if (umem_odp->page_list)
 			mlx5_ib_invalidate_range(umem_odp,
-- 
2.20.1



