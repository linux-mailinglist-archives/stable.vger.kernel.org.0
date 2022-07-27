Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B32582DEC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiG0REx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiG0REW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DE56E8B7;
        Wed, 27 Jul 2022 09:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72176601CE;
        Wed, 27 Jul 2022 16:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA79C433C1;
        Wed, 27 Jul 2022 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939939;
        bh=9FCF1x1SQRRZNClD09Kcp9xA8mgHRhj/2fAz1e3g2F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhFgeJCDlVtrBOrWddp/uk5xUB+QB7Plfl+6QIDgD46r3CABz8StjgGlmxladHFKd
         6u1632DEHn3cINxNd7nqvSMmEZNJ19joVtojsglEUJRE/H5tecziOICk0sKildzg1C
         ItAzHtQy174KEBMTtFBR/1LMu36mKfMRSkS3HXiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/201] nvme: fix block device naming collision
Date:   Wed, 27 Jul 2022 18:09:14 +0200
Message-Id: <20220727161028.969627813@linuxfoundation.org>
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

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit 6961b5e02876b3b47f030a1f1ee8fd3e631ac270 ]

The issue exists when multipath is enabled and the namespace is
shared, but all the other controller checks at nvme_is_unique_nsid()
are false. The reason for this issue is that nvme_is_unique_nsid()
returns false when is called from nvme_mpath_alloc_disk() due to an
uninitialized value of head->shared. The patch fixes it by setting
head->shared before nvme_mpath_alloc_disk() is called.

Fixes: 5974ea7ce0f9 ("nvme: allow duplicate NSIDs for private namespaces")
Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8fca84d44446..0c9cdbaf5cd6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3660,7 +3660,7 @@ static int nvme_add_ns_cdev(struct nvme_ns *ns)
 }
 
 static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
-		unsigned nsid, struct nvme_ns_ids *ids)
+		unsigned nsid, struct nvme_ns_ids *ids, bool is_shared)
 {
 	struct nvme_ns_head *head;
 	size_t size = sizeof(*head);
@@ -3684,6 +3684,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	head->subsys = ctrl->subsys;
 	head->ns_id = nsid;
 	head->ids = *ids;
+	head->shared = is_shared;
 	kref_init(&head->ref);
 
 	if (head->ids.csi) {
@@ -3730,12 +3731,11 @@ static int nvme_init_ns_head(struct nvme_ns *ns, unsigned nsid,
 				"duplicate IDs for nsid %d\n", nsid);
 			goto out_unlock;
 		}
-		head = nvme_alloc_ns_head(ctrl, nsid, ids);
+		head = nvme_alloc_ns_head(ctrl, nsid, ids, is_shared);
 		if (IS_ERR(head)) {
 			ret = PTR_ERR(head);
 			goto out_unlock;
 		}
-		head->shared = is_shared;
 	} else {
 		ret = -EINVAL;
 		if (!is_shared || !head->shared) {
-- 
2.35.1



