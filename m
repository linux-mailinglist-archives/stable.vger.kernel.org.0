Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6854C7F59
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 01:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiCAAgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 19:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiCAAgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 19:36:22 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C15660CE5;
        Mon, 28 Feb 2022 16:35:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XioZOmKz01YX2QKPkvn//p+5MptwiYycd1P4C+tfi/olrrpLiuO7F6yCoJ9/UrGOiMIQQ6Q9rDafBfxrB+e1PlBkgoGtIerU8pklh3ceZbdLAosIJCnf2cUzH31M9k+Rb0ZVryGCGS/M5XKrRYgfRIjyK470qP4wjeRW93IFP8C1TCVenpcyTEf0n0m83md1PI4PSsK+JFFHtZdZd+03AEGY1/snl7lpWrkv1iXvFkUHSDNM/vmaSTtkIb7V+WbwbPcPGoiQwiNydw51+KbRCh7Mnzsd6SkRbNAzSzHKLKWp+2/s7fagJnPTV9saLt/6rGt5ElhrH2KPcMsjmqOUhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8EIylm2qdnYHk2YylpL+1jmqE6/GDlYz1S7OUI30k7s=;
 b=E394tMLC6pq67BkvokjUctv3HwNJdXhplK04Y3DOOeV+6O2gNH8juuBvJe4N0jCsJuIIWKRWLUlx4Kzea4V/nIQj55zE+jqJVu+Q080os12iolbCYFqf5NMIbsQYT3jYX7aUMDa8MEwJ9eP8G0dDNQMg/pG6xCyVzXIYcSZku34mHvSDcvhdR7HjYS+HdwH8j1qZj/g0cNdyIi5/nM5bFN3gZwYfi9uYvflZk5FWn042aWezy8z+neXyKxW7US1tVHIfRfvobAWJSJx9IjXeHpRmFIix/SIUU4SJadZdhJ90yC8TTX5xZOq3ZEPanZiV3nB13kMKqgswpeKQIuUsWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EIylm2qdnYHk2YylpL+1jmqE6/GDlYz1S7OUI30k7s=;
 b=i6U3PMWhPfkgu59lG803PZyUl17SYTMv3mOaQ/23+e0WsAcsBhVX5o08zavJsIFPvRoFfWyKphwPpBe66IGF71x8RVPQS4M7WBRz+0hnhNHLUt5fcjOpGhy7lGz88htJ7J0+rRSvMXMLu0iMD52or0g82WGFwC9H/TyZw3UuYqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BL0PR01MB5219.prod.exchangelabs.com (2603:10b6:208:33::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Tue, 1 Mar 2022 00:35:40 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 00:35:40 +0000
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] arm64: smp: Skip MC sched domain on SoCs with no LLC
Date:   Mon, 28 Feb 2022 16:29:00 -0800
Message-Id: <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1646094455.git.darren@os.amperecomputing.com>
References: <cover.1646094455.git.darren@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:610:38::43) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6ae8d2e-a3e0-440b-8672-08d9fb1b6993
X-MS-TrafficTypeDiagnostic: BL0PR01MB5219:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB52193D777CB302AE354C5338F7029@BL0PR01MB5219.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvahVvEj7PK6U/JUv4KVMnESttjRn6tde03zC+sCRfC1so1PgnlFkGu4uvED6hUf4fRX2vhN04RybQPzkGr2paXFZ1koT/iXwX6gumTzJinkhEf47wjwHros1AinP+FUHZ+MbnYHi7sPQyaSn3QmEAVbmAChDabt682ciGy3ZNpX8ieKVN2SYNqgcyH4ZjHUkyoz9zrM7oj7VaZ9v8L238r76vunPqKl5MveAJfMHdtMEejZc8e9i9ZLdW71Kbr7G448oNRfatmI2jm+V502ckRY1sX98ROWsHPZAfhuK40xxCTsCeGLkajlEO17+Z7i57NXrBvkvA9LSqorAYsXKxxARhxwSSiopWalXyL7nmpHBSGaFW+9SYESMhaiXBrs5xqwlYNO5rwkLVDku5RE9jrjfLZ+MVUNxljB8vg6tsUEP3mGXfi8rMFx4Dj/yPp44Anj+ttdHnCtif5GfVELMa4MnaQ7ofAIv50/pYiUddg/tG6+YYrtP9N/f+CGQ2tXaR3fI+XxG0eqiQQhEE2lzEV0/uMcOHEMT8zblu2aDoh8h2+37LRJJqBB71Ls6WhS38jTS3npF/3fwLwqSbqEROlyCuT9tsJKXdNWyK9+1OJh1JFUukUY3CjpY6B23k0LNh1wXgMSl9nEle6lIFj+yKdidK1O3WGKse9+bHIVCkf9BXSxJK8K8zXHK2g04u+VBeDY0fIJ8R/keQyLSQ8X5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(26005)(186003)(6512007)(5660300002)(8936002)(2616005)(38350700002)(38100700002)(83380400001)(52116002)(508600001)(6486002)(6666004)(6506007)(110136005)(316002)(54906003)(4326008)(8676002)(86362001)(66476007)(66556008)(66946007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xiE9QeEe7HWvZz4Dl3v7xNWaDYGidvQihVCFAtPmiJwXJk3W4L+KN3Nmv4bk?=
 =?us-ascii?Q?n3ccl8ZzyXDHw7bz8NG1PWLAfcQItCHeGh2EfHAXJnfuvdUSkLvwherxHdWM?=
 =?us-ascii?Q?257+L9tdaxkH1kBHN9DJzK3CymptSuasmoGpzji9Vlcx3VCM50Vdfyo6I46T?=
 =?us-ascii?Q?b9gHhmHb3Bb6YE8AAFDO718jm2S8qrU56zl/dso89tIRATLJLtUkWWB9Yvsj?=
 =?us-ascii?Q?ySPlm/dqBDVYq1YbAO4tUAl2mJ3VMBqMqjjOQain5ckLfu+ix4nMtabmlEoK?=
 =?us-ascii?Q?lhQXW3OiU5qgxjWnQtMXIkoi6+q1lcKAPkYwT/revQ6auFh4FhcJ3cYgySc2?=
 =?us-ascii?Q?vzSIDLUiAytFGE7n9lJ8SqV2vx1oyf9Ja04DbP3KV/QrSBvKsFMWU4G+4pgt?=
 =?us-ascii?Q?qbZZ8EBheP6MGj32YfF1hOosviY3F+8z58OTeyg3moYB3nE9wgxTc13/ZYlh?=
 =?us-ascii?Q?ZxBletaq2VVE3xPouAZYyF1ZDpdWuKsdNNFuhiUJO4i/Wm8h17tdSF2yfR1d?=
 =?us-ascii?Q?/otW6NGT6rK9KIAChRwtBn96fPy94u4BhHgWwh1PUz+MC5knuyk7OhWK2C6p?=
 =?us-ascii?Q?VWjMxuKNIkfuCiCKAfnjlUaxTVRVpAIDOIX1fMA8Hkp7rJRwdPJ1VudL/wDk?=
 =?us-ascii?Q?UXEmAZ7DTH8aIgDmbkg51xfF+4OrvAFqYouaeLqmQb4Ygb60Jqo3QvFm7Q4i?=
 =?us-ascii?Q?A8pG8QQ37nhCW0Dc2SIj7Bwfiku0nmLFD7Gm8rf0E4njTN4XSAHEHYiibvQN?=
 =?us-ascii?Q?61QHNK3PKSCEG9sCzhPE6YezgJgX2BTWz32xPBI5u4MOjtq33C4uJt0p0mol?=
 =?us-ascii?Q?zgK/RTneVya8kWVzqeXEmNPHwFEMVAiIT4Pd2w8pSO9zpET7x1uTOt2ZT1Et?=
 =?us-ascii?Q?ItPLHrmpruG1kJ21cwnqnd3R4gq3mIWts7R/k5sa6RdwozSHUvQpYlTJsuno?=
 =?us-ascii?Q?2obIQ8UqFgIQ945z51etQU5B5b4Ml2XADQscS0ztL0Jtr1IjGi+Aulpf0w21?=
 =?us-ascii?Q?eNJQNsArkY49gblFxmO4FW2zJ01xjAwnD7gWyt8ffxv4og/B3DdjfpPsb2RM?=
 =?us-ascii?Q?7m2yVHOHcKgmjBeBwELfCt5/aWeAcJGCb6zHGr9XkXcxpUB7yyhZ4ZdBgTOT?=
 =?us-ascii?Q?jGWVM2xvFE1IYnLbfY28PdbxnUC38r4MU3SnRjZ3cpLx0n7tbkoMwV3f5iNn?=
 =?us-ascii?Q?CCsl5BdwF8DqODj94eWnScZgX1D5sNhvkvHingXzftSGb+1yk9OfezrO+FG2?=
 =?us-ascii?Q?fBLBYUijHDaNQBiqzkHlk8CnzMdAIs7obREHq5yTlB9uGTltFoJmU9ZFc6Ql?=
 =?us-ascii?Q?k4dtX4syg7ZfteeITIuVVFLdzhaQjUO9eULREtj3XDjiAVFKHfExp1+SMqGY?=
 =?us-ascii?Q?U9CRK9UlOnoR8udIqNJOfZ6Qe8abHu1uAhAhOg3fHENhXjnHSMLZDld1tDa+?=
 =?us-ascii?Q?TYX+el4Aii6rfKJfeXqjhHWe8ddjznpczDhILxnEvrbWHQv3xAwCCYNcAQoB?=
 =?us-ascii?Q?qIpt/rweOcqQaKRV10YOAq9xnKQRGCQnvTGHw5uCZPabfLbvPq3/stWksYZs?=
 =?us-ascii?Q?19JAk2PJtec6jF+ifBeICiVswJzAWCPi6fr+Hf5kWt0ZMMLKhSZqrNVoXDG6?=
 =?us-ascii?Q?eEpSPWVcnQUxnduGynKCguJEoLJYh2lYyXSjSZGlz7Xfn2ffjagTHIoVfsuz?=
 =?us-ascii?Q?sozEPJ5W0WEzPDo1MmXP+iq7tbjCN/g4QwjtCY1rmVt2dKIuP0zA85ZS1swU?=
 =?us-ascii?Q?u7HHAfJtFw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ae8d2e-a3e0-440b-8672-08d9fb1b6993
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 00:35:40.5317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNXSmz1BSwAbiVgb8C4QwE1n/HLA9pJuOlpBJFo0sNu84CGqR9S+UF3kAOEKGSj9YbUh2Q6fhHulfAJDqCdej+YGeEMzzZ2N2rh0BtgGkJKoyQkDZGHkKbKBVMYJ5GHd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB5219
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
Control Unit, but have no shared CPU-side last level cache.

cpu_coregroup_mask() will return a cpumask with weight 1, while
cpu_clustergroup_mask() will return a cpumask with weight 2.

As a result, build_sched_domain() will BUG() once per CPU with:

BUG: arch topology borken
     the CLS domain not a subset of the MC domain

The MC level cpumask is then extended to that of the CLS child, and is
later removed entirely as redundant. This sched domain topology is an
improvement over previous topologies, or those built without
SCHED_CLUSTER, particularly for certain latency sensitive workloads.
With the current scheduler model and heuristics, this is a desirable
default topology for Ampere Altra and Altra Max system.

Introduce an alternate sched domain topology for arm64 without the MC
level and test for llc_sibling weight 1 across all CPUs to enable it.

Do this in arch/arm64/kernel/smp.c (as opposed to
arch/arm64/kernel/topology.c) as all the CPU sibling maps are now
populated and we avoid needing to extend the drivers/acpi/pptt.c API to
detect the cluster level being above the cpu llc level. This is
consistent with other architectures and provides a readily extensible
mechanism for other alternate topologies.

The final sched domain topology for a 2 socket Ampere Altra system is
unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:

For CPU0:

CONFIG_SCHED_CLUSTER=y
CLS  [0-1]
DIE  [0-79]
NUMA [0-159]

CONFIG_SCHED_CLUSTER is not set
DIE  [0-79]
NUMA [0-159]

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: D. Scott Phillips <scott@os.amperecomputing.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
---
 arch/arm64/kernel/smp.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 27df5c1e6baa..3597e75645e1 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -433,6 +433,33 @@ static void __init hyp_mode_check(void)
 	}
 }
 
+static struct sched_domain_topology_level arm64_no_mc_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
+#endif
+
+#ifdef CONFIG_SCHED_CLUSTER
+	{ cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
+#endif
+
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
+static void __init update_sched_domain_topology(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (cpu_topology[cpu].llc_id != -1 &&
+		    cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
+			return;
+	}
+
+	pr_info("No LLC siblings, using No MC sched domains topology\n");
+	set_sched_topology(arm64_no_mc_topology);
+}
+
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 	pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
@@ -440,6 +467,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 	hyp_mode_check();
 	apply_alternatives_all();
 	mark_linear_text_alias_ro();
+	update_sched_domain_topology();
 }
 
 void __init smp_prepare_boot_cpu(void)
-- 
2.31.1

