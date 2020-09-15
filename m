Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473F226A71C
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgIOObk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgIOOba (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A60822B48;
        Tue, 15 Sep 2020 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179770;
        bh=+/4Gi/warB2s9shqbQ2i8K/l2a79KsNB7gX8hhBj9Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQ1fc8kuy6FsTAWS9mL5J1FIvsB0gdq9LukXB6VlR1KRL1WT0UGW1KAN046R5JjhN
         jn/ydk25hQgjs2HMc07/+vUptg8tlNz/Gahz4M34s+qx3u2GBxCq+jV0nHJMjz5kcN
         rahUcVh6VVugkrgmz+EOLcxTdgfjzPnqwcFRlLQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 111/132] RDMA/mlx4: Read pkey table length instead of hardcoded value
Date:   Tue, 15 Sep 2020 16:13:33 +0200
Message-Id: <20200915140649.682609222@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

commit ec78b3bd66bc9a015505df0ef0eb153d9e64b03b upstream.

If the pkey_table is not available (which is the case when RoCE is not
supported), the cited commit caused a regression where mlx4_devices
without RoCE are not created.

Fix this by returning a pkey table length of zero in procedure
eth_link_query_port() if the pkey-table length reported by the device is
zero.

Link: https://lore.kernel.org/r/20200824110229.1094376-1-leon@kernel.org
Cc: <stable@vger.kernel.org>
Fixes: 1901b91f9982 ("IB/core: Fix potential NULL pointer dereference in pkey cache")
Fixes: fa417f7b520e ("IB/mlx4: Add support for IBoE")
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx4/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -781,7 +781,8 @@ static int eth_link_query_port(struct ib
 	props->ip_gids = true;
 	props->gid_tbl_len	= mdev->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= mdev->dev->caps.max_msg_sz;
-	props->pkey_tbl_len	= 1;
+	if (mdev->dev->caps.pkey_table_len[port])
+		props->pkey_tbl_len = 1;
 	props->max_mtu		= IB_MTU_4096;
 	props->max_vl_num	= 2;
 	props->state		= IB_PORT_DOWN;


