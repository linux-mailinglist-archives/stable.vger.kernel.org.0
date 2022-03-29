Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D054EA4C5
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 03:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiC2Bvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 21:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiC2Bvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 21:51:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B555C3B03F
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 18:50:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPmXRjE9dWa9bh94FwLPh0mksp/cr/aIu2Ut1G/ViE1fub4ArfeOjgF/h4hlfUEhhw6+jesHe4oWf2DaB1q0RMM8tB1vT36CxASYl9ca1EoXANJPj+J6VWryXdxPUOjvDeGAAvryFJmXHvvEAmh9PrSEXWNlGC6viD/yO1nkxQrFX9PutWBCPju0lKYsm0Zz2z4iSDVBvt2wYW9/iVaDPgYWwyw+IQHcTqiQ+HFqR48thqc3rjUwWGXdFCIMKZ3Env6d2b68Vn9jN8CPgfDtU708reZ8Sex4lq0ze6VD0z3Nn1Ls2+pHBFPenAOuau3vbYZifSIMRC0U94yplRNvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fY577RBdpU5NEKUZLpAI+VnRpIBR8bMNci8DCME/two=;
 b=OpDPMF/LjwMcA/ugAz/fBobEgRYnzYcAXx5iNk9sHDiy9eqJ/kaMOIaVhcNGQ9gJLhFS70FZzsLCMqnPK15i3GI2R6oOzmxK35k1LIW8aHlWCweUR9thwPsvj3a6hJ4uZ5uRE1fpAvnqAhEkCmAA0y+h+NitRq854dd26QDVBK11rIL8h94d1ZKd0DzMXRH0XT/ogrELU+qdhbFjULjBGUAuT2WqPBDJrgvwuSKrLewRKtWuI10xgGEedUsG+P9glbuJQm1oyZc4VNUvu6l1OM79/jt9jo4+xmgXjODA2+MY1GocxNEKw3qwNOgpEOR2wXZxkm50wP6PazrfJylrjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fY577RBdpU5NEKUZLpAI+VnRpIBR8bMNci8DCME/two=;
 b=Sl6xtF9fiZaYZgA5t8/8BJ/QjMpAZGSUtvHhNOqOZeygiLF1m/m/j3HPzb5Imq0Ev+QxNZuVIIV6uHI7qzAUIPRx/UX8SlnTk5Wfdv4Xczp5LVeoKphzRV/Ai6iJO59Plv+n8rdpZ5OUUCRmwrr2qS21srWHBSfKn8Jvj/Djl1E=
Received: from BN9PR03CA0427.namprd03.prod.outlook.com (2603:10b6:408:113::12)
 by BYAPR12MB3573.namprd12.prod.outlook.com (2603:10b6:a03:df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Tue, 29 Mar
 2022 01:50:05 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::e9) by BN9PR03CA0427.outlook.office365.com
 (2603:10b6:408:113::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Tue, 29 Mar 2022 01:50:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Tue, 29 Mar 2022 01:50:04 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 28 Mar
 2022 20:49:59 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     <mpearson@lenovo.com>, <Richard.Gong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 2/2] drm/amdgpu: only check for _PR3 on dGPUs
Date:   Mon, 28 Mar 2022 20:49:52 -0500
Message-ID: <20220329014952.471-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329014952.471-1-mario.limonciello@amd.com>
References: <20220329014952.471-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94e0b9a5-54dc-4e24-58c4-08da112671c3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3573:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB35734D8CCA9B1B295871D4B5E21E9@BYAPR12MB3573.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ugLtQmuVMDPJwyjxwesZI1HO3Z9WiBb0zcNSGT0+bm3nPt2rs+gdAkagNODcfb79w5OxqLVwiofx+UwPHPTNiv3iXcQCTTScj/uwHhOeN4jFcDFN65AJv4gGx/amBQKVdiNTTGnDnW9dEE2f+3op66GAd76i3OYrUPW2hnNs0NWgBniVMN3oPRDHwl+BIzykCMUQ032YmGaPLnt9sj9YcgsQKA+j9a6fqVL+3rpJmYJgOPnEJNffb3qPni3Mm8/V32BesEGQuLfbxphNt9hVYQX8OEktzVxO3t8//Z3fzONXMSVgH07Qotth/0adQIWzqet/DbhQ2ot5f3uTbljagaVzFx8ZVEbEi2oe+XC6Varm14KFC4i0mp/UAobWyawK+ZbeRtj+RJxbSFtL5IJVtwIN4KBT6B6YiMqGqkVqKWifcopB+VA7tJ42HXTijJBY6+53vEItvi9rytQ67X5Fh7oL74r+a+Q5iwHGLCk1RYOuAXGmnd9gAkdruupTW9V8ljfRPiW17R1Y9umsThEFhQawi859OGBYZvhXSjPJnKSRD/9G6n23Ya1fOplK3AyxA8q4Zhc6GobfaCagXWXTpxwxRlH5R27FNc6kiSAaGd2Tgxw7HfK7FhczbXiINR4XUh7I8rXiP5958CcpH1i6iuI5Mkn9Kh+PaxcGTXTTye9BwkHW1w9PIGDrGy+KETy0FiNZjtWtyx8l9/S6aATqkg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(70206006)(508600001)(7696005)(316002)(6666004)(8936002)(44832011)(4326008)(5660300002)(86362001)(356005)(6916009)(36756003)(82310400004)(8676002)(81166007)(2906002)(54906003)(83380400001)(47076005)(40460700003)(36860700001)(336012)(186003)(16526019)(2616005)(1076003)(426003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 01:50:04.0778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e0b9a5-54dc-4e24-58c4-08da112671c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3573
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

We don't support runtime pm on APUs.  They support more
dynamic power savings using clock and powergating.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 85ac2021fe3ace59cc0afd6edf005abad35625b0)
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
No modifications from original commit, just sending together with other
dependency modification.
Please apply to both 5.15.y and 5.16.y.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ea3af6f59ca4..6be480939d3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2144,8 +2144,10 @@ static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 	    !pci_is_thunderbolt_attached(to_pci_dev(dev->dev)))
 		adev->flags |= AMD_IS_PX;
 
-	parent = pci_upstream_bridge(adev->pdev);
-	adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
+	if (!(adev->flags & AMD_IS_APU)) {
+		parent = pci_upstream_bridge(adev->pdev);
+		adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
+	}
 
 	amdgpu_amdkfd_device_probe(adev);
 
-- 
2.34.1

