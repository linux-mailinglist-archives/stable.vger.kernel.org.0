Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837A5F7E74
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfKKSoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729025AbfKKSoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:44:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10016204FD;
        Mon, 11 Nov 2019 18:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497848;
        bh=WJqNjWlZeYXp/OdJW52AYkLhIjoXx0wfAPH5kCfAg+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSk3Oyn/rzUalDr74mcAFhU4aCn1SegvxoysOlvwxiPAb1jlMDcz5qo53hrZ9vDbS
         Hdl+3je0aBsBb+KnIIeB0aUtKHlPLth9vLQ56YmABE2xpqAFtUFkrqmMKEYJJ4+soc
         FB1KQEA0hgLAJiXkkIL5DYR+IId4Q8xv57ZKrN68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafi Wiener <rafiw@mellanox.com>,
        Oleg Kuporosov <olegk@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/125] RDMA/mlx5: Clear old rate limit when closing QP
Date:   Mon, 11 Nov 2019 19:28:33 +0100
Message-Id: <20191111181450.011683215@linuxfoundation.org>
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

From: Rafi Wiener <rafiw@mellanox.com>

[ Upstream commit c8973df2da677f375f8b12b6eefca2f44c8884d5 ]

Before QP is closed it changes to ERROR state, when this happens
the QP was left with old rate limit that was already removed from
the table.

Fixes: 7d29f349a4b9 ("IB/mlx5: Properly adjust rate limit on QP state transitions")
Signed-off-by: Rafi Wiener <rafiw@mellanox.com>
Signed-off-by: Oleg Kuporosov <olegk@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20191002120243.16971-1-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 77b1f3fd086ad..900f85ce0fb08 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2828,10 +2828,12 @@ static int modify_raw_packet_qp_sq(struct mlx5_core_dev *dev,
 	}
 
 	/* Only remove the old rate after new rate was set */
-	if ((old_rl.rate &&
-	     !mlx5_rl_are_equal(&old_rl, &new_rl)) ||
-	    (new_state != MLX5_SQC_STATE_RDY))
+	if ((old_rl.rate && !mlx5_rl_are_equal(&old_rl, &new_rl)) ||
+	    (new_state != MLX5_SQC_STATE_RDY)) {
 		mlx5_rl_remove_rate(dev, &old_rl);
+		if (new_state != MLX5_SQC_STATE_RDY)
+			memset(&new_rl, 0, sizeof(new_rl));
+	}
 
 	ibqp->rl = new_rl;
 	sq->state = new_state;
-- 
2.20.1



