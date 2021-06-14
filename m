Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32AA3A634C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhFNLL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235197AbhFNLJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7437061938;
        Mon, 14 Jun 2021 10:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667609;
        bh=ZeEoaVM7F4t1P1STZsEv3uRlugolwL15Tq9UTNapjUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6ph4vxv6/Du9YzRAhXPERZK24NNsk9eh3OtFkQKdzfR40bIFedmiY04hH/vWbBY+
         2QAEUznmsFSiEAa2CkjcCK1Igayn48T3jy+ATO7gb47hOSyMV5naLlvqkS5F7Edwp6
         /MnI6Yyy0MRJxURoQBnAmiqxYtXuqPQUjD0I9xO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 119/131] IB/mlx5: Fix initializing CQ fragments buffer
Date:   Mon, 14 Jun 2021 12:28:00 +0200
Message-Id: <20210614102657.061837132@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

commit 2ba0aa2feebda680ecfc3c552e867cf4d1b05a3a upstream.

The function init_cq_frag_buf() can be called to initialize the current CQ
fragments buffer cq->buf, or the temporary cq->resize_buf that is filled
during CQ resize operation.

However, the offending commit started to use function get_cqe() for
getting the CQEs, the issue with this change is that get_cqe() always
returns CQEs from cq->buf, which leads us to initialize the wrong buffer,
and in case of enlarging the CQ we try to access elements beyond the size
of the current cq->buf and eventually hit a kernel panic.

 [exception RIP: init_cq_frag_buf+103]
  [ffff9f799ddcbcd8] mlx5_ib_resize_cq at ffffffffc0835d60 [mlx5_ib]
  [ffff9f799ddcbdb0] ib_resize_cq at ffffffffc05270df [ib_core]
  [ffff9f799ddcbdc0] llt_rdma_setup_qp at ffffffffc0a6a712 [llt]
  [ffff9f799ddcbe10] llt_rdma_cc_event_action at ffffffffc0a6b411 [llt]
  [ffff9f799ddcbe98] llt_rdma_client_conn_thread at ffffffffc0a6bb75 [llt]
  [ffff9f799ddcbec8] kthread at ffffffffa66c5da1
  [ffff9f799ddcbf50] ret_from_fork_nospec_begin at ffffffffa6d95ddd

Fix it by getting the needed CQE by calling mlx5_frag_buf_get_wqe() that
takes the correct source buffer as a parameter.

Fixes: 388ca8be0037 ("IB/mlx5: Implement fragmented completion queue (CQ)")
Link: https://lore.kernel.org/r/90a0e8c924093cfa50a482880ad7e7edb73dc19a.1623309971.git.leonro@nvidia.com
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/cq.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -838,15 +838,14 @@ static void destroy_cq_user(struct mlx5_
 	ib_umem_release(cq->buf.umem);
 }
 
-static void init_cq_frag_buf(struct mlx5_ib_cq *cq,
-			     struct mlx5_ib_cq_buf *buf)
+static void init_cq_frag_buf(struct mlx5_ib_cq_buf *buf)
 {
 	int i;
 	void *cqe;
 	struct mlx5_cqe64 *cqe64;
 
 	for (i = 0; i < buf->nent; i++) {
-		cqe = get_cqe(cq, i);
+		cqe = mlx5_frag_buf_get_wqe(&buf->fbc, i);
 		cqe64 = buf->cqe_size == 64 ? cqe : cqe + 64;
 		cqe64->op_own = MLX5_CQE_INVALID << 4;
 	}
@@ -872,7 +871,7 @@ static int create_cq_kernel(struct mlx5_
 	if (err)
 		goto err_db;
 
-	init_cq_frag_buf(cq, &cq->buf);
+	init_cq_frag_buf(&cq->buf);
 
 	*inlen = MLX5_ST_SZ_BYTES(create_cq_in) +
 		 MLX5_FLD_SZ_BYTES(create_cq_in, pas[0]) *
@@ -1177,7 +1176,7 @@ static int resize_kernel(struct mlx5_ib_
 	if (err)
 		goto ex;
 
-	init_cq_frag_buf(cq, cq->resize_buf);
+	init_cq_frag_buf(cq->resize_buf);
 
 	return 0;
 


