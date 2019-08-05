Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335B381CBC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfHENZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731259AbfHENZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D7A020651;
        Mon,  5 Aug 2019 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011538;
        bh=c2wy1AO2I1DZgtEL8bkjda/NJMoKVwJhSI0f/fFwy+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZxdN/nbImm7ny7PSlGgvN8SNcYmLeL/VAwqFD/vxwUhqxC7h+gA6C+WgHFHtZCJk
         Q1CG1YgmSDfU6ydk7IdMAbnxDQFaZIjoApUR3hVQg7PBRnB2t45SUScK9YsQiARXg/
         lYcGesoc9XbGabNoj0WL8jgdO2kqrsPpdoSlv8MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Alex Vainman <alexv@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 126/131] IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specification
Date:   Mon,  5 Aug 2019 15:03:33 +0200
Message-Id: <20190805125000.415246995@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

commit b7165bd0d6cbb93732559be6ea8774653b204480 upstream.

The specification for the Toeplitz function doesn't require to set the key
explicitly to be symmetric. In case a symmetric functionality is required
a symmetric key can be simply used.

Wrongly forcing the algorithm to symmetric causes the wrong packet
distribution and a performance degradation.

Link: https://lore.kernel.org/r/20190723065733.4899-7-leon@kernel.org
Cc: <stable@vger.kernel.org> # 4.7
Fixes: 28d6137008b2 ("IB/mlx5: Add RSS QP support")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Alex Vainman <alexv@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1718,7 +1718,6 @@ static int create_rss_raw_qp_tir(struct
 		}
 
 		MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_TOEPLITZ);
-		MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
 		memcpy(rss_key, ucmd.rx_hash_key, len);
 		break;
 	}


