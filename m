Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3022747FECE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhL0Pcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237848AbhL0Pcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:32:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F52C06175B;
        Mon, 27 Dec 2021 07:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D3A61073;
        Mon, 27 Dec 2021 15:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC71C36AE7;
        Mon, 27 Dec 2021 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619160;
        bh=Se7AwcAQc0nrAkErHlTOE5Erp7NrI+Y/XXQsI0zcgvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ek+R9VcyN7HHsRF5eSd5jrLAsVYTNsB0caHirgsq7d4pkAZnDdHvCGWhzGEBV887t
         c7494jQ4anZ5KtODn4XSufScQ6uQgXETm2HSasebU2w4U5Go7bd0xGgBo/hTXr1lOi
         XBX6BTvuhXq9TiJ1y+GTf1xjgvwhzSIX12rh+pzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Federico Motta <federico@willer.it>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.19 03/38] block, bfq: fix asymmetric scenarios detection
Date:   Mon, 27 Dec 2021 16:30:40 +0100
Message-Id: <20211227151319.491542222@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Federico Motta <federico@willer.it>

commit 98fa7a3e001b21fb47c08af4304f40a3b0535cbd upstream.

Since commit 2d29c9f89fcd ("block, bfq: improve asymmetric scenarios
detection"), a scenario is defined asymmetric when one of the
following conditions holds:
- active bfq_queues have different weights
- one or more group of entities (bfq_queue or other groups of entities)
  are active
bfq grants fairness and low latency also in such asymmetric scenarios,
by plugging the dispatching of I/O if the bfq_queue in service happens
to be temporarily idle. This plugging may lower throughput, so it is
important to do it only when strictly needed.

By mistake, in commit '2d29c9f89fcd' ("block, bfq: improve asymmetric
scenarios detection") the num_active_groups counter was firstly
incremented and subsequently decremented at any entity (group or
bfq_queue) weight change.

This is useless, because only transitions from active to inactive and
vice versa matter for that counter. Unfortunately this is also
incorrect in the following case: the entity at issue is a bfq_queue
and it is under weight raising. In fact in this case there is a
spurious increment of the num_active_groups counter.

This spurious increment may cause scenarios to be wrongly detected as
asymmetric, thus causing useless plugging and loss of throughput.

This commit fixes this issue by simply removing the above useless and
wrong increments and decrements.

Fixes: 2d29c9f89fcd ("block, bfq: improve asymmetric scenarios detection")
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Federico Motta <federico@willer.it>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-wf2q.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -792,24 +792,18 @@ __bfq_entity_update_weight_prio(struct b
 		 * queue, remove the entity from its old weight counter (if
 		 * there is a counter associated with the entity).
 		 */
-		if (prev_weight != new_weight) {
-			if (bfqq) {
-				root = &bfqd->queue_weights_tree;
-				__bfq_weights_tree_remove(bfqd, bfqq, root);
-			} else
-				bfqd->num_active_groups--;
+		if (prev_weight != new_weight && bfqq) {
+			root = &bfqd->queue_weights_tree;
+			__bfq_weights_tree_remove(bfqd, bfqq, root);
 		}
 		entity->weight = new_weight;
 		/*
 		 * Add the entity, if it is not a weight-raised queue,
 		 * to the counter associated with its new weight.
 		 */
-		if (prev_weight != new_weight) {
-			if (bfqq && bfqq->wr_coeff == 1) {
-				/* If we get here, root has been initialized. */
-				bfq_weights_tree_add(bfqd, bfqq, root);
-			} else
-				bfqd->num_active_groups++;
+		if (prev_weight != new_weight && bfqq && bfqq->wr_coeff == 1) {
+			/* If we get here, root has been initialized. */
+			bfq_weights_tree_add(bfqd, bfqq, root);
 		}
 
 		new_st->wsum += entity->weight;


