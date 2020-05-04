Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570241C448F
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732212AbgEDSH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732211AbgEDSH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B198520721;
        Mon,  4 May 2020 18:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615676;
        bh=ds1Jxau9BSf+D3cDbxpy7Qio3XbI/M2VHzL83wDBhyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF27ETN0+K5CB+5/e7HzDA5JQalgr4cY0s6NVjMoLtCSXp31YENK1fDNllkRHqbgt
         N8k18Vsy1Mefu7xVBge5ZdeL4abVMq9s2Ac5pHvMbOAzKjmT4bangFYPJPi9BcOhvq
         W7WG0DofW45djX1OmLaUI7xfMkpK0NJbcyNZbsKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.6 43/73] RDMA/mlx5: Set GRH fields in query QP on RoCE
Date:   Mon,  4 May 2020 19:57:46 +0200
Message-Id: <20200504165508.641327076@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

commit 2d7e3ff7b6f2c614eb21d0dc348957a47eaffb57 upstream.

GRH fields such as sgid_index, hop limit, et. are set in the QP context
when QP is created/modified.

Currently, when query QP is performed, we fill the GRH fields only if the
GRH bit is set in the QP context, but this bit is not set for RoCE. Adjust
the check so we will set all relevant data for the RoCE too.

Since this data is returned to userspace, the below is an ABI regression.

Fixes: d8966fcd4c25 ("IB/core: Use rdma_ah_attr accessor functions")
Link: https://lore.kernel.org/r/20200413132028.930109-1-leon@kernel.org
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5545,7 +5545,9 @@ static void to_rdma_ah_attr(struct mlx5_
 	rdma_ah_set_path_bits(ah_attr, path->grh_mlid & 0x7f);
 	rdma_ah_set_static_rate(ah_attr,
 				path->static_rate ? path->static_rate - 5 : 0);
-	if (path->grh_mlid & (1 << 7)) {
+
+	if (path->grh_mlid & (1 << 7) ||
+	    ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		u32 tc_fl = be32_to_cpu(path->tclass_flowlabel);
 
 		rdma_ah_set_grh(ah_attr, NULL,


