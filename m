Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DF85939DA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244832AbiHOT2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343953AbiHOT0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8856E2A95F;
        Mon, 15 Aug 2022 11:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2685160FB8;
        Mon, 15 Aug 2022 18:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2823C433B5;
        Mon, 15 Aug 2022 18:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588914;
        bh=d9k79EkyQ2/BI9EEkP/6956Vb4q7VWRvrkWKgvW8sIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmHT/nfTnaKx1Op5s8xwdmh2iMc1UQef3ojJgFDWtpKiyRM4v6XHcMG+fbMceDTVx
         qQyA42qmXYnF+PO4EbzlscjF244/uS6ARehaycInHERYPYvcNBnNkfioto9SVfT8Eh
         rmapXrcZnejGi3dnA6VSCIiMqPV5o0ko1kMHvuzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Granados <j.granados@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/779] nvme: catch -ENODEV from nvme_revalidate_zones again
Date:   Mon, 15 Aug 2022 20:03:17 +0200
Message-Id: <20220815180400.976145763@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit e06b425bc835ead08b9fd935bf5e47eef473e7a0 ]

nvme_revalidate_zones can also return -ENODEV if e.g. zone sizes aren't
constant or not a power of two.  In that case we should jump to marking
the gendisk hidden and only support pass through.

Fixes: 602e57c9799c ("nvme: also mark passthrough-only namespaces ready in nvme_update_ns_info")
Reported-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Joel Granados <j.granados@samsung.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ddaad05ff043..ed2740585c5d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1914,8 +1914,10 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 
 	if (ns->head->ids.csi == NVME_CSI_ZNS) {
 		ret = nvme_update_zone_info(ns, lbaf);
-		if (ret)
-			goto out_unfreeze;
+		if (ret) {
+			blk_mq_unfreeze_queue(ns->disk->queue);
+			goto out;
+		}
 	}
 
 	set_disk_ro(ns->disk, (id->nsattr & NVME_NS_ATTR_RO) ||
@@ -1926,7 +1928,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	if (blk_queue_is_zoned(ns->queue)) {
 		ret = nvme_revalidate_zones(ns);
 		if (ret && !nvme_first_scan(ns->disk))
-			return ret;
+			goto out;
 	}
 
 	if (nvme_ns_head_multipath(ns->head)) {
@@ -1941,9 +1943,9 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 		disk_update_readahead(ns->head->disk);
 		blk_mq_unfreeze_queue(ns->head->disk->queue);
 	}
-	return 0;
 
-out_unfreeze:
+	ret = 0;
+out:
 	/*
 	 * If probing fails due an unsupported feature, hide the block device,
 	 * but still allow other access.
@@ -1953,7 +1955,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 		set_bit(NVME_NS_READY, &ns->flags);
 		ret = 0;
 	}
-	blk_mq_unfreeze_queue(ns->disk->queue);
 	return ret;
 }
 
-- 
2.35.1



