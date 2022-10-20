Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CFC6064C9
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 17:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJTPjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 11:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJTPjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 11:39:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3093A1B90CC
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 08:39:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHyzIQkX2bTAl4KHtaeetzhN/tbuBQW0vDg+T7G8+CLhLVcy0PH9GJZ2DTrv/CPvRxcnXyCGa8H113wPTl1i8ZkiO4cNxgKmXP6tZ9QpJht5on2fKa8qNT+WbBuymnETBycb+q9oRBJFYwBqkEWEdznv0u7gly/25xEFLiShzInS5L+D3XCEdfBRW6V2uGKPBPmbF/Db4I4LdIJ7GuFSYi3VtSEFJjZgo+78GyocIMtqw7bgw44vRiO0QaGHoluovgHEVxZn/EvDJwBoZ9H4QpnQ3+gONdkdnBSaBU/7cQOxlaU2oWTT7SN9AAvzgnGpOeOZ9DSf25D8Z4ZRzZG89A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NiWl8Bp7QYjZbSBg3/8dhN+Ni753kfWHcz4P2nfKZhs=;
 b=RyHHUQ2YSY3inQTgBcBvKmgnXqfonk0z0fDJCBe+fYNuWuUiCRiCCHEF70nXURaUPXN+IPjZvLf1M+/jRnJDaVb6XJKOyEBxX20eQwKgMStFQ7syoz5Pors/0el9VTTAANKu2XF5+Y3VKRLGDM9+8UKrgTnBxmWowJJK+Np/n91bwqQrK1t7nr4ecnawOPxhXbRbKbvmmHzo2STvqVNbLczeLRiXyaSNJWtjED3hKQZzphOou7Nniclt8k2lcbUSUx5aCE8xv9j9rvTsIhopikGRe6/inmZIWx8zbFaLlxwKWvUvPrLgP0+8Uurm9G9HTEGZDE8ZlUun2z7wDvdICA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiWl8Bp7QYjZbSBg3/8dhN+Ni753kfWHcz4P2nfKZhs=;
 b=0+ED9yBbJKj6Dq53BFWJSmO7gfF/Ijinx16N2MxAZsB5TtllgzwJn6Rv7aE+uU9078T8uqYgamqskd88DntnATqLN8NOW6lIDVz1vuBJJ6Xpos8fXJTh7kdMPcoHgQZOct/8iq3DMDK7L3B7abtQ2E0Dxm/Kqxf9KPcEtS7h6Wg=
Received: from BN9PR03CA0350.namprd03.prod.outlook.com (2603:10b6:408:f6::25)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 15:39:12 +0000
Received: from BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::c8) by BN9PR03CA0350.outlook.office365.com
 (2603:10b6:408:f6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 15:39:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT093.mail.protection.outlook.com (10.13.177.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 15:39:12 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 10:39:10 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 2/2] Revert "drm/amdgpu: make sure to init common IP before gmc"
Date:   Thu, 20 Oct 2022 11:38:57 -0400
Message-ID: <20221020153857.565160-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020153857.565160-1-alexander.deucher@amd.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT093:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fa9b29-db44-45e1-c17a-08dab2b13cbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iS8SLhrvGVH2OVgwDa2tVNh6DJrV7V9fT5kJEl8WOfOU5jYEAwgtgKxXE9bOb+EVuTvmQkdUw9hI8ZctjdE8AgPWh95Sr1uduq2fATGDajTj/iFI2xFojH1dIpcAnoPpES7RkusL2Cw/Ks8oqXe0vrypXQqAE9ubuT1m1rMBgY7DLhe26ex0zHb7ionwtQpgmWVP1wVeOjgJI5nGzqF8QDulszrt7NcP44R1CaAtemQjz6cecqsQw6D28OCjMSWbhdraxy3wyJu1gHmR1tVhjxOoh+MH4ZFpx/Mq4piksdOAEU3DFZyV51QaXf19Y1Co3DHMVvcx03I2qJ9Wx3mL8EipBuWVmlc7YoAnvPQzP9W5+YOg19XWGULnypI8Hlf0m/FvNgtS6XH1es3VQ55tw9Hz+zNcUQMZN8ClMKVA2/VU7Mv2Yq9n0HxO4YxUn8c3XiWjWieC0FuNdncapKVmFL0oUZ5mCXTymt2o5M6OAB4rmxZkslgq/MlZCo8lKL4wktG8LdhGJnA8YyCDyOefqhZwcQz59GP9IEVQEs5Xl1xms+td1Siw/AltItD0M/3SCJzcXhxFKUjTFRQ8siANqWzNzlEiGLbridKkn84Sa6I+cZhJP8j7pLlKtaWfTOAkh1LIELc9D6Yjk35XC5s0o6tirrLO6TUT1gVvVmZGdk13j3hOHfEUz53wOGKeiSKco8iWrfNYqSPlpHRRYGTZXbYeV0q+T9+0/RG+EtKlbiOBGq8khBO28PSWtmp2QhPj
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(316002)(36860700001)(54906003)(110136005)(426003)(6666004)(40480700001)(47076005)(8936002)(26005)(2616005)(40460700003)(16526019)(1076003)(186003)(2906002)(5660300002)(336012)(70586007)(4326008)(8676002)(70206006)(86362001)(83380400001)(41300700001)(7696005)(36756003)(356005)(81166007)(478600001)(966005)(82740400003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:39:12.4123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fa9b29-db44-45e1-c17a-08dab2b13cbe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 7b0db849ea030a70b8fb9c9afec67c81f955482e.

The patches that this patch depends on were not backported properly
and the patch that caused the regression that this patch set fixed
was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"").
This isn't necessary and causes a regression so drop it.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>    # 5.10
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 881045e600af..bde0496d2f15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2179,16 +2179,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		}
 		adev->ip_blocks[i].status.sw = true;
 
-		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON) {
-			/* need to do common hw init early so everything is set up for gmc */
-			r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
-			if (r) {
-				DRM_ERROR("hw_init %d failed %d\n", i, r);
-				goto init_failed;
-			}
-			adev->ip_blocks[i].status.hw = true;
-		} else if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
-			/* need to do gmc hw init early so we can allocate gpu mem */
+		/* need to do gmc hw init early so we can allocate gpu mem */
+		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
 			/* Try to reserve bad pages early */
 			if (amdgpu_sriov_vf(adev))
 				amdgpu_virt_exchange_data(adev);
@@ -2770,8 +2762,8 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 	int i, r;
 
 	static enum amd_ip_block_type ip_order[] = {
-		AMD_IP_BLOCK_TYPE_COMMON,
 		AMD_IP_BLOCK_TYPE_GMC,
+		AMD_IP_BLOCK_TYPE_COMMON,
 		AMD_IP_BLOCK_TYPE_PSP,
 		AMD_IP_BLOCK_TYPE_IH,
 	};
-- 
2.37.3

