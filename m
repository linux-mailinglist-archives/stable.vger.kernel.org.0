Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D210543615
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbiFHPKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 11:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243513AbiFHPJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 11:09:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D91436AE0
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 07:59:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7zIufSlQzMOZpx2q38fHo10XYQ1l4Gc+oIsiAv1/Np+FboeFe3D1XZuzOkzD+CUzXMI0c2Wr0eGJRqiOMrUqGOcZ8yHIioINLwEdRqUXDGROKePNtnHGiSb60a6Jti6SU83EBqsHoTz51np3z+Fdwxp9pYwiOQtoJA0TuyCrJb4nmGC6PaZ8PGsvmOIuyeOrG4T7p4fVI/J8ZkoUZAoc+5TCrn0LjKDtFLqPRfuHhTFjyfdwhEcWL9C3IzCJUrVk/9Ovo93XUs/2sT3a2vyTEICmzS9lSiTZ28r2izXPxsWoJoXzjHqpvpR+lOeb0/0oMfYWeVIp9+ktq8rD5QA/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYOysDXSQQEOTCivXwuZ6+64GZfiCVQgCjiksFjZsXY=;
 b=ndcq/Te5x+oiw50mqaziczcIaBioCYgpzGpUWKThtnr3Ldd2//ZRtmGNZ9wgq6MKhVg3LmacZl8e4ECn7Y6JTpfZq6EWtv2czsc7kKg5nLXJYpR8lsoeWsd1GO2f0BJgZCyOfcX0eAmBobAWjHZUN8iz3yjDfNNJGDn/pbdhMWcfbmVgMobb5blufD75RIUdnHeS4iVfn9sR0a9tbO4sTI+yy6JlH8b2n4wx8eWglsJVZaZEDnXFMGvzHNS/lij0s51w9VPUYBltXJ5yM+ts5ANWeXBv+09Uo3I9ujy0vtbz1f42cwZJfiBXarsyw1Eb2FExVQFHxr1ZgcueFQOWlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYOysDXSQQEOTCivXwuZ6+64GZfiCVQgCjiksFjZsXY=;
 b=bjjvNxqep703rXYFYhubJXgAjC2X50Q0G5JJQs0nhNdbtIHl18NZa2yVHT10CtluyGyXrQNU4npb43kpSDcIK9wHpLSnejLF1iyMPnIWz0S4idcZSlKZlg9LGuVEwWptTNpm3/nDlzhXE2VuQ3LFTK/83X9wrtfbsffd/ci9jp4=
Received: from DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23)
 by DM5PR12MB2551.namprd12.prod.outlook.com (2603:10b6:4:b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Wed, 8 Jun
 2022 14:52:07 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::af) by DM6PR18CA0010.outlook.office365.com
 (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19 via Frontend
 Transport; Wed, 8 Jun 2022 14:52:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Wed, 8 Jun 2022 14:52:07 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 8 Jun
 2022 09:52:06 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/pm: correct the metrics version for SMU 11.0.11/12/13
Date:   Wed, 8 Jun 2022 10:51:50 -0400
Message-ID: <20220608145150.3536211-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3583d4bc-694b-4799-a749-08da495e7572
X-MS-TrafficTypeDiagnostic: DM5PR12MB2551:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2551764C9485CC04DAB4AC71F7A49@DM5PR12MB2551.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQW1YIXVK1tOLSxQLnXGNdBKdqB+DYFW8CKeQ0EyiHYe8uL96xrH79UuLPEyXyY5N3PnROyajcBmzbYXWTuz6ge4PmhN+eVxyGtB9xvyTW//YCA+AmWWTWTpkd7WCixn9TsYnxxv0tne3vcpY5+ILtdoR2zdi1Kt1B+Dy/Rkugrhwq6O8pk8aPgDu4nyKoTPIhJoDF34Ry7R+GClZauAxKKdU5c4RBE8DJg59uhxbI5tGTBwwRAmGW6me80guoa2gG+EG5m1W4cJ8x/2uXJr2YnOLRC2lTWdVgl84ZbSJcZrEKiiPl3HhjCMwpOnbBJ77z4izEpKT3uVhBnH1R0yLoxgOgPI1gZzcCxSedqvysme1hYZb9bk4HxMOljNeqWrVN52sEUU9BtK0OG40CRFgRIYIYk1XYmV9ctoKBeZgNe372F584lqNy3nlB07PlFS0YHjUWdpAYp0SI7JvB2J+PPslLPvONLCTtvb1wX9AxW5Gc7dUujZHXy0silwW4TLaN5Iy5r6NsQFP46lZNfhRGatn3N/4PRHuB8Zh+M4NqFglC3nF0h17gVWzEV0z9uMp3Sgw1aUVP5ZgTLaMcGyjXM0QLFC5aD/o7q5HvSrqyx2dG3ifkstb7pHQ4N8ZIci1khcewUVVElQ6crP5Q0hTlOG3wRGffrHHW/POHH+/QkjGcAAiToOU9cJ1uTajAm5c6hW8sGlt0DGjQbR7H8pbw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(336012)(966005)(4326008)(83380400001)(40460700003)(47076005)(36860700001)(36756003)(6916009)(426003)(70206006)(8936002)(16526019)(356005)(5660300002)(508600001)(8676002)(2906002)(70586007)(186003)(54906003)(2616005)(81166007)(6666004)(26005)(316002)(82310400005)(7696005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 14:52:07.1454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3583d4bc-694b-4799-a749-08da495e7572
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

Correct the metrics version used for SMU 11.0.11/12/13.
Fixes misreported GPU metrics (e.g., fan speed, etc.) depending
on which version of SMU firmware is loaded.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1925
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 396beb91a9eb86cbfa404e4220cca8f3ada70777)
Cc: stable@vger.kernel.org
---
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 57 ++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 38f04836c82f..7a1e225fb823 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -586,12 +586,28 @@ static int sienna_cichlid_get_smu_metrics_data(struct smu_context *smu,
 	uint16_t average_gfx_activity;
 	int ret = 0;
 
-	if ((smu->adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4900))
-		use_metrics_v3 = true;
-	else if ((smu->adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4300))
-		use_metrics_v2 =  true;
+	switch (smu->adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 7):
+		if (smu->smc_fw_version >= 0x3A4900)
+			use_metrics_v3 = true;
+		else if (smu->smc_fw_version >= 0x3A4300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 11):
+		if (smu->smc_fw_version >= 0x412D00)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 12):
+		if (smu->smc_fw_version >= 0x3B2300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 13):
+		if (smu->smc_fw_version >= 0x491100)
+			use_metrics_v2 = true;
+		break;
+	default:
+		break;
+	}
 
 	ret = smu_cmn_get_metrics_table(smu,
 					NULL,
@@ -3701,13 +3717,28 @@ static ssize_t sienna_cichlid_get_gpu_metrics(struct smu_context *smu,
 	uint16_t average_gfx_activity;
 	int ret = 0;
 
-	if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4900))
-		use_metrics_v3 = true;
-	else if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4300))
-		use_metrics_v2 = true;
-
+	switch (smu->adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 7):
+		if (smu->smc_fw_version >= 0x3A4900)
+			use_metrics_v3 = true;
+		else if (smu->smc_fw_version >= 0x3A4300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 11):
+		if (smu->smc_fw_version >= 0x412D00)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 12):
+		if (smu->smc_fw_version >= 0x3B2300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 13):
+		if (smu->smc_fw_version >= 0x491100)
+			use_metrics_v2 = true;
+		break;
+	default:
+		break;
+	}
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics_external,
-- 
2.35.3

