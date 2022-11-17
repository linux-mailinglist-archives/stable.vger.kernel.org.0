Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E4162D13F
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 03:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiKQCwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 21:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKQCwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 21:52:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF96E43AD6;
        Wed, 16 Nov 2022 18:51:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed3LngrZYFrJSorwgAJjs1rwi7Z/6xcBernnutv0bLnqSwKT2SXq6krCbGA17nGR9NAFsHT1DP5jmec1s6vTD8I6E3G1lzgzMR62FnR6npUUzofxHRpK516oNY7LktpixlLiNr+CwACW8Et+dgU6hA8ZC+wTV2QZT7bfdsIVO0ELYo1y7WLsJqO1T60tCoBHEoxOHofhlSd4Exn/Pq61Ib+biUHTQe58cA3vbbaNvwCQ/1s3X4J06CS2nh6pb+gpiPjjohuDLZE+V/frRixolC+XqDnG3a68CDcwxKTvQA/0KqsKwn7BAIigb1m3yYYUiQz0CcTsDTvehK4XNnsVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4vdABTnmomCtasCUx+mcw49cRlQDJP0SSFAHernidE=;
 b=iAxDXjRfv9vVIlU/VvgzDLv4PEsxEAL9kaK9HVGxaqoKNDdnEpim5mipMkgbig8jeAS6Ztm/bwuCRz4gTeF7Dx4jPU73Xrck2IOs17iGJy3Ohg2o+1LpvcFyHHTBqTEKSbvLMpoBTUFXMcuj3HKwZz3f54p5ks6E8fWqWszc/hBCiBNsYUigwUCGk12vDIBx6IyFzQGwBtF+FRUM/ZVWkhzYv04cF1t8OgwVeyYJMtaue/VWL0xCSl5b2FBb3rOCATID7Edl4XOXHUNyg3/yQFBXireaOtxcLQUNSamvFW9B9Pkzy3w0pbUFrFkR2R7DzglU4vBeKZfbfAP1NLFA0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4vdABTnmomCtasCUx+mcw49cRlQDJP0SSFAHernidE=;
 b=tXK6ASfDjDWLotsE7iiA3q1zXrbu61QxA1VNfpKYsOZVhhrBUfOzQwqgq/raENNh9qNlUGGiM9ZyWeAZ/Dl7iq5LwEik+SL3tHrhr+qwTuWixK8rZ6MxyATkBp7+CiFPCFkG5Vt0iDmZWBG5fGRI2ywZpQItlNjsWJlHQgaqhY4=
Received: from BN0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:408:e5::6)
 by BL1PR12MB5319.namprd12.prod.outlook.com (2603:10b6:208:317::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 02:51:56 +0000
Received: from BL02EPF0000EE3E.namprd05.prod.outlook.com
 (2603:10b6:408:e5:cafe::fc) by BN0PR02CA0031.outlook.office365.com
 (2603:10b6:408:e5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20 via Frontend
 Transport; Thu, 17 Nov 2022 02:51:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3E.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Thu, 17 Nov 2022 02:51:55 +0000
Received: from pyuan-Cloudripper.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 16 Nov 2022 20:51:08 -0600
From:   Perry Yuan <Perry.Yuan@amd.com>
To:     <rafael.j.wysocki@intel.com>, <ray.huang@amd.com>,
        <viresh.kumar@linaro.org>, <Mario.Limonciello@amd.com>
CC:     <Nathan.Fontenot@amd.com>, <Alexander.Deucher@amd.com>,
        <Deepak.Sharma@amd.com>, <Shimmer.Huang@amd.com>,
        <Li.Meng@amd.com>, <Xiaojian.Du@amd.com>, <wyes.karny@amd.com>,
        <gautham.shenoy@amd.com>, <ananth.narayan@amd.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Perry Yuan <Perry.Yuan@amd.com>
Subject: [PATCH 1/5] cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init
Date:   Thu, 17 Nov 2022 10:49:51 +0800
Message-ID: <20221117024955.3319484-2-Perry.Yuan@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117024955.3319484-1-Perry.Yuan@amd.com>
References: <20221117024955.3319484-1-Perry.Yuan@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3E:EE_|BL1PR12MB5319:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f40f32-b28b-46c5-fc3b-08dac846b072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xlsKiyN6Jk83QcjboapZ2KPWgfsIki0xleXjWAPATvLcQYCDoZTsCqHvhpR3ayE/7AxyeGCH8RJnpJ06TJH2acAtuMeYEOGK/da01o8fwn9uIkMH2lbV3fv5J/OtoyyWFb4Il9z+ijJ+wcS6ffnMaYcvMTU/JJdM0ykG53JvIr4qLMKdpJORrmEASvAi0aXr02WNnoyPGO7HRokGG7iH4NaLuwhQtNb7MshWUzYcZrHhJxXIctLjOD0deU60YKy5Ew+gnbwf9e7vMxUROc/+Im35STr9IIgcz/afkacLHr/t8+8TDk7Ss5jQz/XjhjebtFw3DuR1YWHST2mVUWnR5uoFf4f6R4cwsiSMUgjTulomTicWJtxdx6VtSHBrJW5SLnkSL7PFYqFcos+ENEbRavC9S9swS9sZOpvWh86yn3b+kgI3JkhJViJtvjq0FSNKmImLRKjKO5AvG0Q9fBQNNpZouUf0Vh60z6qCrX6r6VX7BsmsjncVEJ/b/0NyYC7V+dKANCRLDZKYYlL8JBAxzOFQBO2EBOxzenYS1RAGnE05JRxh6J8hTGsY7TAezp6kD6XFtlR4SQw3F9lmdEyLCN9ki8AfNFfqWAlLUgn9vg/lNbJ/M0T7huSrHMOVewGZpousoaDsRXBUmH8IwwNyzq+Rx88XQ1P1Z2Wbn0oCnp6plshZmfgrfaGwXT9v7xMtPNmjr/PjddOru6qB7XZQp545BP9X6fImnYPIZN+OsbSUhk6aG4xEJhI/Fsd/KDjmpm//KKwEO+P56+A2bsvHOvAinM4HqixmxAtZv/NlzoRzjIYyuEMCFPAwWwUmmHd2262eBjP5bblf4zObVuRwA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(66899015)(82740400003)(5660300002)(81166007)(356005)(2906002)(40480700001)(8936002)(4326008)(70586007)(8676002)(70206006)(41300700001)(36756003)(26005)(47076005)(16526019)(7696005)(6666004)(86362001)(82310400005)(336012)(2616005)(186003)(36860700001)(426003)(1076003)(110136005)(54906003)(83380400001)(478600001)(40460700003)(6636002)(316002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 02:51:55.9469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f40f32-b28b-46c5-fc3b-08dac846b072
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5319
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wyes Karny <wyes.karny@amd.com>

MSR_AMD_PERF_CTL is guaranteed to be 0 on a cold boot. However, on a
kexec boot, for instance, it may have a non-zero value (if the cpu was
in a non-P0 Pstate).  In such cases, the cores with non-P0 Pstates at
boot will never be pushed to P0, let alone boost frequencies.

Kexec is a common workflow for reboot on Linux and this creates a
regression in performance. Fix it by explicitly setting the
MSR_AMD_PERF_CTL to 0 during amd_pstate driver init.

Cc: stable@vger.kernel.org
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
---
 drivers/cpufreq/amd-pstate.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index ace7d50cf2ac..d844c6f97caf 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -424,12 +424,22 @@ static void amd_pstate_boost_init(struct amd_cpudata *cpudata)
 	amd_pstate_driver.boost_enabled = true;
 }
 
+static void amd_perf_ctl_reset(unsigned int cpu)
+{
+	wrmsrl_on_cpu(cpu, MSR_AMD_PERF_CTL, 0);
+}
+
 static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	int min_freq, max_freq, nominal_freq, lowest_nonlinear_freq, ret;
 	struct device *dev;
 	struct amd_cpudata *cpudata;
 
+	/*
+	 * Resetting PERF_CTL_MSR will put the CPU in P0 frequency,
+	 * which is ideal for initialization process.
+	 */
+	amd_perf_ctl_reset(policy->cpu);
 	dev = get_cpu_device(policy->cpu);
 	if (!dev)
 		return -ENODEV;
-- 
2.25.1

