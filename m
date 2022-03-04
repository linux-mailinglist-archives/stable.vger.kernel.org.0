Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C144CD99C
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 18:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiCDRC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 12:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiCDRC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 12:02:58 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2091.outbound.protection.outlook.com [40.107.220.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EFD1C60F8;
        Fri,  4 Mar 2022 09:02:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YH2Vcw/ESC5Pcwk1nlP0oBFD1Xl4TOdiaW4rk+e2XCvQMgz0q/l+ps7eMXV64RUUMItOsre9nvMISyYspoImaJi1KJOR0hjAye6910XftULQ031hNeapfsqFBPtUoqWZuj7SRqGQSv76Lyqo1gCUcCzfgESVajl6Vkqtj1Ix7TjAhfMa2AFM1BvgBYIve/FudkmIfr8+C87gvrHU62hJJ/3Pbrak/OOk8Vd8QuSk01Ad3clSuMLBzUvl3QMs9k11VPgftxcqHsovdGc9+wmBw7t2xtfPB/exJlzKISi/p3OqYO5/VJwAl6UFergG79GpRaXYk3Fkb4D5k+e4temmTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpBFqktRIFe/9as+w8aLeV5GSBCEloa5ICSwc+v5s1Q=;
 b=i42grKXoQqRiSX2hpIUZg3Rk4/1RxlbAkacAt9JxgxGkqgv2L8MuhwPRknQ1QOElnlc3pODMxyBn0YXF17UYynQ0Ihknl8ihUXrFQ3iNu/82ZUnM7IMi1CXBghHiii1OqFlbs8qS+gQYlmyfZq31qYA1azP4SgaH3aPSm80YeWnrbQOiUGHnaLql6mOHWLLXbzBfkIi3rqwr+8N7jvDIP0iPcQbJPPlsIFCi1IvFuXqu2rYuORpXbnsxlp8nxF12qsnDNWzZaKsKerH+maq4aBkV2wyxhgc+MEs8HC5oj8oDwDDLMLeMSTdpS46tL8fVEUv7wj+poO12aS2D0CK0Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpBFqktRIFe/9as+w8aLeV5GSBCEloa5ICSwc+v5s1Q=;
 b=gIRxoHImVy3McPrlKzogkV6pfLXITX2BVgxgtVqv80af0Gg2JnUyZVdx8W1SE0S1SVb68qSviTXEI7S6UD4W2ChBS47zeFOCiMWPW21OzEM5Gsg/MOm5IOIGQ6NMOMCHeFWmj5bC1m5DEw2x9dEtvDqh49lzL+gJRYShw7WQQOg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SN6PR01MB4319.prod.exchangelabs.com (2603:10b6:805:b0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Fri, 4 Mar 2022 17:02:07 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 17:02:07 +0000
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] topology: make core_mask include at least cluster_siblings
Date:   Fri,  4 Mar 2022 09:01:36 -0800
Message-Id: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:610:60::27) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05718b07-81c6-4cce-6252-08d9fe00b642
X-MS-TrafficTypeDiagnostic: SN6PR01MB4319:EE_
X-Microsoft-Antispam-PRVS: <SN6PR01MB4319C0579B6F64ECA8770FB5F7059@SN6PR01MB4319.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5Czo2vrA/3pqgsKfoqtgzg30i5l9CLetc4x0N5smpLhy9R6xVxncdDYGoBKEZPSI/ALlj8KzJyLj3ULvNDAjag84cvY9wJUcJkIn7gdnXlvJYeIAaqQfJEFitzasfaIA6YE2EGCNsblF/KpremPVEtBVYKqPpj/1cAY269zwkWBJKSPdMd4D8XWwAAFQqJuwRri+CKwVo6cn/bRzihKufgCSW+0SskPEf93whADWVtRiFs3K2sLr+PXwYPKp3Za4C4NrdvO7BTLQkRN5A7jeeFSd8na+qsgBFF3dAPmEIh/TmlDv+4Iu5X9bFUSyO4KsGYZBr2WCvdh8tPBAXBTez98Hev0qM8S5vE/zcJkIP4Flp+D8FykQmLYZK7JdgcVrkj+8Iwy6AobpWeim0HY3B+aqUveAR6VDu6rLKgjwgECI8umi7/I1Mj1wRM0eBcCIhVIOjc78jhk5Am7+xWvoy1pDwvKW7cWb4raSg3pY5is1fq6eSoiJEdqnnAZNchopzG+HOF5mU2xqbgeu1Ir4xz8TAL/OVKmHfhhoV5e352qSfEwh7kI3vp9HkyFSRMFZ2k+g+COnobdLm/sJzY8BHKd3S8bQ3L42IZNRcC+wWczC8AjpfHKCBpwVw0qDQBZrsktzSm82k0NYB4hAJ1bfennDO8ofLKWoBf/42U02t+cp96LQgXWztiW5PrJR/H3z2otXTyCP4pM9a57UQ8MDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(7416002)(508600001)(110136005)(5660300002)(54906003)(83380400001)(6666004)(6506007)(52116002)(186003)(6486002)(316002)(26005)(66476007)(2906002)(8936002)(38350700002)(38100700002)(66946007)(4326008)(66556008)(8676002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ob9ql8Lkb5kqEZKAAOMRndlXB+EKO9IDhzOBQNWyQbj2QIVw6/sNaWXC1dw?=
 =?us-ascii?Q?F9TX/E7I12m+8FIl3yMAfUFtBCKxshJQWvvjaePpkXQN5ef3Vp0HluLD/nDa?=
 =?us-ascii?Q?IIiapytOBAkZ5h2nKemev2IpW2A4zne/9vf1rcOgBJIVSzfG3+0CKeajY74l?=
 =?us-ascii?Q?qbrYB8xNqdMiD1Qyk2GGDAIydkAIJAKI89DduCtT+Cr+ilsbRPbNN0c+VIX+?=
 =?us-ascii?Q?s0/VvtwEAZnuxjO+oEZ1IJ8DF+S8g8DMs76GxKw8BiP7bl5RUqwbbTggaugW?=
 =?us-ascii?Q?D627lE4LMDQPzMtmTc7ImNx3vYyMLJ/sj9d/506UL9KYceiA0zayFAyAcow7?=
 =?us-ascii?Q?MTFVFvYkT4SjwSdeHMkdeBbttlHqDjAbhvfUGcw3hTexQBlwQMMBoNiv6Hk4?=
 =?us-ascii?Q?Y86Q1i81TLhXbZzcfK+lGszex+pt9c+ql0fePLdo1dZBz6TpHgjDqvTyJ3UB?=
 =?us-ascii?Q?jNt7p/tMkc94wHTNFRkwiu7/N/PlDghjBVB/2QtttkpIrHZuiNUtY73T+keX?=
 =?us-ascii?Q?7TNkWyCMCCkAE3DTt6fmO3/CT8FnL+MiDrJGhUCkXUoVCnLk5jGOQ99rmNMk?=
 =?us-ascii?Q?9SfJ13ltnJ1oMjBs2ioOSYSLDeSUujvpNGUUIm5qBvIWwpPlEi+r38eEOt/G?=
 =?us-ascii?Q?0A6yni2n6kPn8gY04iRubqH8nPCMA2/sq0so9e7gL3c6+dZ8HPgz+BTnWrFW?=
 =?us-ascii?Q?v7VUdz/6zAbfVVwOyjJgquDYYCDeEWw0EoWyATZQlHAM0FMiSVM3gehiDns0?=
 =?us-ascii?Q?ikqPYpf+EL4SaEcgqbfIij6KOXVu60KN3wC6kDDqX2v8f99c/US51CAbGlaN?=
 =?us-ascii?Q?Q/LJsyuoCihZm3RxNkjxn9g9NZQ88hhcp4JRmxRmoEECuxNmNrh9bRQjvwir?=
 =?us-ascii?Q?uRL8dNjPhLTaEa+PK29j0mejSql+QL2XE/ypKlc/11NBMQTqxUpsKaZr0VPn?=
 =?us-ascii?Q?MgS9DN5A9OQL7kSn2cSc7XhfC0QslcT+AS3EwZdf0LArySpBZCi9TQhOTLHu?=
 =?us-ascii?Q?COTTVrcs1SEK+WgFwZAWn7EJWQpH1TKmwysF7WTqcai7naM16xW9uiP9Nrh8?=
 =?us-ascii?Q?sZoS+uYWDTxCT2Au8hVu7F8x9bCpPLlhvsfuWqfyqZwvsEd5S05N+oPBKwA2?=
 =?us-ascii?Q?0C1zGKvEO/DFRR7Mwekk/hmHaSInkPbbT2ttsw7qI0WgwplHlGi5fLGZzYBu?=
 =?us-ascii?Q?btu3zloYed5+EyqXcv7Djv1/v8aAjPTKUTbjupfn++jIjUreVOhT06CfVqcP?=
 =?us-ascii?Q?ovmZoqDbDGDfnZ/eOoVVmibgP4ekX0PNS7vcTFKDjlRQdOPaYTh8qZ77eYjJ?=
 =?us-ascii?Q?0rM8Q7JBFcUOUxcY7VfEoXlLg27d8qRMUlLrAN2z2CYPtT26CU5ryPoIKsas?=
 =?us-ascii?Q?BmGBzRTqcEp7t1ReKjs+Cd9eDa7Rbe5Hel377ZVq9jJPgYR+rlD4AX7f5xsm?=
 =?us-ascii?Q?3wXEINotQGyGuFWtsrNp26cr4lgzvEEWotKlTXCKFvHt7MKLz9wcW2j/vSor?=
 =?us-ascii?Q?gJ0lLT9A3Avs3KJW9FqXRWUI8JHA5jOJ8MQnen29MP4ElViMljy4N/rIJVbm?=
 =?us-ascii?Q?mjCdBXrZ5ylYUqTFpTiwd7bhZDsJpjEIANDaJpFr8eMxDfvZmCYLmEEE6xw0?=
 =?us-ascii?Q?THfnv2sdJ5FZDSa404iA3x5SRjxkls7YEXyH/OpZNifs+5gTiCagXO/bPcWv?=
 =?us-ascii?Q?69d5hCcuVZn6evqXCh0yNg4+J8gN3sXaY/iG6CGs2m+w04i/47W0xtovem/U?=
 =?us-ascii?Q?fLr75VIC/w=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05718b07-81c6-4cce-6252-08d9fe00b642
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 17:02:07.0594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGBEWuDYjMkKpRpFlUOZVhQxKAPZ3dIdUBwz8D42Fy6E5RG4i1FWgpBJvAxVDlKl3xK0hD42qy6FJXU7zeXq94CiNdK3WqNN6u7+ElX8dM0s+JbOpOgxUd9TL5Wg1uC4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4319
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

Rather than create a custom sched domains topology structure and
introduce new logic in arch/arm64 to detect these systems, update the
core_mask so coregroup is never a subset of clustergroup, extending it
to cluster_siblings if necessary.

This has the added benefit over a custom topology of working for both
symmetric and asymmetric topologies. It does not address systems where
the cluster topology is above a populated mc topology, but these are not
considered today and can be addressed separately if and when they
appear.

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

Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: D. Scott Phillips <scott@os.amperecomputing.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
---
v1: Drop MC level if coregroup weight == 1
v2: New sd topo in arch/arm64/kernel/smp.c
v3: No new topo, extend core_mask to cluster_siblings

 drivers/base/arch_topology.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 976154140f0b..a96f45db928b 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -628,6 +628,14 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 			core_mask = &cpu_topology[cpu].llc_sibling;
 	}
 
+	/*
+	 * For systems with no shared cpu-side LLC but with clusters defined,
+	 * extend core_mask to cluster_siblings. The sched domain builder will
+	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
+	 */
+	if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
+		core_mask = &cpu_topology[cpu].cluster_sibling;
+
 	return core_mask;
 }
 
-- 
2.31.1

