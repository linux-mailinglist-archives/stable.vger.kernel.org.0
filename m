Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB4447A81
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 07:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhKHGkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 01:40:05 -0500
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:17025
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236305AbhKHGkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 01:40:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQV5WTfKOPkqXjbzZ/nmBkN3zoFoeFXKPYE/5O6JbO5sG6PoEKuxTtwBjz2fuj9nBHy7zPcNlUkfuvndTAGbxxcfBhopx7QkJbs02a1MKSLcXGTrHVEOoKSHtNpEUmtsPVXWV+/zgCQf8wEXBjt+rczURMskHmCyzx17YTLPwJMez6NOLM0mCD1g1OF7HIoh2UZ1ieBuSyfwDoiqE3Qkmvv+5KLWU59xFEIOk23Gpt99kM3u/F6Gyv4Z5FMJggr3had6k4hdwCgWgPlz4hhJEQpaIpVAnAKWrjVqLvusEY6JgMVvXd+sQmxjsJaOr55EJWUMxt+d9E6ajxbGWo5m0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFBahLrFJmaQyP54uBm9/yHHQNQDzoy32ma+xaiGjcI=;
 b=lMX1jymm654lAwxtYURQzn+6FyMoBLMAumr8z4ddshll9vIvo3GWv7ByleHt6fVuvyLW6/Ns64VUqqbElblf6m4+gXFOeLftEvMZ8FLkzegyWvtuPjylcVEhrCuEqeIZODpo+Lb1uRlcMSaOS1IQXNgaS67dz5pSDKKiLOjP4tLbo7tgZtGgv1/SCBboYEykQz/axQSF9C/JklOie1DHp3mEEzYvzeYAWG7NrSEsMhs1kk21ElJ5sQB4YcU2j0RYFnhnes6uvWN8ugZazzgSO4tyTaaEJuXV8puSfI24yIomYLWNgCxIQIE1Kpcu7VXzUxorPlY64QrlhTpSe1p3+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFBahLrFJmaQyP54uBm9/yHHQNQDzoy32ma+xaiGjcI=;
 b=XufnbJWHLA8IMGvymy5dNz91wCKZMOT2ASV23Vp0ZDR7jRQXVpjEhyUaldZOBXGWlVCLK9GEh5cz6UEdsuhuGAfYtwzW7UIr0nR4Ey5rKR14rB31EPp7cPXnpcGAWiX7iI8o7kNCfpUiEDx7S9Rtb5QYaLCFiCeqi7asX+5eNs4=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=vmware.com;
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MW4PR05MB8795.namprd05.prod.outlook.com (2603:10b6:303:12e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Mon, 8 Nov
 2021 06:37:17 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4690.014; Mon, 8 Nov 2021
 06:37:17 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     linux-mm@kvack.org
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] mm: fix panic in __alloc_pages
Date:   Sun,  7 Nov 2021 22:36:50 -0800
Message-Id: <20211108063650.19435-1-amakhalov@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <86BDA7AC-3E7A-4779-9388-9DF7BA7230AA@vmware.com>
References: <86BDA7AC-3E7A-4779-9388-9DF7BA7230AA@vmware.com>
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:610:57::34) To MWHPR05MB3648.namprd05.prod.outlook.com
 (2603:10b6:301:45::23)
MIME-Version: 1.0
Received: from amakhalov-virtual-machine.eng.vmware.com (128.177.79.46) by CH2PR12CA0024.namprd12.prod.outlook.com (2603:10b6:610:57::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4669.11 via Frontend Transport; Mon, 8 Nov 2021 06:37:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7c4a009-85ae-40c6-4318-08d9a2823550
X-MS-TrafficTypeDiagnostic: MW4PR05MB8795:
X-Microsoft-Antispam-PRVS: <MW4PR05MB879538A55A0789CD16F2223CD5919@MW4PR05MB8795.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vzguimFB0aSmdZ5BzTJfrNXOmSEmNHwx87rVjz0Z6sCd3e6/QktFldkJCoXFev0vPHvlF25aLlG9v08IsMDD7g+95MwCNS53SgfeXVXQsNkvT4zX6pt1fuHXdDxcF3ktYuXXjf4pksddVww8U3lHLwxvS2AL9ty+dmAenHQtlEsAnj8DjNKLZ1EBjjB7ahQB5F9o0GoRbAYfECgoy0PdQk900sTXFhbgwFrVOI+LtRvCAJoVwUHMbIG1r4v4dB7i4WAox5Q4gdk5PZT9FTbg2wQYsFMfLwFCUlaysYkmjiHpmvif+V5cHG2uCAKp+mcs1/XRQ8v2d9epeZBpBIgEQ4p/EzdhiN6CTg14cWLW/tfgEjGb/PZrULAU9Nf6rX8RnYqZb4m3cH6iSme3zw/egTf8psnKge/1KdTiR/G4WEigegkzefRSOgiZceI5ky0+9G+bI7oCxypZSjwWqU/3fkza5nEcA57UDiTC6+0dlo+hH+NSygJtn07Xtx9N5JbstxNRsrGOkPP5wFNO0Dknsw5Stp93yJPqCc5WnLuvXM8iCCpQ2/DXGyVwHo7mDvdbux8JOmKoypnBdGBhVX8Si8KBppk16527uI4hV4i6u4r7erMLRdX/pg5PfHCYuALM/O8eGSZ58JpyTSAhYj+lLz3HkoluXDa/IByGBM/uwVVjKzsTHKElHAHGfxxCLhpPKoMIV7NJVeelBPhyX3MHCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(66556008)(66946007)(66476007)(26005)(6486002)(508600001)(316002)(54906003)(38350700002)(38100700002)(8936002)(8676002)(1076003)(4326008)(86362001)(956004)(6666004)(83380400001)(2906002)(186003)(7696005)(5660300002)(7416002)(36756003)(52116002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/lO5S0JlnYGu9jXeJoEoBj1ItDofbcVkAoHKJXbMiqAoZajzROLeaVDk0For?=
 =?us-ascii?Q?Hb9n953hlO8AsBQfbqaQKWJxTX2jfGMuIwu0PFmc2QA3IlPGsRgiW3Z9vfCV?=
 =?us-ascii?Q?dJZt12NHKYG2Rp/oS4lkHAmqvliUVE1qnrOnlI3zMcHXoLBVvoCyf8oLuXV0?=
 =?us-ascii?Q?zOr+7ECdPF/TNxus8uJSGcEHfzJxYToa3041r+myXdmbosEcI1J9Yblo0sky?=
 =?us-ascii?Q?jRF3+YZI5U9ppmcUpMAAToTrLuLrqoiuvf8Cpv1pOE68oeIucYoPjbuDazPa?=
 =?us-ascii?Q?JihsS/7suWjxFD7eEhezc2BUYkQfq3C5/nrPCYNbuVfmptPRg5oknbXXMJmm?=
 =?us-ascii?Q?l2EZ4qpzFIV/oFr/O4cjZhK1e59h2u4ouero5/iQpB34Gok4ynngVb/cIZOw?=
 =?us-ascii?Q?0cxVUA72RN9W9Xq+tV03buGQkO1WZeapZ+t2mSH9YRwyn8O8Cuz9UDN0EWjJ?=
 =?us-ascii?Q?enbkdhrOQvd3Dn0ohTS5Pg+SbSI+ziqgkYr+pbRu/kInCoP2Q2yIJEWSb/HZ?=
 =?us-ascii?Q?T3IJ1VTh/SkZFPRBcQwlSwueO7D0n6Z+VWo4aI+PUayYlE6rOYzjJuIfRJL2?=
 =?us-ascii?Q?8H/oZ9SmzCdAHWDzpkV2QqILSBfWy1dKssWxVMTOFznMtz7GZGMo4WnvaceM?=
 =?us-ascii?Q?a/AGEArjtZ+IpFRnP+wvlzjUb9H+7wgtGCTuzw21M1z/OjFIPfN/b78dmloC?=
 =?us-ascii?Q?9E3qAPt7zqxXZKcpO8hpGmP5EIpjZpTAPD5RNcEAMMycmHQd+3DL+EfWNDQ7?=
 =?us-ascii?Q?/W7QsfWXrDrUIMrgw8m3FWX0GeTmkCC43K8nrwyKxV4zT2BVWhyIytLmiqaR?=
 =?us-ascii?Q?qjfglpXntL18T97q58ZbgZpP7ha+52nn8Cy/xyqUzlV3EdoYSCXgXSW1BS7N?=
 =?us-ascii?Q?YGnim1e/6ffIOXgVow4blYdgEfVnRSazdsSaiALInMoEcNTwy0bEaF1nIt9e?=
 =?us-ascii?Q?rqTAUwKBWBlwWZRhHr0X3k0ZSCe4yYsEKs62UO2yLGMe9KsGGt0IiDDKJDe5?=
 =?us-ascii?Q?zyZPKKA4PERPHvCAkWLT8/20q96awZ+nkEuWZ+GtUzIAizfv7n5e9DkO4Vqi?=
 =?us-ascii?Q?vBd/WeiH/eIiSB0k6bp4y0DrRsY+cogvphUmo+gr9zIPsXZyLSHh7xnBP+TX?=
 =?us-ascii?Q?pxvAmaiAiMc/PEe/c6P9isQTZGnyrnDIR15MaKECUJ3KwHQ0mtNTJY6y9kAt?=
 =?us-ascii?Q?y3g6ZAjkKpZCppRoykZTEjHApfhbpY3lbIMCBn/nytEuZ6dL8GFEtfrxWmhZ?=
 =?us-ascii?Q?2PXhb+XhEhDCHVfvB+tSTZCITiNOHt7ZYv71FuIIw6jzUZYnz/4pXzzrDjtp?=
 =?us-ascii?Q?vLZ2ILRRG6kgx3bFjRgLceEEeTpGVKaQm4SEY4gSt3HC7Fe8tHh+VJeTZWuD?=
 =?us-ascii?Q?ZcsslTEKJAI+YVWRvkWWnobR9brK+9NWn3Zw5hj5+Qac1L2sGKM/bdSMb+7v?=
 =?us-ascii?Q?E0VyVubPnZR7dPoQizFjgRMB6PQoGHtQOdNKGRKBUT7G0Vlj958Jg98XQoVL?=
 =?us-ascii?Q?q3Kq0dV8lm/1H/Udwkt4uOqMByI3D1oBOp0mRsJanye7ib6V8J1e3wVYAO8n?=
 =?us-ascii?Q?GV4XzhWa+UqIhC3iyqyY4RdHanxQ6UUOGYGzL0Zs0zmVTJobCaFHznAOdOjr?=
 =?us-ascii?Q?w1+HO9YR4GzPCuKa1k1X16A=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c4a009-85ae-40c6-4318-08d9a2823550
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 06:37:17.5435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwJpW51ILUzu1s01xJfpZZ6vwV7/6qfftSudQV7+Z/UwvuJ++MrinS50IXT/Md++UboKi0j3H7RsF2mn1dBNTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR05MB8795
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a kernel panic caused by pcpu_alloc_pages() passing
offlined and uninitialized node to alloc_pages_node() leading
to panic by NULL dereferencing uninitialized NODE_DATA(nid).

 CPU2 has been hot-added
 BUG: unable to handle page fault for address: 0000000000001608
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
 Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW

 RIP: 0010:__alloc_pages+0x127/0x290
 Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
 RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
 RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
 RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
 R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
 R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
 FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
 Call Trace:
  pcpu_alloc_pages.constprop.0+0xe4/0x1c0
  pcpu_populate_chunk+0x33/0xb0
  pcpu_alloc+0x4d3/0x6f0
  __alloc_percpu_gfp+0xd/0x10
  alloc_mem_cgroup_per_node_info+0x54/0xb0
  mem_cgroup_alloc+0xed/0x2f0
  mem_cgroup_css_alloc+0x33/0x2f0
  css_create+0x3a/0x1f0
  cgroup_apply_control_enable+0x12b/0x150
  cgroup_mkdir+0xdd/0x110
  kernfs_iop_mkdir+0x4f/0x80
  vfs_mkdir+0x178/0x230
  do_mkdirat+0xfd/0x120
  __x64_sys_mkdir+0x47/0x70
  ? syscall_exit_to_user_mode+0x21/0x50
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Panic can be easily reproduced by disabling udev rule for
automatic onlining hot added CPU followed by CPU with
memoryless node (NUMA node with CPU only) hot add.

Hot adding CPU and memoryless node does not bring the node
to online state. Memoryless node will be onlined only during
the onlining its CPU.

Node can be in one of the following states:
1. not present.(nid == NUMA_NO_NODE)
2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
				NODE_DATA(nid) == NULL)
3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
				NODE_DATA(nid) != NULL)

Percpu code is doing allocations for all possible CPUs. The
issue happens when it serves hot added but not yet onlined
CPU when its node is in 2nd state. This node is not ready
to use, fallback to node_mem_id().

Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 mm/percpu-vm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 2054c9213..f58d73c92 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			    gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
-	int i;
+	int i, nid;
 
 	gfp |= __GFP_HIGHMEM;
 
 	for_each_possible_cpu(cpu) {
+		nid = cpu_to_node(cpu);
+		if (nid == NUMA_NO_NODE || !node_online(nid))
+			nid = numa_mem_id();
+
 		for (i = page_start; i < page_end; i++) {
 			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
-			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			*pagep = alloc_pages_node(nid, gfp, 0);
 			if (!*pagep)
 				goto err;
 		}
-- 
2.30.0

