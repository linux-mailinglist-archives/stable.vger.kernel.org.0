Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5805A4FFA55
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiDMPg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiDMPg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:36:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92DF654AE
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yhs7QoJxPFVxrY6tai5+1s+MpjjQPHNxjwW9H8Cl6ufDbcflpQ07ACW8Pxc2F3k4pa1kafEF6XHEaAUIfRGFF62vUq5vNOzs35DWtBDOJYtQt2H4Qkx86mbCffL5rv5lMDdrZ7jUSbsgncKZ9XUHWdrYIRj9EWz1ugVp5tNBn3ANL2v1UDLEojqdvntKNMwlLcnyfFWCupPUNeOnyyBYh9hGTGx+bTjkjrnV6MSjxiYK0MiizbZpkIOdnLs9vPiilxzck/On/hA+yfbsOD7wDiGKSeW/5NNjZyC9OiWilFLpA0IGzNDiWg853eOCLpb4P9c5b9/BSvjuWXcZ9TfDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pokBEx54HAu3YtVsPcFZ2AqT2nDE52msJSxtjprJUvo=;
 b=Ip1gbGVhevB9riDaAP6APkiP3BHGS6ZOqWgsXGSp7AmRNbhAh3bcAnvWaiXnMY/qz/TDcvwajv+D5wlRRrP/W7jID9G0/1J1GUx2X+zrNMbwVUcPQv8n+kTTJqw/EUswwUMCI165424/YmvbtL0y0bLdlxtmL2hAbAECTSeQwPFdV7k87/V0qcV/IpHQP2rueK2jakdfqNgCQ1Ftk28jWR98dxf6Tn7vlNbAJHu0eZqE2stIof2REeLK99XKUs2V33wgC8ZK104GBj77zBUokhjqZUqyXUw0WI6gwFfKgPddPT3znJef3kIZMqRtI9LZG0SDHm8ubdsnTAIR8rjzLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pokBEx54HAu3YtVsPcFZ2AqT2nDE52msJSxtjprJUvo=;
 b=vK+AP1mh2r0fq71qFFoDGXadSwnVoa1GQBrI1qXM+2nQ442zbwGtuaIyLAYs2/G4An6HIqpvoBL0r93jCVp0BoGa6ezowje4ZctIr2xAhpj3aGZbOx/huEFf5fRjC1BC4QToPFVNtDaySmCZaIipLl8ZZkzB2Z+LsUw42KGjXts=
Received: from DM5PR07CA0075.namprd07.prod.outlook.com (2603:10b6:4:ad::40) by
 MN2PR12MB3069.namprd12.prod.outlook.com (2603:10b6:208:c4::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Wed, 13 Apr 2022 15:34:00 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::f2) by DM5PR07CA0075.outlook.office365.com
 (2603:10b6:4:ad::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29 via Frontend
 Transport; Wed, 13 Apr 2022 15:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 15:33:59 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 10:33:58 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        <richard.gong@amd.com>
Subject: [PATCH 2/2] drm/amd/display: Fix p-state allow debug index on dcn31
Date:   Wed, 13 Apr 2022 11:33:39 -0400
Message-ID: <20220413153339.1436168-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413153339.1436168-1-alexander.deucher@amd.com>
References: <20220413153339.1436168-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf6e7f8f-2c2a-4cbb-eccd-08da1d6307f0
X-MS-TrafficTypeDiagnostic: MN2PR12MB3069:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB30696C2EAF9B6DBAAB105EB4F7EC9@MN2PR12MB3069.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jdDgmY/pFyGID5W4ViRqKy4NIzJ95E5195K20pzXFMXonSP7xiMI444hV3T/gn5rRofmZ+jEY5vhvppopuNs2EBXPqKyBI/Rpr5UegsUITSMWS2pTNXqTZ7kKixq7xUWsIFSa8gxfJirkTT43bN2Ku0kZOgGWzk8Klt9W5swwczTmeMOd8rUSdILjBf0pcEz28JQtSCempllZ5c35F4YddeF11pdvLujXsHiW/uq9SjzJc/XTy5c/k/UhmAL+eGlkw3pcXzStzTychg7/b0UB0alGFB3PkNJ1dAakCkH/7WYhdpL6fGKX86PWdjQPoZ4ZFYHtP2ixbCkUZGTgyMsGOJgMyyrEKRs4JBWFYyDkHPBHjKBfVd7oguAoDWqM5CgMMB2o0wYhWOIv/msFPM1e8V/hveNurRjBm59YTwZZNWTQM+8j6GNlHs0Rm4GbDREzYyZQA7eqW+1FIYLNRbu/Dtsip9Jx8NlGCzxE+2NgzHg2IYPS/6zSBKOXkWMXB8O7V7RIGzYxoJOi4arCIGafvB4RvQMCio1S4wI8cR8421qJrbNgMdWC6dENKLU+R7RM+m9ND/N/5ZKOK+AZU/qlg2jqnRLTrTnoR2C9EePNKm20GKYK82DlwC9GTe5mfwqOUAnOLS1lRV9mK8nq0Lj7IqAOc4xlbdzVfY6d46jPJaPMrTBmH3AqUdQHYljlJZEUhac6vT91zkJWsMySyxaQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(316002)(1076003)(2616005)(5660300002)(36756003)(2906002)(6666004)(7696005)(40460700003)(36860700001)(26005)(186003)(356005)(426003)(83380400001)(47076005)(82310400005)(336012)(6916009)(54906003)(16526019)(8936002)(81166007)(70206006)(70586007)(86362001)(8676002)(508600001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:33:59.7450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6e7f8f-2c2a-4cbb-eccd-08da1d6307f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3069
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[Why]
It changed since dcn30 but the hubbub31 constructor hasn't been
modified to reflect this.

[How]
Update the value in the constructor to 0x6 so we're checking the right
bits for p-state allow.

It worked before by accident, but can falsely assert 0 depending on HW
state transitions. The most frequent of which appears to be when
all pipes turn off during IGT tests.

Cc: Harry Wentland <harry.wentland@amd.com>

Fixes: e7031d8258f1b4 ("drm/amd/display: Add pstate verification and recovery for DCN31")
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3107e1a7ae088ee94323fe9ab05dbefd65b3077f)
Cc: richard.gong@amd.com
Cc: nicholas.kazlauskas@amd.com
Cc: stable@vger.kernel.org # 3.15.x
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
index 3e6d6ebd199e..51c5f3685470 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -1042,5 +1042,7 @@ void hubbub31_construct(struct dcn20_hubbub *hubbub31,
 	hubbub31->detile_buf_size = det_size_kb * 1024;
 	hubbub31->pixel_chunk_size = pixel_chunk_size_kb * 1024;
 	hubbub31->crb_size_segs = config_return_buffer_size_kb / DCN31_CRB_SEGMENT_SIZE_KB;
+
+	hubbub31->debug_test_index_pstate = 0x6;
 }
 
-- 
2.35.1

