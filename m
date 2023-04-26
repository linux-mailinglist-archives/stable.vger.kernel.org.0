Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73A6EF86B
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 18:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDZQ2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 12:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjDZQ2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 12:28:01 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A004F769E
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 09:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1m9bzo8BQaItSorCWRtYwS1mdpX5qDr2LCh9453j6bwJm1kYsuY4dJA2rkeCntMHw9nFymhCD3dWd5TEFNuhUGhOjZH3DlVK7xMpAiyRUdpNklvYBycZloevwirag8qFk52D/2TecfY5ESTGcspBqgYrDTgcgFVymUfZCJ+/3wG8sAKzNftdEnEfXW2elTEAO64JS2ygZjIDxIGrvEJDNDN7t6u1DwwuxmXajCdX+B0Tc80ufRu4z0waVK8PHTlJlLuIdTdC8UR2pJ010MKvr8zaoxPzs7ulmnwQ1zRMwIatZ62j/zLx97Cx+9Tylb5vdBFCranajAWJwf1ze9c9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylb7n5VioOAdBS8yah+fIR8ZVC8bAiBDTShHZo1BJdQ=;
 b=DBO2UNrj+s380BUbcz+L7wSn4JhEzRLzFBKnRPYwZzBVTZIYt/bUdFjcht3dOQ3tbH9Tt6KCMJzfuqXDDZ2tNpbjP1moIsxUnjDWjBW4vBUQ6p3lizdHm0gew8xvgGwryPTSnWKir2m2p4MqwbyyI8ZTuOPDZvZE9mmsCFrT/pU8yqqSnOrajRxFlhgoyKJ+8OTgeCDMp6iP0CroepkgjxYBtnZHESLE8aqBJ2RwfXYZ/ULhCwjp4Q2aK94v+tYpVRDi34+cbTnK5VRQ9zba0Z3P81FFHuAN0q6Jog5RU4nDjhTQEfJmqiwc4FscZ6wZ1BpnZaVqFYYxkXW01FwOEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylb7n5VioOAdBS8yah+fIR8ZVC8bAiBDTShHZo1BJdQ=;
 b=DSxd52h27M8g3H58e0wH8FtIZABHb5/zaVEJy4609g35qAG0L1ceuE6qGl13xEBgDXnoA0KoZ0Tnf3ctcfYq+TJUxg76/DXBn0oPn0uI4UEFZq6pmC6aB8G43um5VjjPI6yYeL4q7zBmtBU5VnBkEd50V1dlOwmgAkC12PznwiI=
Received: from DS7PR03CA0175.namprd03.prod.outlook.com (2603:10b6:5:3b2::30)
 by SJ1PR12MB6364.namprd12.prod.outlook.com (2603:10b6:a03:452::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 16:27:55 +0000
Received: from DS1PEPF0000E63B.namprd02.prod.outlook.com
 (2603:10b6:5:3b2:cafe::37) by DS7PR03CA0175.outlook.office365.com
 (2603:10b6:5:3b2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 16:27:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E63B.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Wed, 26 Apr 2023 16:27:55 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 11:27:54 -0500
Received: from alan-new-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 26 Apr 2023 11:27:50 -0500
From:   Alan Liu <HaoPing.Liu@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Leo Chen <sancchen@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        "Mario Limonciello" <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        <stable@vger.kernel.org>, Alan Liu <HaoPing.Liu@amd.com>
Subject: [PATCH 2/8] drm/amd/display: Change default Z8 watermark values
Date:   Thu, 27 Apr 2023 00:27:06 +0800
Message-ID: <20230426162712.895717-3-HaoPing.Liu@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426162712.895717-1-HaoPing.Liu@amd.com>
References: <20230426162712.895717-1-HaoPing.Liu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63B:EE_|SJ1PR12MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a3ffd0a-76da-41ee-de54-08db467330b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vgw6/jx3BOWJExeEeHdDPKacniNCF61vwCy2rP7QTus1jqXgcl6VzT4FKj5RM6Q0s/RsPeWYvN5iphAWZO5iZyQiwU23mSiBupuSmRb8M7Yxb84MOt4OHO91lausxxcuKJEIqgFApL1d81ITQjz1EFMa567rHb6RMBz+oViXodUNO61G4pgGOGS0RzWA4jWK27+vJ5+bTcVIqEnu6WlZyh7gbw2AkSN/CtDLH8ztK3sNP67PzUVHKyr+aHm1yiKqwez15TRfCkWa1gLusMxbcGqFnWgo9+iqX08ydanc+V/J36rH1xgsG887Se9fEpmxiBqf5pyk1+Gc74wsq1TukduSbAI3Mdu/Pl4oQb7SCVx0bA3l9UECsrFOAJND3nSmQN2iE7sdmU1n1UUBhGclq0rtrFEsno0V6Oc3dt7V2CCoqe8ZT5qwwP/IryDya+wDsi+TpvemcnPxD/SQduw9ox/GpTqWA+AwteqOK3srjCdEYQbNDiQ1NadEiOavqHtefHF/51iSA4VpCg7MowdzUbTdBjHiG4Dp3TfFd25gAE0htyySBT8ufzjOcXCbS8+mJC+i7fkmGZn1f23qqnBvoh0Y6XjSmBdQHOa7fumxe63oVZPZ+trkXFXxs4YFOmaoJ6ScMBfsJJG5zYbRpg2xfc67MR8ZKoBvpj3qJuOAEruHwMOp2Y8XRpttELrC4TruTCSxUIte0f0BvNXDb94MQ7nFEFYJdlq6Vx7M4Hvuag4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199021)(40470700004)(36840700001)(46966006)(1076003)(26005)(356005)(40480700001)(336012)(426003)(2616005)(83380400001)(36756003)(36860700001)(47076005)(82740400003)(186003)(40460700003)(70206006)(81166007)(54906003)(86362001)(70586007)(6916009)(478600001)(8676002)(8936002)(7696005)(5660300002)(41300700001)(2906002)(82310400005)(4326008)(6666004)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 16:27:55.4881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a3ffd0a-76da-41ee-de54-08db467330b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Chen <sancchen@amd.com>

[Why & How]
Previous Z8 watermark values were causing flickering and OTC underflow.
Updating Z8 watermark values based on the measurement.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Leo Chen <sancchen@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
index 19370b872a91..1d00eb9e73c6 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -149,8 +149,8 @@ static struct _vcs_dpi_soc_bounding_box_st dcn3_14_soc = {
 	.num_states = 5,
 	.sr_exit_time_us = 16.5,
 	.sr_enter_plus_exit_time_us = 18.5,
-	.sr_exit_z8_time_us = 210.0,
-	.sr_enter_plus_exit_z8_time_us = 310.0,
+	.sr_exit_z8_time_us = 268.0,
+	.sr_enter_plus_exit_z8_time_us = 393.0,
 	.writeback_latency_us = 12.0,
 	.dram_channel_width_bytes = 4,
 	.round_trip_ping_latency_dcfclk_cycles = 106,
-- 
2.34.1

