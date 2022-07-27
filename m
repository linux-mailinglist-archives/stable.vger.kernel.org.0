Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B877582DE8
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbiG0REv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241480AbiG0REU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE61A6E8AE;
        Wed, 27 Jul 2022 09:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D48760BAF;
        Wed, 27 Jul 2022 16:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4B7C4347C;
        Wed, 27 Jul 2022 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939937;
        bh=QipLENRbmLpjRNNqpZHNq2yd88w3mvICFXc2xDS2GzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwB5zqo9YHPojMukS+gRoQNL1JCBNE2G23dM3bmiWl3Yp6BVduCtfEy78tDAVm+Eo
         YCT7f2BD2Xx5YNII9oQD1rGbyUaheRvrbbnaFAsy5MzkUGUV4xcWYEV6EXrJcLnHYs
         aqQRzNpqfdlV/do+7LRYYMTgV8mI+W6Rxpthz6eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/201] nvme: check for duplicate identifiers earlier
Date:   Wed, 27 Jul 2022 18:09:13 +0200
Message-Id: <20220727161028.923733857@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit e2d77d2e11c4f1e70a1a24cc8fe63ff3dc9b53ef ]

Lift the check for duplicate identifiers into nvme_init_ns_head, which
avoids pointless error unwinding in case they don't match, and also
matches where we check identifier validity for the multipath case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 29b56ea01132..8fca84d44446 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3686,13 +3686,6 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	head->ids = *ids;
 	kref_init(&head->ref);
 
-	ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, &head->ids);
-	if (ret) {
-		dev_err(ctrl->device,
-			"duplicate IDs for nsid %d\n", nsid);
-		goto out_cleanup_srcu;
-	}
-
 	if (head->ids.csi) {
 		ret = nvme_get_effects_log(ctrl, head->ids.csi, &head->effects);
 		if (ret)
@@ -3731,6 +3724,12 @@ static int nvme_init_ns_head(struct nvme_ns *ns, unsigned nsid,
 	mutex_lock(&ctrl->subsys->lock);
 	head = nvme_find_ns_head(ctrl, nsid);
 	if (!head) {
+		ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, ids);
+		if (ret) {
+			dev_err(ctrl->device,
+				"duplicate IDs for nsid %d\n", nsid);
+			goto out_unlock;
+		}
 		head = nvme_alloc_ns_head(ctrl, nsid, ids);
 		if (IS_ERR(head)) {
 			ret = PTR_ERR(head);
-- 
2.35.1



