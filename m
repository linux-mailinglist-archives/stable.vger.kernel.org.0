Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3184F2E5E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349104AbiDEKuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344788AbiDEJmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:42:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05644BF01F;
        Tue,  5 Apr 2022 02:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A568FB81C6E;
        Tue,  5 Apr 2022 09:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB60EC385A2;
        Tue,  5 Apr 2022 09:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150883;
        bh=OMzaquygvnwXRE8+bxUxmK+dmLmjZOJtxQr8nX4eWDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke2yxTBaKxvxNUnMSZuoQZQqFCXYZzPYiHSb1ImLAsbWnAqCIUPtvw5v0t4UlPpqc
         v3H/53lOT82RdwP6o485zySQmF8dWFxT5/a69otbKwaVPm3VsXEhhSdoHuyFlqGyqP
         OQTyaJXEbPKGBAp3gcqwy2yZF9B1MMknzxHHEhm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/913] nvme: cleanup __nvme_check_ids
Date:   Tue,  5 Apr 2022 09:21:18 +0200
Message-Id: <20220405070346.333252726@linuxfoundation.org>
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

[ Upstream commit fd8099e7918cd2df39ef306dd1d1af7178a15b81 ]

Pass the actual nvme_ns_ids used for the comparison instead of the
ns_head that isn't needed and use a more descriptive function name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d5d5d035d677..e06d6026e7fa 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3534,16 +3534,15 @@ static struct nvme_ns_head *nvme_find_ns_head(struct nvme_subsystem *subsys,
 	return NULL;
 }
 
-static int __nvme_check_ids(struct nvme_subsystem *subsys,
-		struct nvme_ns_head *new)
+static int nvme_subsys_check_duplicate_ids(struct nvme_subsystem *subsys,
+		struct nvme_ns_ids *ids)
 {
 	struct nvme_ns_head *h;
 
 	lockdep_assert_held(&subsys->lock);
 
 	list_for_each_entry(h, &subsys->nsheads, entry) {
-		if (nvme_ns_ids_valid(&new->ids) &&
-		    nvme_ns_ids_equal(&new->ids, &h->ids))
+		if (nvme_ns_ids_valid(ids) && nvme_ns_ids_equal(ids, &h->ids))
 			return -EINVAL;
 	}
 
@@ -3642,7 +3641,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	head->ids = *ids;
 	kref_init(&head->ref);
 
-	ret = __nvme_check_ids(ctrl->subsys, head);
+	ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, &head->ids);
 	if (ret) {
 		dev_err(ctrl->device,
 			"duplicate IDs for nsid %d\n", nsid);
-- 
2.34.1



