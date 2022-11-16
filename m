Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84C162B0B0
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 02:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiKPBoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 20:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKPBoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 20:44:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C170311142
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 17:44:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlMRdSYtXt5kvdvcQl+XjQ98lHiicvlMJPjc3FjpggnufQ2T59hE9jrhBuPykWy5Dx1DcDdEq9PTD6IMx3nJOiTbKpAQgIrALL4bst/nx3N+fbQD3tLYzXz97vfOMCZ929Hp65z0vK/binNhByr11zbQJFDaLcqGNZsB/73xy1dE/Efln/q8skrwYL+g7KIYIVwrn4E92MxSY0UBXo62wwl+O+M9lZwOX7jbJRVGbDJjkS7guac1RsUent6Fd6HkIvqfvfmSKJe2mhw+2MnQFF1jCN8/8o8OVXHyZbJsJ4613N7gJg8t2q0+CcLDXYjdy+u5IqROMuiRGpI6Ywf78g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpq974gQ565Q8VaOABN1jgGrqv8mbV0i1tz52xyoDCE=;
 b=YP0SS7YLBXqa6hV5znqDGtrARWXTjUPIorEVdPWgko8ZvkDmO9MwGHZNgyfbo5lPAYE8j4R65GT93a8rTqRnua+kCsytLg74H5HHDpHGbPl8ByMVsucZG7Ri1tqAke8jUOrruDq1eOtzkf1gmWlKENcE5KjlFEvurqAUD0xCTQfB1HNF9ptwWxeZiXIMupAnWYKfsXd/hmFrsdzFZkIPRxVUqqAUD4MfPNGEW4hmdpu3FGl/sLuDlsdTrSIA6653Okzq5k9vkW2F6R6BTf7HjjJqtv2orTZz5Mdjh+dbqPwrVg9dNfTNDbdHWFBEM/KNmkNX90SzhCmRnQexUOLJ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpq974gQ565Q8VaOABN1jgGrqv8mbV0i1tz52xyoDCE=;
 b=irVPoyPj3CUQBR/ip7GXHGTyFjBBDyx6VkZGykq8hzkLUXuY+LTKkqRHtoHvOO23Qo3enpZibtWZ0D5DxQCWo1XilD0raL66uSwMwIQIEMEOXklXbki5t8VatD8KO9BR3wOsnpj9d36f5IsYr9bXsNUfjO60iJ6Oy1Zf5YX5Gg4=
Received: from BN9PR03CA0278.namprd03.prod.outlook.com (2603:10b6:408:f5::13)
 by MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Wed, 16 Nov
 2022 01:44:17 +0000
Received: from BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::8) by BN9PR03CA0278.outlook.office365.com
 (2603:10b6:408:f5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Wed, 16 Nov 2022 01:44:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT108.mail.protection.outlook.com (10.13.176.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Wed, 16 Nov 2022 01:44:17 +0000
Received: from pyuan-Cloudripper.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 15 Nov 2022 19:43:57 -0600
From:   Perry Yuan <Perry.Yuan@amd.com>
To:     <Mario.Limonciello@amd.com>, <Nathan.Fontenot@amd.com>,
        <ray.huang@amd.com>, <gautham.shenoy@amd.com>,
        <ananth.narayan@amd.com>
CC:     <Alexander.Deucher@amd.com>, <Deepak.Sharma@amd.com>,
        <Shimmer.Huang@amd.com>, <Li.Meng@amd.com>, <Xiaojian.Du@amd.com>,
        <wyes.karny@amd.com>, <sos-linux-interlock@mailman-svr.amd.com>,
        <brahma_sw_dev@amd.com>, Perry Yuan <Perry.Yuan@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 5/6] cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register while driver loading
Date:   Wed, 16 Nov 2022 09:42:45 +0800
Message-ID: <20221116014246.3221416-6-Perry.Yuan@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221116014246.3221416-1-Perry.Yuan@amd.com>
References: <20221116014246.3221416-1-Perry.Yuan@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT108:EE_|MW4PR12MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dc1ce48-1430-4392-f30f-08dac77412c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OTYDQ41YobrNVn+AS63I0BKKNUWLBsPIFkLx0JyoFmsjw9r/XNFa4YhNMsoaq8zv1/HcxJjKQrB9moUEDC/zSeFNlBjiD6c2+DNrguAb+AAH/WnNSMD8fxZdNlY7Pt1/cOjs4tHR+Ncn6xbIbhtRMetlOo1G8aa0qzxWKaRRbF2DQr/CAtx218cc9g6aMxXBHna8kEBOUU7P+sIy4osvJ1TDJ74gSLZEfzKfW4tJxp41xpfSkjVIkEWyH8i73jm/PW0GOn39ewHRswK7dhlokKtYM2AmnGxXeKgUsXbE1eo1SFZfuyHmQFSPasA3SXNG6OktQdMoI1z5L7YsMkX0VH5LvF6wBEeoVqGvNV+wpXkWXCoBQsiJkSEK7073nqbJiwZZ16mfUTY1kJrgSOGv5ZGvAlLtGkhnjNcWlE3J4A8fmhu1TyD97un8yAtOaLhxPGvp5CQ92V4gPGDHvFVGwtNDnDdhyTwI3SaZzDV5YfRle7gpNFgt/dhcF0w0/ooBY1Nex4Z0wrvQGh2R6lYwYfXEQdwxLkPrmiEurq4442UhcY+lDfKa7nIv/dKEoiko8SnJa1DWnHecYtY91D+8vw1Dk6xACAsR0K5VqtuXgZYfZBHOGtzJO03nItaZvJE1EPBpbp9u0eNWCIn3X/MTYPBsdCx0LLlF0BCT0MI5ApNp9zr0SDfc8OGMW6OKd3B0DggVI9Nf6hiRaBfoqwmh6Ds1Dppms6KMyc0iRpBlYHneQVSbiNl1O3tEpRnpteYs5JGB7ZVbSfe3NJK8YXuiNC/ABVxpQY86kkM+ybo0z6uRoeaU0NhqIAJ0chPjiVb
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(40470700004)(36840700001)(46966006)(36860700001)(7696005)(70586007)(8676002)(316002)(81166007)(4326008)(70206006)(26005)(426003)(6636002)(54906003)(40460700003)(110136005)(36756003)(2906002)(5660300002)(1076003)(47076005)(40480700001)(16526019)(186003)(8936002)(478600001)(356005)(41300700001)(86362001)(336012)(83380400001)(2616005)(82310400005)(82740400003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 01:44:17.1236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc1ce48-1430-4392-f30f-08dac77412c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262
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

MSR_AMD_PERF_CTL register should be reseted while initializing the
amd_pstate driver. On a running system, if we switch the cpufreq driver
from acpi_cpufreq to amd_pstate, we see the following issue: There is no
frequency change on cores which were previously running at a non-zero
pstate. Hence, reset the pstate to zero on all the cores during the
initialization of the amd_pstate driver to avoid performance drop.

While the AMD_PERF_CTL MSR is guaranteed to be set to 0 on a cold boot,
the same is not true for a kexec boot, which is a very common mode of
switching kernels/reboot in MDCs and Ubuntu.

Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/cpufreq/amd-pstate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 1ffb97b6dbe2..0057ad5dfa97 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -420,12 +420,18 @@ static void amd_pstate_boost_init(struct amd_cpudata *cpudata)
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
 
+	amd_perf_ctl_reset(policy->cpu);
 	dev = get_cpu_device(policy->cpu);
 	if (!dev)
 		return -ENODEV;
-- 
2.25.1

