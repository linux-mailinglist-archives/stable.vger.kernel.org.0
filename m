Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDC5582FED
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiG0Raj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241977AbiG0R21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:28:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854717FE51;
        Wed, 27 Jul 2022 09:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDDDC60DDB;
        Wed, 27 Jul 2022 16:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E662BC433D6;
        Wed, 27 Jul 2022 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940443;
        bh=wNWaaf9ZVTOkTXZushfipplNyncTlNCML5XFMyU0joc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxpKXnzCYhPCkpwESwpX41NT6KQS6sjKYyfjQaUrHMB2j7xEU1n8Mi7rFq975TqKT
         /vuY7zDh4L8auHj8YCUlmdsf7WDnMNBZMSChDNdVmv6UXV1R0O6hzmvbPXb5j+eYxc
         JRNd6aNHQ36Z09gk0SLpeP+RHmWq4cDr/nviVUhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 024/158] RDMA/irdma: Fix sleep from invalid context BUG
Date:   Wed, 27 Jul 2022 18:11:28 +0200
Message-Id: <20220727161022.437017263@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit cc0315564d6eec91c716d314b743321be24c70b3 ]

Taking the qos_mutex to process RoCEv2 QP's on netdev events causes a
kernel splat.

Fix this by removing the handling for RoCEv2 in
irdma_cm_teardown_connections that uses the mutex. This handling is only
needed for iWARP to avoid having connections established while the link is
down or having connections remain functional after the IP address is
removed.

  BUG: sleeping function called from invalid context at kernel/locking/mutex.
  Call Trace:
  kernel: dump_stack+0x66/0x90
  kernel: ___might_sleep.cold.92+0x8d/0x9a
  kernel: mutex_lock+0x1c/0x40
  kernel: irdma_cm_teardown_connections+0x28e/0x4d0 [irdma]
  kernel: ? check_preempt_curr+0x7a/0x90
  kernel: ? select_idle_sibling+0x22/0x3c0
  kernel: ? select_task_rq_fair+0x94c/0xc90
  kernel: ? irdma_exec_cqp_cmd+0xc27/0x17c0 [irdma]
  kernel: ? __wake_up_common+0x7a/0x190
  kernel: irdma_if_notify+0x3cc/0x450 [irdma]
  kernel: ? sched_clock_cpu+0xc/0xb0
  kernel: irdma_inet6addr_event+0xc6/0x150 [irdma]

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 50 --------------------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 638bf4a1ed94..646fa8677490 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -4231,10 +4231,6 @@ void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
 	struct irdma_cm_node *cm_node;
 	struct list_head teardown_list;
 	struct ib_qp_attr attr;
-	struct irdma_sc_vsi *vsi = &iwdev->vsi;
-	struct irdma_sc_qp *sc_qp;
-	struct irdma_qp *qp;
-	int i;
 
 	INIT_LIST_HEAD(&teardown_list);
 
@@ -4251,52 +4247,6 @@ void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
 			irdma_cm_disconn(cm_node->iwqp);
 		irdma_rem_ref_cm_node(cm_node);
 	}
-	if (!iwdev->roce_mode)
-		return;
-
-	INIT_LIST_HEAD(&teardown_list);
-	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
-		mutex_lock(&vsi->qos[i].qos_mutex);
-		list_for_each_safe (list_node, list_core_temp,
-				    &vsi->qos[i].qplist) {
-			u32 qp_ip[4];
-
-			sc_qp = container_of(list_node, struct irdma_sc_qp,
-					     list);
-			if (sc_qp->qp_uk.qp_type != IRDMA_QP_TYPE_ROCE_RC)
-				continue;
-
-			qp = sc_qp->qp_uk.back_qp;
-			if (!disconnect_all) {
-				if (nfo->ipv4)
-					qp_ip[0] = qp->udp_info.local_ipaddr[3];
-				else
-					memcpy(qp_ip,
-					       &qp->udp_info.local_ipaddr[0],
-					       sizeof(qp_ip));
-			}
-
-			if (disconnect_all ||
-			    (nfo->vlan_id == (qp->udp_info.vlan_tag & VLAN_VID_MASK) &&
-			     !memcmp(qp_ip, ipaddr, nfo->ipv4 ? 4 : 16))) {
-				spin_lock(&iwdev->rf->qptable_lock);
-				if (iwdev->rf->qp_table[sc_qp->qp_uk.qp_id]) {
-					irdma_qp_add_ref(&qp->ibqp);
-					list_add(&qp->teardown_entry,
-						 &teardown_list);
-				}
-				spin_unlock(&iwdev->rf->qptable_lock);
-			}
-		}
-		mutex_unlock(&vsi->qos[i].qos_mutex);
-	}
-
-	list_for_each_safe (list_node, list_core_temp, &teardown_list) {
-		qp = container_of(list_node, struct irdma_qp, teardown_entry);
-		attr.qp_state = IB_QPS_ERR;
-		irdma_modify_qp_roce(&qp->ibqp, &attr, IB_QP_STATE, NULL);
-		irdma_qp_rem_ref(&qp->ibqp);
-	}
 }
 
 /**
-- 
2.35.1



