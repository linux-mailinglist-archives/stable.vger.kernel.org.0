Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E79A420FD3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbhJDNiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237661AbhJDNgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF2D610E6;
        Mon,  4 Oct 2021 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353391;
        bh=ObyYr/T3LldMQWcSAsAnkg/1dktYyCdE4mCtWmOzInc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wx3EdizOTSJpyPxp53wEopIkxlTvCDX1p3t0qLNLcNmMzXnLnfkO2An/RaVxHqMay
         GNWZldBhJ/kY2itf5UMvvc/HHe0vFonpxYGJ5qs0ArVumfeFe/LiGYYh9ddvpdX5iw
         dUCv1GVr0ANOBcLWSQwOlF9eV+A91AcmDn/r7/YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 111/172] RDMA/hfi1: Fix kernel pointer leak
Date:   Mon,  4 Oct 2021 14:52:41 +0200
Message-Id: <20211004125048.569275138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Zhi <qtxuning1999@sjtu.edu.cn>

[ Upstream commit 7d5cfafe8b4006a75b55c2f1fdfdb363f9a5cc98 ]

Pointers should be printed with %p or %px rather than cast to 'unsigned
long long' and printed with %llx.  Change %llx to %p to print the secured
pointer.

Fixes: 042a00f93aad ("IB/{ipoib,hfi1}: Add a timeout handler for rdma_netdev")
Link: https://lore.kernel.org/r/20210922134857.619602-1-qtxuning1999@sjtu.edu.cn
Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
Acked-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/ipoib_tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 993f9838b6c8..e1fdeadda437 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -873,14 +873,14 @@ void hfi1_ipoib_tx_timeout(struct net_device *dev, unsigned int q)
 	struct hfi1_ipoib_txq *txq = &priv->txqs[q];
 	u64 completed = atomic64_read(&txq->complete_txreqs);
 
-	dd_dev_info(priv->dd, "timeout txq %llx q %u stopped %u stops %d no_desc %d ring_full %d\n",
-		    (unsigned long long)txq, q,
+	dd_dev_info(priv->dd, "timeout txq %p q %u stopped %u stops %d no_desc %d ring_full %d\n",
+		    txq, q,
 		    __netif_subqueue_stopped(dev, txq->q_idx),
 		    atomic_read(&txq->stops),
 		    atomic_read(&txq->no_desc),
 		    atomic_read(&txq->ring_full));
-	dd_dev_info(priv->dd, "sde %llx engine %u\n",
-		    (unsigned long long)txq->sde,
+	dd_dev_info(priv->dd, "sde %p engine %u\n",
+		    txq->sde,
 		    txq->sde ? txq->sde->this_idx : 0);
 	dd_dev_info(priv->dd, "flow %x\n", txq->flow.as_int);
 	dd_dev_info(priv->dd, "sent %llu completed %llu used %llu\n",
-- 
2.33.0



