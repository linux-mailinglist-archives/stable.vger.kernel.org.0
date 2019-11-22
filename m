Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24727106ECB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfKVK7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfKVK7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E11720706;
        Fri, 22 Nov 2019 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420377;
        bh=iHrSDbtmO6iDPDxEj/3JzV833eWtqf2Bv0P7k8m6R14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXu/dg5aW1uaD2ei0JFD7VHWMD+C/Vyf07mVRgDyGWvqybBFNPu1Ws1Ht5NAA/yty
         FH8+aSApAvsvxhqHQuDFN9ue0SfT7SDiEil1T0ict80xMtHZ9QT6JSEGV2zcoCv4qA
         MYhcoAxhWfpc5+FZs7FPpciEa4LajMu0zRNkS0Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/220] RDMA/hns: Bugfix for CM test
Date:   Fri, 22 Nov 2019 11:27:32 +0100
Message-Id: <20191122100918.844138442@linuxfoundation.org>
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
index c8a3864f19122..7a7232927b126 100644
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



