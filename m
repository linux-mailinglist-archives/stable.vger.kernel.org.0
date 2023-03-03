Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA076AA39B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjCCWCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbjCCWAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:00:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5F765105;
        Fri,  3 Mar 2023 13:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E79B81A12;
        Fri,  3 Mar 2023 21:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43519C4339B;
        Fri,  3 Mar 2023 21:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879934;
        bh=mAAWQfEHiJU8oqnbapWIBjR2/+TiM7vVK2p+Y5vtBmc=;
        h=From:To:Cc:Subject:Date:From;
        b=gbYEZ67yvvm532AIU8dJDQ3GMmQR4QZHDx0Yi+/XfTm/dYrWnjMnNcMNGeKo67+jw
         sMavURX565Zt+hEm1FyRnNrXvDvIw+FA5h6YsJ0c2j3GW4dPV78ATyq8xLTbkVIuDw
         Cedz74GHAJwO9eL8k2gAJ0Ea5Mi/ZnZvVSvHIIZq7DaXqWyHLPRyagGiDFuupNjzCQ
         0vMwpeAeUWtFyCpiRC66FFFKZgBlNNjEFu5Bs7d7iVNODvEioJAuo6Kw3HXBEUgFSx
         17nMJ0DK2Yr3qKlo3qIDiDahnvcBnVM3xY55bm0tDe/5HaDqJhcUFizWqxH/0cCYuV
         e7bxJSeLhfQQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/50] IB/hfi1: Update RMT size calculation
Date:   Fri,  3 Mar 2023 16:44:42 -0500
Message-Id: <20230303214531.1450154-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 892ede5a77f337831609fb9c248ac60948061894 ]

Fix possible RMT overflow:  Use the correct netdev size.
Don't allow adjusted user contexts to go negative.

Fix QOS calculation: Send kernel context count as an argument since
dd->n_krcv_queues is not yet set up in earliest call.  Do not include
the control context in the QOS calculation.  Use the same sized
variable to find the max of krcvq[] entries.

Update the RMT count explanation to make more sense.

Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167329106946.1472990.18385495251650939054.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 59 +++++++++++++++++--------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index b0d587254fe66..689921dc3d4a8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1055,7 +1055,7 @@ static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *dd);
 static void dc_shutdown(struct hfi1_devdata *dd);
 static void dc_start(struct hfi1_devdata *dd);
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np);
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
 static int wait_link_transfer_active(struct hfi1_devdata *dd, int wait_ms);
@@ -13361,7 +13361,6 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int ret;
 	unsigned ngroups;
 	int rmt_count;
-	int user_rmt_reduced;
 	u32 n_usr_ctxts;
 	u32 send_contexts = chip_send_contexts(dd);
 	u32 rcv_contexts = chip_rcv_contexts(dd);
@@ -13420,28 +13419,34 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 					 (num_kernel_contexts + n_usr_ctxts),
 					 &node_affinity.real_cpu_mask);
 	/*
-	 * The RMT entries are currently allocated as shown below:
-	 * 1. QOS (0 to 128 entries);
-	 * 2. FECN (num_kernel_context - 1 + num_user_contexts +
-	 *    num_netdev_contexts);
-	 * 3. netdev (num_netdev_contexts).
-	 * It should be noted that FECN oversubscribe num_netdev_contexts
-	 * entries of RMT because both netdev and PSM could allocate any receive
-	 * context between dd->first_dyn_alloc_text and dd->num_rcv_contexts,
-	 * and PSM FECN must reserve an RMT entry for each possible PSM receive
-	 * context.
+	 * RMT entries are allocated as follows:
+	 * 1. QOS (0 to 128 entries)
+	 * 2. FECN (num_kernel_context - 1 [a] + num_user_contexts +
+	 *          num_netdev_contexts [b])
+	 * 3. netdev (NUM_NETDEV_MAP_ENTRIES)
+	 *
+	 * Notes:
+	 * [a] Kernel contexts (except control) are included in FECN if kernel
+	 *     TID_RDMA is active.
+	 * [b] Netdev and user contexts are randomly allocated from the same
+	 *     context pool, so FECN must cover all contexts in the pool.
 	 */
-	rmt_count = qos_rmt_entries(dd, NULL, NULL) + (num_netdev_contexts * 2);
-	if (HFI1_CAP_IS_KSET(TID_RDMA))
-		rmt_count += num_kernel_contexts - 1;
-	if (rmt_count + n_usr_ctxts > NUM_MAP_ENTRIES) {
-		user_rmt_reduced = NUM_MAP_ENTRIES - rmt_count;
-		dd_dev_err(dd,
-			   "RMT size is reducing the number of user receive contexts from %u to %d\n",
-			   n_usr_ctxts,
-			   user_rmt_reduced);
-		/* recalculate */
-		n_usr_ctxts = user_rmt_reduced;
+	rmt_count = qos_rmt_entries(num_kernel_contexts - 1, NULL, NULL)
+		    + (HFI1_CAP_IS_KSET(TID_RDMA) ? num_kernel_contexts - 1
+						  : 0)
+		    + n_usr_ctxts
+		    + num_netdev_contexts
+		    + NUM_NETDEV_MAP_ENTRIES;
+	if (rmt_count > NUM_MAP_ENTRIES) {
+		int over = rmt_count - NUM_MAP_ENTRIES;
+		/* try to squish user contexts, minimum of 1 */
+		if (over >= n_usr_ctxts) {
+			dd_dev_err(dd, "RMT overflow: reduce the requested number of contexts\n");
+			return -EINVAL;
+		}
+		dd_dev_err(dd, "RMT overflow: reducing # user contexts from %u to %u\n",
+			   n_usr_ctxts, n_usr_ctxts - over);
+		n_usr_ctxts -= over;
 	}
 
 	/* the first N are kernel contexts, the rest are user/netdev contexts */
@@ -14298,15 +14303,15 @@ static void clear_rsm_rule(struct hfi1_devdata *dd, u8 rule_index)
 }
 
 /* return the number of RSM map table entries that will be used for QOS */
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np)
 {
 	int i;
 	unsigned int m, n;
-	u8 max_by_vl = 0;
+	uint max_by_vl = 0;
 
 	/* is QOS active at all? */
-	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
+	if (n_krcv_queues < MIN_KERNEL_KCTXTS ||
 	    num_vls == 1 ||
 	    krcvqsset <= 1)
 		goto no_qos;
@@ -14364,7 +14369,7 @@ static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 
 	if (!rmt)
 		goto bail;
-	rmt_entries = qos_rmt_entries(dd, &m, &n);
+	rmt_entries = qos_rmt_entries(dd->n_krcv_queues - 1, &m, &n);
 	if (rmt_entries == 0)
 		goto bail;
 	qpns_per_vl = 1 << m;
-- 
2.39.2

