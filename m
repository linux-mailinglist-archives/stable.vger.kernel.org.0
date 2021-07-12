Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714493C53D7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348842AbhGLH4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350718AbhGLHvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B36615FF;
        Mon, 12 Jul 2021 07:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076064;
        bh=cDnLT8/CMRyw3U3cZG500gRjHVYJjZbCqkC826D5MXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSbOwa0g78Qv/gXaFZlYY2R13WfFrgAPWqqYsjHDskD87T2/eeVzdcdDU1nNWNKzR
         VQtMMTy97ooqOAHS15J/lbhKynZKb4GrjPjbJlzWzzpvkH1CFt8qDP0QlH1V+MsxF+
         mFklQfLId12/wwqFUt7738uOlL4xFyCz1V0CCMkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <wangxi11@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 484/800] RDMA/hns: Clear extended doorbell info before using
Date:   Mon, 12 Jul 2021 08:08:27 +0200
Message-Id: <20210712061018.668072786@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 7e78dd816e458fbc2928a068d70009178d5d070d ]

Both of HIP08 and HIP09 require the extended doorbell information to be
cleared before being used.

Fixes: 6b63597d3540 ("RDMA/hns: Add TSQ link table support")
Link: https://lore.kernel.org/r/1623392089-35639-1-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 21 +++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d7289b6587f1..78f3e05cc1f5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1619,6 +1619,22 @@ static void hns_roce_function_clear(struct hns_roce_dev *hr_dev)
 	}
 }
 
+static int hns_roce_clear_extdb_list_info(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_cmq_desc desc;
+	int ret;
+
+	hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_CLEAR_EXTDB_LIST_INFO,
+				      false);
+	ret = hns_roce_cmq_send(hr_dev, &desc, 1);
+	if (ret)
+		ibdev_err(&hr_dev->ib_dev,
+			  "failed to clear extended doorbell info, ret = %d.\n",
+			  ret);
+
+	return ret;
+}
+
 static int hns_roce_query_fw_ver(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_query_fw_info *resp;
@@ -2732,6 +2748,11 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	int ret;
 
+	/* The hns ROCEE requires the extdb info to be cleared before using */
+	ret = hns_roce_clear_extdb_list_info(hr_dev);
+	if (ret)
+		return ret;
+
 	ret = get_hem_table(hr_dev);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index a2100a629859..028bc41cb45c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -248,6 +248,7 @@ enum hns_roce_opcode_type {
 	HNS_ROCE_OPC_CLR_SCCC				= 0x8509,
 	HNS_ROCE_OPC_QUERY_SCCC				= 0x850a,
 	HNS_ROCE_OPC_RESET_SCCC				= 0x850b,
+	HNS_ROCE_OPC_CLEAR_EXTDB_LIST_INFO		= 0x850d,
 	HNS_ROCE_OPC_QUERY_VF_RES			= 0x850e,
 	HNS_ROCE_OPC_CFG_GMV_TBL			= 0x850f,
 	HNS_ROCE_OPC_CFG_GMV_BT				= 0x8510,
-- 
2.30.2



