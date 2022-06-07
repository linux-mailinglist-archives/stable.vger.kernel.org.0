Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8E6540557
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346282AbiFGRYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346279AbiFGRXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6C10A612;
        Tue,  7 Jun 2022 10:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD536077B;
        Tue,  7 Jun 2022 17:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5D9C385A5;
        Tue,  7 Jun 2022 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622500;
        bh=UMy7WkdOANGsNd0OvoRXIa3HyHp58+lil8VtMJFr4eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFSaAM6+nM1HWYhiOo6vvWWL2rmAHP7r0aKF2iKG0AK5+KKIWlZqmBwhuteaqOaNs
         frHyWQpBjuFHSXdgyYYefVsCnDwC+5oroC9InBojZAgTsZJxHURfTrcATXiAeURyAD
         zD3yd6lH1E/1T6w0FMcvjmUlhkP9i2r/JNlrlp0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Smith <kyles@hpe.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/452] nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags
Date:   Tue,  7 Jun 2022 18:58:59 +0200
Message-Id: <20220607164910.997254107@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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



