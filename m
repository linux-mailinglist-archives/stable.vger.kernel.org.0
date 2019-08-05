Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D4A81AAC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfHENIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbfHENIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:08:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936C521872;
        Mon,  5 Aug 2019 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010497;
        bh=YwiC+hXW1ijrw9UQ2aF7Quevho4xFUQsbUEAordRrL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5pHoQHkPUao1LzH8GzM6u61JuRqnMErVimUVn6xm6QyLBt8dbp+wUdHKUDcV+kj0
         wSX4lcG2X32+FvJsbfDJtRaKn3swn253OTN4W/+qj+8B/vjvjeV/qjBRx+o+GGW5d4
         M5isa2kJrLAR3fWVoVdL8l9WyClzNHg5j/X8lqmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14 47/53] IB/mlx5: Move MRs to a kernel PD when freeing them to the MR cache
Date:   Mon,  5 Aug 2019 15:03:12 +0200
Message-Id: <20190805124933.152431582@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
References: <20190805124927.973499541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

commit 9ec4483a3f0f71a228a5933bc040441322bfb090 upstream.

Fix unreg_umr to move the MR to a kernel owned PD (i.e. the UMR PD) which
can't be accessed by userspace.

This ensures that nothing can continue to access the MR once it has been
placed in the kernels cache for reuse.

MRs in the cache continue to have their HW state, including DMA tables,
present. Even though the MR has been invalidated, changing the PD provides
an additional layer of protection against use of the MR.

Link: https://lore.kernel.org/r/20190723065733.4899-5-leon@kernel.org
Cc: <stable@vger.kernel.org> # 3.10
Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1305,8 +1305,10 @@ static int unreg_umr(struct mlx5_ib_dev
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
-	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
+			      MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
+	umrwr.pd = dev->umrc.pd;
 	umrwr.mkey = mr->mmkey.key;
 	umrwr.ignore_free_state = 1;
 


