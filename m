Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080D92E3C46
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436518AbgL1OAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436517AbgL1OAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37F852064B;
        Mon, 28 Dec 2020 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163989;
        bh=zH0p7sXh7wp21qaP5jCYIIUP3dBks1Gmyl+eph5S5Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jj+xL9hT12rDKy5GXU5YpGavsb62nBUPW1r53ahjivyinqpLQOxR6NOMM5iY1AK1Z
         T0d14NxGTVzXVLEvWYL/V03vn2poZAv+dC4bxwv4XjbSkQKvSLugdNmoqcYjZHZWM7
         hfnAyK3PaIlHhXh2GuRXBc702zRBjZb0ddpOlVWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/717] RDMA/core: Fix error return in _ib_modify_qp()
Date:   Mon, 28 Dec 2020 13:40:20 +0100
Message-Id: <20201228125022.044529198@linuxfoundation.org>
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

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 5333499c6014224756e97fa1a1047dfa592d76d3 ]

Fix to return error code PTR_ERR() from the error handling case instead of
0.

Fixes: 51aab12631dd ("RDMA/core: Get xmit slave for LAG")
Link: https://lore.kernel.org/r/20201016075845.129562-1-jingxiangfeng@huawei.com
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 740f8454b6b46..3d895cc41c3ad 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1698,8 +1698,10 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 			slave = rdma_lag_get_ah_roce_slave(qp->device,
 							   &attr->ah_attr,
 							   GFP_KERNEL);
-			if (IS_ERR(slave))
+			if (IS_ERR(slave)) {
+				ret = PTR_ERR(slave);
 				goto out_av;
+			}
 			attr->xmit_slave = slave;
 		}
 	}
-- 
2.27.0



