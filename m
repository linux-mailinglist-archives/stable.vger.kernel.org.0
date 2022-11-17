Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4129D62D42E
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 08:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbiKQHgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 02:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239382AbiKQHgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 02:36:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86050701A2;
        Wed, 16 Nov 2022 23:36:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqcETzXaxQ7e4M3WdNVVUhOaY0VnoqKIansmLrS2RJwTj0wYplkvl+HQ6JfPv5EVq947eVaCmfffVcIakoWwdKFw5HtZWRnyx9cZeRAxmidZH7o+WQfF5TgVOcdmryem0utzExQpyYRcze+NCSwTazbh6vEP+GM+qpsprBQkqA7cUp1kAK07n+6FaMikiwdxny7qMnoOzZnwlfNISXfP3KBqMR8jzeWJuAoPYf+GUuWFYCTb/MKbMZE3ornWBNXYNLaIyoorOt+NJOja7dIiVEgdWu6koB/vSaG6ZCWRvZbklG7B/jwni/MiIzfVs32HX5u2Uzcuef9vKQ6TnrNMGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uH2vHdND+rpaickxtwrYN7XcES8PAQW96yRrcD1vcN4=;
 b=dUKFp5qupR6Y7B9SiTcqgmDMmcYZjcGvHqr1k0GNGnnkFhg5LZ0YwYlwklhkWr4zjdYqx8ZjsYrQmbky7ruTkvclh0QE35oTl7PpshGvoYvDcbRqbntvOcF0cUG6HQXBQJgIioFMFWgfx3zZnH56a3nCDWYwjc4lJpzj7ZjISGls/bh1BcGtnkRR5Xoc+Q1eSu7+kK8G7laS93xK5mYpyEZp/kRfFXV88vuB7HZePxNovt01nShMYmSMvxSw0Kx/ezPUeSizyKXT3mmxSMZunbkQxHA/ii3VA7Wyq7V4RtCnQrO5civWDTTNR4YnoBwsusS3sXncocLH4XVs+MDVbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uH2vHdND+rpaickxtwrYN7XcES8PAQW96yRrcD1vcN4=;
 b=pIKrYPEaUyXRRjNHWR6nAAkqCtkcW9b72aARGZ5w6gPysQ8e0wK6R5Red4wiYJWsuz6PSDBnTTvMkTYuPoF1lxDLA2FvFohcJkXVQRc65bFa5mtCA3KHqkCgJKJwb20AKrdukIc9mKV/Ymxs/xg5OibD9W8wRka+QTVVS/8P120=
Received: from MW4PR04CA0160.namprd04.prod.outlook.com (2603:10b6:303:85::15)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 07:36:14 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::69) by MW4PR04CA0160.outlook.office365.com
 (2603:10b6:303:85::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20 via Frontend
 Transport; Thu, 17 Nov 2022 07:36:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Thu, 17 Nov 2022 07:36:13 +0000
Received: from pyuan-Cloudripper.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 17 Nov 2022 01:36:08 -0600
From:   Perry Yuan <Perry.Yuan@amd.com>
To:     <rafael.j.wysocki@intel.com>, <ray.huang@amd.com>,
        <viresh.kumar@linaro.org>, <Mario.Limonciello@amd.com>
CC:     <Nathan.Fontenot@amd.com>, <Alexander.Deucher@amd.com>,
        <Deepak.Sharma@amd.com>, <Shimmer.Huang@amd.com>,
        <Li.Meng@amd.com>, <Xiaojian.Du@amd.com>, <wyes.karny@amd.com>,
        <gautham.shenoy@amd.com>, <ananth.narayan@amd.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Perry Yuan <Perry.Yuan@amd.com>
Subject: [PATCH v3 1/5] cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init
Date:   Thu, 17 Nov 2022 15:35:37 +0800
Message-ID: <20221117073541.3350600-2-Perry.Yuan@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117073541.3350600-1-Perry.Yuan@amd.com>
References: <20221117073541.3350600-1-Perry.Yuan@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|SA0PR12MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: d1046258-238a-4416-57aa-08dac86e67cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YwneT5QstTR9I3uj1JlRLqzf6RY3wZKKBA2TP7U3a6BwLxJxXHQerkJz9JAclmVR3JF22eb2U/JWG5ziBvpFRZAf/iz+bhXQasucPGFhQHBzxoAxB/cqhD18cz9xb1CzFyz34LkVJ/F0jh7I66bLV3bV8gNpTymRNzVgFusojEIB3/lFIoGbhrPkbNB5y4f4ZSTzoIOk0bkdJspmDOe01k0/c0m8/mJ4lqVdaH85JbQbBljp+dpPoxjDKCeVCmNl5pHRvvKSrJ3OeWO744E0r6wMwTzr/6uLp8MD6FtQG5GvMw/aUxMMvc/Y1z1vX8gkhmOB+tOfQ6rIAY0MzLZIyz8mOZBFPHRhiscVbPhQt0RYFzMHOZGY3Ki8/cH0hfgAhRoRgfur22dxMUFSI5WiCJFH6zHBlhbeD6J/+LGi6B/KQ7HdkXXFmR+ST0qQPT4XMf8i578N3MVuz7NYk8h6YXScIFOLAT6cX4aM38oi6hhr53o9nmqA3a+8R0axExKfWyLf7Gg25ivahPSNRuQezgabipIrBOIWmEfENPLKNXMuW2n/TVaC/B2jgMKqTk3mGMgLYhYDjYfJ2lTS+pDuWFh44MEa3gvba2cHUEFzl07URYgqhDnyoWROXVwP1ukf+nLaCZuJ3y+uJEtpG7/DYmtn/v3mdvG7wRbl9Hd4C3/+Ne05hNpGKJ6sqr67doB/wyhuzEECDiuLbYY+9O9GUq5A1VeqDEk4rF5Z4TrwE34Twt8xt9qnXbXPgeWUe05y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(16526019)(1076003)(186003)(40460700003)(336012)(7696005)(110136005)(54906003)(316002)(6636002)(41300700001)(2616005)(8936002)(70586007)(26005)(70206006)(36756003)(8676002)(4326008)(82310400005)(36860700001)(81166007)(356005)(82740400003)(2906002)(40480700001)(83380400001)(47076005)(426003)(86362001)(6666004)(478600001)(66899015)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 07:36:13.8121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1046258-238a-4416-57aa-08dac86e67cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
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
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Wyes Karny <wyes.karny@amd.com>
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

