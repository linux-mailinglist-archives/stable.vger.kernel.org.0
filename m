Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EDA6CAEBC
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjC0Tfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjC0Tfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:35:47 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CACA2727
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 12:35:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyMu19LiLqjNu6JPdUuEJJu8RbQ0MCkgCVNYA27M7SNYo+pM6E2ne/ZeXwCAdbGGz4KfPZ8zqR6PAff+gwFYpGVxCz7e+zFImBai8ytULj/DgyXuS0d1UYWdsFB5RkyQTn+qzsLFx+wcvZ7Vi3hCzmkRvjIN+GzjPurONfY4hT6JjJDm1sLkIbhIBYX7Vnmb7y/WoLzuq0YasKls8RVxbwDh2p/C7dzJzJDbdJYBo5iTxhaO6KWR5C74Xm6Kp6/X32aYcCNg+HTDV5A9XKxDcLIolHqrQDOwkFxCCw9FjUZenSQdQ8qq8pTkbogkgctJZJsVp/frGSe8CHzZl/4ODw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FzBl9NNDqkHF24qm8gfrLKaNsqx+MkZmGRzpRBQ1iiA=;
 b=XEVbNIYa+hI0GDGC0Jwo7Ngrp+TWU6p4+xDO1oWDGcoOkCYV0PqC1m7BkaixyHvBiiV7HmmtYKjb8qiypY4pTvglVK1MzTddi/rBXK+BzsOfHrKxaMTh2S1yiHHvGV0YobQsILH8ZwbqMcfxTs+ewOS/zXsURkAYo0PfftJQMs/YlOGG6QdyqXJfVHAUGu8r8KGsFZxENt4Q0UzkXUBsvXgPag4asOJztaU4z2AGaxqsBhgA6B+nPgCtbDIZvLTW49+PzwY2t70yUKZ3Cc6UiHjVU59daAiUWU8RUrQxI9L68zGHUuBJQ+1CI4+98X9BZCy+TSdoxH5p/E2ai2J7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzBl9NNDqkHF24qm8gfrLKaNsqx+MkZmGRzpRBQ1iiA=;
 b=G+cX6+SLqi9cBgUM71s8ULUMfk3Dfys5ngxrC73Eix9yGD6fG8TzW0AUIEAZjn5TWFwQJ5zXQrTzErpUiDdcuDXuEOiU/qCU/wqvynjF1oYFqYamrwplbCfG4hYQ7Zx8bSF+gu+DKiME4UcZhGa93eXb9F7SqW0YCZtXs8DvTX8=
Received: from DS7PR03CA0138.namprd03.prod.outlook.com (2603:10b6:5:3b4::23)
 by DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 19:35:39 +0000
Received: from DS1PEPF0000E63F.namprd02.prod.outlook.com
 (2603:10b6:5:3b4:cafe::52) by DS7PR03CA0138.outlook.office365.com
 (2603:10b6:5:3b4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.42 via Frontend
 Transport; Mon, 27 Mar 2023 19:35:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E63F.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 19:35:39 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 14:35:38 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 14:35:38 -0500
Received: from aaurabin-elitedesk-arch.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Mon, 27 Mar 2023 14:35:38 -0500
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <bhawanpreet.lakha@amd.com>, <rodrigo.siqueira@amd.com>,
        <harry.wentland@amd.com>, <aurabindo.pillai@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: set correct capablity for MPO on DCN321
Date:   Mon, 27 Mar 2023 15:35:37 -0400
Message-ID: <20230327193537.2603330-1-aurabindo.pillai@amd.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63F:EE_|DM4PR12MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: 95d47d7e-899f-4501-1c5b-08db2efa71f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFczlYFo+8J9b99VoY5hC8EEkTq0LWJkjBCe7d3Xk18RzOLRUulzgnBuJxAUjPeQ3SgRd5o7wv2VRC0+Bdu6vgz5/USbIq+J4LEt8y0odAKIToxQz3ZksgKJ8a3/5HcG9v88dokMqo7T0UrqOWexa8MjQLu4avq3sBrh4HwTTlB7qPyKiUfENAtULU2YbqgWJ6CDdt08C42We7t++iwp83Bi7eHHnp7u+ks/Ms7+82kU9mNImVH9Y9WqjREhREYH4vOh9XVKzIF8Sgm6TSnlWgwVM2YccWPN3KHgg0frUq3bG6nldZDyWR5BUfZKW6GLMv0EwwrQOPBmoksr5FLZGcnvKhMIil+ypRv6OymxBqJkhozMLjoFoj7d3fNH58CxhkORVGTV1nuTC44mSPzySCsVm7IZubJ7AkfA3nXK+1aWl70mt6BiAPyI6CRN5YExTJrWTx/hjv92qPrDwbCOoOQdkK/WQRbA1w5cAFef0STMwH09jNDSILBnEzlaFnu6wsBpd2QOZfo6ezXuYpuVKgYeuwdw+9Ugg1KONCtVZoixPjaSzGefGaVpC1Nj+6XYIou+WfLQTmdv8hvA58Eims/oCElPJjWzHaUZncziBimHhYf3KNt3pEWFuNaafGvSXhMg+4fw56PkELF3Z3d6Z7CzK9mv3Etqff/6bZFQtcpyA2IxgYt7H3/AQwoZ933L7EzhSKX5QYyDkVwdt9DhKtVU0HkksxYY+N8ryIaS67g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(70206006)(4326008)(6916009)(70586007)(316002)(5660300002)(54906003)(7696005)(81166007)(1076003)(26005)(44832011)(8936002)(2616005)(186003)(41300700001)(478600001)(8676002)(336012)(47076005)(426003)(83380400001)(82740400003)(36860700001)(356005)(40460700003)(86362001)(36756003)(82310400005)(40480700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 19:35:39.0997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d47d7e-899f-4501-1c5b-08db2efa71f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6280
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why&How]
Fix the incorrect value for parameters used to enable multi plane
overlay support for DCN321

Fixes: 235c6763423 ("drm/amd/display: add DCN32/321 specific files for Display Core")
Cc: stable@vger.kernel.org
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index c6a0e84885a2..87b9dac4110e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1723,9 +1723,9 @@ static bool dcn321_resource_construct(
 	dc->caps.subvp_pstate_allow_width_us = 20;
 	dc->caps.subvp_vertical_int_margin_us = 30;
 	dc->caps.subvp_drr_vblank_start_margin_us = 100; // 100us margin
-	dc->caps.max_slave_planes = 1;
-	dc->caps.max_slave_yuv_planes = 1;
-	dc->caps.max_slave_rgb_planes = 1;
+	dc->caps.max_slave_planes = 2;
+	dc->caps.max_slave_yuv_planes = 2;
+	dc->caps.max_slave_rgb_planes = 2;
 	dc->caps.post_blend_color_processing = true;
 	dc->caps.force_dp_tps4_for_cp2520 = true;
 	dc->caps.dp_hpo = true;
-- 
2.40.0

