Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF3E32889E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbhCARnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236918AbhCARfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F6D64F24;
        Mon,  1 Mar 2021 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617657;
        bh=TEaw49BOomwqJohOD4Zy3tOagWEnNXGwXCR/F901DY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYjsST9Q2Gb/+RBqBpt7vsvbJi0iwtao3OedQw0WlpQiFqpPVvSAdcpLdqtFsGC59
         k3A6jeFktULVLYfVteo6r2S1aUT/38Emfqirkdl90oCp2N+IgZdJvXQaQBSCXmclku
         GccwK2Zw7NC7I81TXI4cj0lBFHNmagyir0OhTPOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/340] RDMA/mlx5: Use the correct obj_id upon DEVX TIR creation
Date:   Mon,  1 Mar 2021 17:11:34 +0100
Message-Id: <20210301161055.699548601@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index fd75a9043bf15..4d6f25fdcc0ef 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1118,7 +1118,9 @@ static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
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



