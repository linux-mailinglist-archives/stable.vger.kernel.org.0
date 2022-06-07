Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54914540935
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351100AbiFGSGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351486AbiFGSCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A66152BBC;
        Tue,  7 Jun 2022 10:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ABEAB822CE;
        Tue,  7 Jun 2022 17:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4911C34115;
        Tue,  7 Jun 2022 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623882;
        bh=T15obBoK9jnnCw3q+tDyb87O4G8KAWIklECNXn5nR3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIhF/qshNzTBI5l7wEcl1OKJJ6g4ScLU4jqwDP/YqSUjIdNE6Z6EmFxl2f0tptFsu
         dPoAJZGc979tyRQ3VQ7/7Wysbp6TvFSFsn1ZQK+HLBx60fetqoD4oOznZTSf9aO28m
         upNxAWrQfji/Eilhe0x9PQHIvnjxxaumcpgPDxMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Smith <kyles@hpe.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/667] nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags
Date:   Tue,  7 Jun 2022 18:56:29 +0200
Message-Id: <20220607164938.544698822@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Smith, Kyle Miller (Nimble Kernel) <kyles@hpe.com>

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
index e6f55cf6e494..3ddd24a42043 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1680,6 +1680,7 @@ static int nvme_alloc_admin_tags(struct nvme_dev *dev)
 		dev->ctrl.admin_q = blk_mq_init_queue(&dev->admin_tagset);
 		if (IS_ERR(dev->ctrl.admin_q)) {
 			blk_mq_free_tag_set(&dev->admin_tagset);
+			dev->ctrl.admin_q = NULL;
 			return -ENOMEM;
 		}
 		if (!blk_get_queue(dev->ctrl.admin_q)) {
-- 
2.35.1



