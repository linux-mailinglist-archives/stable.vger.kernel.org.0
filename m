Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6990637CE23
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhELRDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244147AbhELQmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA96061D13;
        Wed, 12 May 2021 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835859;
        bh=eAm8exWvtmwzeXUrXpSX/iybcqQcYJHSuy4w0m4A/eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ru1tHX88vk5UGH0kILbYen/FraE/twma7sg21oSMzBW6xb1csiyREz5YJOXaTB+d2
         /WbZ/BBfGy6Yu45zMdJ2spXSPC9zV7wrqfQcmIh1QmgZ1co1pcXp384B90HqabMKI1
         cE1DrTqeVmb/+feNPrgyT8qI/gRrK7gSPfX0KCas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 513/677] RDMA/hns: Fix missing assignment of max_inline_data
Date:   Wed, 12 May 2021 16:49:19 +0200
Message-Id: <20210512144854.433593757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 9eab614338cdfe08db343954454fa5191d082a11 ]

When querying QP, the ULPs should be informed of the max length of inline
data supported by the hardware.

Fixes: 30b707886aeb ("RDMA/hns: Support inline data in extented sge space for RC")
Link: https://lore.kernel.org/r/1617354454-47840-3-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ce26f97b2ca2..ad3cee54140e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5068,6 +5068,7 @@ done:
 	qp_attr->cur_qp_state = qp_attr->qp_state;
 	qp_attr->cap.max_recv_wr = hr_qp->rq.wqe_cnt;
 	qp_attr->cap.max_recv_sge = hr_qp->rq.max_gs - hr_qp->rq.rsv_sge;
+	qp_attr->cap.max_inline_data = hr_qp->max_inline_data;
 
 	if (!ibqp->uobject) {
 		qp_attr->cap.max_send_wr = hr_qp->sq.wqe_cnt;
-- 
2.30.2



