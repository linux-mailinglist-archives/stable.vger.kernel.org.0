Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F99690732
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjBILZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjBILYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:24:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A4B5CBC6;
        Thu,  9 Feb 2023 03:19:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9182619FC;
        Thu,  9 Feb 2023 11:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD97C4339C;
        Thu,  9 Feb 2023 11:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941558;
        bh=Q4fIJrB9ze0H6fdtNt/wHdDiReKz63ks7CkDFg4tGNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbLksrAwlUQj9efA5/2Hm8AKUR6P9hwYLt0HEHgKLaV09rmHXm2gEkwng++kL9aWN
         8aLcE5Do0rQI5h8r0y4plAvuSh8o3fGd4DbFv40VvBH2ESh8/piLANPy1AhjOYzxV0
         w2jsvi4PJ3cBZQlygh2PQR9yn78HCLtdVmDNp2esf7LFhZBQ3pIoQv3J54D2uzMmGN
         JWrwocpQZUe1mHAljL08HZOKNNUiHEktehLifNuqxgRa1D9Pdy8YmfdoTatzDkYyZM
         s44g0S33RQ77Oaa/Rxjd68Kd5eOpMdhayBCvxpZfe1A9ApKYMApRZ+lr5r8vjQw/+C
         m4f0sti3bjAVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Engel <Amit.Engel@dell.com>,
        James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        sagi@grimberg.me, kch@nvidia.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 12/13] nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association
Date:   Thu,  9 Feb 2023 06:18:30 -0500
Message-Id: <20230209111833.1892896-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111833.1892896-1-sashal@kernel.org>
References: <20230209111833.1892896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Engel <Amit.Engel@dell.com>

[ Upstream commit 0cab4404874f2de52617de8400c844891c6ea1ce ]

As part of nvmet_fc_ls_create_association there is a case where
nvmet_fc_alloc_target_queue fails right after a new association with an
admin queue is created. In this case, no one releases the get taken in
nvmet_fc_alloc_target_assoc.  This fix is adding the missing put.

Signed-off-by: Amit Engel <Amit.Engel@dell.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 640031cbda7cc..46fc44ce86712 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1675,8 +1675,10 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 		else {
 			queue = nvmet_fc_alloc_target_queue(iod->assoc, 0,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
-			if (!queue)
+			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
+				nvmet_fc_tgt_a_put(iod->assoc);
+			}
 		}
 	}
 
-- 
2.39.0

