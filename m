Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010C0147D7E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgAXKBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgAXKBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:01:12 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E364206D5;
        Fri, 24 Jan 2020 10:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860072;
        bh=TUJ0KRCeqMmnh+ZN/Rv4Y/URCU1bF2q4D6buvfRgvCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5HlN0/GNCrqrcVIfL15pk6RcmqrBH1aUFK4sdg2qP2Y7uDEARsf7UI8/I3ghBmfg
         ALqEUvY6njDhvJcYUJNdzNOAItLY0aKtGyypN7KdNjoTppUs7q5T42kAH9mdPUMP3x
         27fnOMDolRj9NF30BtRG4fnyi2sGwayRtS+tGoo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <wangxi11@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 252/343] RDMA/hns: Fixs hw access invalid dma memory error
Date:   Fri, 24 Jan 2020 10:31:10 +0100
Message-Id: <20200124092953.211705914@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit ec5bc2cc69b4fc494e04d10fc5226f6f9cf67c56 ]

When smmu is enable, if execute the perftest command and then use 'kill
-9' to exit, follow this operation repeatedly, the kernel will have a high
probability to print the following smmu event:

  arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00007d0000000010
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000020900000080
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000f47cf000
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000f47cf000

This is because the hw will periodically refresh the qpc cache until the
next reset.

This patch fixed it by removing the action that release qpc memory in the
'hns_roce_qp_free' function.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 3a37d26889df1..281e9987ffc83 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -241,7 +241,6 @@ void hns_roce_qp_free(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 
 	if ((hr_qp->ibqp.qp_type) != IB_QPT_GSI) {
 		hns_roce_table_put(hr_dev, &qp_table->irrl_table, hr_qp->qpn);
-		hns_roce_table_put(hr_dev, &qp_table->qp_table, hr_qp->qpn);
 	}
 }
 
-- 
2.20.1



