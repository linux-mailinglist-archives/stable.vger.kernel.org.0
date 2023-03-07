Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E026AEB14
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjCGRkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjCGRjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3698B98870
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB35861514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1083C433EF;
        Tue,  7 Mar 2023 17:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210552;
        bh=sLfTNoFhbdLlSB+wZ1XKYVxRV1FYTt+K2o2LMzANZPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGweNjIZcWRGMcr6BFYycDcb4vHNQTuB729n+ON92ow19a/CRxuNKDb+6qIo3Pqo5
         fJ7z5x2Jk5Un8atUBaVsA178Gexgo4tpYexAi+I8cYskvZkVv9JAG+yqa/LZjBDnoK
         xXuqd6FiG1SOI97bAZRdZ4YAq4pVJUEz6za40yvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Long Li <longli@microsoft.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0577/1001] RDMA/mana_ib: Fix a bug when the PF indicates more entries for registering memory on first packet
Date:   Tue,  7 Mar 2023 17:55:49 +0100
Message-Id: <20230307170046.506934840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 89d42b8c85b4c67d310c5ccaf491acbf71a260c3 ]

When registering memory in a large chunk that doesn't fit into a single PF
message, the PF may return GDMA_STATUS_MORE_ENTRIES on the first message if
there are more messages needed for registering more chunks.

Fix the VF to make it process the correct return code.

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Link: https://lore.kernel.org/r/1676507522-21018-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 8b3bc302d6f3a..7be4c3adb4e2b 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -249,7 +249,8 @@ static int
 mana_ib_gd_first_dma_region(struct mana_ib_dev *dev,
 			    struct gdma_context *gc,
 			    struct gdma_create_dma_region_req *create_req,
-			    size_t num_pages, mana_handle_t *gdma_region)
+			    size_t num_pages, mana_handle_t *gdma_region,
+			    u32 expected_status)
 {
 	struct gdma_create_dma_region_resp create_resp = {};
 	unsigned int create_req_msg_size;
@@ -261,7 +262,7 @@ mana_ib_gd_first_dma_region(struct mana_ib_dev *dev,
 
 	err = mana_gd_send_request(gc, create_req_msg_size, create_req,
 				   sizeof(create_resp), &create_resp);
-	if (err || create_resp.hdr.status) {
+	if (err || create_resp.hdr.status != expected_status) {
 		ibdev_dbg(&dev->ib_dev,
 			  "Failed to create DMA region: %d, 0x%x\n",
 			  err, create_resp.hdr.status);
@@ -372,14 +373,21 @@ int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
 
 	page_addr_list = create_req->page_addr_list;
 	rdma_umem_for_each_dma_block(umem, &biter, page_sz) {
+		u32 expected_status = 0;
+
 		page_addr_list[tail++] = rdma_block_iter_dma_address(&biter);
 		if (tail < num_pages_to_handle)
 			continue;
 
+		if (num_pages_processed + num_pages_to_handle <
+		    num_pages_total)
+			expected_status = GDMA_STATUS_MORE_ENTRIES;
+
 		if (!num_pages_processed) {
 			/* First create message */
 			err = mana_ib_gd_first_dma_region(dev, gc, create_req,
-							  tail, gdma_region);
+							  tail, gdma_region,
+							  expected_status);
 			if (err)
 				goto out;
 
@@ -392,14 +400,8 @@ int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
 			page_addr_list = add_req->page_addr_list;
 		} else {
 			/* Subsequent create messages */
-			u32 expected_s = 0;
-
-			if (num_pages_processed + num_pages_to_handle <
-			    num_pages_total)
-				expected_s = GDMA_STATUS_MORE_ENTRIES;
-
 			err = mana_ib_gd_add_dma_region(dev, gc, add_req, tail,
-							expected_s);
+							expected_status);
 			if (err)
 				break;
 		}
-- 
2.39.2



