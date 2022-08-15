Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FB35944CC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344590AbiHOWYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345968AbiHOWWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:22:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CD26B65D;
        Mon, 15 Aug 2022 12:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7052BCE12C4;
        Mon, 15 Aug 2022 19:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBDEC433D7;
        Mon, 15 Aug 2022 19:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592635;
        bh=i8C6Dc6qGwwea9fahLykl8aMjWmt2PqEQCvALcK+vZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcwLGf+jnK70hsiHQxnptOuheAJs0dIG/iGykdNIbf/CiM+GgHse0u4bv06+RSsg9
         s8lqSol9TF5AF8EVGuu/TJUCnM8Y04WRMx6GR8BNTU43hjxs3qY6p0GhYOwk9ttmXh
         MYNHWdF+giPMPkbtOi3ZUowpvIGKz+khNi4QHKEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Granados <j.granados@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0819/1095] nvme: catch -ENODEV from nvme_revalidate_zones again
Date:   Mon, 15 Aug 2022 20:03:38 +0200
Message-Id: <20220815180503.162495247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index cf7be9b4f5d3..a58a69999dbc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1897,8 +1897,10 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 
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
@@ -1909,7 +1911,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	if (blk_queue_is_zoned(ns->queue)) {
 		ret = nvme_revalidate_zones(ns);
 		if (ret && !nvme_first_scan(ns->disk))
-			return ret;
+			goto out;
 	}
 
 	if (nvme_ns_head_multipath(ns->head)) {
@@ -1924,9 +1926,9 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
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
@@ -1936,7 +1938,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 		set_bit(NVME_NS_READY, &ns->flags);
 		ret = 0;
 	}
-	blk_mq_unfreeze_queue(ns->disk->queue);
 	return ret;
 }
 
-- 
2.35.1



