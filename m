Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC67E4F43F7
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359307AbiDEMXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356150AbiDEKXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC8CBA316;
        Tue,  5 Apr 2022 03:07:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65FA6B81C98;
        Tue,  5 Apr 2022 10:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4549C385A1;
        Tue,  5 Apr 2022 10:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153224;
        bh=BcSDo9r3IFVheWMF8RqV0FJSBjYtjvRasfb3M1YVooo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXnKDTTBAUycApl018fTHgrcjZ9XBdFBP1idxk3RyGf5jhf4YnuCRZ+VDxW3ct98l
         GW/oh3Wiek/Y+vrE2ooZfwerl7fTaGTqy6c2k8hxtYETrkIeahIJNVgiredmqAbdx3
         4rt2CqC1ECJMnYRpINtLoeAvC2w8zELoyQp4B2fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/599] nvme: cleanup __nvme_check_ids
Date:   Tue,  5 Apr 2022 09:27:20 +0200
Message-Id: <20220405070303.187179042@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 71c85c99e86c..853b9a24f744 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3681,16 +3681,15 @@ static struct nvme_ns_head *nvme_find_ns_head(struct nvme_subsystem *subsys,
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
 
@@ -3724,7 +3723,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	head->ids = *ids;
 	kref_init(&head->ref);
 
-	ret = __nvme_check_ids(ctrl->subsys, head);
+	ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, &head->ids);
 	if (ret) {
 		dev_err(ctrl->device,
 			"duplicate IDs for nsid %d\n", nsid);
-- 
2.34.1



