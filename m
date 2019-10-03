Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBB9CA564
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392057AbfJCQd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391473AbfJCQd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3C8B2086A;
        Thu,  3 Oct 2019 16:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120435;
        bh=WaXkzYUQZiX+6yr6ucA7h70yZZ/D3f1BdAj3GtAl+L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i17LURVD6np+kbg4gs+2A5LcfigoIDbbqryLzhjv571dRaYv5Wvdm6W/DnKWRRNWb
         3QFMhZto06QZqJkoT+pg4dQAHxdOAHGpSiCdCZ9LBsLjg2+A95R6uzU4bhxXHyVF0J
         E/3o0KcoOGVH5PUoNunZ1UQ10BnmTlfloLnk0wXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danit Goldberg <danitg@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 221/313] IB/mlx5: Free mpi in mp_slave mode
Date:   Thu,  3 Oct 2019 17:53:19 +0200
Message-Id: <20191003154554.800537477@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

commit 5d44adebbb7e785939df3db36ac360f5e8b73e44 upstream.

ib_add_slave_port() allocates a multiport struct but never frees it.
Don't leak memory, free the allocated mpi struct during driver unload.

Cc: <stable@vger.kernel.org>
Fixes: 32f69e4be269 ("{net, IB}/mlx5: Manage port association for multiport RoCE")
Link: https://lore.kernel.org/r/20190916064818.19823-3-leon@kernel.org
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6829,6 +6829,7 @@ static void mlx5_ib_remove(struct mlx5_c
 			mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
 		list_del(&mpi->list);
 		mutex_unlock(&mlx5_ib_multiport_mutex);
+		kfree(mpi);
 		return;
 	}
 


