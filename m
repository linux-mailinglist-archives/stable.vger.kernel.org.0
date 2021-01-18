Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE22FA910
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393196AbhARSmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390689AbhARLlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C086229C6;
        Mon, 18 Jan 2021 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970028;
        bh=FFLoNLOdNMUGLCdHR6+9SZk+I561sQRq/z4/zVvOktE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pQmrBxhgRo5R5g7Xo3/gWJpIIOVSE4xH6+QmMyahUawOZ0XUfZpfcV3oN5PMexpH
         do5USrVcuosEKnNvtxcHGNr+4UupCEVHQqYGFADLrPdJpERU//yY+zWgAPfnWrT9dg
         3l2iJAHl9Kh7Dz4sZAMHdG1TMz20DhiKKSRmXfFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Petter Selasky <hanss@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 65/76] RDMA/mlx5: Fix wrong free of blue flame register on error
Date:   Mon, 18 Jan 2021 12:35:05 +0100
Message-Id: <20210118113344.074417409@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -6626,7 +6626,7 @@ static int mlx5_ib_stage_bfrag_init(stru
 
 	err = mlx5_alloc_bfreg(dev->mdev, &dev->fp_bfreg, false, true);
 	if (err)
-		mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
+		mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 
 	return err;
 }


