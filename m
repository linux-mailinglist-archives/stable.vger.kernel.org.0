Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD04FC635
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 22:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiDKU6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 16:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349990AbiDKU5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 16:57:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7C61C135;
        Mon, 11 Apr 2022 13:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xqcim/ykw5bx2ANAOSdOAoNyHzKbLJ0EdawVz3QvzIG844qdDEoxnK6sF2nOK1NjJAUAAhxV2GapCv+Q6LXVk//wfTUU6BB0uOOFXMXfHu1QH2dE00UgSPMao7y/KrC+NgU4MzNfax9rOl2g9J7y1TM1X9U6ccyWyvr2ly0ZBwTBsN9kfXiNWQSaIYkZu7uZscPPlvvTR35G2/ln5KI+qkCgnBftkm67WWccrn1mVYGolXGS1iYoYbzILyivPkLs5sKHQriLiRmUfwULn7cR7UGvz0T76I6sj16Ya3wRIijO6Dq3VF+Uh8gQd2Ek7/+8W3Kw/SS3z+EQg2Ya0tIlzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bc8PV9O9L+/wC33GQaqp79nsc1aLwyBNnRXSs3WmEw0=;
 b=NHpoLqkEMcFJeUJJim1sqb+YaePPwj8Np5tN7/A6zonpCj0IzXVRUP+pqpwUmgbvJt12dm8SzYPvDUIlSge/S+OrEL2ZlSMa1McP0vZTVcSsQdpmu7glc3MTq7JYp2X47GkauwBYPJQrOJUqsCVhPh1OI/rpMUguut2X/OLqmPHxf0R3tITjqQxXtEzaws8BzlYHv/IdWpb2cH2KkwpYJq/9KOzbBOV0sOFJK6SNyLc15Wkb5M2/etdRlM0Ak9AR7TvGICHkBhtRrkgOmB+xSScDcxCZ9lGK3AP7l+i8uC8xDXs265MP0kOP+5jlxuSR4T3RKDyK5in/DhesyujRHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bc8PV9O9L+/wC33GQaqp79nsc1aLwyBNnRXSs3WmEw0=;
 b=Toa+h36efGPJZfrmSDX+aQfNkDBZ3MespwQjopSk2Z4/nqs/Nw2Qi8zeE//drPbDpZGMaX2oi1iM2rvx97fbSw6wIwSl001e2lVLpdo8IYg+zn6C/ol47pK0ebd0qSj9v8ZU6zzmsf+9Neqvyt36x9kvNbGsn8dkSyvjUJcM2ec=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 DM6PR01MB4572.prod.exchangelabs.com (2603:10b6:5:7e::11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.19; Mon, 11 Apr 2022 20:55:01 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 20:55:00 +0000
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Barry Song <song.bao.hua@hisilicon.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: [PATCH v5] topology: make core_mask include at least cluster_siblings
Date:   Mon, 11 Apr 2022 13:53:34 -0700
Message-Id: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0027.namprd05.prod.outlook.com (2603:10b6:610::40)
 To SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 646868d8-519d-448c-9bcf-08da1bfd8aa2
X-MS-TrafficTypeDiagnostic: DM6PR01MB4572:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB4572DF64731E60B444448C0DF7EA9@DM6PR01MB4572.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UayfwGS4eGV8Jayek6Fxho2ej3zpto+pklEBy8KG5j3PO2w7f+oajGLow5X+N4HWbs4Rg+TYFVVBQXY9GoBugnVDtx1UJsWjSLobYrX0ZIHnAqDSJ9nQDz4Z5hr1wv61RZOi5jyqLfwBaNtooAuZYzfCAraaimQhqFAyf79tYdubr0ZW12ePZJ8CjIcLok7BaRwbf9U51qEzQaQiscNze/G5YYF5gNnvO8jv/Ji0zJwc8RDTyTIylpj6H8gHsuuWQhxJ9+Nzyf6+5DMcNCWLwXNZ/yJOwtzBz7CppcxSR9JQHIgsJaJ2van+rhRJXsfA3LMU5i39hB07Fs96U/AhJalQvKUF4Ay9Ma2PFhaHEUpsr/bWNh5n/nVMe5j+Y/1cnSSMscCunNqJw9zPGHI6qAYD1DM+FxOoLWR2SMxdKsHrNK/v8ZBMb3tCL613E0RWC5h2W7c7WqpvoN38wTcmi9iS4TlDav+966ZbZHRr6vQkpxgMRvM5I8WDztsB+SSCt5/h5Xk+o6pt8kwN8GNRVmvqk/OpojwM9X6K0w7nt5r7vMQUN/P4N2hPy+wQ4jowk8geBDpRaldF8zsHlYrAtooLNA6k0okbCFNtSFTU5hmcwaMKkliLhUsZ9AX5XPfQydqtPrDt4iPIOjJP+tVUFfuVs66t/qkvBvIyhdy2CAS7jdoIVk/F/i6tFKonbx6yuEuTiHpNvxmjt9AkvBkZZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6666004)(54906003)(110136005)(7416002)(26005)(186003)(6506007)(2616005)(6512007)(6486002)(52116002)(2906002)(83380400001)(508600001)(5660300002)(8936002)(4326008)(86362001)(8676002)(38100700002)(38350700002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CLOWP5RelJOYGkALVgoZeoy9DA/A+WYeP6DMGFHD5BWr8w4Rxo4l1XQStyRk?=
 =?us-ascii?Q?HUiWdmmw5dgdxbXSZxHo6ZK+TfqWoH7heNcB/XS5XIw+vVl8T95IuwYgYsUg?=
 =?us-ascii?Q?gAquXyXPEQIzwOacCeQwDKg/aA5P165htj6o8b9wDo3CwycqljrfJAgr1VjD?=
 =?us-ascii?Q?nkWPpwYtWsT2Mv3byevM1qhxa40MummhH8pnbtAmuzeA62xo+IyAxjzRhUHf?=
 =?us-ascii?Q?xM19EeibG3lhkrXabGfw1iWUt0UfWQqrBsyiEFpaSSR7izCZr3/GE1oFbQPb?=
 =?us-ascii?Q?OxWTn4H5vMMv7PwFLM8r8B8+dwGbEf/le25azOnFQr8E/k/XX2h+83UoOp9s?=
 =?us-ascii?Q?D8m+Y9BR9+a/xQXlDDtt5X6T4c+jFHNewq7S+UtHs3EIdLqxmgiQasdD67VF?=
 =?us-ascii?Q?FbbqVHtNBYLWH/MSOSs513uFv/obDWdUs11kOIuQUWP8+LhEccUhi08fNB9b?=
 =?us-ascii?Q?/wmar/EB8LLATdujbEF+zEzHo1fxmoHVtOGNScaWzDM+H9HLpjgZ9CbdF7N3?=
 =?us-ascii?Q?J3D/DQXyLSawzUUYU3su1MsUARgZ8ZDmjkOexw/XiCHRqX3RY0hGfMcpNoNZ?=
 =?us-ascii?Q?lQAHUiTgbCRKSKqPQI3Bs7+pexqzS55uz9VveTNlkFSGLaw8qitdnWskfmwJ?=
 =?us-ascii?Q?7LA/WGp83iK9YTspSJBz/sw45HjNV4Cojo5kLbvC8h+A6fdptEBFDn5hXtUf?=
 =?us-ascii?Q?bSMnUFeLlMBYeubUzYcbQHXDWIi16rY1i6Cb8eHKJwWMEh7MGweGt/CTXMKW?=
 =?us-ascii?Q?vTjUEZFtyRsickj9ZGOLqMvwzwPpMGMY+zJ8DzLbE/gaNLxQ24HpXLsM8l5W?=
 =?us-ascii?Q?S1qmknGnxirZHNTltmM19GXto9jZ5HcpsdWKmg5B+rhqNK1/dXi92oLq+OWb?=
 =?us-ascii?Q?vcCGvcx6EDnD/J8ZCoelyYupy9++R54SHFkjaAjPW0WhNmOGjOQ1AEO88UeV?=
 =?us-ascii?Q?oeHb8Nn0Nfmb/tEAlCpOCzADyehCDleorS6pXcYp/IUpcTbK9bz7WdyBnp1w?=
 =?us-ascii?Q?qsF88scZOv4GVvez1wXhBItxM44XGBJczIgJKkJKnCNJIkPEStAmFsLhDGqY?=
 =?us-ascii?Q?ypPpVdw4qoeG3bjoQrlkeoeaaYZaZCwA8abtos7ujOs3BH5jL7jNY/vdoJLc?=
 =?us-ascii?Q?V52pHVgCcllUBzlUsO7ENPUYULrb5NZMZEYRvamEm9LSZ3k5xn8NBypCOhoP?=
 =?us-ascii?Q?7ONZCU7prsWzfJnk9zsunKmEvp4OwuH5+GFiKJy8INhG6QuOBBG9tnlJTk8o?=
 =?us-ascii?Q?CKuXX+5mQb/TwHuQFCCAB47h89O1n3Ju8enRu/3TwWi5amzRY1ckadK18KIS?=
 =?us-ascii?Q?YVpG96altVw/OacB/kVBZj6nubtYDlQbeJOfEl6hdJOBD0GAVO7YCXvrkxDW?=
 =?us-ascii?Q?1+ZulYQN7WilcFl+7NfW397yyXDWjXPrfgLqC0xHI+woEJeBPK/+MqpZR5tv?=
 =?us-ascii?Q?vK5XxFqcu73AgcoiCNR61ej6d33aFb0NdSIAMduqjB6YaCgUot4cbjV9fuyF?=
 =?us-ascii?Q?ekyGxZ/HJ0jORbbgxQsK6H1kdpQ4amyViwGyAYJZhvLkKgIVo5RoJw28Zxdr?=
 =?us-ascii?Q?aZ3Oa3dKNf3GoHJZxZKCnMtzPndHOmhjh9hag9faiLdgs3QwW2Yavp8RLeMz?=
 =?us-ascii?Q?toayUf9yvVTQAGDolj2JyXhlzV9h5M5TBxsON6I6kCQrD2YP6kNIHHVddaVi?=
 =?us-ascii?Q?GbV0zMAjJRhkgrVb9NWgJrJTb+QeAAFq5liLCkBGIkotccnW2Wof2SY5ofV4?=
 =?us-ascii?Q?016wvBKuxKdLntiLzkDXxx412Xsae+VshewL47yqL/5p86BDX0x/?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 646868d8-519d-448c-9bcf-08da1bfd8aa2
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 20:55:00.7002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLTWypPNCFNj7KWsqj0tFq7S63aTlGl1p4VdOf70HV8cf02obDbVcj+tVbr9ih/Kk6L/kUu0OCHVI+EBh8s2SvMlsyGykM2dyMO336Kuk0CEt/wncFwlSnMzYF+iore6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4572
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
to cluster_siblings if necessary. Only do this if CONFIG_SCHED_CLUSTER
is enabled to avoid also changing the topology (MC) when
CONFIG_SCHED_CLUSTER is disabled.

This has the added benefit over a custom topology of working for both
symmetric and asymmetric topologies. It does not address systems where
the CLUSTER topology is above a populated MC topology, but these are not
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

Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: D. Scott Phillips <scott@os.amperecomputing.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: <stable@vger.kernel.org> # 5.16.x
---
v1: Drop MC level if coregroup weight == 1
v2: New sd topo in arch/arm64/kernel/smp.c
v3: No new topo, extend core_mask to cluster_siblings
v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SCHED_CLUSTER).
v5: Rebase on 5.18-rc2 for GregKH to pull. Add collected tags. No other changes.

 drivers/base/arch_topology.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 1d6636ebaac5..5497c5ab7318 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 			core_mask = &cpu_topology[cpu].llc_sibling;
 	}
 
+	/*
+	 * For systems with no shared cpu-side LLC but with clusters defined,
+	 * extend core_mask to cluster_siblings. The sched domain builder will
+	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
+	 */
+	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
+	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
+		core_mask = &cpu_topology[cpu].cluster_sibling;
+
 	return core_mask;
 }
 
-- 
2.34.1

