Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D943D4B1B6D
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 02:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346951AbiBKBnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 20:43:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbiBKBnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 20:43:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE825F8E;
        Thu, 10 Feb 2022 17:43:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFfDBRrTxz5F0y5KZDpA6waEPb1Gus6jEX6WiKbRIftfIgAiyM4y1+9gY2q74ikhB1FraaCY6KzsFguCBXOySL+ZVse3bj51Ws0y/VhtxtSd+IGtb0Bny2z7NJj9+CLZwFPc+ePV5sEay8hLsPlXckiqIQAyJFCs1X8PQERNcwtZUYzL3BttRQzVgqMMrbb1N0163qvrFekVCfzk1+N1oLxTZsBkAVYGyajurE+A+WS44Muz5NYmB4egoVmFFZ/Nu6p3kJzsluGZiwa5kc3QJP5Mlt8rfNIDI2TZtbtUWtzflDdO2Ci7yEuvWx4cLqx3ni12LzgVLeMCusGILNcFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkF0w2sbmEJ+/ZgywEQYcBcmTzLUhcmf4ILE6Zaz3+Y=;
 b=bHd3VKoRb+srmkyqJJuqKAn1f9yGtxXvLgS+Mg9eOcK2+zM1q3Z5ZRZu4kPb5Q4e0/vb2yn+UauhzHQcEENrbhrWaitkcVyLkefvRPZ/22GGBN/XrvnKiFU6c+wRshCIOVe30JG+8Qkl4nBe+kKGHWtczHQjhUciBr/uJD9kAZmJtdoK37//eZXMlXL5j5RW0c/mJ+WC1cXt2aV15vKr0LA8EOXQdTJ0Qwethxp3flJvGGfTmX8MQhnY1iuZZ+ry8zzzEBQKB7znC47U0sRM6qbVELB7SaJ7fTDjznVGe8smkFpi7hKIo6FaW3yQl/qKmFoa7I6HVc+0UJMFbp5Yqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkF0w2sbmEJ+/ZgywEQYcBcmTzLUhcmf4ILE6Zaz3+Y=;
 b=OhOKiaBbwCE47Ccq5lCJO+mV6s6FeOjGu2rINPgpsmN7TR8CZyAFttJfjGmjSbXzGcT7TQISE2NBXWmOhHIBy+Z5xbpIeml1c+oRvaIo2aUMIDO8AjNUxR8khGnClWcw7qcDEiVBf4q4mhTrK2xfu+2i1nwvK8h3jpNMpK4Xi0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SN6PR01MB4640.prod.exchangelabs.com (2603:10b6:805:d3::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.18; Fri, 11 Feb 2022 01:43:38 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 01:43:38 +0000
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
Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
Date:   Thu, 10 Feb 2022 17:42:46 -0800
Message-Id: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0021.namprd15.prod.outlook.com
 (2603:10b6:610:51::31) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43a592cd-70b6-4ea0-65d7-08d9ecffeccc
X-MS-TrafficTypeDiagnostic: SN6PR01MB4640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR01MB4640585675850C30BD570750F7309@SN6PR01MB4640.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpiMyMgtYffuITPCqA55JWRA2DUVBd8vmZ50F2FhnZsRKB13nMOn6k/42ltwA8xYw0QobrIyr5C4cjk3XOlG+wQnwgPlqnlHUsUq8sftpkGXYpUBe1A5cIArztMz312KnjWDaEk3kMzjaJdQs5JmGB+GRzH3/DTT2oWciQZgu1zjbGOTDEM7SfkWNEmeZ2YYjFnj3uK65Ehdx2qEThzWHx8Z4OZSGLIbgPzithLRMfUyJhb6PkeAovdka79ew9/Muz2OdmFUoRANi42s8ytkNwFdN/tuoh1w4sRGa4h2W3DlzWxKZEUROWjl9NUCLiQBCwTiD11r/qeYTaJfYd241sgzyFqib+rBOHixeUR3DPhAq8J/WotHqkSwnWldzTovGAZ+bAC27zYpUTnSY235igJ5ATiZD6uOkdBYeNPZQ/EJKL2SOP8BzFkYymnW1n34Ge94qj+GXoafCBWZmCuLSDcW7qHgOgGMgxAqQUG8ce/6Sx5mwXGzWSDzVtOs0KQ/l51/rXoyTD5+B9SXp/dl/r1viCFIc8t8eTBTGh7tREdHcz6bwW2idllqM31cgig5cLv3eiJk3AKC8TQM8ygPGRca8SGot0cC5lGl9lkXkJNeyZO3fadbA0lApdqk8HU2IslE+8TtB9WoHe9iXK31b30TVwIpYPngSQkE7HOpKsnf9VDgEOWk9caseE+udDhYfM0apKb1KzqhbmA8x4HcSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(110136005)(4326008)(6666004)(8676002)(6506007)(6512007)(5660300002)(508600001)(38350700002)(6486002)(86362001)(52116002)(316002)(83380400001)(8936002)(54906003)(186003)(2616005)(38100700002)(26005)(66946007)(66556008)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QmAAyHNwK1nXUcU7V8znqC7mzooBLEO8BrOzxmln3/dyVNvHsogxTpj8RiBr?=
 =?us-ascii?Q?DY8aha6kvUgvDEW+xO7O4INYOa5QmQACBCGOiGRC4XRs/E8ruhwgZW4TJs3N?=
 =?us-ascii?Q?BrWywiJU0EHhI0dSrtR9NyubtLnB5ePFjcsslAZKNBuB2P83pp4RM9qWRQ85?=
 =?us-ascii?Q?jiTQ3pM1UO6/CWhGEijkRNnFY7XDvfHxkBeIoJZ4ZePW4UVTK6OE1lsSbHUu?=
 =?us-ascii?Q?DDs+hI/qR/rYMLS0lyvVn1GZhWQaluCSlLk2/GVBXhHxjiH/40TO8pQnezFo?=
 =?us-ascii?Q?BAhXqwSlD9SsEa+bYRgQtTBnAalZa6YEvVrqN7kbqZxyYC8M9h7553Sa7Ba6?=
 =?us-ascii?Q?PzCksbOpTi32Uc7AOz2681N5OkwMy6PqjehLqCUsHRlKCYNBDwgf/6yofR8S?=
 =?us-ascii?Q?qx6jcStTPvVCVcPdH3lGP3jDaeJtDwQaCXWxD3vMkV6APmKzjSbAAdV/uwqJ?=
 =?us-ascii?Q?A6P+ZyzzH4iGinTmwC4KkFzzXE6R3xKAbWDPlOYfZTqM2gxIXtchLvUQfgpU?=
 =?us-ascii?Q?s8t+XNktf+Hgu/0abqYX7BzBXWheoNKgbBlSTsnAsE0uGbokyuDgC9yULQee?=
 =?us-ascii?Q?2XQ1UwxOQnY43328L7b+XgkKzx/wajAVpYGMQR5rDy+fU0F4UtRyyfbSpDdP?=
 =?us-ascii?Q?Hfz6c5ow+RaBR4i3oPT1/KsaRiB5vBnUd92j1Tq0sE5ADZXHC4QusGkLQaFh?=
 =?us-ascii?Q?tz2oYkjB4T0JWeN8SXa+Ka+w0ZAtb4h6E5XgVTYux+CpiHPtkga8ch3BIQIR?=
 =?us-ascii?Q?//1fpXWRXVFUaIa8s8od8oWZSmjLaskJjq+ydjxPSrc7HNIKK4smWZPvrySc?=
 =?us-ascii?Q?q70v9p4YCSHr2jIAjhzMrllLjBae6LxulxQUQE4P2E04fs02LAR/kgw1Mvs8?=
 =?us-ascii?Q?tsmYKbj9ODwTZNJM1N8ChbLwk8fqZiIrCIoXPTmN9W4JHPgclntA+SZzVetP?=
 =?us-ascii?Q?ybIzNY9h/SzX1+Zbtjv4cOKGMJWvxw/GBwIHbS20wymHmxVgGthkyiWxW5LO?=
 =?us-ascii?Q?chQOlz5RSBC9Vx+AabRPi3Z7pThqfg4Sy88CJaNTDQ4vGdjmIFOb4eeceUuU?=
 =?us-ascii?Q?9nv/72ByyLQtEm8XVEfVSQUx00KAh/GidZ8hIz9Vu1DGMtoCwe08sb1tGb9r?=
 =?us-ascii?Q?qjfEkUrWuYzqNIjJmm0DMTZJa6NXbSo3iHa0patrVjP5oDCJ1OM8drl03cWq?=
 =?us-ascii?Q?vizJoFUxJrU6IusvmW/OURyRX8T4AuHFv5hCF9JVNJIfKxnMrmcZ8B6kLJjv?=
 =?us-ascii?Q?8KwbpyIBLl4DZdVfj1H4IHaX45lb1/hkE22d8qy6/eQF9jD6avVyIluzOrqx?=
 =?us-ascii?Q?F65g+JRJfS/xSxgRGe8rbCVI71Ve76OB5EY3UY4fEOP/XAK9UZcZbwTEL3IH?=
 =?us-ascii?Q?m29MGsPHUTqVYzIvzQQ9Y+Ngvxst6xhTgXMj2lLhzINdR1PJmZ1oNrCo8OvL?=
 =?us-ascii?Q?plOi7PwrBw75vGBIWdL1JuqRdL2tuHqbKTNjXKiBf8VWEpfCkGBg0EPJ8t0e?=
 =?us-ascii?Q?Ne15IrX2Ha43rIgrj08kUo05Kt9OdAGlL1Zn1RNIFjdIEPbkk0CUzckXIYUu?=
 =?us-ascii?Q?LmnUo7c7DFKTYIVsCS8QYPaHglfAAHjDi2tahWkQODVSGC3P0rebTQmOxTV/?=
 =?us-ascii?Q?yC7tkFPiL5pPVgvfKOBY0Pnq7wo92Zcw0nm6KUgFJ5DBZbJXGn/SDeQz1z5f?=
 =?us-ascii?Q?iuaSpnL4u5KuRWWGNYsS/2u6/3vg2Ox9w8lCQ8NNnlwmEU1PfIlAXl0G6q5f?=
 =?us-ascii?Q?FKVQCX4uVA=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a592cd-70b6-4ea0-65d7-08d9ecffeccc
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 01:43:38.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjHvNDjHJXU6h/5wU/YvGCmEqesr0/+uMdmALHLWK+D+5+RY/hihkkUvWPCRjBcfuCMVvxiaIcGFwZwzpI1f4STlknhY6dzCk7g+1LnsSWhMbbt+gi8sJW8KUkeXEIXD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4640
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SoCs such as the Ampere Altra define clusters but have no shared
processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
CONFIG_SCHED_MC, build_sched_domain() will BUG() with:

BUG: arch topology borken
     the CLS domain not a subset of the MC domain

for each CPU (160 times for a 2 socket 80 core Altra system). The MC
level cpu mask is then extended to that of the CLS child, and is later
removed entirely as redundant.

This change detects when all cpu_coregroup_mask weights=1 and uses an
alternative sched_domain_topology equivalent to the default if
CONFIG_SCHED_MC were disabled.

The final resulting sched domain topology is unchanged with or without
CONFIG_SCHED_CLUSTER, and the BUG is avoided:

For CPU0:

With CLS:
CLS  [0-1]
DIE  [0-79]
NUMA [0-159]

Without CLS:
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
 arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 27df5c1e6baa..0a78ac5c8830 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
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
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	const struct cpu_operations *ops;
+	bool use_no_mc_topology = true;
 	int err;
 	unsigned int cpu;
 	unsigned int this_cpu;
@@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 
 		set_cpu_present(cpu, true);
 		numa_store_cpu_info(cpu);
+
+		/*
+		 * Only use no_mc topology if all cpu_coregroup_mask weights=1
+		 */
+		if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
+			use_no_mc_topology = false;
+	}
+
+	/*
+	 * SoCs with no shared processor-side cache will have cpu_coregroup_mask
+	 * weights=1. If they also define clusters with cpu_clustergroup_mask
+	 * weights > 1, build_sched_domain() will trigger a BUG as the CLS
+	 * cpu_mask will not be a subset of MC. It will extend the MC cpu_mask
+	 * to match CLS, and later discard the MC level. Avoid the bug by using
+	 * a topology without the MC if the cpu_coregroup_mask weights=1.
+	 */
+	if (use_no_mc_topology) {
+		pr_info("cpu_coregroup_mask weights=1, skipping MC topology level");
+		set_sched_topology(arm64_no_mc_topology);
 	}
 }
 
-- 
2.31.1

