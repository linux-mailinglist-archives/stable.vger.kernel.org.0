Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADADF7C45
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfKKSom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbfKKSom (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:44:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46898204FD;
        Mon, 11 Nov 2019 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497881;
        bh=VkUJ9Gsze1TFv8GHo1eZ9XvY5w9VauaoEJVkzxwl9SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMZ0eugVoycAUodNdNECkQILMI0J+aXhIMSZyfhThzQJFHmPyvmhkGtHxleJ1q9Zq
         4I2EdAFbYh8P45uK+nMZg05JeuNrIk9z/dSqFRTwaa/FGidnWOQ8nTn4lyLw3xpeyD
         kayFXtXyTtsRB7mYyJBgGyiqKq6L27epSk2/Vcy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/125] net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
Date:   Mon, 11 Nov 2019 19:28:37 +0100
Message-Id: <20191111181450.548753263@linuxfoundation.org>
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
index 8ca1d1949d930..d8d0b6bd5c5ae 100644
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



