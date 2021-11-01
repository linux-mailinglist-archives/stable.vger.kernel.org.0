Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0524416A0
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhKAJ10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhKAJYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1585961183;
        Mon,  1 Nov 2021 09:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758494;
        bh=OKgFzT+ff7Eb5jtF/i4f0G0JbXhRs77iLv9F64WHIa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHnBULs0CJqcEXBHk25H0lkWwDF4Bv4IZHq5H9HMpXBwmx0Six81LCBXr4sztL9WX
         F1Nf38MA6NpYESyNZMKcR92WxLT/C0U1GsSR5SXMJ8kLtOGWQUaBBi8DHblHho0ejV
         POiD8A8hosdfsv4SROGnuGFc6yCqHbtcRYYyQOSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.19 22/35] RDMA/mlx5: Set user priority for DCT
Date:   Mon,  1 Nov 2021 10:17:34 +0100
Message-Id: <20211101082456.830795816@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
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
@@ -3387,6 +3387,8 @@ static int mlx5_ib_modify_dct(struct ib_
 		MLX5_SET(dctc, dctc, mtu, attr->path_mtu);
 		MLX5_SET(dctc, dctc, my_addr_index, attr->ah_attr.grh.sgid_index);
 		MLX5_SET(dctc, dctc, hop_limit, attr->ah_attr.grh.hop_limit);
+		if (attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE)
+			MLX5_SET(dctc, dctc, eth_prio, attr->ah_attr.sl & 0x7);
 
 		err = mlx5_core_create_dct(dev->mdev, &qp->dct.mdct, qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in));


