Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA32F7DEA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfKKSxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbfKKSxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D400E222D2;
        Mon, 11 Nov 2019 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498401;
        bh=SjGmx2f95nIpbYgxMLJJg94hP0uwKMUt5OY7cItNRwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IOPABQ+3oUDDEypB9sCWYvO30bSlSYmwlUa8pr2UyyjC7oVsM72MJJQncnVnRnzi
         Fs/NcY4i5b7GTRu/hS2hquH7xTcopIB6i97MKt1KGmJPMQBTGlw5ChpiNl1ZZhttZu
         1jTVdfG9HV+aXOjWi2dB60X1VC4g5basSo+0kVII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 107/193] net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
Date:   Mon, 11 Nov 2019 19:28:09 +0100
Message-Id: <20191111181509.021424289@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
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
index 4c50efe4e7f11..61021133029e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -464,8 +464,10 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
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



