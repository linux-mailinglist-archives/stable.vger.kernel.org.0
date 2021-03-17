Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0E533EABC
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 08:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhCQHqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 03:46:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230250AbhCQHq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 03:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615967188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=82gmeAJsvP4hK9AfOTVe8qBR5dhZKAxAXp6V3rDGDkI=;
        b=R7cDexOkAuV+eFkKc8u7JPkbwKz1694hK+oTeS1xUEM9fNwE/lFWVRmT/lCCoiHIYNEc/e
        UO+1R4fqOBf/vZ9ZTHRNT5McmzbxH5aKDUM32YbaoYpQVMm5+o5JxGjtu7Fne67dgrHqib
        JJIkv+p8KPpWffpZNfaYuj5ytJ8TT1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-t9-fT-LXORartMY9Jt65cw-1; Wed, 17 Mar 2021 03:46:26 -0400
X-MC-Unique: t9-fT-LXORartMY9Jt65cw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A938D81746B;
        Wed, 17 Mar 2021 07:46:24 +0000 (UTC)
Received: from dhcp-12-105.nay.redhat.com (unknown [10.66.61.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B7183805;
        Wed, 17 Mar 2021 07:46:22 +0000 (UTC)
From:   Yi Zhang <yi.zhang@redhat.com>
To:     stable@vger.kernel.org
Cc:     jgg@nvidia.com,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] RDMA/srp: Fix support for unpopulated and unbalanced NUMA nodes
Date:   Wed, 17 Mar 2021 15:45:34 +0800
Message-Id: <20210317074532.26312-1-yi.zhang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>

This patch fixed one kernel NULL pointer issue with blktests srp/005

----------

From: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>

commit 2b5715fc17386a6223490d5b8f08d031999b0c0b upstream.

The current code computes a number of channels per SRP target and spreads
them equally across all online NUMA nodes.  Each channel is then assigned
a CPU within this node.

In the case of unbalanced, or even unpopulated nodes, some channels do not
get a CPU associated and thus do not get connected.  This causes the SRP
connection to fail.

This patch solves the issue by rewriting channel computation and
allocation:

- Drop channel to node/CPU association as it had no real effect on
  locality but added unnecessary complexity.

- Tweak the number of channels allocated to reduce CPU contention when
  possible:
  - Up to one channel per CPU (instead of up to 4 by node)
  - At least 4 channels per node, unless ch_count module parameter is
    used.

Link: https://lore.kernel.org/r/9cb4d9d3-30ad-2276-7eff-e85f7ddfb411@suse.com
Signed-off-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 110 ++++++++++++----------------
 1 file changed, 45 insertions(+), 65 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5492b66a8153..31f8aa2c40ed 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3628,7 +3628,7 @@ static ssize_t srp_create_target(struct device *dev,
 	struct srp_rdma_ch *ch;
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
-	int ret, node_idx, node, cpu, i;
+	int ret, i, ch_idx;
 	unsigned int max_sectors_per_mr, mr_per_cmd = 0;
 	bool multich = false;
 	uint32_t max_iu_len;
@@ -3753,81 +3753,61 @@ static ssize_t srp_create_target(struct device *dev,
 		goto out;
 
 	ret = -ENOMEM;
-	if (target->ch_count == 0)
+	if (target->ch_count == 0) {
 		target->ch_count =
-			max_t(unsigned int, num_online_nodes(),
-			      min(ch_count ?:
-					  min(4 * num_online_nodes(),
-					      ibdev->num_comp_vectors),
-				  num_online_cpus()));
+			min(ch_count ?:
+				max(4 * num_online_nodes(),
+				    ibdev->num_comp_vectors),
+				num_online_cpus());
+	}
+
 	target->ch = kcalloc(target->ch_count, sizeof(*target->ch),
 			     GFP_KERNEL);
 	if (!target->ch)
 		goto out;
 
-	node_idx = 0;
-	for_each_online_node(node) {
-		const int ch_start = (node_idx * target->ch_count /
-				      num_online_nodes());
-		const int ch_end = ((node_idx + 1) * target->ch_count /
-				    num_online_nodes());
-		const int cv_start = node_idx * ibdev->num_comp_vectors /
-				     num_online_nodes();
-		const int cv_end = (node_idx + 1) * ibdev->num_comp_vectors /
-				   num_online_nodes();
-		int cpu_idx = 0;
-
-		for_each_online_cpu(cpu) {
-			if (cpu_to_node(cpu) != node)
-				continue;
-			if (ch_start + cpu_idx >= ch_end)
-				continue;
-			ch = &target->ch[ch_start + cpu_idx];
-			ch->target = target;
-			ch->comp_vector = cv_start == cv_end ? cv_start :
-				cv_start + cpu_idx % (cv_end - cv_start);
-			spin_lock_init(&ch->lock);
-			INIT_LIST_HEAD(&ch->free_tx);
-			ret = srp_new_cm_id(ch);
-			if (ret)
-				goto err_disconnect;
+	for (ch_idx = 0; ch_idx < target->ch_count; ++ch_idx) {
+		ch = &target->ch[ch_idx];
+		ch->target = target;
+		ch->comp_vector = ch_idx % ibdev->num_comp_vectors;
+		spin_lock_init(&ch->lock);
+		INIT_LIST_HEAD(&ch->free_tx);
+		ret = srp_new_cm_id(ch);
+		if (ret)
+			goto err_disconnect;
 
-			ret = srp_create_ch_ib(ch);
-			if (ret)
-				goto err_disconnect;
+		ret = srp_create_ch_ib(ch);
+		if (ret)
+			goto err_disconnect;
 
-			ret = srp_alloc_req_data(ch);
-			if (ret)
-				goto err_disconnect;
+		ret = srp_alloc_req_data(ch);
+		if (ret)
+			goto err_disconnect;
 
-			ret = srp_connect_ch(ch, max_iu_len, multich);
-			if (ret) {
-				char dst[64];
-
-				if (target->using_rdma_cm)
-					snprintf(dst, sizeof(dst), "%pIS",
-						 &target->rdma_cm.dst);
-				else
-					snprintf(dst, sizeof(dst), "%pI6",
-						 target->ib_cm.orig_dgid.raw);
-				shost_printk(KERN_ERR, target->scsi_host,
-					     PFX "Connection %d/%d to %s failed\n",
-					     ch_start + cpu_idx,
-					     target->ch_count, dst);
-				if (node_idx == 0 && cpu_idx == 0) {
-					goto free_ch;
-				} else {
-					srp_free_ch_ib(target, ch);
-					srp_free_req_data(target, ch);
-					target->ch_count = ch - target->ch;
-					goto connected;
-				}
-			}
+		ret = srp_connect_ch(ch, max_iu_len, multich);
+		if (ret) {
+			char dst[64];
 
-			multich = true;
-			cpu_idx++;
+			if (target->using_rdma_cm)
+				snprintf(dst, sizeof(dst), "%pIS",
+					&target->rdma_cm.dst);
+			else
+				snprintf(dst, sizeof(dst), "%pI6",
+					target->ib_cm.orig_dgid.raw);
+			shost_printk(KERN_ERR, target->scsi_host,
+				PFX "Connection %d/%d to %s failed\n",
+				ch_idx,
+				target->ch_count, dst);
+			if (ch_idx == 0) {
+				goto free_ch;
+			} else {
+				srp_free_ch_ib(target, ch);
+				srp_free_req_data(target, ch);
+				target->ch_count = ch - target->ch;
+				goto connected;
+			}
 		}
-		node_idx++;
+		multich = true;
 	}
 
 connected:
-- 
2.21.0

