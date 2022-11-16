Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB762B276
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 05:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiKPEyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 23:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKPEx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 23:53:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D859A5F6B
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 20:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfO1+/DyzM156i+VjLJ2nlVctLa+MYM+DVpdN6n7Kw5fJTIBC7aJvKmfHqgy11ObzpabFVL/JfgEKxyvbGe0TS+qAfHOz7yLQO/TSCeGwtafjUz97VqusoDoQt4PgiFX9AelJbD+/fE0S3+NaJhWfY6qQXg/r/8wjTJMTnidD8f5ZtRF6j5a+1XYNu5PYN4X85N06DyrIYY6pqqyFV9MMaXratlkG+1DEzGZqFcjFeposVVqkVEzv/qNzo2ANLD+q5utKDE5KF/wyaBRcC3u5Sdy1Ck6skjMh/ZTqC3Xb2jkHvW0QnyGg/2hpF0+8lVBQo9DRurlz2zBXXg5D/U3pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnpLMhFZUWzdSmSc26Ngkg44++D76MbfWOxQ3RfE1fI=;
 b=C+rd/9w5WEIhSqcDVAnCUxAIvcnYUDshGd2i/sMV4/zxegusEODbbJRiueusYRS5BRLdRE6i38cmPgRQtiIslI1/MTux+K1C0/IgR8HPZqmnCAGnGLZOwOR5HLuQIbVP91zBNsIP9qrwtTeVptDIqLi0atthxAEAXzUD7aWLm0EimWCdDp7znUXr+glyTZOc5mDuRH66u0ol6ouB6pAkXr49NUTZp5zx8uChb8IrHTeE3h4IPzSpPY0oSsUtWXjKf2MTMGiK5fOEdbzZPZi94vrJg3ClUlT6ahvUtXC55CI3Rr3l00Zasxl1BsLlZt+MASa7S8QXw5DuRPl/ly9uvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=igalia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnpLMhFZUWzdSmSc26Ngkg44++D76MbfWOxQ3RfE1fI=;
 b=rwpoFFZJgF8HZmojwvoWVUNnjjrcNKO3UT7a0keBCwxVn/iq/WgqGg8KUwDjibNL+J6H6sgIg1IIfAdwkCc+vJho5n60SEQ/Jv69og1DTi8B3yTwd2AIrBgxk/8BNJoY+mX/ticEh5MnCOgnAht2QMP7RyXdrq5EZny+feSghLE=
Received: from BN0PR04CA0168.namprd04.prod.outlook.com (2603:10b6:408:eb::23)
 by PH7PR12MB6660.namprd12.prod.outlook.com (2603:10b6:510:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Wed, 16 Nov
 2022 04:53:55 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::6) by BN0PR04CA0168.outlook.office365.com
 (2603:10b6:408:eb::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Wed, 16 Nov 2022 04:53:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Wed, 16 Nov 2022 04:53:54 +0000
Received: from amd-X570-AORUS-ELITE.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 15 Nov 2022 22:53:52 -0600
From:   Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
To:     <christian.koenig@amd.com>, <alexander.deucher@amd.com>,
        <gpiccoli@igalia.com>
CC:     <Mario.Limonciello@amd.com>,
        Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] drm/amdgpu: Fix VRAM BO evicition issue on resume
Date:   Tue, 15 Nov 2022 20:53:02 -0800
Message-ID: <20221116045302.1007888-1-Arunpravin.PaneerSelvam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|PH7PR12MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d1ec4fd-75cc-433f-52a2-08dac78e9029
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cCF8iGoKOIJN38YF9aSKre2f+WVI8mOzDncEH7yYMXUAzdTCjLsc+iqUonSvQVbTz7RSG30eOUgbUhTKr84DYHuB1TKvEBgNse/F8fulxltHY5liUlE4faNbGk6QU/x2VLE795X0Hg97X9WDhH4mNyVJZXtG6S0G/VCJavLQKVJmuhoWUyA78MT0E2eIeBBCkrShxFlEpEx9sggtMjQ+oGE600XPCnK5U6eGRAWOqgfH62QV8I5SoO69rAuVfxqy/zecHdpJfg/KT+Vp7d6jsBEa9M1D5TW5oZP4zNjIOHQ0F/Gj0dkhrXhyuJtvFH7BgYvP0mBYrPLcEkuwRGd9rAPYhxfChSSD5BQcVc9Nmsu5oWuucORAVyOwyPAbu8afx622CZpo/LptRcinMoMm6TlPWWluh9aXZYujpctBCZht2gjAom1A+/Iq4myj0eyIxULZrDg7k7+NBrFZ9nw5VIi3BaZaGZLDi6ZJhxshICh/C+CZz+iqTS/1cvLmy7phEsqDP1i3kONXoEAwNEenaQPtI5hverQovg3U8sZuDVV5H7Dhm+xoKtiHlGbCoPRzcvKVTBC2+HKtCIr0jHFgaZI09Q8ILmPXq/pXMctChZvHcGgRpFDkpft5s0CTx3StZxgFslDOuN/Fqg/bjSdziTPrqYsFBdqD7M/uQ5Gd1l2aRX5uFR1Zj98FbCgC716OtgSY+gy/bUy2wuJ5We/gXoVic4jV95GWNbGTbQG9UGkxG4uZwTmbt8BPmkd3sBWM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(40460700003)(426003)(2906002)(47076005)(186003)(70586007)(8676002)(41300700001)(26005)(966005)(336012)(5660300002)(4326008)(70206006)(2616005)(81166007)(82310400005)(1076003)(356005)(36860700001)(16526019)(36756003)(82740400003)(83380400001)(40480700001)(8936002)(86362001)(478600001)(54906003)(7696005)(110136005)(316002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 04:53:54.3632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1ec4fd-75cc-433f-52a2-08dac78e9029
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6660
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

Gitlab issue link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213

v2: Added issue link and fixes tag.

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

