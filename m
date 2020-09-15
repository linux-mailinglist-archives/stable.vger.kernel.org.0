Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7089526B5B3
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgIOXtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgIOOcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D8723BCD;
        Tue, 15 Sep 2020 14:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179861;
        bh=mGYM22SuLBLeqxtZ/AoDeKzHOnWQecWB71KGhDY2e5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwSluy9ZRnW353EoE6C1AifLlThLvmVGcTA6uqLm0OMWx178p28YCzhK5/w3ieKFm
         r18U6gS9mS0mpdoWZR9tOd9zUvkRamZthm2auQSBWhcfluEjhv0CC8P9CfUePmicMw
         IA3Ole6yomPgAZoQwVWhiBbSEFZwwY50fcRjm4Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 015/177] RDMA/rxe: Fix memleak in rxe_mem_init_user
Date:   Tue, 15 Sep 2020 16:11:26 +0200
Message-Id: <20200915140654.373655720@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit e3ddd6067ee62f6e76ebcf61ff08b2c729ae412b ]

When page_address() fails, umem should be freed just like when
rxe_mem_alloc() fails.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200819075632.22285-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index e83c7b518bfa2..bfb96a0d071bb 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -207,6 +207,7 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
 			vaddr = page_address(sg_page_iter_page(&sg_iter));
 			if (!vaddr) {
 				pr_warn("null vaddr\n");
+				ib_umem_release(umem);
 				err = -ENOMEM;
 				goto err1;
 			}
-- 
2.25.1



