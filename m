Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20526330E69
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhCHMg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhCHMgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9DB65210;
        Mon,  8 Mar 2021 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206998;
        bh=OIpZ9trqQ74KuIHQkV41t0IZRFG3Q73bshzWAruJd8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqzegX3IXkr6z8o0Z+0vWZ1RmI8hUDl59mVDKenUP2pPwmZHTTMdDPpyqMMnXecdP
         Ow4FwU+5vMUlCUJt6g+BvQrhwho/JznR/weCdhVmchp5e7b+mjmHl+KZvvmV8hWWHp
         xVclPN52nEchpCS1rVKwjmzmu6PyX61Pjoj23Y88=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 34/44] IB/mlx5: Add missing error code
Date:   Mon,  8 Mar 2021 13:35:12 +0100
Message-Id: <20210308122720.224203506@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index ff8e17d7f7ca..8161035eb774 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1970,8 +1970,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 
 		num_alloc_xa_entries++;
 		event_sub = kzalloc(sizeof(*event_sub), GFP_KERNEL);
-		if (!event_sub)
+		if (!event_sub) {
+			err = -ENOMEM;
 			goto err;
+		}
 
 		list_add_tail(&event_sub->event_list, &sub_list);
 		uverbs_uobject_get(&ev_file->uobj);
-- 
2.30.1



