Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4504A4F2119
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiDEC0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 22:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiDEC0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 22:26:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2113.outbound.protection.outlook.com [40.107.94.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE49218115B;
        Mon,  4 Apr 2022 18:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5ce0ZmtwjqeiK0dTFOlX60Jg2MOtJER2RQGvcSW8ekYBV7P+ZVhqG9YHLGKDNug+ZRpiHueXle0NQvhhKRs9fVumbGYs6wdT6R44vJ6VU1Zb1lZc6Gs0Y8xtmmqceAVO+mnfG13tb6CgEdbLJbs0JKhzPYXn1oH/NK7xeUsAbT7FQogNTwaJe6oY377o3aMWZL9m6t2Ihccn55B7/vl6j3jEZE1h8lukZxx2HDJ5sijWn4BOLN29Hn7OnQwG6lxFmVOLSUutqmH7CjUYvFV+HGj1bbLguEloQVa07RY8v5UCE3RDb1ljz+3q1k8Hm2cmrgvX5sEsnFHZMr//Hm8Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qah2VP26lCPgl7TStyEOv0eJ1Wooz3QrsG8GA1UEhWk=;
 b=GcUTA2OQI+IVOAQDZ78HRGni/LjsOTJv8yz8iGt27QRj3P4+aE7c5Id5H9u+nacAkTTvOFAL/OMEEA9+qn2tpgtiQOwQjJdRDH+OsiwalBZRqmHeU5n8ln4FZ/tD9EMrlLCmzYURzSjYs+7zamY5YxG1YLFdbI+HXOE+1akdl8K9f6yrgEPYOj6iDxBj8ixkyELj1jxppJwfvhRchZV2hyllIh3wUFOnj5Ao54aXKV2ohC3LAP6RaZtKEb5TosyWlKWz6OzqKt6KGmvJbDGyERd6G12yj5opZwkvdPjbsJ9Wgje2t7xNbAVTx3ZigfMXXgk/2hsnKvkEar5SXcIA5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qah2VP26lCPgl7TStyEOv0eJ1Wooz3QrsG8GA1UEhWk=;
 b=CfkheW32b02gieNOHfbkHTcM9Vn98e4tR0z9SRvzwmrr9BgzTZoIR61+t/k3i8Kq+8P6Vb+VhF1MDrkJfBjImNsatk7d/VjkJxnBrnaoeUkC01JFXD5uDgjv1Dt8KCsHlKaalTy86MjXkwR7w9Fr9Py/Ej+BLmNlIKWFHFax/R4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 DM6PR01MB4924.prod.exchangelabs.com (2603:10b6:5:5e::14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.25; Mon, 4 Apr 2022 23:42:10 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 23:42:09 +0000
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: [PATCH v4] topology: make core_mask include at least cluster_siblings
Date:   Mon,  4 Apr 2022 16:40:37 -0700
Message-Id: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0058.prod.exchangelabs.com
 (2603:10b6:208:25::35) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dd126a3-40c3-48b6-203f-08da1694bc28
X-MS-TrafficTypeDiagnostic: DM6PR01MB4924:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB49242D28631759932364C53AF7E59@DM6PR01MB4924.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1RWxmMY+3t0l7cnd4efZqtkUZhcJF8Py97HiMpvwzO+Vqlt3tKwN18BiWStgJfmAAgnS/1uyTYiLFEgMf3tJOW4Bnr1PO9dP7QP6y62WkHcP8LyeFa4yBTOkvrhiMtZ+RGBw0JZzMKMYLig4bK54/jTSRxfLx0j7fg8Dj8h0970rpjrMLxEHLpkO5jdSy4RpiJcZyKbXSBMyksonwX+8Nbs5IRC2+A70qDDQX+4rWz4wm+8OX+Bny123waJnvSgqCZ+uOR+yFVb1Ca1uJVm8F+5ITraYEwOgDUS84dILPy2etqXYxBLQMnwcuJVW9GuJWF5ug8HZ/zRWvOkKKMxae+k+S/ZLav/BIOVisItCJbzy+qmxrgOGMS6jcP1jXp9PSnUCdMy3qJjDwyTG5ktVwQ2XBPvihE8YCveG48JZOBzE9KyNH7LgWnhOZS24gMVPtcuMzLuimFNPnwaSZvJ1Ddkbu1DShuAbopIofHE2EOFpmHjl+V0gvA1hPydmvTvzsAdHMtWs0Hx2sjGSPoQtJPGM+HLRgs6+DuCYbOkhLt58yH4AoAqJIiQgsrKUUt7YS1juroKe+ohE85ZFFh5x09ER9jcoYQyO46N4FmwRtvAg5/9gBx1tBXnZw2Sc/fgGyUunN18lhuYxvOoJIvDRAS9Jc9brp38lOW3DVXTYFXAJ0HHq6IqKkJsrls9tPG98kZ7zIV7Kpreq+Hl1uRsYgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(316002)(508600001)(52116002)(6512007)(6506007)(6666004)(110136005)(54906003)(4326008)(8676002)(66946007)(66476007)(7416002)(2616005)(2906002)(83380400001)(186003)(26005)(8936002)(86362001)(66556008)(5660300002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u9FYvcF4OVivJMCF6SdXqoGC4B8LzKlrAXrqy53m5pHe4VjjGUORJ96ywqp0?=
 =?us-ascii?Q?92NtH/SezYFjXHhQfmFsobtTOAdaxxxSZ7fjB9Yukc8c0hw/wm4w6ZtZeOlJ?=
 =?us-ascii?Q?KE4p19kUyv0Vb0E8UZqxNGtEkfLFQkQYv89zEhOBHrFIuf4E1gb0JsWsk123?=
 =?us-ascii?Q?FrhU/mu8Nfm562I+0YYku7+quZEkL+yJ88E1sCJWWvH6ME9ca0vX0i8QuQy5?=
 =?us-ascii?Q?Wu2OVw5f7baTuIKFvgrsse7gJW9ph6nt7KOnjyoOKPrdiUn0VZPYu9Ew2GS8?=
 =?us-ascii?Q?tdp5HnOsC+a0TbNlS+KkZL3+nPAu38Y4RiRqtpqdLU2wgRPeIpgqhyUhHu1b?=
 =?us-ascii?Q?G5jO6v/Sb+g6euYRY0kj86ydFaUq8glztiE7ujZx6W0vLT7RUZg9E+kyuptv?=
 =?us-ascii?Q?6qr3kg1mDcek3hjartWLRTKS8i2+4m1auU86i86+6gs8o9TgGhim2VyHGH6A?=
 =?us-ascii?Q?A7/Ph1RAoVDspCJ+xh4If1xCo+VInyvjycV9gzq7jH0kScWKKYBQvFlgEhwq?=
 =?us-ascii?Q?MVDSTOlbjTSO7zdUaD92+At7seSWjxdpv7u12LoZVDxOpRwRmm43as7mGIRd?=
 =?us-ascii?Q?RU0SUMpmZ+/KD5y9PpEv7Jci9zsD7rUUFjBZm6MYvx35av9CYk2RPVN7KFqb?=
 =?us-ascii?Q?u630GSOWAnxDQthEz6BMO7HPbq2Dha1cUN0AmBFgfJAhTH99aMWcxKCKNTZN?=
 =?us-ascii?Q?sWzymci6J5TV0V39BkAALbCk3tR3GTPzo/oPeKvU99UIUWmQiw5fff/f7BLi?=
 =?us-ascii?Q?It2XKpU5FdwqDwXub8IijKsWK4hTkcbL0iYz+hfz0jNZPgvq1GcJZhbi8fYM?=
 =?us-ascii?Q?pNxM6mlEaKpJjLsGEVxQb36zler6tanCk+CTdjGChKONS1GIeNaBSRM8A3Bt?=
 =?us-ascii?Q?Rk9PF2MWXwN75COsMIPqOyyXZuB3Aj2p4twMZhmfzszYOIzAc6t/9ubkH9Xz?=
 =?us-ascii?Q?8MwCbi2De3GejBOQULwp71PxbHIlgbRgFmJ59Ed+qrYc/RdiJqC53RT6yJfz?=
 =?us-ascii?Q?vX8SDLkKxLmyOo5cUEypTkxUCZGfmWfeEprp5xdu10NktV7oZ27NS54c+g+q?=
 =?us-ascii?Q?H++flMKIdEwbPgNb/Lv43bx+CZWPROma9yb5fypJNOK44lWgH85gZS3lVa6E?=
 =?us-ascii?Q?2vp89+j7k43Sjm7qWHfnYrxeHFGi7VMXHQNxvtsc+zzuS3V/nhL/bja0URow?=
 =?us-ascii?Q?itdMwENdxtCaUkRnXVDj16h9A2CAvLqGYMpWtVym8ZEaqfokfoOw+cSgUDat?=
 =?us-ascii?Q?OY3CzNwOBj3Bvs6gzH6FL/WaB1UXIMyBCFfXVhL2ABv4Gzulv5xMC3sQ1fuE?=
 =?us-ascii?Q?k+HI+hZrpUdR4q41Y9UrM8nyrtZzFTWnd1npZKQuEXr3S8EoUIK/o66RKo3a?=
 =?us-ascii?Q?u8eiFusQq98HaMe39WNjLOEym6pmo4782Wjh6F6q/ymc9v+RmbzuFHVsO8Uf?=
 =?us-ascii?Q?lVoIFBLTan820pHuCrHPZ2zWYt5hrdP1xQUd/vd3rIk8qX2iexGXSABHmSk+?=
 =?us-ascii?Q?fnbk05sPwoi2odm+5REq+icAsjwT2E3rCWVXRXCU7uEyZS9b5oTAQKDaizEy?=
 =?us-ascii?Q?eeHP/zPqMth6yZ9BtqatHWu8e4u+fuUv29Bss1BhF50m2McrqCnhU6HTPbXH?=
 =?us-ascii?Q?OQPaeaXYHcCiBt8z//iE2hzLy2psECdFahWM6/f6IjDyePTtDKze4dwog4hX?=
 =?us-ascii?Q?NjceRMp/Oz2k8rVE3kfPmvs14sdSGOhVaWmVdTjtoEXTBOuGnYXt7EDkSOWj?=
 =?us-ascii?Q?Dv9/elOP/cOIdwIshD3LU7ukgdEKoP4VO2DRBOSR19qg1o7F4WqY?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd126a3-40c3-48b6-203f-08da1694bc28
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 23:42:09.7031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHSxCvSOAKReUhC9CghMureSWfof0gidUUF2ZMV4JwLYK3Uj6vKlcMZJE9XTf8gtDOcYGSLNFDLs3pko+z0sCZt/PcVGYVOYIQ3UooY99B9Ja8d0Wufm+vEbiuOsudOI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4924
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: D. Scott Phillips <scott@os.amperecomputing.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: Carl Worth <carl@os.amperecomputing.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
---
v1: Drop MC level if coregroup weight == 1
v2: New sd topo in arch/arm64/kernel/smp.c
v3: No new topo, extend core_mask to cluster_siblings
v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SCHED_CLUSTER).

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
2.31.1

