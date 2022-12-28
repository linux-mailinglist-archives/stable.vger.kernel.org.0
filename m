Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323D2657930
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiL1O64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiL1O62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4848B12AC5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D99CC61540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC48DC433EF;
        Wed, 28 Dec 2022 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239506;
        bh=tjkjdGOPDSXns9yFj+eN9VxY6v2IOHPTTUM86X+rUSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzTm1V/BJlCo9yvEsdbNlp3HJ5Mhjh3dmQE9Su8WBzaM2o6PkdVctPZ8KSuuWy4EH
         PjtbEI4qzjuNkCV1Op6htQ6u6AWajgPdUz/u+L5UAQewRwCQzaMBw2DskVKFkxsegE
         E9/cEr+kNNsRvKVAh6bQwPY6KrpB+JpDzJX6AUzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joel Granados <j.granados@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/731] nvme: return err on nvme_init_non_mdts_limits fail
Date:   Wed, 28 Dec 2022 15:35:07 +0100
Message-Id: <20221228144302.361236995@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Joel Granados <j.granados@samsung.com>

[ Upstream commit bcaf434b8f04e1ee82a8b1e1bce0de99fbff67fa ]

In nvme_init_non_mdts_limits function we were returning 0 when kzalloc
failed; it now returns -ENOMEM.

Fixes: 5befc7c26e5a ("nvme: implement non-mdts command limits")
Signed-off-by: Joel Granados <j.granados@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 692ee0f4a1ec..2d5b5e0fb66a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2874,7 +2874,7 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (!id)
-		return 0;
+		return -ENOMEM;
 
 	c.identify.opcode = nvme_admin_identify;
 	c.identify.cns = NVME_ID_CNS_CS_CTRL;
-- 
2.35.1



