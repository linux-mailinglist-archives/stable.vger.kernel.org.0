Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C165C68A
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjACSlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbjACSkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAEA14023;
        Tue,  3 Jan 2023 10:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 393E3B810BC;
        Tue,  3 Jan 2023 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B51C433D2;
        Tue,  3 Jan 2023 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771217;
        bh=ddG3QBwF8T64A+niWfQE99/jFh+5VsFSgyYnBNmFRwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGQp4MdqPl/A7BkNjUNMjXUMSmIcGcn+dqeIAtE1biPE6pMbzudthqeETIk9gI/GW
         hQo/7sh8tcCmHnlCCdo3Jyv6EGry/tmmHB4dWQ3dzx5WnBKn8l6exiuTt095627yuC
         q07WuG8rJbwJ6s4guxCrn3icDId3ql3cHpREMoFTHxzwrJdaI6RYq1aaBQUKd4s5A3
         YfPKQk9Gbj53GTeqJFMaHSkL5o/nYCDlL2EgGKE0MZDvsAlfsEbXHPkKeHnyfFYITe
         CQChSQM5frtEJA18bYqs6KeJQZvn4NkOuRbCBcNfTJpkT5aoaVM0fOcaHHqr7i1482
         OZ8NCULT2Im7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 3/4] nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it
Date:   Tue,  3 Jan 2023 13:40:11 -0500
Message-Id: <20230103184013.2022849-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103184013.2022849-1-sashal@kernel.org>
References: <20230103184013.2022849-1-sashal@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 61f37154c599cf9f2f84dcbd9be842f8645a7099 ]

Use NVME_CMD_EFFECTS_CSUPP instead of open coding it and assign a
single value to multiple array entries instead of repeated assignments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 35 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 52bb262d267a..bf78c58ed41d 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -164,26 +164,29 @@ static void nvmet_execute_get_log_page_smart(struct nvmet_req *req)
 
 static void nvmet_get_cmd_effects_nvm(struct nvme_effects_log *log)
 {
-	log->acs[nvme_admin_get_log_page]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_identify]		= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_abort_cmd]		= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_set_features]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_get_features]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_async_event]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_keep_alive]		= cpu_to_le32(1 << 0);
-
-	log->iocs[nvme_cmd_read]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_write]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_flush]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_dsm]			= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_write_zeroes]	= cpu_to_le32(1 << 0);
+	log->acs[nvme_admin_get_log_page] =
+	log->acs[nvme_admin_identify] =
+	log->acs[nvme_admin_abort_cmd] =
+	log->acs[nvme_admin_set_features] =
+	log->acs[nvme_admin_get_features] =
+	log->acs[nvme_admin_async_event] =
+	log->acs[nvme_admin_keep_alive] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
+
+	log->iocs[nvme_cmd_read] =
+	log->iocs[nvme_cmd_write] =
+	log->iocs[nvme_cmd_flush] =
+	log->iocs[nvme_cmd_dsm]	=
+	log->iocs[nvme_cmd_write_zeroes] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 }
 
 static void nvmet_get_cmd_effects_zns(struct nvme_effects_log *log)
 {
-	log->iocs[nvme_cmd_zone_append]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_zone_mgmt_send]	= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_zone_mgmt_recv]	= cpu_to_le32(1 << 0);
+	log->iocs[nvme_cmd_zone_append] =
+	log->iocs[nvme_cmd_zone_mgmt_send] =
+	log->iocs[nvme_cmd_zone_mgmt_recv] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 }
 
 static void nvmet_execute_get_log_cmd_effects_ns(struct nvmet_req *req)
-- 
2.35.1

