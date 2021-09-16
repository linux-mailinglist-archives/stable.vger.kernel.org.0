Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0224740E658
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbhIPRVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351008AbhIPRSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6716A61A0A;
        Thu, 16 Sep 2021 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810449;
        bh=iLuBPChP8CnU6bCYsrI2zTFECfXArob8xnTlED8KBIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGCkruLRsq7RldVpZtH9ymT4lhi95J/5TbVJdKPZtVhAR0XxMFVVoJ0jq92tx7OAf
         8M3gA7W+GZiCh7WANKlHMy4YWMHBcaN1R/dCrKN6gu2u6JSH9oR2c8z0A532KWlnfR
         wdJlpSFXhi+ew9Fsa+79Fr5i0OyAz3audtT5mdT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/432] RDMA/hns: Ownerbit mode add control field
Date:   Thu, 16 Sep 2021 17:57:57 +0200
Message-Id: <20210916155815.094417837@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit f8c549afd1e76ad78b1d044a307783c9b94ae3ab ]

The ownerbit mode is for external card mode. Make it controlled by the
firmware.

Fixes: aba457ca890c ("RDMA/hns: Support owner mode doorbell")
Link: https://lore.kernel.org/r/1629539607-33217-4-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 594d4cef31b3..0e0be5664137 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4114,6 +4114,9 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 	if (hr_qp->en_flags & HNS_ROCE_QP_CAP_RQ_RECORD_DB)
 		hr_reg_enable(context, QPC_RQ_RECORD_EN);
 
+	if (hr_qp->en_flags & HNS_ROCE_QP_CAP_OWNER_DB)
+		hr_reg_enable(context, QPC_OWNER_MODE);
+
 	hr_reg_write(context, QPC_RQ_DB_RECORD_ADDR_L,
 		     lower_32_bits(hr_qp->rdb.dma) >> 1);
 	hr_reg_write(context, QPC_RQ_DB_RECORD_ADDR_H,
-- 
2.30.2



