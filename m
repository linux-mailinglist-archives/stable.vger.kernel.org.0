Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B3449D0A
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhKHU0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:26:18 -0500
Received: from mail-bn8nam08on2045.outbound.protection.outlook.com ([40.107.100.45]:41827
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230243AbhKHU0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 15:26:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQalVGh+CCCilbaOzx5sLhO709Gtp8+D8yhbFHI+QKIFPl4G8ny7aZmlNtWfWfZX9kChbnBzUqknhXZszWGPRd1wQ/g4f0XA4pK5xnRSsK1nN7E0TIkO5eTvCHoYFj5wEmuj0g4nRGtdR0rUPfq8lXyPNWW3j2fWZI1zhoDgDTzFqj5D1bcNjMbj5UQLieXAngaFgV9Gckoz761rZZaDQKKAdebCzhEfX/QmrnGlJgIyUVmO0cXYiCcXqWhFd5zNAWMx8/zLfJoDRtaCbQKRLjA2JiuIk37wBb1jnx3p3YF9fWE7+REExEakaHpREaQnoyAaNye69LmmEaN5RU+peA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3xOqy0d9KGm7m7QXYb6J/mut+VZ0bf5Ro7DNvjSpRA=;
 b=XEGsRzoEdnnJ08oKKvrnFigEOCj7qpDLgk56vymehGmnFXGiTHyJGOPHZ8j+gi+AmoE+C/bY/1snh8HRWEv7AyhqFgsdM6wKbZt3OP19Lw9DuwWK4avCSe+VUSYDyfSV81lAEP60KE59DBaibgiICape7dx+XD5CMNlmazQFZ73SU6NLfcAjmeXxoPOKuazcv6zmnHmpzSe8APzjh4tViWGKQAzzWnHJOs+2O66OZObTn8lD/l9E4pPg0DrcEe0HRnTnznFYHXMliYotls9RjQtcna4ZJMAN5Y+iR63PTQ1C7AIj+2emj98q8p3zzXaomKZrBAjTTCS02oGrBm0diw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3xOqy0d9KGm7m7QXYb6J/mut+VZ0bf5Ro7DNvjSpRA=;
 b=RAChvZYEFoa95boPwM30cB0OH+Jsh8DQGnC9XyIRT93ZW6ztjt/9m0uWUXvv47emK8NWLzT7xGAmAt7DbhGv/cT8Mh2lEY5gxjpYJxJzAzIBv/RIjDUQneqgWZ/gsgq3MYtfj59KXhwiM9oRW3X7cl+4G+opVFacfY99S/QMpVg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by CO1PR05MB8441.namprd05.prod.outlook.com (2603:10b6:303:e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5; Mon, 8 Nov
 2021 20:23:29 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4690.015; Mon, 8 Nov 2021
 20:23:29 +0000
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
Subject: [PATCH v3] mm: fix panic in __alloc_pages
Date:   Mon,  8 Nov 2021 12:23:24 -0800
Message-Id: <20211108202325.20304-1-amakhalov@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::27) To MWHPR05MB3648.namprd05.prod.outlook.com
 (2603:10b6:301:45::23)
MIME-Version: 1.0
Received: from amakhalov-virtual-machine.eng.vmware.com (128.177.79.46) by BY3PR05CA0052.namprd05.prod.outlook.com (2603:10b6:a03:39b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.4 via Frontend Transport; Mon, 8 Nov 2021 20:23:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b78c6fc6-f846-4620-b486-08d9a2f5a0ba
X-MS-TrafficTypeDiagnostic: CO1PR05MB8441:
X-Microsoft-Antispam-PRVS: <CO1PR05MB8441C029BE8A31E4AD998F2ED5919@CO1PR05MB8441.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lasIk+KmixonK3CtVEAX0c4iJi+NMhMY4u9OeijtYmyf0aMqrtrX6imOfiLwcYjLlxGVF/CDybuB2HzqJxp/AisObJFNRz2VwBDFm9akD85FcJF27cR+Ck6MdFgq9xtIyt2k+m0j+y7QxWCwykIqZwFwr7Nttqi2Cf6EzZpKJX3Cls8XA6/AzAlj5i4IZdlXlyw7VqjF+mzAljJVTw65W1U/lB9aIOZY8U8Cz3SFRh6rFwFUW3gp9XgK4ugDCGN3E4NTpDt8uTp9xHj121oUR9ePhRTPPn7bkb42VlN0SQa8+qOjFjlBVEhu8V05n/B5lNf/nr5/A78ePIVidRvCoOGV91qhvClKHZUNCRJkyaS5q26qdQ9jNxiOadWzATt2o1nry5hAmvTT29waE3dtqKhFPCCea+nbUvHt0nB6eUORbKDuVx4BJOUwQsAUlBFPs3LFuAuc1W4Hc2Qd8ku0WClVqfUL1xzaDRIt0OP6eumDu7wMHMKJNKK9yiK5NPU1fHQTR41/UMOD7XC+0PXoLwqJYm91DX/Gk0l03JVD6Lp5vYzEbpLBG9qZKUx6hkISs7+k1TYXDYMa3Dy2BidES4PpuZ4lXeiIEVxR5HldfPLuZS3B/FRHj42EAECe+H0zDKC5Cx7qNnJkykQHeBZWLmgcE7obLdER16wtCHVO0HfQXBcpZJUH0mnHInubBG3NKT9RL+O138L+BwZwCXexg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(54906003)(316002)(2906002)(7696005)(5660300002)(6916009)(508600001)(8676002)(86362001)(6666004)(6486002)(186003)(2616005)(7416002)(83380400001)(52116002)(66476007)(1076003)(38350700002)(66556008)(956004)(8936002)(36756003)(4326008)(66946007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x2LAHQ0OqUT0Ndb292zO/AyLiujwaSEhKPmcN4+AFtwY9/dk/Rjj4TGb32ol?=
 =?us-ascii?Q?2wZ0UnpgABMpA/Sdwc6sDLieq1Z4MKvkl/nR8dtS3bx6919FSYFjXoB6guaU?=
 =?us-ascii?Q?UoO8nyttS0wwoBfcAXFvYdwhVx0KBlmxkDg2j37dXvYBaU0BkQfD6UprQ7pS?=
 =?us-ascii?Q?/u3w5ahH0nagnZVOUigjgLJNpFCf/UjMlQUXOA+QqtjfYOS5AzQ9LmVj3kF4?=
 =?us-ascii?Q?/nrmCuIjN/qxRDHk4wPh5FbLbJ+to/k7U2W0CbnM+PdqONoaOpq6Ztq/rdyr?=
 =?us-ascii?Q?cn+xhlfI8msTnRbuotBZsE7D0bM35HUik1rxbusiNGJF3dyR2wW7+CnhDZE3?=
 =?us-ascii?Q?PezlVyYQypIhUoPRXmHlBVdaKjlOSnhRZE8Kc5B9Ge6whbypwsnYfOneZwZB?=
 =?us-ascii?Q?9jlBjfSuhwieXEejd4D3Q78T8CF9wRNuXzWuGODS4xMuMnyVdtZCMcebCHkL?=
 =?us-ascii?Q?ZInsrFnYcNs1xV7AV42vV6fJvOTpDy4RQ9NbkXAn1T18Kj+Tf4dHDhutqvZO?=
 =?us-ascii?Q?Yt0PNIOkbATpJFncJ5/CXUWbUjYXoeZQzwQaUx2o00EgmLe6vPelCWmppoXf?=
 =?us-ascii?Q?kLyiYa1dGZDLb+SbWzlmT0eeFDTn05NfRiCg82qzpLNunGAYfU0iJZVVjOdH?=
 =?us-ascii?Q?Q1AZho2nzRPvODqdyZ5JlHvUI4TyN5WZaOV+5iWjSGaemBu0xW6WDhiBD7WJ?=
 =?us-ascii?Q?dnloZfL05/8zCb3RQWXitYSFjLc2J+oG/f79L9poSrLZ3MObLYUjaLYhn6Pc?=
 =?us-ascii?Q?E3Mo4up/lOhRFPA8C4TzKN/73HWI0c+8J/xs6xfhmq28OPrCk/eYmOZe4EZe?=
 =?us-ascii?Q?cqqYDecrhAQhtkUd05Js5Pu85DQ8IQgl55x0QmHmnlwDrwO+YqORH5NToTQD?=
 =?us-ascii?Q?8H/E43iWoF+f0hkT+uD+V4mpovb8FZvHe+d4FXLU7eMgRbyeJ/uYh7S54LJw?=
 =?us-ascii?Q?Coknsdbr23rh7n9RPzYMmeCaPZL1aK1vWhSjsfiWasym0Q+z201YhgYo3kYA?=
 =?us-ascii?Q?LWfxSRlCRWJ5jnJKnydjJJqinC2NBTa0zPKdPsGzrUkcUYEyUTvz6+0Iex8U?=
 =?us-ascii?Q?cJM1dswt2EaQeYZ4QF2d7pjLvis+7AZ83PY5GjJANHSUu3bPXGFVpVRlgs+W?=
 =?us-ascii?Q?FpKAmGO8iTgC411RK2W4XadSTdCcPJb8wMFkv+/mpwAmjhk7wkZs04Fdrr/8?=
 =?us-ascii?Q?U0RvTfcU0XJzD0sQaPJeYasuOBS8gAbwx+p2KcH5Kb0BU0LplRJJCAja5gCg?=
 =?us-ascii?Q?F9uG2xvi0hYZgmcyXx9CPRe7yap6Tbe9eU9Go7+3kKiNO6mDu4bdfQM5C9Q2?=
 =?us-ascii?Q?n4k4YY146wsL5Q41kRtJuIUSy1r/QzuYaxDDdmosli/Fc6/zAsRpNVL8iCJJ?=
 =?us-ascii?Q?AjTOP/n5tu6XXvVvK1RbIhsMI1GEEHVuiaEN6fiYyklAKNJML7cLjogm3QUE?=
 =?us-ascii?Q?GEcUSiyP3GnO+DCFTEUc4bhpHnzzghMFVfDAI115baWlaEuq36lO9TGPZHD2?=
 =?us-ascii?Q?ddHL/HgB7VEF2weAG1evL76EETBMmnId2Y5SWwFtpHGUdW8w9OZuKrIFdc7X?=
 =?us-ascii?Q?A7nlSzUKAWm5SpBRKLf0HNY4uFVDWGoKdk+kEzGE6q4ROL8xkAt5grAaa2J+?=
 =?us-ascii?Q?5n4iGFWk6sajEIE84jlfe3E=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b78c6fc6-f846-4620-b486-08d9a2f5a0ba
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 20:23:29.8152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcekJ3k4lHkbiTlIhO2FOCxrRwUx3bhgCzRZh6VAvseijZQwILSSv419OXjBqYmXUyt9PX6KBrJ+iZe2Sa5YNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR05MB8441
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
to use, fallback to numa_mem_id().

Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

