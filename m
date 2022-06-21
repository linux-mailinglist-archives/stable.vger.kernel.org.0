Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165E95535E8
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352827AbiFUPXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352835AbiFUPXr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 21 Jun 2022 11:23:47 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D9629364
        for <Stable@vger.kernel.org>; Tue, 21 Jun 2022 08:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEhiRx2g5K8i8K8QdGPwo2edphy2oNZOh4f6USP2XGeHVUiCM9vJGzTd3g7W8mynZgy79yawllGwqgOKZfxvoxUzkoHXPnDVpOaOGJl40nQdPcNHrrNc5M2gqc23yXru5JXiFaUaRBEQ2LUndzSwbaCvYvL2ml41G4IUoT5P0HwlBzkvcmym6B+W6L38DdVqECcGO8RSActMDbjWZ6k6jxljWxXrWIM05yxoygWw9G3XhT+/gpC3vKLXev8sBq8GaiiKBAHfBG+2rPOkLAR0/cn0ikFUYEOzFH7/fm85ygwVKarDLdBySPoPCmmIsC5wspqVmDL8pcyR3MzewtASkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeJAaVRCcRfwUt+otv7VLzPbavxqQbT4/2h252b7ah8=;
 b=CjsjBFeX/qN/ZsjmrW9yVJCSdkNcKXOaO0R0FJ387DOJVfVrDOVB0iLH8Sl6XpAKaw9UtlNokDkCzbv/uvVgCdXAwpSoLVUoL++b5ThkjzTApW1uQB1Ly1aOGAlYVrMgR3SiSFHkCtuorkmKzQ+LjJ9zwPbS22BM71dULg/eYzKFQno13ho/v+UBvf1SjwUKSKEhvBc/IR1GDittrkWbTW3nWpSlV5WrzzFVfYM7FL9uV82NRuIHSVmRgSDug6V06AhGeyuXxRGWDXaJ2BOjtYaEimZcGYi4zAd63uRotqbh3G5qncx19tNhbaGsGhTcvMfmFWot9iLSuwzaPpK57w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeJAaVRCcRfwUt+otv7VLzPbavxqQbT4/2h252b7ah8=;
 b=1Y/b+qI7JIhxlQCFwb75QU6dICOtura06nuhkAl+o/qJ1Ld1oKopSPGEc2zEaNqZoT1q5S+j5H8x5ioMejx9RAPDmZOqp6oj93+1sGAoa8BAHaQDJVGudS2uvIUcvy9n2x31SjAHSBi4XLiahAfln5uSuixAJC1GhSupDIfsMcc=
Received: from MW4PR04CA0352.namprd04.prod.outlook.com (2603:10b6:303:8a::27)
 by MN2PR12MB3024.namprd12.prod.outlook.com (2603:10b6:208:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Tue, 21 Jun
 2022 15:23:42 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::5d) by MW4PR04CA0352.outlook.office365.com
 (2603:10b6:303:8a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18 via Frontend
 Transport; Tue, 21 Jun 2022 15:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Tue, 21 Jun 2022 15:23:41 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 21 Jun
 2022 10:23:40 -0500
Received: from aaurabin-elitedesk-arch.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28
 via Frontend Transport; Tue, 21 Jun 2022 10:23:40 -0500
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <alexdeucher@gmail.com>, <aurabindo.pillai@amd.com>,
        <rodrigo.siqueira@amd.com>, <Stable@vger.kernel.org>
Subject: [PATCH 1/2] drm/amd/display: fix array index in DML
Date:   Tue, 21 Jun 2022 11:23:39 -0400
Message-ID: <20220621152340.2475484-1-aurabindo.pillai@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46c4a57f-3054-4b52-20f3-08da539a0620
X-MS-TrafficTypeDiagnostic: MN2PR12MB3024:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3024EFC660E3D13063744FC48BB39@MN2PR12MB3024.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCtSgY6a5WN/CUQqFoXA47ZT17R/k4Bqau9Lt+boxGcz9Z+y57rDVjL13tP1GobFZdcdGkedYdLVVqfD+V+xovI0ertyAVtNIfhdfSGvQfuTBBI1RKxx/KUh9d8Ra8qs41nkmxJFDEASworbYo4pQyFKDchVRnPDoEtX+739IYUwgvpRuRcj4SV+pfI2AGK/6R61TKTpnDocUES4njbLP+PocjgiBsBfTwllegA1yI8pqoU9IpB7C/cT9s4wUpgIxbNcKJulNOOUu+HMN/Vho2NGiOuQKEg4QM1pdrk8uqf1MgdtuRhiFmmSmLnwP7p87ayCoAz4jVufCvJOE+J0/gTUiMLHREGvWhQYQaOiJ70faB7C1TekrT7syJVvLWXgK8kCyn98xSQQKzhHlE1RP9BNxqafVVdk6CLSqdfXHteD5UH3ZDiI5AWI1+ozmy7iM2IZz/unXrD6rO1IFxHypjL0tMY0xeVGEys0WSi+0/FYaW+Ynz3ZsP2DjxAzwHse68CQLH1aDRqFrYkG+LXnVdW5BpS4j48EqluCtRzX1YdfGVEX4+YdU775GSQaqdhIij98OyYJ7gUvEgoyzc9FOSz7ip1pnHShXD/yighUFpjvJXDNRRLFoSaEEgYchJv/Ke3l8TvLK4lddX264h6eqafI3yoWeoQX8QLrenYFq7jLaKjheXDMK+ljqeZ6GODRMLJiWgzggGmsr0SU4esQQ4XEnxZLCCBEE5IPACR+npDm0QheeJATxONgV0X18l8K
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(40470700004)(46966006)(36840700001)(2906002)(8936002)(7696005)(478600001)(44832011)(54906003)(5660300002)(26005)(8676002)(70206006)(70586007)(2616005)(41300700001)(6916009)(36756003)(316002)(47076005)(336012)(1076003)(186003)(4326008)(40480700001)(426003)(40460700003)(83380400001)(36860700001)(86362001)(82740400003)(81166007)(82310400005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 15:23:41.6997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c4a57f-3054-4b52-20f3-08da539a0620
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3024
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why&How]
When the a 3d array is used by indexing with only one dimension in an if
condition, the addresses get compared instead of the intended value stored in the
array. GCC 12.1 caught this error:

drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c: In function ‘DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation’:
drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c:1007:45: error: the comparison will always evaluate as ‘true’ for the address of ‘use_one_row_for_frame_flip’ will never be NULL [-Werror=address]
1007 | if (v->use_one_row_for_frame_flip[k]) {
| ^
In file included from ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/display_mode_lib.h:32,
from ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dc.h:45,
from drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c:30:
./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/display_mode_vba.h:605:14: note: ‘use_one_row_for_frame_flip’ declared here
605 | bool use_one_row_for_frame_flip[DC__VOLTAGE_STATES][2][DC__NUM_DPP__MAX];
|

Fix this by explicitly specifying the last two indices.

Fixes: d03037269bf2 ("drm/amd/display: DML changes for DCN32/321")
Cc: Stable@vger.kernel.org
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index b9f5bfa67791..c920d71fbd56 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -994,7 +994,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 							+ mode_lib->vba.DPPPerPlane[k]
 									* (v->PDEAndMetaPTEBytesFrame[k]
 											+ v->MetaRowByte[k]);
-					if (v->use_one_row_for_frame_flip[k]) {
+					if (v->use_one_row_for_frame_flip[k][0][0]) {
 						mode_lib->vba.TotImmediateFlipBytes =
 								mode_lib->vba.TotImmediateFlipBytes
 										+ 2 * v->PixelPTEBytesPerRow[k];
-- 
2.36.1

