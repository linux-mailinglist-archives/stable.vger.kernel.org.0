Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AE21ECC7C
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 11:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgFCJVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 05:21:53 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:21495 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgFCJVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 05:21:53 -0400
Received: from moto.blr.asicdesigners.com (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0539LFJZ004971;
        Wed, 3 Jun 2020 02:21:20 -0700
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de, gregkh@linuxfoundation.org
Cc:     nirranjan@chelsio.com, bharat@chelsio.com,
        Dakshaja Uppalapati <dakshaja@chelsio.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH nvme] nvme: Revert "nvme: Discard workaround for non-conformant devices"
Date:   Wed,  3 Jun 2020 14:48:51 +0530
Message-Id: <20200603091851.16957-1-dakshaja@chelsio.com>
X-Mailer: git-send-email 2.18.0.232.gb7bd9486b.dirty
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts upstream 'commit 530436c45ef2
("nvme: Discard workaround for non-conformant devices")'

Since commit `530436c45ef2` introduced a regression due to which
blk_update_request IO error is observed on formatting device, reverting it.

Fixes: 530436c45ef2 ("nvme: Discard workaround for non-conformant devices")
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
---
 drivers/nvme/host/core.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f3c037f5a9ba..ec598a86f88e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -607,14 +607,8 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	struct nvme_dsm_range *range;
 	struct bio *bio;
 
-	/*
-	 * Some devices do not consider the DSM 'Number of Ranges' field when
-	 * determining how much data to DMA. Always allocate memory for maximum
-	 * number of segments to prevent device reading beyond end of buffer.
-	 */
-	static const size_t alloc_size = sizeof(*range) * NVME_DSM_MAX_RANGES;
-
-	range = kzalloc(alloc_size, GFP_ATOMIC | __GFP_NOWARN);
+	range = kmalloc_array(segments, sizeof(*range),
+			      GFP_ATOMIC | __GFP_NOWARN);
 	if (!range) {
 		/*
 		 * If we fail allocation our range, fallback to the controller
@@ -654,7 +648,7 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 
 	req->special_vec.bv_page = virt_to_page(range);
 	req->special_vec.bv_offset = offset_in_page(range);
-	req->special_vec.bv_len = alloc_size;
+	req->special_vec.bv_len = sizeof(*range) * segments;
 	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	return BLK_STS_OK;
-- 
2.18.0.232.gb7bd9486b.dirty

