Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76474111F09
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfLCXGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfLCWsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC31820656;
        Tue,  3 Dec 2019 22:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413305;
        bh=cWK1kp03Or15lWIONAwKQIPs6G7BvNiBb99QgZGfv+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5eG8xQVh++RcJ5Jxwzuaq/0BG0YtQFdwcu7O52PpW2kCUlF4CfMi1KobdjYnEW4e
         00Bnp67dLjRNPIy2dcEDgyn11DzOYHm4jPQS6VONtG4TUkHwTsudUBH8VXZS9VHBBK
         pIBOeQNlYnGDAWJV2HCV/MNslb6Vi3ZHS44q1erI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/321] RDMA/hns: Fix the bug while use multi-hop of pbl
Date:   Tue,  3 Dec 2019 23:32:22 +0100
Message-Id: <20191203223431.115229525@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 4af07f01f7a787ba5158352b98c9e3cb74995a1c ]

It will prevent multiply overflow when defines the pbl for u64 type.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 41a538d23b802..c68596d4e8037 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -1017,14 +1017,14 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			goto err_umem;
 		}
 	} else {
-		int pbl_size = 1;
+		u64 pbl_size = 1;
 
 		bt_size = (1 << (hr_dev->caps.pbl_ba_pg_sz + PAGE_SHIFT)) / 8;
 		for (i = 0; i < hr_dev->caps.pbl_hop_num; i++)
 			pbl_size *= bt_size;
 		if (n > pbl_size) {
 			dev_err(dev,
-			    " MR len %lld err. MR page num is limited to %d!\n",
+			    " MR len %lld err. MR page num is limited to %lld!\n",
 			    length, pbl_size);
 			ret = -EINVAL;
 			goto err_umem;
-- 
2.20.1



