Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EFA4416E3
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhKAJa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhKAJ23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:28:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EAF3611C8;
        Mon,  1 Nov 2021 09:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758592;
        bh=JrZKr1S745qfprtNEnIGuFOkwlBI9Jkb0l9vvrwhGCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZK2AMuCVNBMoqk0Dqkjg0RcDREeTnGzsJUgOdf4YG6pAPQ296xXnyVnAPBNs78SH
         azkBBud3YxZ++QtZ21o42OEZMyAQUoVrvWTrc2jp433LDuEHGOPTCeQixhnGtx/WLg
         isIhSLTr27HzwBxsNlSWBppEtmlfEiCgge3CfclI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 28/51] RDMA/mlx5: Set user priority for DCT
Date:   Mon,  1 Nov 2021 10:17:32 +0100
Message-Id: <20211101082506.948243318@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

commit 1ab52ac1e9bc9391f592c9fa8340a6e3e9c36286 upstream.

Currently, the driver doesn't set the PCP-based priority for DCT, hence
DCT response packets are transmitted without user priority.

Fix it by setting user provided priority in the eth_prio field in the DCT
context, which in turn sets the value in the transmitted packet.

Fixes: 776a3906b692 ("IB/mlx5: Add support for DC target QP")
Link: https://lore.kernel.org/r/5fd2d94a13f5742d8803c218927322257d53205c.1633512672.git.leonro@nvidia.com
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/qp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3865,6 +3865,8 @@ static int mlx5_ib_modify_dct(struct ib_
 		MLX5_SET(dctc, dctc, mtu, attr->path_mtu);
 		MLX5_SET(dctc, dctc, my_addr_index, attr->ah_attr.grh.sgid_index);
 		MLX5_SET(dctc, dctc, hop_limit, attr->ah_attr.grh.hop_limit);
+		if (attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE)
+			MLX5_SET(dctc, dctc, eth_prio, attr->ah_attr.sl & 0x7);
 
 		err = mlx5_core_create_dct(dev->mdev, &qp->dct.mdct, qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in), out,


