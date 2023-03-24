Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054AD6C7833
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 07:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCXGv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 02:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCXGvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 02:51:55 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2069.outbound.protection.outlook.com [40.107.212.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA9922A1E
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 23:51:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRJu1jg1t9E2aaqPrtn/T8asbrM6Wnlwi4C5j7Tp+G2tFpmMpISPcE8bo2BYJBdTAvwUMU0bRawssCzQJEVmNz0rca8fhcIyHr3JCC9RxICMHC8rSTSOYln2OtKCv9QT3ILi8fUouv4ta1fMClFV6mVmNjL3rI5fuB9aPOmx8c4H/h9uPJN9S/bUXRkcUv2M6gsd6SbmQELgInaj8cmHX2OZcVDE3hdly38UD1+cIYxAotz0Sq6Bb5EhPwcNC+Og3xrud6/WOjwoZ0704uLH8HYQfNWBsDa2ksNUZ9jQhew2DhAv9sjqXkLyyv3dbbrP4cNCzPQmhrEy5R89Ye/v1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oShPCNGnvc4da7nttgZfvq/X2Pa2K/YMXQ6J3k3+3Sw=;
 b=bVpZanmxlLWYcM83/H+7/izsaMCs+U4pHBQxCUwX9N4HJzkEpsTybaB96y9HSP0t1P/y9FRZvfDlj15sYBjbhKQTPAzxnnxT9GKZG4wYZR1uJsOV7dkpGVTwq+6uqX7rpdQ7/j7GovPOk50kRzvrRgAwkJwh1CknxsS0nhc0KyFhY7xiSiPy0Xr63vHapuyZKQB1qgLB8QVIOZ8f+GFoc2goNEhzcjnHOMp/bFHz47wVVXthXZBKjIPMV92Vq1M6BO/M/ZMBTdHkR05xvJkKNWX7AwNRsan7EePz4XY3llMtu5bDlNfiFACN5BJHJ8OXBPj2edL0J6h6uW1M/XpgOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oShPCNGnvc4da7nttgZfvq/X2Pa2K/YMXQ6J3k3+3Sw=;
 b=K3Iwv3Huy5QpmiQAENIvDBnFaQfJ7rM1cyKbD6VD01O7yLvMSDuUxpCia57FS10E5gFRphkrTQ6onGmz9s+AnTBcPZtwaARDsiijLwjGvXObwvMgZ+0/QAoUFPTW44DPmYWGsQARln9eI75/r0mWIGSNOrda4WxzllnbeRjh/HA=
Received: from MW4PR03CA0288.namprd03.prod.outlook.com (2603:10b6:303:b5::23)
 by CH3PR12MB7570.namprd12.prod.outlook.com (2603:10b6:610:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 06:51:50 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::57) by MW4PR03CA0288.outlook.office365.com
 (2603:10b6:303:b5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39 via Frontend
 Transport; Fri, 24 Mar 2023 06:51:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 06:51:50 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 01:51:43 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>
Subject: [PATCH 01/19] drm/amd/display: Add NULL plane_state check for cursor disable logic
Date:   Fri, 24 Mar 2023 02:50:53 -0400
Message-ID: <20230324065111.2782-2-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324065111.2782-1-qingqing.zhuo@amd.com>
References: <20230324065111.2782-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT021:EE_|CH3PR12MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: 801bede4-f4e3-48ff-75ef-08db2c343ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/W5rO0MM0rDyRNlYCzSz2sft3v4njwSQEw7xts01SigjOF/ILjr0cKhmG9ENbXDfLyP/wjpmPaw3kmcVRnM6nxMZfaiNsKcnms2YGk80FJokeafE6xL+F0u6iIZ69o66d3SPA2SbL2L2F6Gl/yFwRn9s/am/uej6DonDwJSCaRCOerOGQ+5gNaX8JZMvFGugZj89INpC7WBaxwsGVGSK+9yrI2whLNwDJhuHmTx/zUpN06OjOWs0AaDLPzoE0z1iboAOyy6jsF8TSAHhi+C/RBNSGu0lTjiU5fUX90hz5P/ZksUw4ekZ7ideG7nEVbdupEFoGxJsiIocy/4qb7fwjI32OWKm8guARvuIQEizhhP0/7hcHfYp6a/XtT3bdCp1iA9+JRpsLJ6aejc3LODT/acajAPh5wgclYfec5dpr+ySV11djnzSPmegJAwLT4HhCwRkzKW6imlaXZUW1JOYstH/C1IkjxzTJPzwhpgLHa8MTFP449BF442JYjXXimmyhsflIX9kgDvBYiJUlHpT267lamvDv9dlQqZ7CHf27q/tEnlHA46PnnI51OxL/4n7e9iCGWICrQjT7ECZKEZl78ycLTfD+aLaaw+lKiZqn7/TxG95bJk+v/xJlwK1DZoUCqZqqcXckc3B+PaYfcHQHND//X3vw95XHEvp08BboxeUnazIIRwvoY9fP4frAUX/BzBBad3spWDNiP3zTBmmCVM0e5u95aV9aDRvOXWA9U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(356005)(336012)(83380400001)(2616005)(16526019)(186003)(26005)(478600001)(47076005)(6666004)(426003)(4326008)(6916009)(8676002)(316002)(54906003)(70586007)(70206006)(1076003)(41300700001)(2906002)(5660300002)(8936002)(81166007)(44832011)(82740400003)(36860700001)(40460700003)(40480700001)(86362001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 06:51:50.2659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 801bede4-f4e3-48ff-75ef-08db2c343ead
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7570
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[Why]
While scanning the top_pipe connections we can run into a case where
the bottom pipe is still connected to a top_pipe but with a NULL
plane_state.

[How]
Treat a NULL plane_state the same as the plane being invisible for
pipe cursor disable logic.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 7f9cceb49f4e..46ca88741cb8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3385,7 +3385,9 @@ static bool dcn10_can_pipe_disable_cursor(struct pipe_ctx *pipe_ctx)
 	for (test_pipe = pipe_ctx->top_pipe; test_pipe;
 	     test_pipe = test_pipe->top_pipe) {
 		// Skip invisible layer and pipe-split plane on same layer
-		if (!test_pipe->plane_state->visible || test_pipe->plane_state->layer_index == cur_layer)
+		if (!test_pipe->plane_state ||
+		    !test_pipe->plane_state->visible ||
+		    test_pipe->plane_state->layer_index == cur_layer)
 			continue;
 
 		r2 = test_pipe->plane_res.scl_data.recout;
-- 
2.34.1

