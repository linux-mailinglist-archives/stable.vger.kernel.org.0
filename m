Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4BC32905C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242588AbhCAUHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242626AbhCATyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B47BF6536B;
        Mon,  1 Mar 2021 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621297;
        bh=CLPtXlB4GU6KgkOvV6314dz6ArOgq21o84ll28Q5A3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lf7B+nD4/0p8vOr6FQpIyJ/Lb0mj2r3jtVomKiXTR9lgaIN+Zn1ZVZrtLcQvtRQDP
         iTL0nNXu/8PieS/eKQkeTm+bYlDBbV+zAKel7Uii5Ye577VVXvU/amdz1RGwHepILt
         8EPS0MTzN1lY/WPgCinnVP74QHQ9MQFTijCsqLgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 434/775] RDMA/hns: Fixed wrong judgments in the goto branch
Date:   Mon,  1 Mar 2021 17:10:02 +0100
Message-Id: <20210301161223.013881583@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit bb74fe7e81c8b2b65c6a351a247fdb9a969cbaec ]

When an error occurs, the qp_table must be cleared, regardless of whether
the SRQ feature is enabled.

Fixes: 5c1f167af112 ("RDMA/hns: Init SRQ table for hip08")
Link: https://lore.kernel.org/r/1611997090-48820-5-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index d9179bae4989d..60822e666f351 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -772,8 +772,7 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 	return 0;
 
 err_qp_table_free:
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ)
-		hns_roce_cleanup_qp_table(hr_dev);
+	hns_roce_cleanup_qp_table(hr_dev);
 
 err_cq_table_free:
 	hns_roce_cleanup_cq_table(hr_dev);
-- 
2.27.0



