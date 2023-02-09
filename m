Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46369075A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjBIL1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjBIL0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:26:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B612C5A92E;
        Thu,  9 Feb 2023 03:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D953B82104;
        Thu,  9 Feb 2023 11:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D23C4339B;
        Thu,  9 Feb 2023 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941599;
        bh=VlimYip4QmXbNgZABISrBU9lsnrR4iu0EX/ecs3U5oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCLrI7AuPZQ5/ufgW3f++XnRaSnzo3cJJMYJ84LCh5W4J96pWqhAkCQWxyq7QYSbg
         Aavsfd10guOEoDwKQWTtPhqdTcJRt6pgXmVVRo9+X9ThkXFKuSYLrNxXtBDmkK7J0v
         aIahj9XX4QZIfNk7NNb7SiAM/rMdukvl6wmE04sPE0rZy1RpVwUSSoV+VCL+DR26Kd
         msi7MyjsHGpq/ipvAn6Yhvbww9U/9R89xw75HkFrI4gb6WEkUIjOjiZ1WAVslRpX/y
         BX+c9m2BrR+BSsB3AUtZdIg2oEgyDtQ2bvCW0k/RRkeDthP/ibky+EXP+4jRusrNF0
         LWw34izElFiYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Engel <Amit.Engel@dell.com>,
        James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        sagi@grimberg.me, kch@nvidia.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 10/10] nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association
Date:   Thu,  9 Feb 2023 06:19:19 -0500
Message-Id: <20230209111921.1893095-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111921.1893095-1-sashal@kernel.org>
References: <20230209111921.1893095-1-sashal@kernel.org>
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
index 9b07e8c7689ab..f74fc6481731d 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1362,8 +1362,10 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
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

