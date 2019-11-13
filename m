Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C08FA5A8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfKMCYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbfKMBwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22AD72245D;
        Wed, 13 Nov 2019 01:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609929;
        bh=0fCyDe2XJ+/YJ9Rha8IJWPEjZCdyHlAaygACeS00hbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RurpCokUzEofHBJQTJaxf3kixp7GAKhqa1bNNOCiYhCRO56EXUxMKO/3kg/Gt8n+o
         aLRW2Eit5iOsPQDoeWFJvaOBivMsNOJUkN3vPMgr2SeEHwit53IQ9qZZD0rZoHtCqU
         tG2FJeG3FFOp57hr23LuRtPrSFymH/a55CsyDx+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/209] RDMA/hns: Bugfix for CM test
Date:   Tue, 12 Nov 2019 20:48:11 -0500
Message-Id: <20191113015025.9685-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 15fc056fba7b17b9abfbe80a12f188403fc949fb ]

It will print the warning when the MSB bit of SLID is not zero running
cm_req_handler function that test CM. It needs to fixed zero when test
RoCE device.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ce44a90d2bd3e..b5150d7b953bd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2268,6 +2268,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		wc->src_qp = (u8)roce_get_field(cqe->byte_32,
 						V2_CQE_BYTE_32_RMT_QPN_M,
 						V2_CQE_BYTE_32_RMT_QPN_S);
+		wc->slid = 0;
 		wc->wc_flags |= (roce_get_bit(cqe->byte_32,
 					      V2_CQE_BYTE_32_GRH_S) ?
 					      IB_WC_GRH : 0);
-- 
2.20.1

