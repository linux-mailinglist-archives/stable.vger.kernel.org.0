Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C912F9F48
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbhARMQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390900AbhARLqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CA8F22D5B;
        Mon, 18 Jan 2021 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970375;
        bh=igt8EuL5nuiUf7f+sJcAA1cbkSnPUBA1VkxbnqbKkS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5sbOJ8aRbP3XcoMQjx1z6b68mrzV/21HmlRvS7yL711BUinklyojZowJHxddAfBa
         jYfraPbkCAoEMRSurIYMNPAtvCzXObqJ+kKUZ9WsOadnnlhwh/s4HiQ6X5c9hzDTSv
         mHjSMekD1MfVlwGxhT1CFxlaOiW6peFx5Pa1rtKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Petter Selasky <hanss@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 136/152] RDMA/mlx5: Fix wrong free of blue flame register on error
Date:   Mon, 18 Jan 2021 12:35:11 +0100
Message-Id: <20210118113359.242728586@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -4362,7 +4362,7 @@ static int mlx5_ib_stage_bfrag_init(stru
 
 	err = mlx5_alloc_bfreg(dev->mdev, &dev->fp_bfreg, false, true);
 	if (err)
-		mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
+		mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 
 	return err;
 }


