Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA7B328B13
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbhCAS2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:28:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239769AbhCASWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C7BD65041;
        Mon,  1 Mar 2021 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619100;
        bh=j3PgkOnwPYUJR7KFodu16s2/Vdsxd6iZaw61a2TTOCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4YMfMKQZWc77SWfR4hBJxq6Ahu38H1BEzcB/oDnUAJfqislEAiPXDEi+JApRlgNP
         Ux7/qtS2OUXQfykXZdzzYdeJ1Xfv/pwUTsxt9u6rmWNukuaxJocFc2MNGQm0UUEjuB
         LfKA/dK8imsVDnn21/6FgE3xkaa7gPvAvBHh48Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/663] RDMA/mlx5: Use the correct obj_id upon DEVX TIR creation
Date:   Mon,  1 Mar 2021 17:09:09 +0100
Message-Id: <20210301161156.725784467@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 8798e4ad0abe0ba1221928a46561981c510be0c6 ]

Use the correct obj_id upon DEVX TIR creation by strictly taking the tirn
24 bits and not the general obj_id which is 32 bits.

Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
Link: https://lore.kernel.org/r/20201230130121.180350-2-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 9e3d8b8264980..26564e7d34572 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1067,7 +1067,9 @@ static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
 		MLX5_SET(general_obj_in_cmd_hdr, din, opcode, MLX5_CMD_OP_DESTROY_RQT);
 		break;
 	case MLX5_CMD_OP_CREATE_TIR:
-		MLX5_SET(general_obj_in_cmd_hdr, din, opcode, MLX5_CMD_OP_DESTROY_TIR);
+		*obj_id = MLX5_GET(create_tir_out, out, tirn);
+		MLX5_SET(destroy_tir_in, din, opcode, MLX5_CMD_OP_DESTROY_TIR);
+		MLX5_SET(destroy_tir_in, din, tirn, *obj_id);
 		break;
 	case MLX5_CMD_OP_CREATE_TIS:
 		MLX5_SET(general_obj_in_cmd_hdr, din, opcode, MLX5_CMD_OP_DESTROY_TIS);
-- 
2.27.0



