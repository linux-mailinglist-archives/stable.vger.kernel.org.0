Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB8265C684
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjACSlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbjACSk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD73A13F92;
        Tue,  3 Jan 2023 10:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E99CB80EBF;
        Tue,  3 Jan 2023 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4B3C433F2;
        Tue,  3 Jan 2023 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771211;
        bh=3iJDEg26w5JXxeO2spyA4n8QeKcUd/6tuQpHV6WNuig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wto7t6R7yPqo609aa5lzZx6R1F+hEKgafSqfs4jF7wrc6pBCcbHYbtby/AH88fNCC
         uctvD9PCWey2o3mnjikpmOwLaRoNmThbO4xgMp7HuZh3eMBfUruNRxGoMMandHaiMz
         ZUl2zQYzAVun8SVEPMzlkYr7IsVhej8fd8ykgrADSr+7Ebq4satC1DO7Cr6275P7vr
         yarUDtCJ+VSxRj3fa4j9CLZPNel7UhyMtvzqwiFF4w2pBv+tVomkvI8zDMLHBDcFQ8
         Q20H0jB7sNHP4ALU4hQcO6gV3OsjQKUDU78rImvyiSTdpLRGiGT6/QkC18tSxIoIvM
         vUg0kxqFIsY6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 3/4] nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it
Date:   Tue,  3 Jan 2023 13:39:54 -0500
Message-Id: <20230103183956.2022789-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183956.2022789-1-sashal@kernel.org>
References: <20230103183956.2022789-1-sashal@kernel.org>
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
index fc8a957fad0a..4aaa27cc8d2b 100644
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

