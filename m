Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F82F711
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfD3Lsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730882AbfD3Lso (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB282054F;
        Tue, 30 Apr 2019 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624923;
        bh=QxCnPLDxI3vzo4dtboAXHm8v6VZkQ2zXc8lzd9GYQDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2OqMQr7bZIAOU8/vWnyNnSWt3N3lrEijKrJmVqvRHCiiXODJrbrFWJ6OPGkd+J7Y
         QpjyYLj2DfDKS/ewNa85P8BiKg9duOPgFqF3QpgIGvCR5OHpVjiaOuOpTbqywot9cJ
         wNadJZQlL743ApUrj9tFcm1lv5L8riDdpN9/n7/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 5.0 24/89] RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
Date:   Tue, 30 Apr 2019 13:38:15 +0200
Message-Id: <20190430113611.159345140@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit d5e560d3f72382ac4e3bfe4e0f0420e6a220b039 upstream.

Since mlx5 supports device disassociate it must use this API for all
BAR page mmaps, otherwise the pages can remain mapped after the device
is unplugged causing a system crash.

Cc: stable@vger.kernel.org
Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2154,14 +2154,12 @@ static int mlx5_ib_mmap(struct ib_uconte
 		if (PAGE_SIZE > 4096)
 			return -EOPNOTSUPP;
 
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		pfn = (dev->mdev->iseg_base +
 		       offsetof(struct mlx5_init_seg, internal_timer_h)) >>
 			PAGE_SHIFT;
-		if (io_remap_pfn_range(vma, vma->vm_start, pfn,
-				       PAGE_SIZE, vma->vm_page_prot))
-			return -EAGAIN;
-		break;
+		return rdma_user_mmap_io(&context->ibucontext, vma, pfn,
+					 PAGE_SIZE,
+					 pgprot_noncached(vma->vm_page_prot));
 	case MLX5_IB_MMAP_CLOCK_INFO:
 		return mlx5_ib_mmap_clock_info_page(dev, vma, context);
 


