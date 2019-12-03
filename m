Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B332A111DE0
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfLCW5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:57:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730594AbfLCW5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 382FB20656;
        Tue,  3 Dec 2019 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413870;
        bh=f22FDCR3WqLNWGLPTUVymr8HLIizD922/Aj4S0NdCNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9+X/18vC6pfTMuvk1BHtSuk3JVfYXNnX8FCjj2w/fMElDhvDWCEygCvw6ZpCclJR
         M9jvmZr5yIhkqSzN3dgTAO8zU42ONRec72DTnT5Ie/UC5MKtN6CaF7V2wSTDe6fA4y
         Jyte2kgSN/Ntd+WE3t/f+ccjOL/eJjpvk4MWDVqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixian Liu <liuyixian@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 257/321] RDMA/hns: Fix the state of rereg mr
Date:   Tue,  3 Dec 2019 23:35:23 +0100
Message-Id: <20191203223440.504039837@linuxfoundation.org>
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

From: Yixian Liu <liuyixian@huawei.com>

[ Upstream commit ab22bf05216a6bb4812448f3a8609489047cf311 ]

The state of mr after reregister operation should be set to valid
state. Otherwise, it will keep the same as the state before reregistered.

Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1eda8a22a4252..a5ec900a14ae9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1776,6 +1776,9 @@ static int hns_roce_v2_rereg_write_mtpt(struct hns_roce_dev *hr_dev,
 	struct hns_roce_v2_mpt_entry *mpt_entry = mb_buf;
 	int ret = 0;
 
+	roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_MPT_ST_M,
+		       V2_MPT_BYTE_4_MPT_ST_S, V2_MPT_ST_VALID);
+
 	if (flags & IB_MR_REREG_PD) {
 		roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_PD_M,
 			       V2_MPT_BYTE_4_PD_S, pdn);
-- 
2.20.1



