Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61312191B4
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfEIS7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbfEISwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E882183E;
        Thu,  9 May 2019 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427935;
        bh=FIXdxNrE9/HrVfQLCvXe/WWdQ3EDi7cCuGjjZ40Gutw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9Mk+pra+OJHxJTDKDosAnvSZqzLXoq7ZGCsErOpA6s8xhU3unHZGpAT9fy+frARM
         9KrREo3OFK4RHX75PPtR1ttXr4BB9b9nEmLnylx1bQnsK3Lw7n/BTrZ80cXdQzoo/P
         3O2T+LqtoiaB1QIMpAKs4d+jZkNyrR6KnNOs0wxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 32/95] IB/hfi1: Fix the allocation of RSM table
Date:   Thu,  9 May 2019 20:41:49 +0200
Message-Id: <20190509181311.548879047@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d0294344470e6b52d097aa7369173f32d11f2f52 ]

The receive side mapping (RSM) on hfi1 hardware is a special
matching mechanism to direct an incoming packet to a given
hardware receive context. It has 4 instances of matching capabilities
(RSM0 - RSM3) that share the same RSM table (RMT). The RMT has a total of
256 entries, each of which points to a receive context.

Currently, three instances of RSM have been used:
1. RSM0 by QOS;
2. RSM1 by PSM FECN;
3. RSM2 by VNIC.

Each RSM instance should reserve enough entries in RMT to function
properly. Since both PSM and VNIC could allocate any receive context
between dd->first_dyn_alloc_ctxt and dd->num_rcv_contexts, PSM FECN must
reserve enough RMT entries to cover the entire receive context index
range (dd->num_rcv_contexts - dd->first_dyn_alloc_ctxt) instead of only
the user receive contexts allocated for PSM
(dd->num_user_contexts). Consequently, the sizing of
dd->num_user_contexts in set_up_context_variables is incorrect.

Fixes: 2280740f01ae ("IB/hfi1: Virtual Network Interface Controller (VNIC) HW support")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index b443642eac021..0ae05e9249b39 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13219,7 +13219,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int total_contexts;
 	int ret;
 	unsigned ngroups;
-	int qos_rmt_count;
+	int rmt_count;
 	int user_rmt_reduced;
 	u32 n_usr_ctxts;
 	u32 send_contexts = chip_send_contexts(dd);
@@ -13281,10 +13281,20 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		n_usr_ctxts = rcv_contexts - total_contexts;
 	}
 
-	/* each user context requires an entry in the RMT */
-	qos_rmt_count = qos_rmt_entries(dd, NULL, NULL);
-	if (qos_rmt_count + n_usr_ctxts > NUM_MAP_ENTRIES) {
-		user_rmt_reduced = NUM_MAP_ENTRIES - qos_rmt_count;
+	/*
+	 * The RMT entries are currently allocated as shown below:
+	 * 1. QOS (0 to 128 entries);
+	 * 2. FECN for PSM (num_user_contexts + num_vnic_contexts);
+	 * 3. VNIC (num_vnic_contexts).
+	 * It should be noted that PSM FECN oversubscribe num_vnic_contexts
+	 * entries of RMT because both VNIC and PSM could allocate any receive
+	 * context between dd->first_dyn_alloc_text and dd->num_rcv_contexts,
+	 * and PSM FECN must reserve an RMT entry for each possible PSM receive
+	 * context.
+	 */
+	rmt_count = qos_rmt_entries(dd, NULL, NULL) + (num_vnic_contexts * 2);
+	if (rmt_count + n_usr_ctxts > NUM_MAP_ENTRIES) {
+		user_rmt_reduced = NUM_MAP_ENTRIES - rmt_count;
 		dd_dev_err(dd,
 			   "RMT size is reducing the number of user receive contexts from %u to %d\n",
 			   n_usr_ctxts,
@@ -14272,9 +14282,11 @@ static void init_user_fecn_handling(struct hfi1_devdata *dd,
 	u64 reg;
 	int i, idx, regoff, regidx;
 	u8 offset;
+	u32 total_cnt;
 
 	/* there needs to be enough room in the map table */
-	if (rmt->used + dd->num_user_contexts >= NUM_MAP_ENTRIES) {
+	total_cnt = dd->num_rcv_contexts - dd->first_dyn_alloc_ctxt;
+	if (rmt->used + total_cnt >= NUM_MAP_ENTRIES) {
 		dd_dev_err(dd, "User FECN handling disabled - too many user contexts allocated\n");
 		return;
 	}
@@ -14328,7 +14340,7 @@ static void init_user_fecn_handling(struct hfi1_devdata *dd,
 	/* add rule 1 */
 	add_rsm_rule(dd, RSM_INS_FECN, &rrd);
 
-	rmt->used += dd->num_user_contexts;
+	rmt->used += total_cnt;
 }
 
 /* Initialize RSM for VNIC */
-- 
2.20.1



