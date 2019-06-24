Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D012A506C3
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfFXJ6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbfFXJ6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:58:11 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6887E213F2;
        Mon, 24 Jun 2019 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370290;
        bh=ptRqHiaZJhelNecC+tFPsl0PMujncQwmy8uCPCa8F80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB6e3GGyXY94YfChp65nU9SsiUzUatp0EJjT5HPg+FD7qnyduN+xxlqqTr91hKRIq
         EEjTRmRPlSNEgMLvCf2DuID4xWCTDCuvtFfkVuO9zED6nUu1YheBL6DtTKr8InGagH
         TTBFtzaJFKGhTeBM/DEOW+SOfgi4/aA0EaJqQgqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Collier <josh.d.collier@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/51] IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value
Date:   Mon, 24 Jun 2019 17:56:37 +0800
Message-Id: <20190624092308.445649009@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
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
index 2e8854ba18cf..f4372afa0e81 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1400,8 +1400,6 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 	rdi->dparms.props.max_cq = hfi1_max_cqs;
 	rdi->dparms.props.max_ah = hfi1_max_ahs;
 	rdi->dparms.props.max_cqe = hfi1_max_cqes;
-	rdi->dparms.props.max_mr = rdi->lkey_table.max;
-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_pd = hfi1_max_pds;
 	rdi->dparms.props.max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9d92aeb8d9a1..350bc29a066f 100644
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
index e7013d2d4f0e..d5b51f4cb49a 100644
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



