Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC645FD205
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiJMA6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiJMA54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:57:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0BE25EB8;
        Wed, 12 Oct 2022 17:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58EDC616B6;
        Thu, 13 Oct 2022 00:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3E8C433C1;
        Thu, 13 Oct 2022 00:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620687;
        bh=kpCVKSVx4edmN/FF2ES1UPayu/qR0i3LiEngz2CZ+Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auzLM9j43/8KS4m87n+YYvoqurHEmwV7l+A7OolRcTC1KrjxPc7JmIjXXrjIiLC4G
         925898uV9TMvxmfkNBts06L2i/YrTppKwkCfPbxwUMtLh0KW9xaFD69XBVySZTqJ3e
         OaqMn5HGnAK3mdLVdQmMWWxUhkGljRuRRWKCzvYnHP98cRqmC+QdVR0TL6w10H2eQu
         QrJtR++pEWhfZ8ahFjVU/reHAwDXLsONeeb15zT1X7oF7UFKSgaGoTiocvoFZZY44U
         gsuZt7fmLPdpRSWqiTYZ768ty+5dOL+UT7qpv56UjRzKcrC+CkpDXKb51I+kRg1Auy
         Cn46ePt/8YKIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Jeff Lien <jeff.lien@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 28/33] nvme: copy firmware_rev on each init
Date:   Wed, 12 Oct 2022 20:23:27 -0400
Message-Id: <20221013002334.1894749-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
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
index 265d9199b657..e9c13804760e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2949,7 +2949,6 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	nvme_init_subnqn(subsys, ctrl, id);
 	memcpy(subsys->serial, id->sn, sizeof(subsys->serial));
 	memcpy(subsys->model, id->mn, sizeof(subsys->model));
-	memcpy(subsys->firmware_rev, id->fr, sizeof(subsys->firmware_rev));
 	subsys->vendor_id = le16_to_cpu(id->vid);
 	subsys->cmic = id->cmic;
 	subsys->awupf = le16_to_cpu(id->awupf);
@@ -3110,6 +3109,8 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 				ctrl->quirks |= core_quirks[i].quirks;
 		}
 	}
+	memcpy(ctrl->subsys->firmware_rev, id->fr,
+	       sizeof(ctrl->subsys->firmware_rev));
 
 	if (force_apst && (ctrl->quirks & NVME_QUIRK_NO_DEEPEST_PS)) {
 		dev_warn(ctrl->device, "forcibly allowing all power states due to nvme_core.force_apst -- use at your own risk\n");
-- 
2.35.1

