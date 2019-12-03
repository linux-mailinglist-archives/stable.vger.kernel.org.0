Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C91111DE4
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfLCW6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbfLCW6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC3420656;
        Tue,  3 Dec 2019 22:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413881;
        bh=BBuT6WcOlJ5I5KToApIymCv4XRE2claoTNM1LLNUSx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbeDX6tGz1Gz50j9NWG97zSkySFeW/x9fUbrFB8sk4+nFYTLijpqLLXNYcFvFIRy6
         shE/38o0xS3OpPBxrxerJMntaGLbGI0HIlwwXz4RK2rBkajQAMW5DtPApi84fCG7Bs
         MPVeYXmHVwVQpUQFWe+oOc9tpnqsVb2pGRjgbuTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 258/321] RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp
Date:   Tue,  3 Dec 2019 23:35:24 +0100
Message-Id: <20191203223440.555593418@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 4e69cf1fe2c52d189acdd06c1fd99cc258aba61f ]

The the below commit, hns_roce_v2_modify_qp is called inside spinlock
while using GFP_KERNEL. Change it to GFP_ATOMIC.

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a5ec900a14ae9..7021444f18b46 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3446,7 +3446,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	struct device *dev = hr_dev->dev;
 	int ret = -EINVAL;
 
-	context = kcalloc(2, sizeof(*context), GFP_KERNEL);
+	context = kcalloc(2, sizeof(*context), GFP_ATOMIC);
 	if (!context)
 		return -ENOMEM;
 
-- 
2.20.1



