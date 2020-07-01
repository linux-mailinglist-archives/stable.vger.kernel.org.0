Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508E72115A9
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 00:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgGAWNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 18:13:51 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:6248
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbgGAWNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 18:13:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcOHRop9DZiFG21j8Uh+NWJqWDGnsp9YuP08uXskeA6NhaXcRuqhVrw1wHZfG87xj4igjf/1JLKBMyPXbOs/ADLjPDMhFU5t0NuqZNWKl+14a7MVFizwcxTnvrh2hUFqAy5EMKJi+ibaXrFMqgLHIUM0bBxrxwuaIcwPqwKne+zeudr3IQ9ubUAVT/8T3giIepLwhuV/Lqcp0ZRMDD8QxfIU4Wfq8dfvPGgCuQpAUC3kYrtV+/yJZE4dWeD6+QmOd1E7IPqSQJ3ExuVXZ4S5FWVC6xnvSU2WVW068kw9xi7/gYAaRgBZ8qpFHZDiR8tczg6k21P1DyYpaSm0x3aaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZe/3S7Dl7AJ5f/MbRSrO287BzpU/F2z0ZGBChqERo4=;
 b=I0OajqvjdtO7DTF7pqQ68J8tTD94DTXN5okvvx+I86h64YfpTlcSdREp1LZCBjueMWI4oz0mxZpgEkD7NSWI13vfeCEWsnpxAp/AJYSJcjw1JPmRoodnexP8yD7XAqGYxjviXmDp2C4xzoS+CM0KGwmh/rcYqHw2Xc4i507A4LtFyQqEXEMVWogENwdd8toeW7ZlXCcAdZOu1lvDEfIONLNPRQKCqjMY9u96yxbN9HNL1kx0MC8HAN2bBw/qd2AMWUGBal7YOz5tYeS3j9Lvwh7Gd+B/shhZOIuc7SVbeT3SS2+dYWyl7PG4Jq2wMTwgFfnqulxbSlcl2VSw0DOaRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZe/3S7Dl7AJ5f/MbRSrO287BzpU/F2z0ZGBChqERo4=;
 b=0mHdEquiOH5Begb0LIGnBO0KiJacb5lyglqtfF90GrVzgTJDL9b64GsknBsGaXH7wJAzWRmv0OG1vG8MsP9Es1ZcJhZI9hgqAPsAZQV+MKnB79x+Oznwfnn3athRfdINNgrbpFsoXnGVwF4+U3xLaM/HwY/sH9neCiVJRM+/tng=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2556.namprd12.prod.outlook.com (2603:10b6:907:a::11)
 by MWHPR12MB1341.namprd12.prod.outlook.com (2603:10b6:300:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 1 Jul
 2020 22:13:48 +0000
Received: from MW2PR12MB2556.namprd12.prod.outlook.com
 ([fe80::9c8e:f3d8:eb8a:255c]) by MW2PR12MB2556.namprd12.prod.outlook.com
 ([fe80::9c8e:f3d8:eb8a:255c%6]) with mapi id 15.20.3153.022; Wed, 1 Jul 2020
 22:13:48 +0000
Subject: [PATCH] x86/resctrl: Fix memory bandwidth counter width for AMD
From:   Babu Moger <babu.moger@amd.com>
To:     fenghua.yu@intel.com, stable@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, tglx@linutronix.de,
        reinette.chatre@intel.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 01 Jul 2020 17:13:45 -0500
Message-ID: <159364160826.31030.7457664122034606608.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0004.namprd02.prod.outlook.com
 (2603:10b6:803:2b::14) To MW2PR12MB2556.namprd12.prod.outlook.com
 (2603:10b6:907:a::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0201CA0004.namprd02.prod.outlook.com (2603:10b6:803:2b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend Transport; Wed, 1 Jul 2020 22:13:46 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15d1a596-37d2-4c67-f37d-08d81e0c0703
X-MS-TrafficTypeDiagnostic: MWHPR12MB1341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB13412D8F9F7403F32DE86904956C0@MWHPR12MB1341.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5Sr6FBpEpwy/55kA4unG2pXa+BWi5or+SEGjrfudXqJ3bjo6KyMTlvlR5F9sLm4vSiGHwO7NQ4RBbu8cadi3/4oURsiwBEYJ8nEmosewzzFP0jt7Jv1mHc7uql6vO6IcHvLoPpBwuZGcozNZO/uglMzmLHaA21Fh5TaCsDgyr+5asrEjn5Iu9vzAKvjoVFQMoLQGtqHNY0FXXWEG0CBv08nQVlDj4yYPRUAEkVJ4pNp57qNYWZsYuXTl0pyEb6trb0Bk/Od7uIR4MM+CyveP9hKuhtGqmzytXOWecfBjWM+MeS9VbQbqysxE4zQiTjzCFfpssKJnzLCOEpmZrGCb7FW2WWzFVDPa+i6+41cB285MGGmc+EC3hFvQQHlu4npl6gffJgJEdwY2PEntsbqGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2556.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(396003)(39860400002)(376002)(346002)(366004)(136003)(66946007)(16526019)(186003)(66556008)(52116002)(66476007)(103116003)(16576012)(26005)(478600001)(316002)(956004)(9686003)(2906002)(8676002)(8936002)(83380400001)(6486002)(44832011)(966005)(86362001)(5660300002)(4326008)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zc2BO259uCm584i9o1Ei5bpOc7fD0age9yKx1MslprXfp+rAU8Y3vsyU/5qK+Uy7BTiFYUZCmTADRinpdkMTmtAyfcM/1NIUibbfJQONUcCPjU3/2Rou2hUBLkcVYE2KvCXRq8TlstImkP9syIytLbvErQ+sVFyvlXmnJ2oEYr2CJdZrKPpP6Dua0LqEVP2cSXRv3JYSSEdj8i+XHpB+cg5uJercoVejFplf2L7GjF59Qhv8FdbeCzp+oIQYuMeQfEbiTC1lg6n+RRMrjjxZfEe7Xqmoe1nwQkPmCrfDCXmp9fkr02T2+HjHuBKIQ1KWmekBi5YMM9n2kDdHC/T/GhuWn0vkyHlo5ylCIiC23LlMk3OoJWvKvsoOuXCaBtqpLjazIYujGLuyFr/YNWJbxioBgb8hJjnC/R9+JL583kDOH3d8JZa6do4YjydjNClCL+VTnD2OPYPWrJVmqzPwJz/aN4wKgQNQSytAhMj6neE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d1a596-37d2-4c67-f37d-08d81e0c0703
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2556.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 22:13:48.0764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uc7H3b5opqKbr8rAmSRI64D8l4HggAmTLwF1a0dW8GdEf4amrxur9XEx6iTDj0Cz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1341
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2c18bd525c47f882f033b0a813ecd09c93e1ecdf ]

Memory bandwidth is calculated reading the monitoring counter
at two intervals and calculating the delta. It is the software’s
responsibility to read the count often enough to avoid having
the count roll over _twice_ between reads.

The current code hardcodes the bandwidth monitoring counter's width
to 24 bits for AMD. This is due to default base counter width which
is 24. Currently, AMD does not implement the CPUID 0xF.[ECX=1]:EAX
to adjust the counter width. But, the AMD hardware supports much
wider bandwidth counter with the default width of 44 bits.

Kernel reads these monitoring counters every 1 second and adjusts the
counter value for overflow. With 24 bits and scale value of 64 for AMD,
it can only measure up to 1GB/s without overflowing. For the rates
above 1GB/s this will fail to measure the bandwidth.

Fix the issue setting the default width to 44 bits by adjusting the
offset.

AMD future products will implement CPUID 0xF.[ECX=1]:EAX.

 [ bp: Let the line stick out and drop {}-brackets around a single
   statement. ]

Fixes: 4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature")
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/159129975546.62538.5656031125604254041.stgit@naples-babu.amd.com
---

Note:
 This commit is already queued for 5.7 stable kernel.
 Backporting it t 5.6 stable and older kernels now.
 Had to make some changes in data structure to make it work on older kernels

 arch/x86/kernel/cpu/resctrl/core.c     |    2 ++
 arch/x86/kernel/cpu/resctrl/internal.h |    3 +++
 arch/x86/kernel/cpu/resctrl/monitor.c  |    3 ++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 89049b343c7a..5fb0b84cda30 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -260,6 +260,7 @@ static bool __get_mem_config_intel(struct rdt_resource *r)
 	r->num_closid = edx.split.cos_max + 1;
 	r->membw.max_delay = eax.split.max_delay + 1;
 	r->default_ctrl = MAX_MBA_BW;
+	r->membw.mbm_width = MBM_CNTR_WIDTH;
 	if (ecx & MBA_IS_LINEAR) {
 		r->membw.delay_linear = true;
 		r->membw.min_bw = MAX_MBA_BW - r->membw.max_delay;
@@ -289,6 +290,7 @@ static bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 	/* AMD does not use delay */
 	r->membw.delay_linear = false;
 
+	r->membw.mbm_width = MBM_CNTR_WIDTH_AMD;
 	r->membw.min_bw = 0;
 	r->membw.bw_gran = 1;
 	/* Max value is 2048, Data width should be 4 in decimal */
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 181c992f448c..2cfc4f5aceee 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -32,6 +32,7 @@
 #define CQM_LIMBOCHECK_INTERVAL	1000
 
 #define MBM_CNTR_WIDTH			24
+#define MBM_CNTR_WIDTH_AMD		44
 #define MBM_OVERFLOW_INTERVAL		1000
 #define MAX_MBA_BW			100u
 #define MBA_IS_LINEAR			0x4
@@ -368,6 +369,7 @@ struct rdt_cache {
  * @min_bw:		Minimum memory bandwidth percentage user can request
  * @bw_gran:		Granularity at which the memory bandwidth is allocated
  * @delay_linear:	True if memory B/W delay is in linear scale
+ * @mbm_width:		memory B/W monitor counter width
  * @mba_sc:		True if MBA software controller(mba_sc) is enabled
  * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
  */
@@ -376,6 +378,7 @@ struct rdt_membw {
 	u32		min_bw;
 	u32		bw_gran;
 	u32		delay_linear;
+	u32		mbm_width;
 	bool		mba_sc;
 	u32		*mb_map;
 };
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 773124b0e18a..0cf4f87f6012 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -216,8 +216,9 @@ void free_rmid(u32 rmid)
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr)
 {
-	u64 shift = 64 - MBM_CNTR_WIDTH, chunks;
+	u64 shift, chunks;
 
+	shift = 64 - rdt_resources_all[RDT_RESOURCE_MBA].membw.mbm_width;
 	chunks = (cur_msr << shift) - (prev_msr << shift);
 	return chunks >>= shift;
 }

