Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B597F7C8A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfKKSrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbfKKSrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE8420659;
        Mon, 11 Nov 2019 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498028;
        bh=kTmUC/kT/1UyJ9+YbANHS2wxCM4gFA/irWodXxNT4e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1DQIu/w8DkDRVP7JUPUcupmaodhB+8a87+5BdEPAfRuhI1UqxXAdZcENJIHajL4e
         UYesyl6gopIp4IFcS5Nt/Tlg7ci1A3FOvNt3LmO3AqyfVVDfmHOASfIR2aMMtwNp/V
         RwPIPkzn0fninhQpNFbzipFcU8DokrXcZ3054v2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/125] net/mlx5e: TX, Fix consumer index of error cqe dump
Date:   Mon, 11 Nov 2019 19:28:36 +0100
Message-Id: <20191111181450.396864099@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 61ea02d2c13106116c6e4916ac5d9dd41151c959 ]

The completion queue consumer index increments upon a call to
mlx5_cqwq_pop().
When dumping an error CQE, the index is already incremented.
Decrease one for the print command.

Fixes: 16cc14d81733 ("net/mlx5e: Dump xmit error completions")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 0b03d65474e93..73dce92c41c44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -462,7 +462,10 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 static void mlx5e_dump_error_cqe(struct mlx5e_txqsq *sq,
 				 struct mlx5_err_cqe *err_cqe)
 {
-	u32 ci = mlx5_cqwq_get_ci(&sq->cq.wq);
+	struct mlx5_cqwq *wq = &sq->cq.wq;
+	u32 ci;
+
+	ci = mlx5_cqwq_ctr2ix(wq, wq->cc - 1);
 
 	netdev_err(sq->channel->netdev,
 		   "Error cqe on cqn 0x%x, ci 0x%x, sqn 0x%x, syndrome 0x%x, vendor syndrome 0x%x\n",
-- 
2.20.1



