Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977C66BC314
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 02:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCPBCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 21:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjCPBCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 21:02:46 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209FBBCFFD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 18:02:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8PrIbPfwSYkALihZShfX1Qg4DzYHIOyYRhuH3mczwg3zAcrCKfBadr3P4VmpL3WuQXxZXQgj6fsikC+l2JwPIlj5XmXXwQQiBALzsPDm5nveTmH8czHHZo+qCYfDnpDJK+c537G7m/eGiWrF8T3f0HGyomI4Va+xmH+NijiMoYfmQ2lUB4rgb5JEkKnr936Fq4AGjJP7FKd02trRWXXA94fTzax4RanIdw2Lw8oUnrB+wtHkNo8grX4MA5LFy07/3u3w8UBKZ6JD4TgciEk45cTLInzayBmHcr3TTBJ6BbQgKUAvVXK0ovly8n6PoJwvY0kceBWgqjT4BBPVR9OhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYPT/EG+dYb5Cq1H26Hs/oHNUmi/vBanIzMYhZP0jug=;
 b=mzcWMK3B9l3Wp5EwEcl+YKXH4lrSBVun2L8nrlnH9F98K+l1TsPgKoMBQUPUIQkUaonkvABIOSpvBdBOj8LAwxY8M93piF8NrG1q6mHN7Cmez+x+FC2XZhC83gh4/aX3OrkS+dTV780wewguYLK2hnO0SWUWlEfoDubzUdw9C5QeUCzS4a/ddSYIOpWlA/hcDKWuOg92Q1TtOVM0F+9+7v3bUbpdlM+umEMaRbr1Y0bjuHUsJ/7Mc9OTJPDMAwE/J7amWhfe7yWG3eZ5P9Haf7T3jP/eBGFpGZcO/EMOBsdr45CAuunLTO8NG3915YSK5s9FenJVx6I98dbsEfplIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=igalia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYPT/EG+dYb5Cq1H26Hs/oHNUmi/vBanIzMYhZP0jug=;
 b=JeE0woEqiVkD7TUhQAEjUZdinFXPMqgekVHRBAmxFcc5dhXNqt8mVdMG61+r5REnCyyeXUVQtGtFJZjgPkhLg6Sk6UfAQqCACb8oMCUIrsEHL+bWTGR0uofv5l4HWmNqK6eRoUXHSZdli+Erjs18wa7FLu6CaVJvk4lYu2Ye6vQ=
Received: from BN0PR03CA0036.namprd03.prod.outlook.com (2603:10b6:408:e7::11)
 by IA0PR12MB8326.namprd12.prod.outlook.com (2603:10b6:208:40d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 01:02:41 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::5e) by BN0PR03CA0036.outlook.office365.com
 (2603:10b6:408:e7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Thu, 16 Mar 2023 01:02:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6199.11 via Frontend Transport; Thu, 16 Mar 2023 01:02:41 +0000
Received: from ssomasek-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Mar
 2023 20:02:40 -0500
From:   Sreekant Somasekharan <sreekant.somasekharan@amd.com>
To:     <joseph.greathouse@amd.com>
CC:     <sreekant.somasekharan@amd.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        <stable@vger.kernel.org>, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 1/2] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh broken BIOSes
Date:   Wed, 15 Mar 2023 21:02:26 -0400
Message-ID: <20230316010227.2472-1-sreekant.somasekharan@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|IA0PR12MB8326:EE_
X-MS-Office365-Filtering-Correlation-Id: 979a3f9a-4e47-40b7-2d2a-08db25ba24e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DtaT5j3PrCOO5z0C+Od1TF+wxqaXcE7K1uln8Dtj22OlSkxmP0HQgDnlkFv6Ku8Qp91EtWukL1p1KIPKZs1xSIBpX4sI+Vu02KA1eRDhjwNMG/F4gkn7QCSucgn5LrzJ4jnJBoHpiRo5/w8clyTyQ52EZo1ysnsXIpMwwqITIZsQUZ5nqgV3pq5qMQ6NwtX/QTBkEx89LaNXtO2MhgWr5ztsnKd2tZECzVLbTWlh4Kmos5o7q85Z0wgywMB1DUYM+AczPlnWp3KKIBlaW/awA1KY2MGUNiUMSdBgm3BSLw2Hqd54E6fATSzaZ++WDs+aIhItLf3tYSN47ZUQ0hqenlXFuHbYgQC6h3Lxu3NPjDgE4GuhySoLlT5tqvn+dHoc+saNsNqx7/maVha4wAOiHBYeWFuzrMhThHjS/j/e0E2knZhcDOrWtWxP0oJ9fRALEOIR1SSBkyJqZI6RUUiYItZzd8c0MhcIGD5YacGq93xufW4rZQ6sgtRAXY9cZ5+TmvJyEuJL9EfZcYiq1HLGAljs6uDhLTSpjt7XHCQ2Hh5kVJiCpNsc2SBumRtWajnFFzPwLxGzP7UFlfd8hZgJovUP0/r/2tt8jGH6B0z953OawQbL1HCAJRLqXQ+Z6Buc7Bt903Up23ENijawpaNjnU/ihk7UHTCk28JJ62Qq0HIVUItliMyN8A2DpTpmXz0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(356005)(36756003)(81166007)(82740400003)(86362001)(36860700001)(7696005)(44832011)(2906002)(41300700001)(8936002)(5660300002)(6862004)(82310400005)(40480700001)(4326008)(2616005)(316002)(40460700003)(37006003)(16526019)(186003)(336012)(426003)(47076005)(54906003)(1076003)(83380400001)(6636002)(26005)(8676002)(6666004)(966005)(70206006)(478600001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 01:02:41.5535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 979a3f9a-4e47-40b7-2d2a-08db25ba24e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8326
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>

The VCN firmware loading path enables the indirect SRAM mode if it's
advertised as supported. We might have some cases of FW issues that
prevents this mode to working properly though, ending-up in a failed
probe. An example below, observed in the Steam Deck:

[...]
[drm] failed to load ucode VCN0_RAM(0x3A)
[drm] psp gfx command LOAD_IP_FW(0x6) failed and response status is (0xFFFF0000)
amdgpu 0000:04:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring vcn_dec_0 test failed (-110)
[drm:amdgpu_device_init.cold [amdgpu]] *ERROR* hw_init of IP block <vcn_v3_0> failed -110
amdgpu 0000:04:00.0: amdgpu: amdgpu_device_ip_init failed
amdgpu 0000:04:00.0: amdgpu: Fatal error during GPU init
[...]

Disabling the VCN block circumvents this, but it's a very invasive
workaround that turns off the entire feature. So, let's add a quirk
on VCN loading that checks for known problematic BIOSes on Vangogh,
so we can proactively disable the indirect SRAM mode and allow the
HW proper probe and VCN IP block to work fine.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2385
Fixes: 82132ecc5432 ("drm/amdgpu: enable Vangogh VCN indirect sram mode")
Cc: stable@vger.kernel.org
Cc: James Zhu <James.Zhu@amd.com>
Cc: Leo Liu <leo.liu@amd.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index 8664a5301b2f..4bbfb9c9d8d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -26,6 +26,7 @@
 
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/debugfs.h>
 #include <drm/drm_drv.h>
@@ -114,6 +115,24 @@ int amdgpu_vcn_sw_init(struct amdgpu_device *adev)
 	    (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG))
 		adev->vcn.indirect_sram = true;
 
+	/*
+	 * Some Steam Deck's BIOS versions are incompatible with the
+	 * indirect SRAM mode, leading to amdgpu being unable to get
+	 * properly probed (and even potentially crashing the kernel).
+	 * Hence, check for these versions here - notice this is
+	 * restricted to Vangogh (Deck's APU).
+	 */
+	if (adev->ip_versions[UVD_HWIP][0] == IP_VERSION(3, 0, 2)) {
+		const char *bios_ver = dmi_get_system_info(DMI_BIOS_VERSION);
+
+		if (bios_ver && (!strncmp("F7A0113", bios_ver, 7) ||
+		     !strncmp("F7A0114", bios_ver, 7))) {
+			adev->vcn.indirect_sram = false;
+			dev_info(adev->dev,
+				"Steam Deck quirk: indirect SRAM disabled on BIOS %s\n", bios_ver);
+		}
+	}
+
 	hdr = (const struct common_firmware_header *)adev->vcn.fw->data;
 	adev->vcn.fw_version = le32_to_cpu(hdr->ucode_version);
 
-- 
2.25.1

