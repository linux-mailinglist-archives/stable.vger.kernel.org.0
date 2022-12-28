Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC486579BD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiL1PEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiL1PEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:04:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8B213CD4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8920061547
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D86C433D2;
        Wed, 28 Dec 2022 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239848;
        bh=qs7ePXJz6nWPfINvO/KZHy64/AVUTkyglbnJs4m5cm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNe9QcKrzKMyNokuSac3/cyzlNTcLB/pP4/2xWbD1FRnE1V0+YhGNdz8iAWH1vZ68
         xk65ZJl230LSNkneE2WsK2718vk4U56uCE4/owhHV0EkFxBfl3CYONF1LQ5AiHdfFx
         DCL6ZlwF5wjWlfIq6UYvZf34aWvCc5loMwtUUH+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sumit Gupta <sumitg@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0050/1146] soc/tegra: cbb: Update slave maps for Tegra234
Date:   Wed, 28 Dec 2022 15:26:29 +0100
Message-Id: <20221228144331.521283065@linuxfoundation.org>
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

[ Upstream commit cd1d719b47767f1970d02d18661122b649c35b00 ]

Updating the slave map for fabrics and using the same maps for DCE, RCE
and SCE as they all are a replica in Tegra234.

Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: 55084947d6b4 ("soc/tegra: cbb: Add checks for potential out of bound errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra234-cbb.c | 34 +++++++++++-----------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index 654c3d164606..04e12d9fdea5 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -516,7 +516,7 @@ static irqreturn_t tegra234_cbb_isr(int irq, void *data)
 		u32 status = tegra_cbb_get_status(cbb);
 
 		if (status && (irq == priv->sec_irq)) {
-			tegra_cbb_print_err(NULL, "CPU:%d, Error: %s@%llx, irq=%d\n",
+			tegra_cbb_print_err(NULL, "CPU:%d, Error: %s@0x%llx, irq=%d\n",
 					    smp_processor_id(), priv->fabric->name,
 					    priv->res->start, irq);
 
@@ -732,48 +732,35 @@ static const struct tegra234_cbb_fabric tegra234_cbb_fabric = {
 	.off_mask_erd = 0x3a004
 };
 
-static const struct tegra234_slave_lookup tegra234_dce_slave_map[] = {
+static const struct tegra234_slave_lookup tegra234_common_slave_map[] = {
 	{ "AXI2APB", 0x00000 },
 	{ "AST0",    0x15000 },
 	{ "AST1",    0x16000 },
+	{ "CBB",     0x17000 },
+	{ "RSVD",    0x00000 },
 	{ "CPU",     0x18000 },
 };
 
 static const struct tegra234_cbb_fabric tegra234_dce_fabric = {
 	.name = "dce-fabric",
 	.master_id = tegra234_master_id,
-	.slave_map = tegra234_dce_slave_map,
+	.slave_map = tegra234_common_slave_map,
 	.errors = tegra234_cbb_errors,
 	.notifier_offset = 0x19000,
 };
 
-static const struct tegra234_slave_lookup tegra234_rce_slave_map[] = {
-	{ "AXI2APB", 0x00000 },
-	{ "AST0",    0x15000 },
-	{ "AST1",    0x16000 },
-	{ "CPU",     0x18000 },
-};
-
 static const struct tegra234_cbb_fabric tegra234_rce_fabric = {
 	.name = "rce-fabric",
 	.master_id = tegra234_master_id,
-	.slave_map = tegra234_rce_slave_map,
+	.slave_map = tegra234_common_slave_map,
 	.errors = tegra234_cbb_errors,
 	.notifier_offset = 0x19000,
 };
 
-static const struct tegra234_slave_lookup tegra234_sce_slave_map[] = {
-	{ "AXI2APB", 0x00000 },
-	{ "AST0",    0x15000 },
-	{ "AST1",    0x16000 },
-	{ "CBB",     0x17000 },
-	{ "CPU",     0x18000 },
-};
-
 static const struct tegra234_cbb_fabric tegra234_sce_fabric = {
 	.name = "sce-fabric",
 	.master_id = tegra234_master_id,
-	.slave_map = tegra234_sce_slave_map,
+	.slave_map = tegra234_common_slave_map,
 	.errors = tegra234_cbb_errors,
 	.notifier_offset = 0x19000,
 };
@@ -888,7 +875,7 @@ static const struct tegra_cbb_error tegra241_cbb_errors[] = {
 };
 
 static const struct tegra234_slave_lookup tegra241_cbb_slave_map[] = {
-	{ "CCPLEX",     0x50000 },
+	{ "RSVD",       0x00000 },
 	{ "PCIE_C8",    0x51000 },
 	{ "PCIE_C9",    0x52000 },
 	{ "RSVD",       0x00000 },
@@ -941,8 +928,12 @@ static const struct tegra234_slave_lookup tegra241_cbb_slave_map[] = {
 	{ "PCIE_C3",    0x58000 },
 	{ "PCIE_C0",    0x59000 },
 	{ "PCIE_C1",    0x5a000 },
+	{ "CCPLEX",     0x50000 },
 	{ "AXI2APB_29", 0x85000 },
 	{ "AXI2APB_30", 0x86000 },
+	{ "CBB_CENTRAL", 0x00000 },
+	{ "AXI2APB_31", 0x8E000 },
+	{ "AXI2APB_32", 0x8F000 },
 };
 
 static const struct tegra234_cbb_fabric tegra241_cbb_fabric = {
@@ -955,6 +946,7 @@ static const struct tegra234_cbb_fabric tegra241_cbb_fabric = {
 };
 
 static const struct tegra234_slave_lookup tegra241_bpmp_slave_map[] = {
+	{ "RSVD",    0x00000 },
 	{ "RSVD",    0x00000 },
 	{ "RSVD",    0x00000 },
 	{ "CBB",     0x15000 },
-- 
2.35.1



