Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A821C8F25
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgEGO3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgEGO3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22AD52073A;
        Thu,  7 May 2020 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861790;
        bh=hhGZnsy/UqyqfE1YGceDVAiV5IZvAu1HD1paBAx4yfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWnfe13n1IgmYul6y2S53/dXoiDIrxi9Cc29hsot0TdJ9uSWccaJZaPW0toWYYA0V
         tqQBAeUtBg3gJbIP3Tg7DffIPq2MErkwAijJpS2MCMpfogiY+c/3BE7VsXMhvqXurc
         GuJwt0URajvBmxcFJwo7xDRY7E63WpkIX2tqKYcY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/16] RDMA/mlx5: Set GRH fields in query QP on RoCE
Date:   Thu,  7 May 2020 10:29:32 -0400
Message-Id: <20200507142943.26848-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142943.26848-1-sashal@kernel.org>
References: <20200507142943.26848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

[ Upstream commit 2d7e3ff7b6f2c614eb21d0dc348957a47eaffb57 ]

GRH fields such as sgid_index, hop limit, et. are set in the QP context
when QP is created/modified.

Currently, when query QP is performed, we fill the GRH fields only if the
GRH bit is set in the QP context, but this bit is not set for RoCE. Adjust
the check so we will set all relevant data for the RoCE too.

Since this data is returned to userspace, the below is an ABI regression.

Fixes: d8966fcd4c25 ("IB/core: Use rdma_ah_attr accessor functions")
Link: https://lore.kernel.org/r/20200413132028.930109-1-leon@kernel.org
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0cb60072c82f3..d835ef2ce23c0 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4362,7 +4362,9 @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
 	rdma_ah_set_path_bits(ah_attr, path->grh_mlid & 0x7f);
 	rdma_ah_set_static_rate(ah_attr,
 				path->static_rate ? path->static_rate - 5 : 0);
-	if (path->grh_mlid & (1 << 7)) {
+
+	if (path->grh_mlid & (1 << 7) ||
+	    ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		u32 tc_fl = be32_to_cpu(path->tclass_flowlabel);
 
 		rdma_ah_set_grh(ah_attr, NULL,
-- 
2.20.1

