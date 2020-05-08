Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C91CAF78
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgEHMjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbgEHMi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE1721835;
        Fri,  8 May 2020 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941538;
        bh=n0fEWB4p/0Z+k3rXMIsL0JbQVMb8WB2ugcptipI2SlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDcMa8pJK75u/ypagyfkBTSYAWhODT/NQkVYKDG67d2eiOf1fSRqgpg2dSkCKGONh
         yuyFO7qjgQaNJFQJ3WQrWyIak6116k9RGsp5dcqSOGy/lePfzWfHrmMFrsBsx882Zp
         9tFzM3vdi2CiaE8GsTGijwieLsRQJtluzLe6zYhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalh@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 4.4 073/312] IB/mlx5: Fix RC transport send queue overhead computation
Date:   Fri,  8 May 2020 14:31:04 +0200
Message-Id: <20200508123129.673349927@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leon@leon.nu>

commit 75c1657e1d50730dc0130a67977f7831a4e241f4 upstream.

Fix the RC QPs send queue overhead computation to take into account
two additional segments in the WQE which are needed for registration
operations.

The ATOMIC and UMR segments can't coexist together, so chose maximum out
of them.

The commit 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead
computation") was intended to update RC transport as commit messages
states, but added the code to UC transport.

Fixes: 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead computation")
Signed-off-by: Kamal Heib <kamalh@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -271,8 +271,10 @@ static int sq_overhead(enum ib_qp_type q
 		/* fall through */
 	case IB_QPT_RC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
-			sizeof(struct mlx5_wqe_atomic_seg) +
-			sizeof(struct mlx5_wqe_raddr_seg);
+			max(sizeof(struct mlx5_wqe_atomic_seg) +
+			    sizeof(struct mlx5_wqe_raddr_seg),
+			    sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+			    sizeof(struct mlx5_mkey_seg));
 		break;
 
 	case IB_QPT_XRC_TGT:
@@ -280,9 +282,9 @@ static int sq_overhead(enum ib_qp_type q
 
 	case IB_QPT_UC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
-			sizeof(struct mlx5_wqe_raddr_seg) +
-			sizeof(struct mlx5_wqe_umr_ctrl_seg) +
-			sizeof(struct mlx5_mkey_seg);
+			max(sizeof(struct mlx5_wqe_raddr_seg),
+			    sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+			    sizeof(struct mlx5_mkey_seg));
 		break;
 
 	case IB_QPT_UD:


