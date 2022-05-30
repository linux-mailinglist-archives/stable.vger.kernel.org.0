Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4172E53823C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiE3OW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239481AbiE3OOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C0F996A3;
        Mon, 30 May 2022 06:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B15EDB80DAE;
        Mon, 30 May 2022 13:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380DFC3411E;
        Mon, 30 May 2022 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918174;
        bh=qoEqqG5jjxCAbW2crZUv/sz/nd05QD4ziCVP9ciO8nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVVzJtUb7G2+cmLzW8koG6RIbV+Ggd4FjfZjn1llLsDllvbgeSiW3BS03Mo6ZxXw+
         lGtVaGT7UlK01nN4npWN1OoabLvvdxE+gWWdh2lm1OZrhfCbOYK28CrFRIVQKnHkW5
         mLd+VOQ2gYTBNsxJQ0MS8IYo66GWDYzoSJKBpAFzitii0038sIK9JaYQCAUSJNorws
         Mp6tXSvwbGtxvgS425EBSn2QOm/DutN2tr9KvEuNgWW1cMkR0leEl+vvQmV8CU56LU
         pr3ivctoE11EV0myxnVjAABCWTwJl8oEvnL/ifeExYVlJulaYI82IvFVhdgCzT3yJS
         4e4Qivc8l3KTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Smith, Kyle Miller (Nimble Kernel)" <kyles@hpe.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 085/109] nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags
Date:   Mon, 30 May 2022 09:38:01 -0400
Message-Id: <20220530133825.1933431-85-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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

