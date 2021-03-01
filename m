Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9612E328F8E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242294AbhCATw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242230AbhCAToJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3FC1652FB;
        Mon,  1 Mar 2021 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620469;
        bh=h0yn47Vxr/VXfNRTUqbNcSSxzW8GIh0UmrxAErLPn9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWdWwPGJM/Gp4nqgcfkVzTnp7oD+af13jZMcBkNaIgMRnb9HRujlrfhrI6gswTO/g
         z4dmQocVc4bNF733hn8MV4aCvIwE0vnzplzbHlSKvghgKkxWhEG2484KqETdG1GY7c
         exxU6XMMJR82YCh7T6g3jrkaWdS49Od7K2r0GMAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 163/775] net/mlx5e: Fix CQ params of ICOSQ and async ICOSQ
Date:   Mon,  1 Mar 2021 17:05:31 +0100
Message-Id: <20210301161209.696147926@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit ebf79b6be67c0a77a9ab7cdf74c43fd7d9619f0c ]

The commit mentioned below has split the parameters of ICOSQ and async
ICOSQ, but it contained a typo: the CQ parameters were swapped for ICOSQ
and async ICOSQ. Async ICOSQ is longer than the normal ICOSQ, and the CQ
size must be the same as the size of the corresponding SQ, but due to
this bug, the CQ of async ICOSQ was much shorter than async ICOSQ
itself. It led to overflows of the CQ with such messages in dmesg, in
particular, when running multiple kTLS-offloaded streams:

mlx5_core 0000:08:00.0: cq_err_event_notifier:529:(pid 9422): CQ error
on CQN 0x406, syndrome 0x1
mlx5_core 0000:08:00.0 eth2: mlx5e_cq_error_event: cqn=0x000406
event=0x04

This commit fixes the issue by using the corresponding parameters for
ICOSQ and async ICOSQ.

Fixes: c293ac927fbb ("net/mlx5e: Refactor build channel params")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3edc826cc6bbe..a2e0b548bf570 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1827,12 +1827,12 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 
 	mlx5e_build_create_cq_param(&ccp, c);
 
-	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
+	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->async_icosq.cqp, &ccp,
 			    &c->async_icosq.cq);
 	if (err)
 		return err;
 
-	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->async_icosq.cqp, &ccp,
+	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
 			    &c->icosq.cq);
 	if (err)
 		goto err_close_async_icosq_cq;
-- 
2.27.0



