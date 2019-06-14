Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6603C469CE
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfFNUff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbfFNU34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:56 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172C42184D;
        Fri, 14 Jun 2019 20:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544195;
        bh=0gMyo5s7uGc6NxHUF73+Q0JClM20VxjdkUE/l6UHU1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZLxvRNGG94L2RJ7szZMNJsttmYmcQNBJLLqpsWmI4k6kewg7o5tgQjmBGxalhhI1
         lvvUEUxzWh7eEOHgLYv8Jg1ee/buoMAzt9WYGk3X1Zb9kG8f6ovLocxiuRP38VKAFr
         /BL+EAqSJUwwrKskbxSvCO7FkgeMONowA/fQGrNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Josh Collier <josh.d.collier@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/39] IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value
Date:   Fri, 14 Jun 2019 16:29:18 -0400
Message-Id: <20190614202946.27385-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

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
index 48692adbe811..27d9c4cefdc7 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1418,8 +1418,6 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 	rdi->dparms.props.max_cq = hfi1_max_cqs;
 	rdi->dparms.props.max_ah = hfi1_max_ahs;
 	rdi->dparms.props.max_cqe = hfi1_max_cqes;
-	rdi->dparms.props.max_mr = rdi->lkey_table.max;
-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_pd = hfi1_max_pds;
 	rdi->dparms.props.max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 41babbc0db58..803c3544c75b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1495,8 +1495,6 @@ static void qib_fill_device_attr(struct qib_devdata *dd)
 	rdi->dparms.props.max_cq = ib_qib_max_cqs;
 	rdi->dparms.props.max_cqe = ib_qib_max_cqes;
 	rdi->dparms.props.max_ah = ib_qib_max_ahs;
-	rdi->dparms.props.max_mr = rdi->lkey_table.max;
-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
 	rdi->dparms.props.max_qp_init_rd_atom = 255;
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 5819c9d6ffdc..39d101df229d 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -96,6 +96,8 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 	for (i = 0; i < rdi->lkey_table.max; i++)
 		RCU_INIT_POINTER(rdi->lkey_table.table[i], NULL);
 
+	rdi->dparms.props.max_mr = rdi->lkey_table.max;
+	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	return 0;
 }
 
-- 
2.20.1

