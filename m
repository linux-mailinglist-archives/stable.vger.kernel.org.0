Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FE5FCFEA
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJMAYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJMAXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD132CDF1;
        Wed, 12 Oct 2022 17:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39DE7616B6;
        Thu, 13 Oct 2022 00:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BD7C43470;
        Thu, 13 Oct 2022 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620295;
        bh=a1NmIaOeyYaTxwOAA1EU/07zKuDViUH5GJZYzsjpOSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZaX5GcVuv8kvLOf1N2bj4mr1Tko+b5F9R7nbezPiNGW7A8Xgr7/6WBmTITUIK8Tl
         0CFLePSWbRYxzaq1gcEXFL3kDcgnRtRXIy5ypfbMAlM46VftGj0g1OnVFQSyCEoTHm
         M/ViZdCuYNqYNm/EYggsTP9NZ23eND23CGi6y9SJe1v3bCNCSuIjqyfkgi2RO0lovB
         cyqMcmFZLEQbau5evwKQ7A9BOKkt4Ishiebsp09337D9A1yyKInB0ShXNmDLga7v8T
         tYNRMIMmD451swUCznTU3ptTdxlNlB3bvJMt6Z9sdBw7A811UAIu8SHuP4do1FvGx/
         Uy2hRzJCrwB8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, sagi@grimberg.me,
        kch@nvidia.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 59/67] nvmet: don't look at the request_queue in nvmet_bdev_set_limits
Date:   Wed, 12 Oct 2022 20:15:40 -0400
Message-Id: <20221013001554.1892206-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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
index 2dc1c1035626..77c20c0db9d5 100644
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

