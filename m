Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345352C9C3A
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390221AbgLAJO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390164AbgLAJNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5037206C1;
        Tue,  1 Dec 2020 09:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814010;
        bh=2Fo6vi6kCH/5mXrATqVRF6n8re/g7WmJFFgnowkU8M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubZAiJH2zN9Jdciz1J6pYiwBsKsW+KzMutD11thQp+E6dMtmo4zYXO+juTAANzMS6
         kVmBHQ2q1U0I/hPlKYyOJeZQrEYDVvHBdX1GxPeV0krfZchTSDCBedK7JyyX40xyn9
         8IQtdNyrNb/Yly/hu/exQmxMD0fUw+SBZ2Ww820M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixian Liu <liuyixian@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 135/152] RDMA/hns: Bugfix for memory window mtpt configuration
Date:   Tue,  1 Dec 2020 09:54:10 +0100
Message-Id: <20201201084729.504982801@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

[ Upstream commit 17475e104dcb74217c282781817f8f52b46130d3 ]

When a memory window is bound to a memory region, the local write access
should be set for its mtpt table.

Fixes: c7c28191408b ("RDMA/hns: Add MW support for hip08")
Link: https://lore.kernel.org/r/1606386372-21094-1-git-send-email-liweihang@huawei.com
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ccbe12de8e59b..4c02839b7b418 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2738,6 +2738,7 @@ static int hns_roce_v2_mw_write_mtpt(void *mb_buf, struct hns_roce_mw *mw)
 
 	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_R_INV_EN_S, 1);
 	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_L_INV_EN_S, 1);
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_LW_EN_S, 1);
 
 	roce_set_bit(mpt_entry->byte_12_mw_pa, V2_MPT_BYTE_12_PA_S, 0);
 	roce_set_bit(mpt_entry->byte_12_mw_pa, V2_MPT_BYTE_12_MR_MW_S, 1);
-- 
2.27.0



