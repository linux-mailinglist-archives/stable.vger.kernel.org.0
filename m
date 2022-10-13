Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26DE5FD035
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiJMAZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJMAXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD44E6F57;
        Wed, 12 Oct 2022 17:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A2A9B81AD1;
        Thu, 13 Oct 2022 00:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B85DC433C1;
        Thu, 13 Oct 2022 00:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620461;
        bh=FzWqlkmIfZ88xJBlNS5dF9AWOlGYzMLuODCBWHb3S3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbVVnCWjrwZE/LmESXc8Yu0Hn2meb8YtxOxphHtrZKqSatqZkx4+n1/VRkLz0E0Vl
         or7A+QN8lHXGHIexEVn2kmkV9mXy1B0T9oJnyD8QHxYFGRobwrWKdJM/Vg7VN639H7
         +2jQWOvezJQE1yEXOIE3HOK9DDePpXilgvrsdytYwdwP9rnUTWsKNvU3nDfTevvq3q
         xl6Nb1JkwvWxp7aZjUVpPwbVEAj2xyu2J9giDLBVRgMKdKGjjo7JAgJg0i5h4ftcbR
         ASn9laf708cj/TTjY/BaKu42/zlJ0ro3tibeT1R31VpZBHFaLejUZlmBe+7Y5uiy+Y
         3aZKJifMj0m6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, sagi@grimberg.me,
        kch@nvidia.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 56/63] nvmet: don't look at the request_queue in nvmet_bdev_set_limits
Date:   Wed, 12 Oct 2022 20:18:30 -0400
Message-Id: <20221013001842.1893243-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 84fe64f898913ef69f70a8d91aea613b5722b63b ]

nvmet is a consumer of the block layer and should not directly look at
the request_queue.  Use the bdev_ helpers to retrieve the device limits
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 27a72504d31c..521fe9469e08 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -12,11 +12,9 @@
 
 void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 {
-	const struct queue_limits *ql = &bdev_get_queue(bdev)->limits;
-	/* Number of logical blocks per physical block. */
-	const u32 lpp = ql->physical_block_size / ql->logical_block_size;
 	/* Logical blocks per physical block, 0's based. */
-	const __le16 lpp0b = to0based(lpp);
+	const __le16 lpp0b = to0based(bdev_physical_block_size(bdev) /
+				      bdev_logical_block_size(bdev));
 
 	/*
 	 * For NVMe 1.2 and later, bit 1 indicates that the fields NAWUN,
@@ -42,11 +40,12 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-	id->npdg = to0based(ql->discard_granularity / ql->logical_block_size);
+	id->npdg = to0based(bdev_discard_granularity(bdev) /
+			    bdev_logical_block_size(bdev));
 	/* NPDG = Namespace Preferred Deallocate Alignment */
 	id->npda = id->npdg;
 	/* NOWS = Namespace Optimal Write Size */
-	id->nows = to0based(ql->io_opt / ql->logical_block_size);
+	id->nows = to0based(bdev_io_opt(bdev) / bdev_logical_block_size(bdev));
 }
 
 void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
-- 
2.35.1

