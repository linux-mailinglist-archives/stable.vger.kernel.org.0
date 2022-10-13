Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A89E5FCFCA
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJMAWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiJMAVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:21:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B7D123466;
        Wed, 12 Oct 2022 17:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA049B81CBE;
        Thu, 13 Oct 2022 00:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8426C433C1;
        Thu, 13 Oct 2022 00:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620294;
        bh=40nMb0QXbyHEzCCs04WjfBquDekogf4DJI5B2dFe7gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqBHgsVvVuCbqSEoLhcYi6Z7EYBkCynKcXw1OIyQOH+Fi4ip6C0KAe8HyE1PVB34E
         xjPtCdLEWs1X4XrkFQopZlWXMHc9BozC04w8oRh3OLb4XAwqz6xM9KI5MkFdLh5zVU
         fP+xbW1a4OBFI2jKvXq0QNnP4nmROkyh5rkPGfCeSdS2ABvW87L0MnBs0ELYOBUSqk
         XK1Pu6dlNLuuZkSa2P9SzD6vVFuk3x2vOWejkcM9CmA8F4QPZDy9LwjnOOdNP8PoJN
         yjJKQDsPmfr28ws70pR7OTHlVXxTEi/qIptNbijW4hrjy30mpC09yirhL/LsW6MtIB
         mwHoiqqgrZrBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, sagi@grimberg.me,
        kch@nvidia.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 58/67] nvmet: don't look at the request_queue in nvmet_bdev_zone_mgmt_emulate_all
Date:   Wed, 12 Oct 2022 20:15:39 -0400
Message-Id: <20221013001554.1892206-58-sashal@kernel.org>
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

[ Upstream commit 8df20252c06046ef4c68107bcaaca56c21028d8c ]

nvmet is a consumer of the block layer and should not directly look at
the request_queue.  Just use the NUMA node ID from the gendisk instead of
the request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/zns.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 835bfda86fcf..1254cf57e008 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -400,7 +400,6 @@ static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
 {
 	struct block_device *bdev = req->ns->bdev;
 	unsigned int nr_zones = bdev_nr_zones(bdev);
-	struct request_queue *q = bdev_get_queue(bdev);
 	struct bio *bio = NULL;
 	sector_t sector = 0;
 	int ret;
@@ -409,7 +408,7 @@ static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
 	};
 
 	d.zbitmap = kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(*(d.zbitmap)),
-				 GFP_NOIO, q->node);
+				 GFP_NOIO, bdev->bd_disk->node_id);
 	if (!d.zbitmap) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.35.1

