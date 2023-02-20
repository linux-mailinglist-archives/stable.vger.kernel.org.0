Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6297D69CE6B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjBTN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjBTN7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D360F1E9D7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0DAA60EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10CAC4339B;
        Mon, 20 Feb 2023 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901494;
        bh=PR/EohbDIxEQmBUHz8lHyT1xIeNdyOWaRKch9tCK5AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch5YqrOrgLCuq4ay9zuWXpjIw2Vkb4bsL2eOMPUM2V0REpU6a6yptmONb99Euat4z
         Fe1NZsAP04ssR4QD3NMgYBstraxUE3l6oC6TbqMxi8Iia5Obm+8d+fl79H8s08ZZ0f
         ixp1CQ0PiJJxjjCDPvwfRaRLSZDyRwb1FJHPH4tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maurizio Lombardi <mlombard@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/118] nvme: clear the request_queue pointers on failure in nvme_alloc_admin_tag_set
Date:   Mon, 20 Feb 2023 14:35:47 +0100
Message-Id: <20230220133601.669667832@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



