Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CCF27307B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgIURFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgIUQeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB68E239D0;
        Mon, 21 Sep 2020 16:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706049;
        bh=P74bg1oxvriKc+IHNTu/YL9uDoN4V/68SHrFiH+Bd4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9UaIYmmcCxdA/Yaz72r2HnmRXVhIv/XBj2Tk8mprNeVrUqPr/ckyxkGTqimtGq19
         z1SqwJH+bpuCLvfGwS0zjPbS7OBcSOejZyj1WLLiuyIIPetub5jxt3vXeIHLJU7SEB
         /VXmvXIWknfmyfNAIE3MOIgzfGX4jC8RX1GL+qrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/70] RDMA/rxe: Fix memleak in rxe_mem_init_user
Date:   Mon, 21 Sep 2020 18:27:02 +0200
Message-Id: <20200921162035.247677847@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 9b732c5f89e16..6d1ba75398a1a 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -205,6 +205,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 			vaddr = page_address(sg_page(sg));
 			if (!vaddr) {
 				pr_warn("null vaddr\n");
+				ib_umem_release(umem);
 				err = -ENOMEM;
 				goto err1;
 			}
-- 
2.25.1



