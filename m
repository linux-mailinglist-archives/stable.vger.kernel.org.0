Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772154511DE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244539AbhKOTPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:15:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244388AbhKOTOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D3C0634B6;
        Mon, 15 Nov 2021 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000431;
        bh=N7LUOq01zWU37ULwI9wO+7caatsylTJ0EFOwYwfj3uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rG6utlkPVFF8Y7Yc6QPoumvp5MFlYJcSsZSk0R6Q757zNNKPiEdclbR1TsnrN4tCe
         ydZFeY1w82450Gi7AsxbylW7KFbkSHvt1GW3McXCxqMMtKsACYOyqq5Ypiv6Vr296z
         bUbcHB1xQtPZDEDNpM+W3xeWOWJwfVWtl279JkJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 657/849] RDMA/hns: Modify the value of MAX_LP_MSG_LEN to meet hardware compatibility
Date:   Mon, 15 Nov 2021 18:02:20 +0100
Message-Id: <20211115165442.490098622@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 0e60778efb072d47efc7100c4009b5bd97273b0b ]

The upper limit of MAX_LP_MSG_LEN on HIP08 is 64K, and the upper limit on
HIP09 is 16K. Regardless of whether it is HIP08 or HIP09, only 16K will be
used. In order to ensure compatibility, it is unified to 16K.

Setting MAX_LP_MSG_LEN to 16K will not cause performance loss on HIP08.

Fixes: fbed9d2be292 ("RDMA/hns: Fix configuration of ack_req_freq in QPC")
Link: https://lore.kernel.org/r/20211029100537.27299-1-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a77732c218dcb..e2547e8b4d21c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4413,8 +4413,8 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	mtu = ib_mtu_enum_to_int(ib_mtu);
 	if (WARN_ON(mtu <= 0))
 		return -EINVAL;
-#define MAX_LP_MSG_LEN 65536
-	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
+#define MAX_LP_MSG_LEN 16384
+	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 16KB */
 	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
 	if (WARN_ON(lp_pktn_ini >= 0xF))
 		return -EINVAL;
-- 
2.33.0



