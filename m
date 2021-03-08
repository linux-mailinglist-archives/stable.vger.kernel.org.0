Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF40C330DAB
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhCHMbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhCHMbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E004E651C9;
        Mon,  8 Mar 2021 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206682;
        bh=QnYbkgD8aclNv4Rh0U4euC6yqpGD1SRB3pG+Ax5/5OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xvt/yrzNHRhH1XyL3c1qaRe1R2urVyWip11+51cjhoBnsuWxL8eqctThKjo5ZA8E/
         GgL4zrpar2FNrfzQCMUNmevtol5iDyX6Ef6n2Q1XDJWiq/I1qIBWbYx8NzTcMNLLvl
         fBBvFlhmU9YDoH3o2tVptQFX4Z1PK/vOBglOO8BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/22] IB/mlx5: Add missing error code
Date:   Mon,  8 Mar 2021 13:30:35 +0100
Message-Id: <20210308122715.277432170@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 3a9b3d4536e0c25bd3906a28c1f584177e49dd0f ]

Set err to -ENOMEM if kzalloc fails instead of 0.

Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
Link: https://lore.kernel.org/r/20210222122343.19720-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 4d6f25fdcc0e..664e0f374ac0 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2022,8 +2022,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 
 		num_alloc_xa_entries++;
 		event_sub = kzalloc(sizeof(*event_sub), GFP_KERNEL);
-		if (!event_sub)
+		if (!event_sub) {
+			err = -ENOMEM;
 			goto err;
+		}
 
 		list_add_tail(&event_sub->event_list, &sub_list);
 		if (use_eventfd) {
-- 
2.30.1



