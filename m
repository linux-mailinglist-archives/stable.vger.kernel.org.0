Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C482E3D19
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439616AbgL1OLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439608AbgL1OLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F249620791;
        Mon, 28 Dec 2020 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164642;
        bh=BqJwRxP8ZzfzyNkfWQlO8MWhnedBFyBNcvCiWPOYyBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nddhm28VF61Y3VZ9+knXiJmixHBcLQ1ZD+88o/51XCLpNbpLqdYvdLxji9VplHi74
         TAubaxBcWHIzIRjZ4XVna0pHaPMHiqGDYds5q12jnMO36dKuPgNraq818AYcuBf/0Q
         UdwAOYZea0oRrefOh+Z/H8fIYHmdGsivuRyfR0PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/717] RDMA/hns: Avoid setting loopback indicator when smac is same as dmac
Date:   Mon, 28 Dec 2020 13:43:34 +0100
Message-Id: <20201228125031.325146544@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 3631dadfb118821236098a215e59fb5d3e1c30a8 ]

The loopback flag will be set to 1 by the hardware when the source mac
address is same as the destination mac address. So the driver don't need
to compare them.

Fixes: d6a3627e311c ("RDMA/hns: Optimize wqe buffer set flow for post send")
Link: https://lore.kernel.org/r/1605526408-6936-4-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d127e0e4c3cda..4db7eea3dcec5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -433,8 +433,6 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	unsigned int curr_idx = *sge_idx;
 	int valid_num_sge;
 	u32 msg_len = 0;
-	bool loopback;
-	u8 *smac;
 	int ret;
 
 	valid_num_sge = calc_wr_sge_num(wr, &msg_len);
@@ -457,13 +455,6 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	roce_set_field(ud_sq_wqe->byte_48, V2_UD_SEND_WQE_BYTE_48_DMAC_5_M,
 		       V2_UD_SEND_WQE_BYTE_48_DMAC_5_S, ah->av.mac[5]);
 
-	/* MAC loopback */
-	smac = (u8 *)hr_dev->dev_addr[qp->port];
-	loopback = ether_addr_equal_unaligned(ah->av.mac, smac) ? 1 : 0;
-
-	roce_set_bit(ud_sq_wqe->byte_40,
-		     V2_UD_SEND_WQE_BYTE_40_LBI_S, loopback);
-
 	ud_sq_wqe->msg_len = cpu_to_le32(msg_len);
 
 	/* Set sig attr */
-- 
2.27.0



