Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF694C83BB
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 07:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiCAGHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 01:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiCAGH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 01:07:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9097C63BC8
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 22:06:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MapGP8tZgsyJeERppwuz3IW9wqYv7bDYQ25k1KxqsPpbt9nA+iHxSs5ztEqRVGN86S7vnueENCnoMMuxEvcWT79li3EAfPS8ZYUDfoQOmyKPCasWjiqPpS/iXt15KF9fmPZlqSMMkoe8yNTrQhtt/QAFS3yk4gRfGahQ8umZVQKS5BmkJiCRA3zEThgO0Zy0b6BhlaP0CJ3mpFtsT46cr4PAxkMALfaNA27EBgrgwtMmAfgD1EDasVNMSjYiT4JH5V9W9mzb0axUDSASrVfo1V8G7B6zP149XD9M/sHH4QErjLj7l7C/AIxKLpQ63knlIdI14CN9s5PxXZlbZGzgDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1nwE+ATNSvBmbFoOno8bCnikaPXtUVs1D3F9n4JPg0=;
 b=DQz0355yVZ2+M11xnNvTvcNXuGY28vwZfZS6DEQT5bWxH34rorcnbTyhtd1lk+SglCicf/FY7bTTyZ1GXxqA6kdSlqjVfbN8ddyTy4s/smt53+Tmj4/2RpiqaculI2bttQndXitjsAzP2WlTqmCyNzBQJv1c5gl9wgXfwuP+LpSaC7czTf/NwipC2xsm5YCGqME1ZFSxt4FHpezocFn7Xi5vkA43Bon3IPCU/7cu7MJGvwTgUzHbeBdrzvpPDpru9VvO5UAEHTicflw7mXAPUOMXTRJ7k4XRMgJWxjItmaxfkzJiXOlDcEy1Nv1cjShezIHzpPLaFRLOP8Bgh+Ipkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1nwE+ATNSvBmbFoOno8bCnikaPXtUVs1D3F9n4JPg0=;
 b=Njc86SVgp2vG82Lq1+Uo/FwDc0xVAI5emxfVeoDgRYXXPwJR7LKJvqjdjQCZQ2JDdTmAPuL4FzeN8K2b5R0rTmV2eo+93t9B3hJ2xKABFfBX5NpfIU1DPclKQrOuut9dqe2LNRhuNPUvh4sA2JlU/cBRlZh+ynJrDN9cli0KJEY=
Received: from DS7PR03CA0281.namprd03.prod.outlook.com (2603:10b6:5:3ad::16)
 by BY5PR12MB4177.namprd12.prod.outlook.com (2603:10b6:a03:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Tue, 1 Mar
 2022 06:06:48 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::e6) by DS7PR03CA0281.outlook.office365.com
 (2603:10b6:5:3ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Tue, 1 Mar 2022 06:06:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 06:06:47 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Mar
 2022 00:06:44 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: Reduce dmesg error to a debug print
Date:   Tue, 1 Mar 2022 00:04:14 -0600
Message-ID: <20220301060414.1543486-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301060414.1543486-1-mario.limonciello@amd.com>
References: <20220301060414.1543486-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f772b65-f999-465b-78c4-08d9fb49ab46
X-MS-TrafficTypeDiagnostic: BY5PR12MB4177:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41778FE3FBC19F6279586BC5E2029@BY5PR12MB4177.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eWSwEJcxlVLDIp2hAORkvD4CsGAVZI5GVpCD5zSTZa1rUE9I5/as4RB4EWKGFVLtD5g3+ElcR0e4y6M/JOCnb/YKp1gieTbOyUU1wHgecznXDo0oX+XCoRWe5zvohUAR+YYRXI63ucDMC/TlW/5xB1i8QHRhUl3LqT6JSVKvdjjekRzsac4EuliDgCQfksjB750GLqsEOnZRSmNWkcGolPqd61/8dOsZjX2i/uEiikPPLNIwV9OHIyJtoWYjRnXwgCE7wmaPj/m6JJl2nPm8IgZ6va9/+T8wgI/vqvR9Z4Uoa1sygaMDV3686rQ7+gIhia2kz17nuE9xd1ADaL3zmf2M2L37lwWFOVGRd0Io5kr4Gi0Bqd/zYZdCT9TeiGJPXD3Zua0I14u8bkJO9tqUFEJg92Vcq1GAGKXsnrLRmmP3vUH0yU+WVcTL44KH/ItD86T/Ze1K4R+WD+3+WhjfW4q0wGkLAClC41dcopZMIOPpOlvPqA9m4Yi90GO62Rdq1u3zZW3oxANUbbZJJSnpI2+amBF2qq59yJProQ5MQz2Zs1TVrdjmLSQGkNdvB6nCehexHILqeJi/v8FNmZRDbkmZBAWzRjJ1pkABlYvjMTgqB4DXpAUvSO9qzgfKH8rpsYyepG5aJ7WJfPGcXBzybLr+6y7XdR/OPPwoaEEZelSe6WwoAcSS4yvhUWpUhk+E8rtVSpCPlNb6f/VNjuahPA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(508600001)(6916009)(82310400004)(44832011)(2616005)(8936002)(83380400001)(336012)(6666004)(426003)(2906002)(316002)(81166007)(356005)(5660300002)(36756003)(36860700001)(47076005)(70586007)(70206006)(1076003)(26005)(40460700003)(186003)(16526019)(86362001)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 06:06:47.3248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f772b65-f999-465b-78c4-08d9fb49ab46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4177
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Leo (Hanghong) Ma" <hanghong.ma@amd.com>

[Why & How]
Dmesg errors are found on dcn3.1 during reset test, but it's not
a really failure. So reduce it to a debug print.

Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1d925758ba1a5d2716a847903e2fd04efcbd9862)
---
Add extra define guard for the backport to ensure debug messages only
come up when compiled with DCN on 5.16.

Backport to 5.16.y only, different backport for older kernel.
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 94e75199d942..135ea1c422f2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4454,7 +4454,9 @@ bool dp_retrieve_lttpr_cap(struct dc_link *link)
 				lttpr_dpcd_data,
 				sizeof(lttpr_dpcd_data));
 		if (status != DC_OK) {
-			dm_error("%s: Read LTTPR caps data failed.\n", __func__);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+			DC_LOG_DP2("%s: Read LTTPR caps data failed.\n", __func__);
+#endif
 			return false;
 		}
 
-- 
2.34.1

