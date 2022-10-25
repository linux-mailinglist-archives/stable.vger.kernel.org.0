Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412E960C15F
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiJYBr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiJYBrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:47:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FA589937
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 18:41:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZmulrp6Hp9joBpChulBkz9j+RiYzOzDttUzan0m4VkMJpbDtP6u/mEQrsk6/krW+41Lw0HFghNiX0ysi0sgDxVlwJakdqEjQbT0S9sWYcL/cEQ8sPx3UEOouT7Duw+vwRj8Wr7dbypzkXzfZWGl1aSuzxQGerDyHeU4mptkbSLZ68tzL3GPZn5PSW49Mjtj+g27RSFCe5rOZABdubhK7QX7uqhCTamQpMn8b3kTxCgbIvXYMXv3Y1ebj6jn7FEVpxQP78ecnxxHMSdvE8D4vP7Q0wYbHLfCg5/tTF51KTGTjnkgKey7nYvxaJa9twK/IyTy1rSBnkFemwfIdoBNEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zBUgI8gUjKymKu9X6MsqGWb9uxKGWKKwKBDpVvw1Mk=;
 b=aJ0ewN255OxW6y6GFtBp9hV+lmJ5CC7RSD2lUOQ0OT5L+i2JeCsAgfv99haP49duurbTgWBeKJ0GWJaxMBI+5Lh2HsDA07ZocUvsfEHW/r6Wt7LHdPGtPlAJgsuaMFombajXRvizOPPD2uF4eEKPYAFU08PD7BWh5DJ0IJoj5BLsfyLRqq9wZBVDKU/TkEnTppi8W/6OzrjU62KokcTy+Y05FC+B6hHndv6HWuJk6q4fTYX8dyY7uotZhec+lNJZ+Hwrf5D7YvIDJgD2pS9HFWLFpL+0EUbSRZyR+rpQfUQ2QzA0tPqUq9LeGpWlBSavLPOeLDIOrqbIrVoMkyUnKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zBUgI8gUjKymKu9X6MsqGWb9uxKGWKKwKBDpVvw1Mk=;
 b=wbFOR+gVfUN2CmcAYCRhhg0eYqwrcYdRw5sZDtPFPuYv8f86926z6ByAuW/FTdIfnOWIS0lFajIVS3vEpi5uNJVXu0vy7kVHvlj1O1czW8vLjCR8VcAUNX4/WPyvbKFlcDEbLeBVJTk51juf9o5UnCjSHZoc4OdOzzjwydulzSs=
Received: from MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::35)
 by CY5PR12MB6526.namprd12.prod.outlook.com (2603:10b6:930:31::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 01:40:59 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::b0) by MW4P221CA0030.outlook.office365.com
 (2603:10b6:303:8b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Tue, 25 Oct 2022 01:40:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Tue, 25 Oct 2022 01:40:58 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 20:40:55 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Shirish S <shirish.s@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: explicitly disable psr_feature_enable appropriately
Date:   Mon, 24 Oct 2022 20:40:39 -0500
Message-ID: <20221025014039.11493-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|CY5PR12MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: ed3e7f8f-aed5-4ac6-c538-08dab629f778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDPvMhJfJnq/R4ubZ7Cb8M9E73qL/77Jrpx/4UMN8m7Xhi1g/XSOiSoMACs8i2LHrlRRPGIH6CpwR31lQA3Kqyfq8TA3Fo6tNwxldVMv2j4mHCaFRiStU68aqg4NAJfm6BgoMenR7fTYykiv0hqBidK0InUL8YrQtYw3h4ySAkF7LCqb1OLWAK6UOzm0zdD3HocXbscBuiHotTPg8HXmQtSs2vGC1gr6ZErAswEusqmyOYoK4KNa7r1+NUaykMTPWE4ErpW90VR8giY+u+s/6Vgr7StStPudsJCT66T4fjlQLxzbQDkpLbN8SYBNzfIMMywZ7EXZ4k+SzOuWGQmUScVtFlxAH8sYvAQjBpCN5cZt79CjcweYd0FGfYXU5CtzrammrMCYWfWHK7zeOmOqMWPx+uNM2BUXe1g2JNastNvRY+B3CqiICFq3EOceFzC7+sSs0z5WwMxJZgu/eD/on+j6N6Do6jFeYVVNa2ndWFZFp2kapyZ1mPKLPNFGnsGsdYDBHJKcWtWinLSrByV8QBu4LXCgIA/VdMHXDlWEHuDvjkYwm1IHHGVwUdpv+nJYyRIPd9aguITI7fWyq+e6/wsmHXnaxq+YP+LS0460C9REYphU01q1aGNL/dIm9g2XPGgcXmyy9jQM51Cay+eks3G+JYY9lF+pCkz5Caab1yuV+Vg5KjUvlSl49pGrPRC+l82fYJSnRCWiuonHCv252hHdCWCZUF0R0YbCODU8UJWkE2c00y65VPSlP5wHPvzcLcGFCYKpTHnOiqF3pQZObrw6GoNdX0cZkUNWfFgJK7NH8JenXXpg3HbVfRWpdpWD
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(8676002)(82740400003)(6666004)(426003)(478600001)(83380400001)(36756003)(4326008)(44832011)(47076005)(2906002)(54906003)(26005)(316002)(82310400005)(356005)(8936002)(6916009)(40460700003)(86362001)(41300700001)(81166007)(2616005)(7696005)(5660300002)(40480700001)(186003)(16526019)(336012)(70206006)(1076003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 01:40:58.6429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3e7f8f-aed5-4ac6-c538-08dab629f778
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6526
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
If psr_feature_enable is set to true by default, it continues to be enabled
for non capable links.

[How]
explicitly disable the feature on links that are not capable of the same.

Fixes: 8c322309e48e9 ("drm/amd/display: Enable PSR")
Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.15+
(cherry-picked from 6094b9136ca9038b61e9c4b5d25cd5512ce50b34)
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
This did not apply to 5.15.y due to missing contextual dependencies, so this
is hand modified to meet the intent of the original commit.

This is *only* for 5.15.y.
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index 7072fb2ec07f..278ff281a1bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -36,10 +36,14 @@ void amdgpu_dm_set_psr_caps(struct dc_link *link)
 {
 	uint8_t dpcd_data[EDP_PSR_RECEIVER_CAP_SIZE];
 
-	if (!(link->connector_signal & SIGNAL_TYPE_EDP))
+	if (!(link->connector_signal & SIGNAL_TYPE_EDP)) {
+		link->psr_settings.psr_feature_enabled = false;
 		return;
-	if (link->type == dc_connection_none)
+	}
+	if (link->type == dc_connection_none) {
+		link->psr_settings.psr_feature_enabled = false;
 		return;
+	}
 	if (dm_helpers_dp_read_dpcd(NULL, link, DP_PSR_SUPPORT,
 					dpcd_data, sizeof(dpcd_data))) {
 		link->dpcd_caps.psr_caps.psr_version = dpcd_data[0];
-- 
2.34.1

