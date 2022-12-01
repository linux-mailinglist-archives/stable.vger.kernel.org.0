Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADAC63FAFC
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 23:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiLAWyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 17:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiLAWyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 17:54:36 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7BE27B14
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 14:54:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5TadJwtdtogzGsPnzCvCN7ZEfUys8RMZsTB4iTplgip0pKx4KbHRoF5Exx9TncRC07dpeLqY37wAt3iHYZh3wrfiia6iQ5hx5I4TT5Q2CT4XIS7RfzaInPRmHvl1oh2REOkRSW8iAxs0Vlpg+L9GjEU9hBUzBbD32d1wRSor4giDqtSKPagy1qckbmMHgKbKnwo2wafKcRLPEv9wVVjGyENG4CmjyXxVB2NscBqzzNx1ayP+mW7voCBrykLblUL76i+94Sv9b2xJ0Rt2m1riBwLFOG0R/CmA7YqskXDWOwCsycvWTwWweyUA1vgae96zmYJu3vO4gDRRYhdWxQhTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWzgJaLEpjrmPJQLFLxbsS5+Ol25ZdI78OhX65JF40k=;
 b=A3ziKM1TObLbhxdAD8pdAWz6Zs9jM3FYJX48MRYM24W+2UlEikKrqRpo25h1cZycQW69BaOAeX97d9Sb9IkFmcX6hYRNyipyA13cCPM8b2SYceRrcc/PKvURFlWoKVRYWc2ncz7H6kS8qyacPyyQL3gZBBqUxxrp5ThSGWoPTAwzpVYWElOD1u9mshkiZdu+NW+DDdJGJpTCgOV0r9dLkF/OC1FNj8JiPrJktFkWJ7DRZCiv3rS4fS8OOdxyIfXKy06pDsz1LGChdoJSWkvngc/4HoCGG60FR3tAh8yivRu4QAOzvA6A8baVddZvu9eICFoVRnQ26GAGUNxGFy3rfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWzgJaLEpjrmPJQLFLxbsS5+Ol25ZdI78OhX65JF40k=;
 b=IJRluSCnY7cWkzseBIz0R1v++RcYmGRoyzyZbUCOhuxANzOkf0ThBb/oJh4iLAACiXnW/haETlRO89KuO8jIjX53lAjOlMOt76O3XtK7r/A5Rcg9lq7f9vPFMLk+5Y6qpoWYUrQB2dNE9d6STklgIwMuxDyJIkMpJo2LaIycrBA=
Received: from MW4PR03CA0033.namprd03.prod.outlook.com (2603:10b6:303:8e::8)
 by CH0PR12MB5058.namprd12.prod.outlook.com (2603:10b6:610:e1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 22:54:31 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::3c) by MW4PR03CA0033.outlook.office365.com
 (2603:10b6:303:8e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 22:54:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 22:54:30 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 16:54:27 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Ruijing Dong <ruijing.dong@amd.com>, Leo Liu <leo.liu@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 1/1] drm/amdgpu/vcn: update vcn4 fw shared data structure
Date:   Thu, 1 Dec 2022 16:54:17 -0600
Message-ID: <20221201225417.12452-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201225417.12452-1-mario.limonciello@amd.com>
References: <20221201225417.12452-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|CH0PR12MB5058:EE_
X-MS-Office365-Filtering-Correlation-Id: dd9e7a80-6a24-431c-3041-08dad3ef01ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xBUXuFKn7s/xlTeu+jKWtE4DKJJNJSEV/0rVQNYOpWg3+uQy/MPP8ofMj13vbahYIQfmS0rGOTTLSSQCTHrSbdusHCdNIMWy+IjwkaapeProhoWqegU5IEjh6mR8gCWptyZHNv7RoTtnH+Ow4CfggHSiDIkru//OlA/sCwMAYnA4iCIPrWwjbKR5gk9KO2VgaiFviO8Yj9UURbP/fpjjruHMbM+x8syr7k3wjMWXjLqvKHIwcW6AJA1sdeeHNsue0pRAnuNnp8R00inTwpDVHvqqXYCoxjD1vj3FHY79lfUeAhJqSVnJrBS7ee0VAnEmGdJ+f1cltWD32euUETn/6QtgxFr/PoBlaqhLOiBu7PXYSzH6gkcGroFNudXsYUYIJ1obSRkjT7+dhjBwHDjzbpcFNO6cu3idYpdVLMNETfIJInKxswOxbCiYPYhGCEclW6cSipIH/+Y3Q+q4BpIXVNvFN2iOWphxUB+SV//2xGDszE7VcKs3cGyL81W/EKYyKvLqfvXnIPsbFeK7FfIydj3s2jcwD1f5OzrhcAdmIuIwFlpcjs07nmnV/BEINz3RJ+74SZxCCspeedtjnsq4RIrcOh0TWY7DwHgvHayi1LqkZNoTgJnmLdJlQxs7AooUshKLTmdI1DYtf5QqPovtF8FWKbto0M7t40w7WeWKXhpGA0fy19t4jxygZrg+VyuHms3lslbbKjg5GDFNG4+LAzVaSJQ+HFYohTaSwr52yVU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(316002)(26005)(1076003)(7696005)(2616005)(186003)(54906003)(36756003)(6916009)(478600001)(81166007)(40480700001)(86362001)(426003)(336012)(82740400003)(356005)(47076005)(83380400001)(16526019)(40460700003)(36860700001)(82310400005)(6666004)(4326008)(44832011)(70586007)(8676002)(15650500001)(70206006)(5660300002)(8936002)(41300700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 22:54:30.5653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9e7a80-6a24-431c-3041-08dad3ef01ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5058
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruijing Dong <ruijing.dong@amd.com>

update VF_RB_SETUP_FLAG, add SMU_DPM_INTERFACE_FLAG,
and corresponding change in VCN4.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 167be8522821fd38636410103e1c154b589cb1d9)
Hand modified large dependency of commit aa44beb5f0155 ("drm/amdgpu/vcn: Add sriov VCN v4_0 unified queue support")
This no longer updates VF_RB_SETUP_FLAG, but just adds SMU_DPM_INTERFACE_FLAG.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h | 7 +++++++
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
index 60c608144480..ecb8db731081 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -161,6 +161,7 @@
 #define AMDGPU_VCN_SW_RING_FLAG		(1 << 9)
 #define AMDGPU_VCN_FW_LOGGING_FLAG	(1 << 10)
 #define AMDGPU_VCN_SMU_VERSION_INFO_FLAG (1 << 11)
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG (1 << 11)
 
 #define AMDGPU_VCN_IB_FLAG_DECODE_BUFFER	0x00000001
 #define AMDGPU_VCN_CMD_FLAG_MSG_BUFFER		0x00000001
@@ -170,6 +171,9 @@
 #define VCN_CODEC_DISABLE_MASK_HEVC (1 << 2)
 #define VCN_CODEC_DISABLE_MASK_H264 (1 << 3)
 
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU (0)
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_APU (1)
+
 enum fw_queue_mode {
 	FW_QUEUE_RING_RESET = 1,
 	FW_QUEUE_DPG_HOLD_OFF = 2,
@@ -323,6 +327,9 @@ struct amdgpu_vcn4_fw_shared {
 	struct amdgpu_fw_shared_unified_queue_struct sq;
 	uint8_t pad1[8];
 	struct amdgpu_fw_shared_fw_logging fw_log;
+	uint8_t pad2[20];
+	uint32_t pad3[13];
+	struct amdgpu_fw_shared_smu_interface_info smu_dpm_interface;
 };
 
 struct amdgpu_vcn_fwlog {
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index fb2d74f30448..c5afb5bc9eb6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -132,6 +132,10 @@ static int vcn_v4_0_sw_init(void *handle)
 		fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
 		fw_shared->sq.is_enabled = 1;
 
+		fw_shared->present_flag_0 |= cpu_to_le32(AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG);
+		fw_shared->smu_dpm_interface.smu_interface_type = (adev->flags & AMD_IS_APU) ?
+			AMDGPU_VCN_SMU_DPM_INTERFACE_APU : AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU;
+
 		if (amdgpu_vcnfw_log)
 			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
 	}
-- 
2.34.1

