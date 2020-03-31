Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21464199200
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgCaJEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730929AbgCaJEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9188E20848;
        Tue, 31 Mar 2020 09:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645455;
        bh=FMoj8vQ3CJQ28E34Ty/KO3Y1PzfJBJMcuwGYh4c7THc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxaD/Xtc9uiyL5nzAEXT5X1wZSAnEmeZnXc3wTE9PuEt5zkLwfx9Q35iiiZKFvFcA
         gOMD/8ar1ersFAI6eMJ3bdmUKtYDb+k1Fc1XO3zIAEWJhP91TYfgDd77Wy8c/jSpba
         NJ/3jPBhT5ees/S0+F7r+gqDdVBcrBLHAfoPAdXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 058/170] net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset
Date:   Tue, 31 Mar 2020 10:57:52 +0200
Message-Id: <20200331085430.749617384@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 39369fd536d485a99a59d8e357c0d4d3ce19a3b8 ]

When resetting the RQ (moving RQ state from RST to RDY), the driver
resets the WQ's SW metadata.
In striding RQ mode, we maintain a field that reflects the actual
expected WQ head (including in progress WQEs posted to the ICOSQ).
It was mistakenly not reset together with the WQ. Fix this here.

Fixes: 8276ea1353a4 ("net/mlx5e: Report and recover from CQE with error on RQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -181,10 +181,12 @@ mlx5e_tx_dma_unmap(struct device *pdev,
 
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 {
-	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		mlx5_wq_ll_reset(&rq->mpwqe.wq);
-	else
+		rq->mpwqe.actual_wq_head = 0;
+	} else {
 		mlx5_wq_cyc_reset(&rq->wqe.wq);
+	}
 }
 
 /* SW parser related functions */


