Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243F0341C89
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhCSMVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhCSMVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E4064F6A;
        Fri, 19 Mar 2021 12:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156468;
        bh=yzUNqevlFbXe2wFS/Q4U2Es4UX4t22eR83ywGh0/E+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaAKZpMlGwzWbvfxgVzeZR++/kqqlBKPaW28eTBidYEw1x5D2MiJhX2Cvbfh5WbIm
         xxJq4sSAEDb0/EzHZWzQ0FfWqtGvBw6vZdh8wdpGnFL+wafjk3bq4P7cUA6d2L7eBh
         wJ2Phh4U4tgzuyAunXao7+6gFIc8e1hN08MkLpoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 5.11 26/31] RDMA/srp: Fix support for unpopulated and unbalanced NUMA nodes
Date:   Fri, 19 Mar 2021 13:19:20 +0100
Message-Id: <20210319121748.047018321@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  116 ++++++++++++++----------------------
 1 file changed, 48 insertions(+), 68 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3628,7 +3628,7 @@ static ssize_t srp_create_target(struct
 	struct srp_rdma_ch *ch;
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
-	int ret, node_idx, node, cpu, i;
+	int ret, i, ch_idx;
 	unsigned int max_sectors_per_mr, mr_per_cmd = 0;
 	bool multich = false;
 	uint32_t max_iu_len;
@@ -3753,81 +3753,61 @@ static ssize_t srp_create_target(struct
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
-
-			ret = srp_create_ch_ib(ch);
-			if (ret)
-				goto err_disconnect;
-
-			ret = srp_alloc_req_data(ch);
-			if (ret)
-				goto err_disconnect;
-
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
+	for (ch_idx = 0; ch_idx < target->ch_count; ++ch_idx) {
+		ch = &target->ch[ch_idx];
+		ch->target = target;
+		ch->comp_vector = ch_idx % ibdev->num_comp_vectors;
+		spin_lock_init(&ch->lock);
+		INIT_LIST_HEAD(&ch->free_tx);
+		ret = srp_new_cm_id(ch);
+		if (ret)
+			goto err_disconnect;
+
+		ret = srp_create_ch_ib(ch);
+		if (ret)
+			goto err_disconnect;
+
+		ret = srp_alloc_req_data(ch);
+		if (ret)
+			goto err_disconnect;
+
+		ret = srp_connect_ch(ch, max_iu_len, multich);
+		if (ret) {
+			char dst[64];
+
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
 			}
-
-			multich = true;
-			cpu_idx++;
 		}
-		node_idx++;
+		multich = true;
 	}
 
 connected:


