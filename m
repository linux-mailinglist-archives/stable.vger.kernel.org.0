Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61065FCFC1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiJMAVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiJMAUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:20:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4988AE6F54;
        Wed, 12 Oct 2022 17:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55367616B5;
        Thu, 13 Oct 2022 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A029EC43141;
        Thu, 13 Oct 2022 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620284;
        bh=5qt8H4mypo9d3J9EVjpniftXE2g7dQ0BL2h2ZP4cgy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8Ay+NfbXlOGvPtzEXzHRS2yCaKx5YR7ewDRDwybGXaxPaAYRJtYCmlmcNaBvyY4l
         So5pnjdK12IhrrKT5xaatG11GUaFtOwGJecy6ANX0/8v5fHHa4UU2Rc0scP9BQxdju
         fkWfH2eh9xVpcPu+uNMQqivVT1qR/NEBlMWSt3ADGtQFJjfz9A6PmaYx+t98mi1dgH
         1BpXdo+v8xA7eUeWbEYD/aRfP1LB44pZNQDH2WcpS+jkGduwSAXMpSlc+47f2tgZo4
         mSsZGo2nIyXkVoVUqeb/IPJ+RrK23dfoCZdKYTf29C428TWOXmcdt7WA3aWpVhISCe
         2KvxC23lGMieQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Jeff Lien <jeff.lien@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 53/67] nvme: copy firmware_rev on each init
Date:   Wed, 12 Oct 2022 20:15:34 -0400
Message-Id: <20221013001554.1892206-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a8eb6c1ba48bddea82e8d74cbe6e119f006be97d ]

The firmware revision can change on after a reset so copy the most
recent info each time instead of just the first time, otherwise the
sysfs firmware_rev entry may contain stale data.

Reported-by: Jeff Lien <jeff.lien@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7991d28e6a6a..59e4b188fc71 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2889,7 +2889,6 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	nvme_init_subnqn(subsys, ctrl, id);
 	memcpy(subsys->serial, id->sn, sizeof(subsys->serial));
 	memcpy(subsys->model, id->mn, sizeof(subsys->model));
-	memcpy(subsys->firmware_rev, id->fr, sizeof(subsys->firmware_rev));
 	subsys->vendor_id = le16_to_cpu(id->vid);
 	subsys->cmic = id->cmic;
 
@@ -3108,6 +3107,8 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 				ctrl->quirks |= core_quirks[i].quirks;
 		}
 	}
+	memcpy(ctrl->subsys->firmware_rev, id->fr,
+	       sizeof(ctrl->subsys->firmware_rev));
 
 	if (force_apst && (ctrl->quirks & NVME_QUIRK_NO_DEEPEST_PS)) {
 		dev_warn(ctrl->device, "forcibly allowing all power states due to nvme_core.force_apst -- use at your own risk\n");
-- 
2.35.1

