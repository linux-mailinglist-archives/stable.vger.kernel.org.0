Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4413F81B0A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfHENLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfHENLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:11:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B888216F4;
        Mon,  5 Aug 2019 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010678;
        bh=BR5uul7/2wqA9HRNeJg6ZGJ5QHshGNdX/Ucbmgif948=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/AGOV0sWa7y+vL8t9+Ux2NoH38b5cYIR4RU0SfBhlY8AVFLN7VJ6VCH8XBfcMbwF
         ZHx4I/1Z3WT5TQ6HGD85aqSrxup5FF9991f25sU63qFoPRnHdAB3BXe5DLEhGEmVlK
         KjpuqIwu68kOTKvUgyTeVmePt44fOMY/YGcoI2+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 62/74] IB/mlx5: Fix unreg_umr to ignore the mkey state
Date:   Mon,  5 Aug 2019 15:03:15 +0200
Message-Id: <20190805124940.849754208@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

commit 6a053953739d23694474a5f9c81d1a30093da81a upstream.

Fix unreg_umr to ignore the mkey state and do not fail if was freed.  This
prevents a case that a user space application already changed the mkey
state to free and then the UMR operation will fail leaving the mkey in an
inappropriate state.

Link: https://lore.kernel.org/r/20190723065733.4899-3-leon@kernel.org
Cc: <stable@vger.kernel.org> # 3.19
Fixes: 968e78dd9644 ("IB/mlx5: Enhance UMR support to allow partial page table update")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 +
 drivers/infiniband/hw/mlx5/mr.c      |    4 ++--
 drivers/infiniband/hw/mlx5/qp.c      |   12 ++++++++----
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -467,6 +467,7 @@ struct mlx5_umr_wr {
 	u64				length;
 	int				access_flags;
 	u32				mkey;
+	u8				ignore_free_state:1;
 };
 
 static inline const struct mlx5_umr_wr *umr_wr(const struct ib_send_wr *wr)
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1407,10 +1407,10 @@ static int unreg_umr(struct mlx5_ib_dev
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
-	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
-			      MLX5_IB_SEND_UMR_FAIL_IF_FREE;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
 	umrwr.mkey = mr->mmkey.key;
+	umrwr.ignore_free_state = 1;
 
 	return mlx5_ib_post_send_wait(dev, &umrwr);
 }
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3717,10 +3717,14 @@ static int set_reg_umr_segment(struct ml
 
 	memset(umr, 0, sizeof(*umr));
 
-	if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
-		umr->flags = MLX5_UMR_CHECK_FREE; /* fail if free */
-	else
-		umr->flags = MLX5_UMR_CHECK_NOT_FREE; /* fail if not free */
+	if (!umrwr->ignore_free_state) {
+		if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
+			 /* fail if free */
+			umr->flags = MLX5_UMR_CHECK_FREE;
+		else
+			/* fail if not free */
+			umr->flags = MLX5_UMR_CHECK_NOT_FREE;
+	}
 
 	umr->xlt_octowords = cpu_to_be16(get_xlt_octo(umrwr->xlt_size));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_XLT) {


