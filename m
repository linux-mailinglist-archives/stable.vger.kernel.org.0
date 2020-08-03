Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9DE23A66E
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHCMZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbgHCMZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 877A1207DF;
        Mon,  3 Aug 2020 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457505;
        bh=6LHmk7Ht4zZ2Wj4OwJ9ygqINNShstrp45leu13E+blE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTd277c2bJIfABQxcP1+5Y44CfNWgbijOZs32cmCDweVO0jfM4Fhn8+0OK3rO7HsU
         Id56SF3+8Y/6/d4TsRpX2DQMJHqLjvYuSWmNpJVMwHoXUvljVOLOZo84AArlT2Izcw
         p1HDtrPIOLijoqX+qzgDR9vw6ZX5RrtX4BQQ2me0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 091/120] net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq
Date:   Mon,  3 Aug 2020 14:19:09 +0200
Message-Id: <20200803121907.339054458@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit e692139e6af339a1495ef401b2d95f7f9d1c7a44 ]

The function invokes bpf_prog_inc(), which increases the reference
count of a bpf_prog object "rq->xdp_prog" if the object isn't NULL.

The refcount leak issues take place in two error handling paths. When
either mlx5_wq_ll_create() or mlx5_wq_cyc_create() fails, the function
simply returns the error code and forgets to drop the reference count
increased earlier, causing a reference count leak of "rq->xdp_prog".

Fix this issue by jumping to the error handling path err_rq_wq_destroy
while either function fails.

Fixes: 422d4c401edd ("net/mlx5e: RX, Split WQ objects for different RQ types")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b485eec812111..9861c9e42c0a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -422,7 +422,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_ll_create(mdev, &rqp->wq, rqc_wq, &rq->mpwqe.wq,
 					&rq->wq_ctrl);
 		if (err)
-			return err;
+			goto err_rq_wq_destroy;
 
 		rq->mpwqe.wq.db = &rq->mpwqe.wq.db[MLX5_RCV_DBR];
 
@@ -475,7 +475,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq,
 					 &rq->wq_ctrl);
 		if (err)
-			return err;
+			goto err_rq_wq_destroy;
 
 		rq->wqe.wq.db = &rq->wqe.wq.db[MLX5_RCV_DBR];
 
-- 
2.25.1



