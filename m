Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF2F6579C1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbiL1PEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiL1PEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5485A13D1C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:04:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58D66154E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FD5C433D2;
        Wed, 28 Dec 2022 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239859;
        bh=vcx5H1HFlMFS9H7dIWDCKvIHvDcFMR2Ft+FFeTJHQDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7GZ5oxtUnHAXwKxsu+L1yrSh/Bstwm27bv/s4k+Yd3dMQ21kO62rHxrx2xBiO4bh
         kir6Hbs8yumSAed8HoC/qumfL5ziXR6r9NPO5QWiDNHkjvLC9yaf1LYj5CFdBqfO56
         DRV6gdQnBZ/uRD9qkR2GYjKP/+pufMTPJenj0dt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sumit Gupta <sumitg@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0051/1146] soc/tegra: cbb: Add checks for potential out of bound errors
Date:   Wed, 28 Dec 2022 15:26:30 +0100
Message-Id: <20221228144331.548573782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 55084947d6b48977c5122fbe443743a6c50c12bf ]

Added checks to avoid potential out of bounds errors which can happen if
the 'slave map' and 'CBB errors' arrays are not correct or latest where
some entries are missing.

Fixes: fc2f151d2314 ("soc/tegra: cbb: Add driver for Tegra234 CBB 2.0")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra234-cbb.c | 42 ++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index 04e12d9fdea5..0fab9e21d677 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -95,7 +95,9 @@ struct tegra234_cbb_fabric {
 	const char * const *master_id;
 	unsigned int notifier_offset;
 	const struct tegra_cbb_error *errors;
+	const int max_errors;
 	const struct tegra234_slave_lookup *slave_map;
+	const int max_slaves;
 };
 
 struct tegra234_cbb {
@@ -270,6 +272,12 @@ static void tegra234_cbb_print_error(struct seq_file *file, struct tegra234_cbb
 		tegra_cbb_print_err(file, "\t  Multiple type of errors reported\n");
 
 	while (status) {
+		if (type >= cbb->fabric->max_errors) {
+			tegra_cbb_print_err(file, "\t  Wrong type index:%u, status:%u\n",
+					    type, status);
+			return;
+		}
+
 		if (status & 0x1)
 			tegra_cbb_print_err(file, "\t  Error Code\t\t: %s\n",
 					    cbb->fabric->errors[type].code);
@@ -281,6 +289,12 @@ static void tegra234_cbb_print_error(struct seq_file *file, struct tegra234_cbb
 	type = 0;
 
 	while (overflow) {
+		if (type >= cbb->fabric->max_errors) {
+			tegra_cbb_print_err(file, "\t  Wrong type index:%u, overflow:%u\n",
+					    type, overflow);
+			return;
+		}
+
 		if (overflow & 0x1)
 			tegra_cbb_print_err(file, "\t  Overflow\t\t: Multiple %s\n",
 					    cbb->fabric->errors[type].code);
@@ -333,8 +347,11 @@ static void print_errlog_err(struct seq_file *file, struct tegra234_cbb *cbb)
 	access_type = FIELD_GET(FAB_EM_EL_ACCESSTYPE, cbb->mn_attr0);
 
 	tegra_cbb_print_err(file, "\n");
-	tegra_cbb_print_err(file, "\t  Error Code\t\t: %s\n",
-			    cbb->fabric->errors[cbb->type].code);
+	if (cbb->type < cbb->fabric->max_errors)
+		tegra_cbb_print_err(file, "\t  Error Code\t\t: %s\n",
+				    cbb->fabric->errors[cbb->type].code);
+	else
+		tegra_cbb_print_err(file, "\t  Wrong type index:%u\n", cbb->type);
 
 	tegra_cbb_print_err(file, "\t  MASTER_ID\t\t: %s\n", cbb->fabric->master_id[mstr_id]);
 	tegra_cbb_print_err(file, "\t  Address\t\t: %#llx\n", cbb->access);
@@ -373,6 +390,11 @@ static void print_errlog_err(struct seq_file *file, struct tegra234_cbb *cbb)
 	if ((fab_id == PSC_FAB_ID) || (fab_id == FSI_FAB_ID))
 		return;
 
+	if (slave_id >= cbb->fabric->max_slaves) {
+		tegra_cbb_print_err(file, "\t  Invalid slave_id:%d\n", slave_id);
+		return;
+	}
+
 	if (!strcmp(cbb->fabric->errors[cbb->type].code, "TIMEOUT_ERR")) {
 		tegra234_lookup_slave_timeout(file, cbb, slave_id, fab_id);
 		return;
@@ -639,7 +661,9 @@ static const struct tegra234_cbb_fabric tegra234_aon_fabric = {
 	.name = "aon-fabric",
 	.master_id = tegra234_master_id,
 	.slave_map = tegra234_aon_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra234_aon_slave_map),
 	.errors = tegra234_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra234_cbb_errors),
 	.notifier_offset = 0x17000,
 };
 
@@ -655,7 +679,9 @@ static const struct tegra234_cbb_fabric tegra234_bpmp_fabric = {
 	.name = "bpmp-fabric",
 	.master_id = tegra234_master_id,
 	.slave_map = tegra234_bpmp_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra234_bpmp_slave_map),
 	.errors = tegra234_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra234_cbb_errors),
 	.notifier_offset = 0x19000,
 };
 
@@ -727,7 +753,9 @@ static const struct tegra234_cbb_fabric tegra234_cbb_fabric = {
 	.name = "cbb-fabric",
 	.master_id = tegra234_master_id,
 	.slave_map = tegra234_cbb_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra234_cbb_slave_map),
 	.errors = tegra234_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra234_cbb_errors),
 	.notifier_offset = 0x60000,
 	.off_mask_erd = 0x3a004
 };
@@ -745,7 +773,9 @@ static const struct tegra234_cbb_fabric tegra234_dce_fabric = {
 	.name = "dce-fabric",
 	.master_id = tegra234_master_id,
 	.slave_map = tegra234_common_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra234_common_slave_map),
 	.errors = tegra234_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra234_cbb_errors),
 	.notifier_offset = 0x19000,
 };
 
@@ -753,7 +783,9 @@ static const struct tegra234_cbb_fabric tegra234_rce_fabric = {
 	.name = "rce-fabric",
 	.master_id = tegra234_master_id,
 	.slave_map = tegra234_common_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra234_common_slave_map),
 	.errors = tegra234_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra234_cbb_errors),
 	.notifier_offset = 0x19000,
 };
 
@@ -761,7 +793,9 @@ static const struct tegra234_cbb_fabric tegra234_sce_fabric = {
 	.name = "sce-fabric",
 	.master_id = tegra234_master_id,
 	.slave_map = tegra234_common_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra234_common_slave_map),
 	.errors = tegra234_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra234_cbb_errors),
 	.notifier_offset = 0x19000,
 };
 
@@ -940,7 +974,9 @@ static const struct tegra234_cbb_fabric tegra241_cbb_fabric = {
 	.name = "cbb-fabric",
 	.master_id = tegra241_master_id,
 	.slave_map = tegra241_cbb_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra241_cbb_slave_map),
 	.errors = tegra241_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra241_cbb_errors),
 	.notifier_offset = 0x60000,
 	.off_mask_erd = 0x40004,
 };
@@ -960,7 +996,9 @@ static const struct tegra234_cbb_fabric tegra241_bpmp_fabric = {
 	.name = "bpmp-fabric",
 	.master_id = tegra241_master_id,
 	.slave_map = tegra241_bpmp_slave_map,
+	.max_slaves = ARRAY_SIZE(tegra241_bpmp_slave_map),
 	.errors = tegra241_cbb_errors,
+	.max_errors = ARRAY_SIZE(tegra241_cbb_errors),
 	.notifier_offset = 0x19000,
 };
 
-- 
2.35.1



