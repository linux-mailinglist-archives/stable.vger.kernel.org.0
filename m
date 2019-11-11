Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD32BF7BA5
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfKKSiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfKKSiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B0FC204FD;
        Mon, 11 Nov 2019 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497491;
        bh=wEqq2Gp2cFmHyhYl4WEbc33WFOLcIfzbyW5YtyCoAHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7QO7oIz3G4yk7zNjjxrzRZHqxCp7aknuz/f1kBPj7i51MIDF2KKJfB1Rd/J7huEU
         Ag1ObXzadz0h0TmHySL21XMEX6ELLgrCtKGQuHcK+N4m8wgzg4mHoryt4gkqE6vj1K
         ZLPxhywAKd6U5hAOH4+WuhfSWS1sZpd4zq4ZAJ5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 072/105] net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
Date:   Mon, 11 Nov 2019 19:28:42 +0100
Message-Id: <20191111181445.863075653@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit c8c2a057fdc7de1cd16f4baa51425b932a42eb39 ]

In mlx5_fpga_conn_create_cq if mlx5_vector2eqn fails the allocated
memory should be released.

Fixes: 537a50574175 ("net/mlx5: FPGA, Add high-speed connection routines")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index c4392f741c5fe..5212428031a43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -462,8 +462,10 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	}
 
 	err = mlx5_vector2eqn(mdev, smp_processor_id(), &eqn, &irqn);
-	if (err)
+	if (err) {
+		kvfree(in);
 		goto err_cqwq;
+	}
 
 	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(cq_size));
-- 
2.20.1



