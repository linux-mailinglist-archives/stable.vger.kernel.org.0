Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE9B53821C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiE3OV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241402AbiE3ORe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8719E9C2CD;
        Mon, 30 May 2022 06:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EFB60F14;
        Mon, 30 May 2022 13:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22551C3411C;
        Mon, 30 May 2022 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918380;
        bh=4+g9D5xTre7t5UvhEJEZqO+KyPzsgxnaoiiOJSFfVww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3Fi8dzw8SVAqcbb9fzSWJrF1iQIJt6mHKuXYkQPjqS57OFLw5TkZmhPfkgqNvnEp
         f/fY4RCCLbJCJtNgW6wDfJDPqS3PxxClkV3PYAQnTrBmkXaLWYMymMSuXcOd3vuj1T
         402h1/Yrzg3LVMz4gz6/0MmmGjRrMRGCwPttfpzfUv391I0E6fnMUOT4fNuD2EKTgQ
         WmTWn9vkfYYCyNPJTnrhbMb/reUWrdN9X5/J1MAxtLfL2MQL8uT8UvXndcBgeT+neo
         di4RZ4DkslX5k6qZZfiVx4DKDUlsTPtvcKXRMzvugioFNaIokgbchE2fOMgwD8YD03
         mxwR8ZXsxJzZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Smith, Kyle Miller (Nimble Kernel)" <kyles@hpe.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 60/76] nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags
Date:   Mon, 30 May 2022 09:43:50 -0400
Message-Id: <20220530134406.1934928-60-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Smith, Kyle Miller (Nimble Kernel)" <kyles@hpe.com>

[ Upstream commit da42761181627e9bdc37d18368b827948a583929 ]

In nvme_alloc_admin_tags, the admin_q can be set to an error (typically
-ENOMEM) if the blk_mq_init_queue call fails to set up the queue, which
is checked immediately after the call. However, when we return the error
message up the stack, to nvme_reset_work the error takes us to
nvme_remove_dead_ctrl()
  nvme_dev_disable()
   nvme_suspend_queue(&dev->queues[0]).

Here, we only check that the admin_q is non-NULL, rather than not
an error or NULL, and begin quiescing a queue that never existed, leading
to bad / NULL pointer dereference.

Signed-off-by: Kyle Smith <kyles@hpe.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a36db0701d17..7de24a10dd92 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1666,6 +1666,7 @@ static int nvme_alloc_admin_tags(struct nvme_dev *dev)
 		dev->ctrl.admin_q = blk_mq_init_queue(&dev->admin_tagset);
 		if (IS_ERR(dev->ctrl.admin_q)) {
 			blk_mq_free_tag_set(&dev->admin_tagset);
+			dev->ctrl.admin_q = NULL;
 			return -ENOMEM;
 		}
 		if (!blk_get_queue(dev->ctrl.admin_q)) {
-- 
2.35.1

