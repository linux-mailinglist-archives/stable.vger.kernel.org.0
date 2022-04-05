Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A370F4F29D6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349109AbiDEKuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344809AbiDEJmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:42:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B625BF03E;
        Tue,  5 Apr 2022 02:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 381D8B81C84;
        Tue,  5 Apr 2022 09:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4509C385A0;
        Tue,  5 Apr 2022 09:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150886;
        bh=TamW6Xsci8vfjCNSf+pGM21D24uxs4X8EZtl3LmgROo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHtJr9nP1GN6ts3P2qlxV0CVjrB0j2GzmpGxWo0Tq5SQItlzjWTRBqiP+bLE38tGA
         mSAaFomPo+jxH9+rGBxRQ446FBplG4GgmStlEYms52ohutyG0wuEoRuI1TMUfxxe8G
         HU428rDmmKsKJB1hOfRSBEnkMxqYWK7T7Ewn129s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/913] nvme: fix the check for duplicate unique identifiers
Date:   Tue,  5 Apr 2022 09:21:19 +0200
Message-Id: <20220405070346.362888752@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit e2724cb9f0c406b8fb66efd3aa9e8b3edfd8d5c8 ]

nvme_subsys_check_duplicate_ids should needs to return an error if any of
the identifiers matches, not just if all of them match.  But it does not
need to and should not look at the CSI value for this sanity check.

Rewrite the logic to be separate from nvme_ns_ids_equal and optimize it
by reducing duplicate checks for non-present identifiers.

Fixes: ed754e5deeb1 ("nvme: track shared namespaces")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e06d6026e7fa..b349e19e745b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1674,13 +1674,6 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 		blk_queue_max_write_zeroes_sectors(queue, UINT_MAX);
 }
 
-static bool nvme_ns_ids_valid(struct nvme_ns_ids *ids)
-{
-	return !uuid_is_null(&ids->uuid) ||
-		memchr_inv(ids->nguid, 0, sizeof(ids->nguid)) ||
-		memchr_inv(ids->eui64, 0, sizeof(ids->eui64));
-}
-
 static bool nvme_ns_ids_equal(struct nvme_ns_ids *a, struct nvme_ns_ids *b)
 {
 	return uuid_equal(&a->uuid, &b->uuid) &&
@@ -3537,12 +3530,21 @@ static struct nvme_ns_head *nvme_find_ns_head(struct nvme_subsystem *subsys,
 static int nvme_subsys_check_duplicate_ids(struct nvme_subsystem *subsys,
 		struct nvme_ns_ids *ids)
 {
+	bool has_uuid = !uuid_is_null(&ids->uuid);
+	bool has_nguid = memchr_inv(ids->nguid, 0, sizeof(ids->nguid));
+	bool has_eui64 = memchr_inv(ids->eui64, 0, sizeof(ids->eui64));
 	struct nvme_ns_head *h;
 
 	lockdep_assert_held(&subsys->lock);
 
 	list_for_each_entry(h, &subsys->nsheads, entry) {
-		if (nvme_ns_ids_valid(ids) && nvme_ns_ids_equal(ids, &h->ids))
+		if (has_uuid && uuid_equal(&ids->uuid, &h->ids.uuid))
+			return -EINVAL;
+		if (has_nguid &&
+		    memcmp(&ids->nguid, &h->ids.nguid, sizeof(ids->nguid)) == 0)
+			return -EINVAL;
+		if (has_eui64 &&
+		    memcmp(&ids->eui64, &h->ids.eui64, sizeof(ids->eui64)) == 0)
 			return -EINVAL;
 	}
 
-- 
2.34.1



