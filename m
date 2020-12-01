Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB882C9C04
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbgLAJOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390204AbgLAJOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E2321D46;
        Tue,  1 Dec 2020 09:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814004;
        bh=vrhCK6X2iUaJHMGsJjbD3BWzwM2rCqHGj3chcMaJe7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaumzDgEYfwA9CL692hQ0Wk3huCs4sxGAf54B4Kv/UvhNyDouHSxoulus5V+IXu6f
         jsN55hrkko2dfxQf6fU87vZFYGGTk7ucuMhXUkgLA5/35XbywnINJA1aykQrONN9tG
         jp/82Pw6Z9B8hjgMdMFo4OjWipqxfocx+Gxxuw+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 133/152] RDMA/hns: Fix wrong field of SRQ number the device supports
Date:   Tue,  1 Dec 2020 09:54:08 +0100
Message-Id: <20201201084729.232382314@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit ebed7b7ca47f3aa95ebf2185a526227744616ac1 ]

The SRQ capacity is got from the firmware, whose field should be ended at
bit 19.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Link: https://lore.kernel.org/r/1606382812-23636-1-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 17f35f91f4ad2..9d27dfe86821b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1639,7 +1639,7 @@ struct hns_roce_query_pf_caps_d {
 	__le32 rsv_uars_rsv_qps;
 };
 #define V2_QUERY_PF_CAPS_D_NUM_SRQS_S 0
-#define V2_QUERY_PF_CAPS_D_NUM_SRQS_M GENMASK(20, 0)
+#define V2_QUERY_PF_CAPS_D_NUM_SRQS_M GENMASK(19, 0)
 
 #define V2_QUERY_PF_CAPS_D_RQWQE_HOP_NUM_S 20
 #define V2_QUERY_PF_CAPS_D_RQWQE_HOP_NUM_M GENMASK(21, 20)
-- 
2.27.0



