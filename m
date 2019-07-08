Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5208B624F7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733095AbfGHPSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733089AbfGHPSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1627C216E3;
        Mon,  8 Jul 2019 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599121;
        bh=RZJpHUA9UalKnGKAO5JqPGcAIvPEq94kXoZ+MS4YgaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgRU0l9ld2j4FphJGn2EDr8R9Z3bmjfnRfLH4UCSXqcpmqkMoefjo+G6mrBJh/xD0
         dhnooazroK+otj26lrx2EvHyIXBenpFmVo6gxpt/7WrTNGwz1MMoRduwXl+6tUHKG2
         bp+C2wAoKMHAAihx0Oioo18E/uXUHenDUXyd5BnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Collier <josh.d.collier@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/102] IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value
Date:   Mon,  8 Jul 2019 17:12:06 +0200
Message-Id: <20190708150526.779982731@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 35164f5259a47ea756fa1deb3e463ac2a4f10dc9 ]

The command 'ibv_devinfo -v' reports 0 for max_mr.

Fix by assigning the query values after the mr lkey_table has been built
rather than early on in the driver.

Fixes: 7b1e2099adc8 ("IB/rdmavt: Move memory registration into rdmavt")
Reviewed-by: Josh Collier <josh.d.collier@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c    | 2 --
 drivers/infiniband/hw/qib/qib_verbs.c | 2 --
 drivers/infiniband/sw/rdmavt/mr.c     | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index d9c71750e22d..15054a0cbf6d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1344,8 +1344,6 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 	rdi->dparms.props.max_cq = hfi1_max_cqs;
 	rdi->dparms.props.max_ah = hfi1_max_ahs;
 	rdi->dparms.props.max_cqe = hfi1_max_cqes;
-	rdi->dparms.props.max_mr = rdi->lkey_table.max;
-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_pd = hfi1_max_pds;
 	rdi->dparms.props.max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 954f15064514..d6e183775e24 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1568,8 +1568,6 @@ static void qib_fill_device_attr(struct qib_devdata *dd)
 	rdi->dparms.props.max_cq = ib_qib_max_cqs;
 	rdi->dparms.props.max_cqe = ib_qib_max_cqes;
 	rdi->dparms.props.max_ah = ib_qib_max_ahs;
-	rdi->dparms.props.max_mr = rdi->lkey_table.max;
-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
 	rdi->dparms.props.max_qp_init_rd_atom = 255;
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 49d55a0322f6..dbd4c0d268e9 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -94,6 +94,8 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 	for (i = 0; i < rdi->lkey_table.max; i++)
 		RCU_INIT_POINTER(rdi->lkey_table.table[i], NULL);
 
+	rdi->dparms.props.max_mr = rdi->lkey_table.max;
+	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	return 0;
 }
 
-- 
2.20.1



