Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F421226643
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgGTQBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732554AbgGTQBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C622A22CE3;
        Mon, 20 Jul 2020 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260902;
        bh=jNrkXYo/X5zwOmFM2rzZX4spAW98ANmnOQDvPJvCgKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwUiKtmNU6ECWr/a48kuqCo8BxB6NSntxmn2D6VYtvBoudThHZBYJYu50QBqu2qon
         KddoCfccxJ3b7LkA9tcx91tW3poyjSZL95Fi1ythF4Lr7XKa4TgNfigrnhR/AZYSd6
         k7YUOkEOP799o9UB5ZV2aao83X/AesUx9q0n/wzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 130/215] RDMA/mlx5: Verify that QP is created with RQ or SQ
Date:   Mon, 20 Jul 2020 17:36:52 +0200
Message-Id: <20200720152826.381730060@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

commit 0eacc574aae7300bf46c10c7116c3ba5825505b7 upstream.

RAW packet QP and underlay QP must be created with either
RQ or SQ, check that.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20200427154636.381474-37-leon@kernel.org
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1463,6 +1463,8 @@ static int create_raw_packet_qp(struct m
 	u16 uid = to_mpd(pd)->uid;
 	u32 out[MLX5_ST_SZ_DW(create_tir_out)] = {};
 
+	if (!qp->sq.wqe_cnt && !qp->rq.wqe_cnt)
+		return -EINVAL;
 	if (qp->sq.wqe_cnt) {
 		err = create_raw_packet_qp_tis(dev, qp, sq, tdn, pd);
 		if (err)


