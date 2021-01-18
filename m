Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD52FAA1E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437333AbhART1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:27:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390428AbhARLiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E5AE222BB;
        Mon, 18 Jan 2021 11:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969812;
        bh=LsQVsncU5STLMQtFu4Ldhy7w1YbLiSPXSqe9RZqdxCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ81jSTrM7XvLc5+cIOLsiNLBqrxrH5SE6BsF53GtcXH0l0qbleauUTtjsjbJo4lZ
         CPYLf+0odojURvBrD88lh31h6jnP0p3APelQBHIRGCkxkLLQqikgjw/nGp9EJrJjoh
         st8jPrvCkvNUTdRCH90EQo1LxrI877G8Q0uLdrDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Petter Selasky <hanss@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.19 35/43] RDMA/mlx5: Fix wrong free of blue flame register on error
Date:   Mon, 18 Jan 2021 12:34:58 +0100
Message-Id: <20210118113336.649349284@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

commit 1c3aa6bd0b823105c2030af85d92d158e815d669 upstream.

If the allocation of the fast path blue flame register fails, the driver
should free the regular blue flame register allocated a statement above,
not the one that it just failed to allocate.

Fixes: 16c1975f1032 ("IB/mlx5: Create profile infrastructure to add and remove stages")
Link: https://lore.kernel.org/r/20210113121703.559778-6-leon@kernel.org
Reported-by: Hans Petter Selasky <hanss@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6094,7 +6094,7 @@ int mlx5_ib_stage_bfrag_init(struct mlx5
 
 	err = mlx5_alloc_bfreg(dev->mdev, &dev->fp_bfreg, false, true);
 	if (err)
-		mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
+		mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 
 	return err;
 }


