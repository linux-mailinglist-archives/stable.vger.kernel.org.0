Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D006906BB
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBILUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjBILTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:19:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24815D1C8;
        Thu,  9 Feb 2023 03:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2505BB82100;
        Thu,  9 Feb 2023 11:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E049AC4339B;
        Thu,  9 Feb 2023 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941403;
        bh=PR/EohbDIxEQmBUHz8lHyT1xIeNdyOWaRKch9tCK5AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/ES8GNTsuBhMXlj9rR9obBBdK7UO0PtZObdzytf+wTG5j82DwEjD9hamV9rAkXms
         9zU5WVSLdNPj9GN3UmpAdKWdG0xvlf2SlxBrpxvv4KRidSzPSEOnI1AZxXP48ZIfVM
         /7lhO2pm5BccuuCWAFmV2KxuQ3i13E7wxjKfTHDlZUCPkEl/INsYXFmb+Nnbcg2twF
         FaW2xy+VGc9TjmOd0qXYFdvWgw+GGkGy9kOM96eHRbGkJ5c3uCqmpYkWrI9pPNVCAf
         Uvrq57b4cOjB2HmDO7q9Xvd8A8cF88yX4XgMx+7bdEZqb2aFvmpxy7xzrbl3n0iLDU
         aRvw9QjV/+9tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 27/38] nvme: clear the request_queue pointers on failure in nvme_alloc_admin_tag_set
Date:   Thu,  9 Feb 2023 06:14:46 -0500
Message-Id: <20230209111459.1891941-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit fd62678ab55cb01e11a404d302cdade222bf4022 ]

If nvme_alloc_admin_tag_set() fails, the admin_q and fabrics_q pointers
are left with an invalid, non-NULL value. Other functions may then check
the pointers and dereference them, e.g. in

  nvme_probe() -> out_disable: -> nvme_dev_remove_admin().

Fix the bug by setting admin_q and fabrics_q to NULL in case of error.

Also use the set variable to free the tag_set as ctrl->admin_tagset isn't
initialized yet.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 25ade4ce8e0a7..e189ce17deb3e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4881,7 +4881,9 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 out_cleanup_admin_q:
 	blk_mq_destroy_queue(ctrl->admin_q);
 out_free_tagset:
-	blk_mq_free_tag_set(ctrl->admin_tagset);
+	blk_mq_free_tag_set(set);
+	ctrl->admin_q = NULL;
+	ctrl->fabrics_q = NULL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
-- 
2.39.0

