Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F5A3288BA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbhCARnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238865AbhCARjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:39:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D15664FC1;
        Mon,  1 Mar 2021 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617762;
        bh=6JljrjbqFNtzi9qI077mRgAsGYw0Ub6NmU7EzQY+wD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9XtobJaFWehsPtO4jVL2VwI4qFpZprKMgXYx6gmK1cELa3Nlx6EafKmeMtnJUumX
         c+bDuUGvYq7+w8hDL+HKQeIL4gr9Z66WQc8OBRqllTSmpNaDckILmvwFpNid86KFqJ
         Jn6DhlYyyR9zOFGciMZsAESBmWNfQWaMbpZzI0Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/340] RDMA/hns: Fixed wrong judgments in the goto branch
Date:   Mon,  1 Mar 2021 17:12:11 +0100
Message-Id: <20210301161057.514672640@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index b5d196c119eec..f23a341400c06 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -848,8 +848,7 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 	return 0;
 
 err_qp_table_free:
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ)
-		hns_roce_cleanup_qp_table(hr_dev);
+	hns_roce_cleanup_qp_table(hr_dev);
 
 err_cq_table_free:
 	hns_roce_cleanup_cq_table(hr_dev);
-- 
2.27.0



