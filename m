Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F49451E13
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350976AbhKPAfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344530AbhKOTY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E34A633D6;
        Mon, 15 Nov 2021 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002756;
        bh=zMEjE3Knkr0P5Wz39Ef0JuhVw/WI+mBe+VHqqnnyn7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JP8dr5iliU8RS7saV2BOcYrAQ/HnFUJdvE0TtOSK1dFgYvGQJ25A4OLxDzNNDnggi
         ixHMjf7SnCU9YTJ7W61G+VCTQivDasTdU7zq3sADtam+L/17oKlHh7nlE1ZgWOwj55
         fVkYt2cz/eVqu0XkhuB0vI6yD6XFJyDY8WdXwtEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 685/917] RDMA/hns: Modify the value of MAX_LP_MSG_LEN to meet hardware compatibility
Date:   Mon, 15 Nov 2021 18:03:00 +0100
Message-Id: <20211115165452.126721478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 8e5f0862896ee..a9c6ffef9640f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4399,8 +4399,8 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
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



