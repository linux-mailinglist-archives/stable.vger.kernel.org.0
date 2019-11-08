Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D455F558D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbfKHTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390707AbfKHTDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE9E20650;
        Fri,  8 Nov 2019 19:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239790;
        bh=hRXQ8sUkkvj8f+ms3hSWiNmVXTyGDsp/hBlvFvf3ciw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHbJsjctm92LWjwY4KcNXI4i+B/72JG0IkGoaFyxW62kMQBvgGsqUPUBAQTCbkqcG
         tRigNhkORhePSGQ1jZDpTEVfca735RRZ+wJSjRijhGPK4shiqaKfg/hO1mzCo4tPN7
         Y9dSVY4YfHOho6yMshZnjc5OUT6T9ShrSfD6EjRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 61/79] net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget
Date:   Fri,  8 Nov 2019 19:50:41 +0100
Message-Id: <20191108174820.613541097@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 9df86bdb6746d7fcfc2fda715f7a7c3d0ddb2654 ]

When CQE compression is enabled, compressed CQEs use the following
structure: a title is followed by one or many blocks, each containing 8
mini CQEs (except the last, which may contain fewer mini CQEs).

Due to NAPI budget restriction, a complete structure is not always
parsed in one NAPI run, and some blocks with mini CQEs may be deferred
to the next NAPI poll call - we have the mlx5e_decompress_cqes_cont call
in the beginning of mlx5e_poll_rx_cq. However, if the budget is
extremely low, some blocks may be left even after that, but the code
that follows the mlx5e_decompress_cqes_cont call doesn't check it and
assumes that a new CQE begins, which may not be the case. In such cases,
random memory corruptions occur.

An extremely low NAPI budget of 8 is used when busy_poll or busy_read is
active.

This commit adds a check to make sure that the previous compressed CQE
has been completely parsed after mlx5e_decompress_cqes_cont, otherwise
it prevents a new CQE from being fetched in the middle of a compressed
CQE.

This commit fixes random crashes in __build_skb, __page_pool_put_page
and other not-related-directly places, that used to happen when both CQE
compression and busy_poll/busy_read were enabled.

Fixes: 7219ab34f184 ("net/mlx5e: CQE compression")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1267,8 +1267,11 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
 
-	if (cq->decmprs_left)
+	if (cq->decmprs_left) {
 		work_done += mlx5e_decompress_cqes_cont(rq, cq, 0, budget);
+		if (cq->decmprs_left || work_done >= budget)
+			goto out;
+	}
 
 	cqe = mlx5_cqwq_get_cqe(&cq->wq);
 	if (!cqe) {


