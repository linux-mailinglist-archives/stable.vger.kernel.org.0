Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3354E62B2F8
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 06:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiKPFr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 00:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiKPFrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 00:47:55 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387F613F34
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 21:47:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoLn8hyPUUrvBasnTeVyp0T1WMb/JezmitEniL+v/5FQ+iJem4N5WBd5DZ5sy44DBImE+6NV5t7jgPU5fIxl6yVy1AzJ6Klc/iwyOo0ZJK39IrW+45EMyfNNeLn+c55qZ3jbKA0V/+6ATRzDTIXwMDshp1x/sxVVSWG3KKBcEScwLWd3Pad5ZcufttjeUoTvxDKzyXHzmb1z+x9clm6Xg1fpDrdDgS7E1hnIDsD8kj30ZuRy20wZQjxls7vD6Voucf3kvPeemAyWubrp8o29sdir7xTayA0cIeAjyxczscWUXvQ4fEF6c5c6iM3fIO79+zUfr9Xy+gyonONDh7zmVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1T+0eRSEai10VWqpZTvwlAa4aL+IzmBOjry597QZxnE=;
 b=KC7v9sKRhlE9+m9DwBgu5gH6NYpawzd6YWcwvwU5jTSWyj1Sc/aY5WOo6iSREZZpXgFsXQUxMjLlrpe/qJj6YVwmJ3cgE1M9kRaOWQuWe1DJXkJygoiZVzjzijA6DYQw0YOh0mB1Be1bMmL3shjj9ftG84KhmLW0sZlRBmR4wyb0hKRTwsEMVMekQWyNdVX+LwB4PSXO12thF0F5sdmQimPks3ECHgiAYg9WmjRh2uyha+//qi78dVgHa5OQ6GIPhaiFu0d0hVBMKIj4obIbw0/opqpiywFr0MIJGdRa4MDA8iyRHD8XXpQO31fdUBgGcZr4ibYKtT9leTYZzu2AMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1T+0eRSEai10VWqpZTvwlAa4aL+IzmBOjry597QZxnE=;
 b=eIGi7x3GQKUxrqTArlq9lcd8LgTpzoiY8vBzAH6DAgniyaRHBdLnybUY3iTdQ38u2I3NdX5lP0wUDHmKKorXNc8is7S7oDPahee9CDpLi7SlisHkjmL/hjf4HO/7tfQwbvJA02RGmbOioyYejOt1VFFes45i0gqutbfSSC3bPMM=
Received: from BN0PR04CA0095.namprd04.prod.outlook.com (2603:10b6:408:ec::10)
 by CY5PR12MB6646.namprd12.prod.outlook.com (2603:10b6:930:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 05:47:51 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::50) by BN0PR04CA0095.outlook.office365.com
 (2603:10b6:408:ec::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Wed, 16 Nov 2022 05:47:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Wed, 16 Nov 2022 05:47:50 +0000
Received: from amd-X570-AORUS-ELITE.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 15 Nov 2022 23:47:43 -0600
From:   Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <christian.koenig@amd.com>,
        <alexander.deucher@amd.com>, <gpiccoli@igalia.com>
CC:     <Mario.Limonciello@amd.com>,
        Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] drm/amdgpu: Fix VRAM BO evicition issue on resume
Date:   Tue, 15 Nov 2022 21:47:21 -0800
Message-ID: <20221116054721.1008253-1-Arunpravin.PaneerSelvam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|CY5PR12MB6646:EE_
X-MS-Office365-Filtering-Correlation-Id: cbfe32c4-a23e-45b1-43cb-08dac7961930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/JJ4VZQMkDaeqwK1S/feMVoO/yvBdeTqiQ3OapaapjPeaSXrv5/zYdxLBhN+jeuRpT7LMPTEuyssS8TUSqRBhb4XW9Qrti7XLdaS/djzlo2c5bgJAaMj+6qxJ7ah7LuSD8OWfeMcbvlUxc0YxdQn3+wpAH8GdSyx4eYToeHlvBIxMfN5w4h9r/6tyP8357/Dzl2NPWl5KiLGWsu7eC+mvB3k1VVybdkhw7rJzqwMJBd6Ap8qN7AuSoA6z/zSLyyhbXdJuvqa83oHapBXou0hw0EbozUbhGAPn/Bt29Z7FPajDJfi92i8j1RIzHygYnXZ+/iFFCV2N9FoVmnQetVzvnqTsiJdxRemX6r2n1i1gLzYD54Suv++WfWosMCWWJK7DY+nTOvvp1clNwBhfdB42RHMzfQVimThlbT0mfsjaH/zzC8hGXpulwe4zLHZAhf9HklBPtt1r5+nCebZrK6FM+PwSEG71nreG2vaP5V46rg6oQ7ErR3vuV3W+qKPYA5hSpvY3jELrWR0V1CfGL5lS69F4eVhvndcdIFwireq4KJCv0AaFyFoO/uzGewTgBkQETagnipJHi/XmJ4WS8EDs3L2AhLZ0tw9KoqEuFbJCIuG46TfWM8sznbbfMx3DqBYrnbvnQ4Q/v3gGfXUHKYgfyP/ebkNimqmlZaqKQpno5cZJEOipA/vTW9/s6v8O7/hLpF2kjNy6oET6jujX1fVqbIpdt4NWjdx1ALwIHfiyWwgCGPsZIMW6gAf5E71Hu1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(81166007)(356005)(2906002)(40480700001)(8936002)(5660300002)(70206006)(4326008)(8676002)(70586007)(41300700001)(83380400001)(36756003)(6666004)(336012)(186003)(966005)(7696005)(26005)(16526019)(82310400005)(86362001)(2616005)(1076003)(47076005)(36860700001)(426003)(54906003)(316002)(478600001)(110136005)(40460700003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 05:47:50.7493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbfe32c4-a23e-45b1-43cb-08dac7961930
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6646
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes the VRAM BO eviction issue during resume when
playing the steam game cuphead.

During psp resume, it requests a VRAM buffer of size 10240 KiB for
the trusted memory region, as part of this memory allocation we are
trying to evict few user buffers from VRAM to SYSTEM domain, the
eviction process fails as the selected resource doesn't have contiguous
blocks. Hence, the TMR memory request fails and the system stuck at
resume process.

This change will skip the resource which has non-contiguous blocks and
goes to the next available resource until it finds the contiguous blocks
resource and moves the resource from VRAM to SYSTEM domain and proceed
for the successful TMR allocation in VRAM and thus system comes out of
resume process.

v2:
  - Added issue link and fixes tag.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: stable@vger.kernel.org #6.0
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index aea8d26b1724..1964de6ac997 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1369,6 +1369,10 @@ static bool amdgpu_ttm_bo_eviction_valuable(struct ttm_buffer_object *bo,
 	    amdgpu_bo_encrypted(ttm_to_amdgpu_bo(bo)))
 		return false;
 
+	if (bo->resource->mem_type == TTM_PL_VRAM &&
+	    !(bo->resource->placement & TTM_PL_FLAG_CONTIGUOUS))
+		return false;
+
 	return ttm_bo_eviction_valuable(bo, place);
 }
 
-- 
2.25.1

