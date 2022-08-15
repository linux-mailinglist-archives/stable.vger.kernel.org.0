Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D98594CD4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiHPAdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242813AbiHPAbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD508186E88;
        Mon, 15 Aug 2022 13:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 678EFB80EA8;
        Mon, 15 Aug 2022 20:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F61C433C1;
        Mon, 15 Aug 2022 20:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595811;
        bh=4W+j0Bg9obX7L5ZVTF5NbGu5Xo5MV93h/4WaETWB/cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjH4XwGzh/Lb1s44Z1fEKoHJQyrudEz6bXr4Swa6DeQ4PZgO7QK6pvJB9/tJK9PwN
         NxW6Om1zAn8Sx6g/HuYeoTKXshtcuNeAVvwZ/XeaStWX/ULaPOHKUiJ3+RiJn1J/K4
         FeiP7vAXO5WSXUPCvet9CPN9HTtSoXIT4dlwPApA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Granados <j.granados@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0882/1157] nvme: catch -ENODEV from nvme_revalidate_zones again
Date:   Mon, 15 Aug 2022 20:03:58 +0200
Message-Id: <20220815180514.702520111@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 9c75d7378d31..2f965356f345 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1927,8 +1927,10 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 
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
@@ -1939,7 +1941,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	if (blk_queue_is_zoned(ns->queue)) {
 		ret = nvme_revalidate_zones(ns);
 		if (ret && !nvme_first_scan(ns->disk))
-			return ret;
+			goto out;
 	}
 
 	if (nvme_ns_head_multipath(ns->head)) {
@@ -1954,9 +1956,9 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
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
@@ -1966,7 +1968,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 		set_bit(NVME_NS_READY, &ns->flags);
 		ret = 0;
 	}
-	blk_mq_unfreeze_queue(ns->disk->queue);
 	return ret;
 }
 
-- 
2.35.1



