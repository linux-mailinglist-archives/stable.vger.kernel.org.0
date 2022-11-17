Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7832F62D3F0
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 08:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbiKQHTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 02:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiKQHTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 02:19:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C096F34F;
        Wed, 16 Nov 2022 23:19:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYfGB3KwU/qGJEZxj+k5h5eFOJo28bRnoBh8u0uXOfE+Wf1FdriBFsgBhuIJPSGZF19NZNcA0HLdxH7NnTdxyHKS/iNlVPzVf9OFFbNPHs5tpqBdY4CPcB3RVtrgmDQTRz78KFjurbRIDR9svtmRzXoeH17aIyN3n6xi10kSPCzN57d8/K3wou7lYCwkH+0d1m7PYuklhNDZL+6cWtqnqHSOAduXw5p/Mkk1tNS3pV2shtWqe/IrM6XysSVs5cijOBafE+caotJTIG5EqxJbduKj3MumadhOc07aN8IAxxlg1xbjYoYJo7DkV/3u5XuEHFZoOzO2fk9/aem1wbuPDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AW+a566QQSG+KQj7q3b6S9EwyMXzi1qKHIFQPV9ACo=;
 b=FS/GQxIyPPf0aQALeUPriAhiRpR5SYgKmHmyEfUC187ADfVo4OF4TbLwbpdYzQWpu4yyN1n4N+CAuKxnceKHSvB2vfQv/Z4XKfB4CMFmi4dAUuY551JNZfgve4072cxD5CmnEAJysnFx9psvCQHBLx3bF9E+I6Y2AlPB1STMLRtscUqNqA7iCc6icfAe8bvG4UgQK2I7nPpKk5hwC3FZlVrkbFJ5+WZvhQaR41uK9Yt9OEVeLFvvx7c2CYnRwTDxGb2vtI72q5VgWQPYgX+iYyfctNRYOiaI5AWjkojEL59X8QcW9a7Zj2uUe6B0QZFxzMG3O7Cj1go7Oh54aIl7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AW+a566QQSG+KQj7q3b6S9EwyMXzi1qKHIFQPV9ACo=;
 b=zNidgquCyCAjurpXSUivvllhQEq9RblEl0v2d4a910tlrliSxW0aHWQzjvlLYKYY3TqECzfg0tQSkDdwCcFYEN0c7K+Cu9AKkAzCp8t6vFb49L8D9cWuxdoFtP6tskl0EM+1twmvjsc1FX7CEtmFOUr4DMzAoQfQYdxupM2ou5I=
Received: from MW4PR04CA0200.namprd04.prod.outlook.com (2603:10b6:303:86::25)
 by DS0PR12MB6558.namprd12.prod.outlook.com (2603:10b6:8:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Thu, 17 Nov
 2022 07:19:37 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::e) by MW4PR04CA0200.outlook.office365.com
 (2603:10b6:303:86::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20 via Frontend
 Transport; Thu, 17 Nov 2022 07:19:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Thu, 17 Nov 2022 07:19:37 +0000
Received: from pyuan-Cloudripper.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 17 Nov 2022 01:19:32 -0600
From:   Perry Yuan <Perry.Yuan@amd.com>
To:     <rafael.j.wysocki@intel.com>, <ray.huang@amd.com>,
        <viresh.kumar@linaro.org>, <Mario.Limonciello@amd.com>
CC:     <Nathan.Fontenot@amd.com>, <Alexander.Deucher@amd.com>,
        <Deepak.Sharma@amd.com>, <Shimmer.Huang@amd.com>,
        <Li.Meng@amd.com>, <Xiaojian.Du@amd.com>, <wyes.karny@amd.com>,
        <gautham.shenoy@amd.com>, <ananth.narayan@amd.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Perry Yuan <Perry.Yuan@amd.com>
Subject: [PATCH v2 1/5] cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init
Date:   Thu, 17 Nov 2022 15:19:06 +0800
Message-ID: <20221117071910.3347052-2-Perry.Yuan@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117071910.3347052-1-Perry.Yuan@amd.com>
References: <20221117071910.3347052-1-Perry.Yuan@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT007:EE_|DS0PR12MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 04716dbe-8c12-4ede-f014-08dac86c1604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EmttMXeHUGL+A1BM7o7fFqr6Ngn3FZPVoDPY8QVYcySf8aOPk3kGFyaCmId2k7PlDkQ1m7nijT/CHpUNPgsqPnFwdgFi5cOxjXOHwavXj0f3BCuHSQg87wHV81ABb2LkslUIC6Vb/MZ3cz7SOk+vkavHD6FHj5Vpwv8kPTGixJD36bZvSVmQ78MSIUW72V37RIBk192hWLbqTcgOrDhkTPUzzv+bRpADteDWyY8Ks0kB9TDNaNK+2QlcTRBMRbAPCaPO+Srparv87hNu+3/R3d50f9UXyJg5OaBB6ReLTtTRO5L5hij7xrI0Rqndk9CTvL/ByuLtq6ZiHlyuzJF6GE64qzbXEwvcWlHySKZM/gW5F05XxNsk7ZXPa/9yGE3OUGYu0CIkaJ5/9eI2k46+KozyWJOG6HePbDl08954uzBqXgNReLgloRgp7VN2PJ4fhtED/uvRD3eAjSyREI4Otu81JaFp7FhyVcUn9U9Tbnk6XpGZ6PdxFJuK1SW/pzWWXTm1momvsN6hk4k7eFYNqrC0RSrrdCO+zR9QxcMSF3JKBp66hCCG7PtKaWKk+EG/tHXuZF7qxbITuBmIE0gx3WvO/MJ5Z/856UwMYr9sKP0tqe25yowD8q9eA6TXMCjEWsz+NpSvcknsjmUjLYFCOOa+8fFJzCl3jXnzBkEu398KPuAXzrFQr6k1TFOeIDAg9sn0e8zmj9m6YUpQmsi3iwQXKNIEx+T+9OhLHm/xrnPRtARj/XqXB1qT/Hqpufy3
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(47076005)(8936002)(336012)(82310400005)(426003)(186003)(41300700001)(1076003)(16526019)(2616005)(66899015)(83380400001)(5660300002)(7696005)(70586007)(26005)(4326008)(8676002)(70206006)(36756003)(6666004)(2906002)(478600001)(6636002)(40480700001)(316002)(110136005)(36860700001)(82740400003)(86362001)(81166007)(356005)(54906003)(40460700003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 07:19:37.6073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04716dbe-8c12-4ede-f014-08dac86c1604
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6558
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

