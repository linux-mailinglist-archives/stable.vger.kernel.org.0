Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5A573C3B
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 19:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiGMRx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiGMRx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 13:53:59 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF2F23BE4;
        Wed, 13 Jul 2022 10:53:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYGNcoDfrfABSNoZC/zylco1h2Gc0GygvFGmKKF1DHJ2MiHirgeKDBsRBTdlEVsJGtuMxSzW4QaMJA/K/59lB64N8gseiqxKn+TRl3UJ3G57dmtNI5qFMpRkRpmBgadup0wX053wiNATzY2cbVNMJpZ09l/V5H9uoKyJ9RXdB/p+mEkQVLtU3ohxLYancsqDhjKFgPs5+1dHfttx8sN5gFPLfOXXUVsxzWGwk6Of0fPFtPjULOxVgdF+qs6Y/c4lXzfzxdF/S/QDeAtUO7tgeuHQQxMUwfHIYt6meniwpNU01FX/fx3JFkyI45ciIsapb89549GLbnhagAzv7kIJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YydfP/cKPMOXsh1meXMvFeUVEkMRiwfhkltq+gyQkWg=;
 b=Pt7O+k+ttvHn8PutAEgwM97vHSWrfIwti1Fw37RJlktJYPLwbafUHKJvHA7y50dj1pquGBUhnrkHYIkUCN0DxPlMoxV+YX7rlOUbJTm0MInbdW1NXx+MAwqvJfEaueiuBZMWjmutQ/t1tUSp8NlAjnPWOwt/G3BI0xG19oSKFyeLd8y0YoPy2ib+IcalyDPMV4448Br0QgJRMal/WqQfmlJcxRl+RTLy23Ym+Luc+uufu/ZxC4S3hfowewL+pmv0PKo5e0hCi04mfwgtFtr06Tv8xtR85R4b4mcCfRtdiMHmIuYlsbXYN5FteFhW35npuRpmHDmFZN/Xc3iZCV2GUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YydfP/cKPMOXsh1meXMvFeUVEkMRiwfhkltq+gyQkWg=;
 b=rH+qWmbUMIb8gqWcGHKTRnH6wSJgxTggWGbGzcJXyHQ6J0bX6ZUoKxFzDSckUwZLZ3wCDFVWfEd7XK2X1gXt+uLNWbGCSuiJvSAGRyViHC2RQzI6Q6kAv8KjG1yG0oGcZQFnT7W2tmxXNXLq/Jv2547J9eAXcqbOn0B+xqCfYEo=
Received: from MW2PR16CA0068.namprd16.prod.outlook.com (2603:10b6:907:1::45)
 by BL1PR12MB5777.namprd12.prod.outlook.com (2603:10b6:208:390::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 13 Jul
 2022 17:53:55 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::be) by MW2PR16CA0068.outlook.office365.com
 (2603:10b6:907:1::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13 via Frontend
 Transport; Wed, 13 Jul 2022 17:53:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 17:53:54 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 13 Jul
 2022 12:53:52 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Len Brown" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Pierre Gondois <pierre.gondois@arm.com>
CC:     <perry.yuan@amd.com>, <ray.huang@amd.com>,
        <stable@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: CPPC: Fix enabling CPPC on AMD systems with shared memory
Date:   Wed, 13 Jul 2022 12:53:46 -0500
Message-ID: <20220713175346.630-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4857ccd1-2eb6-486f-50e8-08da64f8a761
X-MS-TrafficTypeDiagnostic: BL1PR12MB5777:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VA7VCOUTGfmOPXgxNPIerfmftQxllg33elBbMgj90lC79638PyFNPs76WlFLgnnOZPJDQMJP5ToMNk2laquvY8YfXIEGw7cT/d2BPscVYBH/7pB06URi2tUTGuavo6GxUIuC0pWB1lbu0ieLQl2Vc66d+KzjGVg0hb0jPniBe2HuHNUVPC8nQ1aIGQmbgWRg4Z731sGGMn2DI5fcjxDMkq1yeu387V2VmEjbwOHTP46SUBgQ7IG2tNIgIedfRUP9tw6QsTZqFS9B7J4ayO9glzmXB8UNl/2C3HLfQUJEJeUhFKCxZ7iaj/Ptn7prp2KJDiebOT5GCpT+l+qXNu1AncZXpDEMPXKFLPrURrEj4RGL0TYhh2WrjgOON095CgyOOiMZQmdWGWiJDNoK8xtcGR4OqAdtjaKjE7Fi7WnrP/CibY+C30LUCAh/itxWyqTn0D9EUFdmnCvC3GTtl12kiNZNiwJf/XqiUMzuY1RD8X44G9rwF0U/hCeIpH9cXNG/hQSS/HYSEdYfwVR5yWEmL0oWAmQfsj7hDX/W+AfHgzlYoAjY5vDpU3F5MboXdl9sYOvejS37x3aEJFd/5LmGEKu1sU81/PtYKtRkx1nVEGjp+AqpeQbJpwAteCznZrHAhB1TlLtT6wt69x1Gy91RDkWNc8kCNeiel/SAd1KN3fWSnDRVpYNkMhFwWgdaa9rvIVW+ToQ1+W8lcdm9BfWRhIDr0OmUZcHFwwPU9gbgtVi60Dj7WS0VDOQ5/NFl3yq5Cmvlvp57I+7WUFjzxaYPNIvat7N3Drt04bTQ1dDFfMCNbYhddTUlgjUY9HppO8aoF7Ig1vix/TZl8i4bwSc1cnJ91ETQBX8ByeLxZCq0RZveBatuIgqo305j+BRKy5Zl
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(40470700004)(36840700001)(46966006)(2906002)(16526019)(478600001)(26005)(41300700001)(1076003)(2616005)(6666004)(70586007)(186003)(7696005)(966005)(110136005)(36756003)(8676002)(47076005)(8936002)(7416002)(40480700001)(82310400005)(54906003)(356005)(426003)(81166007)(86362001)(5660300002)(316002)(44832011)(36860700001)(336012)(70206006)(4326008)(40460700003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 17:53:54.7311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4857ccd1-2eb6-486f-50e8-08da64f8a761
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When commit 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all
and when CPPC_LIB is supported") was introduced, we found collateral
damage that a number of AMD systems that supported CPPC but
didn't advertise support in _OSC stopped having a functional
amd-pstate driver. The _OSC was only enforced on Intel systems at that
time.

This was fixed for the MSR based designs by commit 8b356e536e69f
("ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported")
but some shared memory based designs also support CPPC but haven't
advertised support in the _OSC.  Add support for those designs as well by
hardcoding the list of systems.

Fixes: 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all and when CPPC_LIB is supported")
Fixes: 8b356e536e69f ("ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported")
Link: https://lore.kernel.org/all/3559249.JlDtxWtqDm@natalenko.name/
Cc: stable@vger.kernel.org # 5.18
Reported-and-tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 arch/x86/kernel/acpi/cppc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/acpi/cppc.c b/arch/x86/kernel/acpi/cppc.c
index 734b96454896..8d8752b44f11 100644
--- a/arch/x86/kernel/acpi/cppc.c
+++ b/arch/x86/kernel/acpi/cppc.c
@@ -16,6 +16,12 @@ bool cpc_supported_by_cpu(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_HYGON:
+		if (boot_cpu_data.x86 == 0x19 && ((boot_cpu_data.x86_model <= 0x0f) ||
+		    (boot_cpu_data.x86_model >= 0x20 && boot_cpu_data.x86_model <= 0x2f)))
+			return true;
+		else if (boot_cpu_data.x86 == 0x17 &&
+			 boot_cpu_data.x86_model >= 0x70 && boot_cpu_data.x86_model <= 0x7f)
+			return true;
 		return boot_cpu_has(X86_FEATURE_CPPC);
 	}
 	return false;
-- 
2.34.1

