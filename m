Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A598E13E14E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAPQsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgAPQsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93F63214AF;
        Thu, 16 Jan 2020 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193330;
        bh=B6DUPrTdQ9hfcdz+6dm4drQdGXJjR4qDpjWxewy2T2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EodHKl7uOG0S8+rfSZ1qA9jN3/Lala6mDKselRE35iM7Lbqx/ZZfS86SAlcMXvltj
         GNtDyU/V8eDYPqZTdjW2ENLS+bdSlzEaJg7cHmUKOBNcizxUewqHhnoDvYVP4cMrtD
         E+cV1Qf6GSq/2/HL1X6LNWJGwtyyLLLMMPrxNyPo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 076/205] RDMA/hns: Bugfix for qpc/cqc timer configuration
Date:   Thu, 16 Jan 2020 11:40:51 -0500
Message-Id: <20200116164300.6705-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit 887803db866a7a4e1817a3cb8a3eee4e9879fed2 ]

qpc/cqc timer entry size needs one page, but currently they are fixedly
configured to 4096, which is not appropriate in 64K page scenarios. So
they should be modified to PAGE_SIZE.

Fixes: 0e40dc2f70cd ("RDMA/hns: Add timer allocation support for hip08")
Link: https://lore.kernel.org/r/1571908917-16220-3-git-send-email-liweihang@hisilicon.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 43219d2f7de0..76a14db7028d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -87,8 +87,8 @@
 #define HNS_ROCE_V2_MTT_ENTRY_SZ		64
 #define HNS_ROCE_V2_CQE_ENTRY_SIZE		32
 #define HNS_ROCE_V2_SCCC_ENTRY_SZ		32
-#define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		4096
-#define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		4096
+#define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		PAGE_SIZE
+#define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_INVALID_LKEY			0x100
-- 
2.20.1

