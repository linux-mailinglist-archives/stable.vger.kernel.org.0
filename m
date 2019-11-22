Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92D7106EDC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfKVK7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfKVK7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08D9C2073F;
        Fri, 22 Nov 2019 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420374;
        bh=NYihL1uFTwIweITVkwcy2TUbxQBpKIxwrTjikLGmq8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTFTCmXBNLmFRt4dop9AyFI98kPkuNd+aMFyeq85mycTQ2z562HEkw0CVPsToHb3F
         S6/VCqK8TbrJgm3GyCW2x+OLtBrShNnj1mCZnhYTkNMnAEG1QEnN9LjYSzkRj9Ow50
         5vtTdmPZoNIXgtSKzBaNYashi5RpDO2sa5buqYGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/220] RDMA/hns: Submit bad wr when post send wr exception
Date:   Fri, 22 Nov 2019 11:27:31 +0100
Message-Id: <20191122100918.747691647@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit c80e066100b5fed722c8da67c1bd2312e7bcf129 ]

When user issues a RDMA read and enables sq inline, it needs to report a
bad wr to user.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4e1465dbad91c..c8a3864f19122 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -121,6 +121,7 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		}
 
 		if (wr->opcode == IB_WR_RDMA_READ) {
+			*bad_wr =  wr;
 			dev_err(hr_dev->dev, "Not support inline data!\n");
 			return -EINVAL;
 		}
-- 
2.20.1



