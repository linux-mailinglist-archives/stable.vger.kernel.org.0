Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C5A6DC55D
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjDJJx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDJJxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:53:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80822697;
        Mon, 10 Apr 2023 02:53:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvbnHT5AnaDGFv4UhA+Y2cK22w/xXMf6V4+NN8COSztqj65Cp1n9Bb4sWO4uQrVsqvNcZMR0gJvqSiI0YRU1dnx8j3sgO3br5Dwa+Nw17hp5cz5soZkYZ3R1HUTjyyrKtrN9MtEc8dE0aLNBQkNWTHdMbY6FANXyLEv8TL7uoIJqORM3aPhwPgMgx6EzBuXoFp6I0xVgyjFtatSNlhBy/BjdeopbkQbfk2I3wT/uKOtEaXO+hGNxITgy2EG4VOngB+gUTGis2CjcAFyKeBAk9IEFzIlCRo0W6N8JMJA3gNWfyq58R/PlbKgVcr67DWDyT7i1FRYMSLbgGIcZBBN5Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPiD4y58o7FmxPLFDaXsIbFOai38OvwCh+r+77WEFxc=;
 b=KSb/gkyqdGxghKJCxdkEWMZlOzrsQj8X7B9owBZt19WOf1BhBtdfVVCh6CZVjLxF9JIbUVGxWHaVpP6O42loYiUENNRxFpP2jD4TdFwUC+kSMRMlAkLGgv+mPLb5eq+tdYrnc2jaOXgJ21gDT/8VOlNHfebYt4FFaw0NvN81HQrAJa+zsITZjptaBiusZHBTscU18vUVx1vJKcElN+bJa0OEW8SEiBjxTHzTxXAJJSgkWX/7lZ922eaWigm5dg1TGwMO1n4fS4GePd23+08URTkSZmIknAmdcJlpquaFutxlYrz8B1HPjeWdAO7pshozn+lw7n/WX26Z9MekjX4Eiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPiD4y58o7FmxPLFDaXsIbFOai38OvwCh+r+77WEFxc=;
 b=YL/jyvCQvrHDwhsUIwRaC2lnwlty4TfGxx+kY9EOyI69lLmzEm32hhxiwGSgmq1o8U+Q6cvr2TX6jzrwmUJWnCGQFvRx6wS26GStp2iqqkZSyh+75Cg4TZvRW91CJwkIqu2PhBGkEGnjquP19T2hZp8sZTUYMnZwgLdKZWlXc3g=
Received: from MW4PR04CA0314.namprd04.prod.outlook.com (2603:10b6:303:82::19)
 by PH7PR12MB6537.namprd12.prod.outlook.com (2603:10b6:510:1f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 10 Apr
 2023 09:53:27 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::d5) by MW4PR04CA0314.outlook.office365.com
 (2603:10b6:303:82::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35 via Frontend
 Transport; Mon, 10 Apr 2023 09:53:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.25 via Frontend Transport; Mon, 10 Apr 2023 09:53:27 +0000
Received: from beas.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 10 Apr
 2023 04:53:18 -0500
From:   Wyes Karny <wyes.karny@amd.com>
To:     <ray.huang@amd.com>, <rafael@kernel.org>, <viresh.kumar@linaro.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>,
        <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
        <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>,
        <bsegall@google.com>, <mgorman@suse.de>, <bristot@redhat.com>,
        <vschneid@redhat.com>, <joel@joelfernandes.org>,
        <gautham.shenoy@amd.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wyes Karny <wyes.karny@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] cpufreq/schedutil: Add fast_switch callback check
Date:   Mon, 10 Apr 2023 09:52:50 +0000
Message-ID: <20230410095250.14908-1-wyes.karny@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410095045.14872-1-wyes.karny@amd.com>
References: <20230410095045.14872-1-wyes.karny@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|PH7PR12MB6537:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c5b243e-a9ab-4785-d60c-08db39a96ea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7etvTiLCCJybty4Q4weL3n+IIKHbpTH/7xbQdKuyU3vkCxIk/D4eGxIQN8GdV6g19+XweaeosxIxFHwhjIKcf9OhDGTdNzKE7XsPWiU5zIRE1H5pWW3StacVnFqBAsrIGNCizL58U/o54J8BNA5owkxZFxg6+CvMbHc59cc1TSDEBT1tdZCX9UlpKuhi+2xbkVCjIA3qeuS91LVjoVlMToRO0yEyva5tqP3KLnrqw044H1nbaTmcIO+/Q5tJfinTgYWgS7/uqyn1wVXoUHux4/6LM41CQ/o6jpiQZoYQBrJDtqW/MXiOOUukMdtU69SJ9WO+aKFX3uP8xLA9O4A5E0WT5xksFqP7C54BZCd4dwVwwlDg2Q0PS3Euk5fmOEJgBexY2y//7N5Z5cmh3vI20qhbeGa8TAiPyaCgFehwVmEPPGCwsgTxFLErPjdnjbPQKxTGYM80TDTidngeD5LcVDEYws53hXof0UgDZwNVuSqtuG930k0CrJJGiTvEsGQYK0I+hJL+9B6jNOEuRLecXCCRHmSI4UFBdhU9xmWSgcgfX44B4RQvjLSvKOgWtjc4qVqy7nFeZ3pcOjFR38/LFyzPlqs2fWUffGyCZzjSOoc3zk+meIEb9uqqgkBzs5q2dbzqA//RcQ61tyf9CNqPwIS6nEk3Gedp0ehsDVGNxJugbCHip8AOxkzmyBrxZfDwavZ7W8x8ACQRFlNYLqd8C3XrcuMohQJzowBfX+3J1Y6LMKu3fUkot9WMh8bcsfQHqTL/oBLmzguawGXAC5A1g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(16526019)(186003)(66899021)(7416002)(26005)(44832011)(1076003)(40480700001)(6666004)(40460700003)(426003)(110136005)(36756003)(8676002)(81166007)(7696005)(82310400005)(36860700001)(54906003)(478600001)(70206006)(316002)(4326008)(82740400003)(83380400001)(356005)(41300700001)(70586007)(47076005)(86362001)(2906002)(336012)(5660300002)(8936002)(2616005)(2101003)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 09:53:27.0375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c5b243e-a9ab-4785-d60c-08db39a96ea9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6537
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The set value of `fast_switch_enabled` flag doesn't guarantee that
fast_switch callback is set. For some drivers such as amd_pstate, the
adjust_perf callback is used but it still sets `fast_switch_possible`
flag. This is not wrong because this flag doesn't imply fast_switch
callback is set, it implies whether the driver can guarantee that
frequency can be changed on any CPU sharing the policy and that the
change will affect all of the policy CPUs without the need to send any
IPIs or issue callbacks from the notifier chain.  Therefore add an extra
NULL check before calling fast_switch in sugov_update_single_freq
function.

Ideally `sugov_update_single_freq` function should not be called with
amd_pstate. But in a corner case scenario, when aperf/mperf overflow
occurs, kernel disables frequency invariance calculation which causes
schedutil to fallback to sugov_update_single_freq which currently relies
on the fast_switch callback.

Normal flow:
  sugov_update_single_perf
    cpufreq_driver_adjust_perf
      cpufreq_driver->adjust_perf

Error case flow:
  sugov_update_single_perf
    sugov_update_single_freq  <-- This is chosen because the freq invariant is disabled due to aperf/mperf overflow
      cpufreq_driver_fast_switch
         cpufreq_driver->fast_switch <-- Here NULL pointer dereference is happening, because fast_switch is not set

Fix this NULL pointer dereference issue by doing a NULL check.

Fixes: a61dec744745 ("cpufreq: schedutil: Avoid missing updates for one-CPU policies")
Signed-off-by: Wyes Karny <wyes.karny@amd.com>

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/cpufreq/cpufreq.c        | 11 +++++++++++
 include/linux/cpufreq.h          |  1 +
 kernel/sched/cpufreq_schedutil.c |  2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6d8fd3b8dcb5..364d31b55380 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2138,6 +2138,17 @@ unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_fast_switch);
 
+/**
+ * cpufreq_driver_has_fast_switch - Check "fast switch" callback.
+ *
+ * Return 'true' if the ->fast_switch callback is present for the
+ * current driver or 'false' otherwise.
+ */
+bool cpufreq_driver_has_fast_switch(void)
+{
+	return !!cpufreq_driver->fast_switch;
+}
+
 /**
  * cpufreq_driver_adjust_perf - Adjust CPU performance level in one go.
  * @cpu: Target CPU.
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 65623233ab2f..8a9286fc718b 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -604,6 +604,7 @@ struct cpufreq_governor {
 /* Pass a target to the cpufreq driver */
 unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
 					unsigned int target_freq);
+bool cpufreq_driver_has_fast_switch(void);
 void cpufreq_driver_adjust_perf(unsigned int cpu,
 				unsigned long min_perf,
 				unsigned long target_perf,
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index e3211455b203..a1c449525ac2 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -364,7 +364,7 @@ static void sugov_update_single_freq(struct update_util_data *hook, u64 time,
 	 * concurrently on two different CPUs for the same target and it is not
 	 * necessary to acquire the lock in the fast switch case.
 	 */
-	if (sg_policy->policy->fast_switch_enabled) {
+	if (sg_policy->policy->fast_switch_enabled && cpufreq_driver_has_fast_switch()) {
 		cpufreq_driver_fast_switch(sg_policy->policy, next_f);
 	} else {
 		raw_spin_lock(&sg_policy->update_lock);
-- 
2.34.1

