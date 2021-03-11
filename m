Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6483375A3
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 15:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhCKO1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 09:27:06 -0500
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:47456
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233264AbhCKO0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 09:26:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H17Dpe6lbymaw7NLcpRcikZLg/eQOU7tt4aaZfdFt2I/0fCGqGqujIarTOFHauT17Yy9WTfGuquYgOoMzYxqykzH/ejFH2g0NyIQUHdLnLqfqTVFVy0MfnItuhFi62DN1OnPD3CAzLgT0/CYz6hp/pMhEgjqpylnUxwsXz2izEvqQJhDAUwMtrvWH9LbKchDE1dlXzO/o1IKd4cAemisANPa9Lcu4Q9Mjp7/3dvHhxU3Vwm2DFcU8ATSvrFVbYzFeuNwtY+JIMWJHK2OhE3LnLgkujkscZmowa+5zAmD4Gnkjz7bRlzVbb3qoKOPxcKqGsaT4U3r3onNwzsPjT+RNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmDjuCzIsugNRfIx1Sf3yWR/Hc6g3YUsdLtFcbWUFBg=;
 b=bqsRL0xMF9C2ZO7flIyk73A60zraesrf5s0ZHvx/QzNh+SH1vebBam6Ftpu4250r8WipE1IiMq1Pqo2ZVZERTAgoxVs2bbEVVg1bPPsyD02yNLWzAPDUIwwwdQOff3wC5ygC28Pf9PcnVgYo4V5c7n5gOakQNvp670Ior3BkVrsM/bJ5fb2G2dCSHYqofig4WU3EhMH6kiCNU8DyFtBCNrJl7Np/+VTuN/p76NqXECJQ2sb11cHF13rKBJ58syrmOG0iVOEAThj14oqXHU/b8JMcjUNTxplWCXs4On3QidrW72KbZ9Ekat+nWULAmF5zYuqIYZ00WC1sXrfqLyGKmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmDjuCzIsugNRfIx1Sf3yWR/Hc6g3YUsdLtFcbWUFBg=;
 b=Cc1jrbkTWxarjCYhNmDL7sLuCAViInrdE5nEvp9h3lfhQpo7nyceYcHr7d8zmQJpkOttTVTHNXuzOX3tJb5pTEYhHNZNPZDEPpBlOgnm9iRrCGe9jekM2QXfIX26iII4VfagXc24Z3Y0LJVLl14pXS1upUMwL/7R/strjlPhZbE=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1520.namprd12.prod.outlook.com (2603:10b6:301:f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 14:26:49 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::5094:3a69:806f:8a28]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::5094:3a69:806f:8a28%5]) with mapi id 15.20.3912.028; Thu, 11 Mar 2021
 14:26:48 +0000
From:   Huang Rui <ray.huang@amd.com>
To:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        Huang Rui <ray.huang@amd.com>, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH] iommu/amd: Fix iommu remap panic while amd_iommu is set to disable
Date:   Thu, 11 Mar 2021 22:28:07 +0800
Message-Id: <20210311142807.705080-1-ray.huang@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HKAPR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:203:d0::11) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd.amd.com (58.247.170.245) by HKAPR04CA0001.apcprd04.prod.outlook.com (2603:1096:203:d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 14:26:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff5fc478-81ce-4a4c-af3f-08d8e499b498
X-MS-TrafficTypeDiagnostic: MWHPR12MB1520:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1520A2C83209BA8A59078917EC909@MWHPR12MB1520.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8BKgy7+IbUXj6SCKlLhEf0e8B5GvbfM+PbgIPBXDGV6f7uxHTPavGVlH/cGi54SBrh2IZYpTbh/S7RzLW9cGq6oSjc/U0iPofOLzsRAyIHa0iLnHAw0WyefgIctnFP9c8S4dGX7W9xhRrK5K/beT6v1GqjjH629YQnlsrSWn8q7ck0K/daR5NGJtWAYuSRPuF2qU5oozm+Puu1zllGzzZwrRht7kiqwV8H5Rj3QJRePiIBJ4yFjdLTU4TCbxoxFx3/ReVuRa4LUyyFWFrcj1HdGLFESzt6VdkltTM7aKZzVyT5ohfwkag+f0ptcuwcAv5j437V3pmRD+Vyqg9nQ+ZPe8PlmMBnaTeHNHRtlF3ROZuV8NLJW8Gph0MiSUffdCMitM5T0M6PyH5FrXn/uNnLsPyGi3phlRJu5VU0BmIzEzRlifV3voaabTh1IUNFAwqLQWNJBQUL11nDeyl9TWQN41b4yNuPWn+w3wxSoNoSLQO3HNERqfC9FvMjh5E8Rq0knjIzCxr27Sn9pMeuJhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(6486002)(36756003)(186003)(26005)(4326008)(6666004)(66946007)(66556008)(86362001)(5660300002)(66476007)(52116002)(16526019)(8936002)(7696005)(2616005)(1076003)(478600001)(54906003)(8676002)(956004)(316002)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gaDSLNCwHtiPA6bKfnSha2XPCuaP7vE01tG5Yf8NUSDzspCZrTYWPjEo60WM?=
 =?us-ascii?Q?NM0acvV+ObIP2Jo1dN4JOwmGz5knzmGqLLLrgNTAC6H4DygmgRLX6P6vnTdV?=
 =?us-ascii?Q?IJeGIvUFo3dg3Sb+7fLLmEpruILW0KB9mwi1+MqvbfH3ftyUO+flhN0ox3MP?=
 =?us-ascii?Q?FpbQLr6FqQcMmLcMqs/2qR6HrUp2nnbE5cXtlQRpoN/pGZwvHcC6KOFUg+Yq?=
 =?us-ascii?Q?mGYucxgXRlTS9YgcBeDq7V6TW95Eb7YMaX0WbPuujZ1lJxiQhwCpuvOJVEg+?=
 =?us-ascii?Q?EtAQxJuPgnJ06JgK2wrswzlFxdT9FOQnjLa/XbQXzvBbfcNC9uJn7vqRwY3o?=
 =?us-ascii?Q?SRho5o9B/xciu4DgPiYNU6HV9c7/qSH8sYVR5VLQnJ8pbKSRpZQMuE76OqdB?=
 =?us-ascii?Q?bL6mTsO/VC3IrYSVG6mJwPjw/EOIbfhMGOJg9j47X0fsjZUQm6BUuzogzoPr?=
 =?us-ascii?Q?SiY7nlG+PZtlgSck4s6acWapsQMQB3JWld4We0PEmRMKBLNrjBcRdGfY184X?=
 =?us-ascii?Q?32pv9PQIQlSC8vizsnoBaTlgv5jBMXY1Puyh1ezArW3CRqeKbNZAm2qK8a1p?=
 =?us-ascii?Q?l1bZNRnbUd9mPiwrjRc9dZDRriieFiETUBmyPETyGViJDQ1+bNJ1848VtLz4?=
 =?us-ascii?Q?AxnoRvSUsU9zFLEDlRVMaaLOxxR7XQeQ+xFxd/it/5/6TSD4+HWDIxzt7KOe?=
 =?us-ascii?Q?+wwPjfUwM7A3StahBo3OuABh0GEC27I9qi9J5QawoMkkGrP4AhE7/wZo6Hjo?=
 =?us-ascii?Q?KgIn2DIRb4mN62ePgeMAUeQLI0SotOpCtYlqf5YtmflCBcQ6S6vI5Ge2Y70K?=
 =?us-ascii?Q?sq7N9mKf/ko92fkNRRDYjgjy3Hthuqk0OVGOD3yu0iWS/xQIm4vwSXFEX0iw?=
 =?us-ascii?Q?C8arowXE0Cdpy3/TfwDcBpyNIpYqYRrLoFmoPg64sxZipzj4zYnKcyFoSxcH?=
 =?us-ascii?Q?jj4K0CVpYaDoSmHYO975W7Ilv1CggCRpzHQOS4nZA/qjftixAct5FRVqbLJY?=
 =?us-ascii?Q?9HYZGBAeUI/zVKEf72G4cY5Zo8E0XKWu1wPLUokHpigo0btxcb68lWwifmuv?=
 =?us-ascii?Q?qW4gv+YUNn8oyeZVc2BGbftGKOx9YTfOem0Z5jnTqSFF2Q6ByE1UBNKNqTAu?=
 =?us-ascii?Q?SH498k/4empcCUgR9fMa8RMG6eqqGoz84Iun897xqOlViZJ976ipxth5dICw?=
 =?us-ascii?Q?5w8+FKdMcAbV3yF/YA/4h1gB6rsvX+SJQQSCRk+ufHdsTj51O/3+qTmI7KH3?=
 =?us-ascii?Q?Wm53CiiNCp2RS0XnH2v9ZLRcFXsfzg+ub5m2FHZACJzfGm0vdbQdysReT/mg?=
 =?us-ascii?Q?5mPfOvtUwiNifmgdEkBc9UDe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5fc478-81ce-4a4c-af3f-08d8e499b498
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:26:48.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGnSYP/2ItX7MOd3FLqzwF+W1PWRUfe6BN4bUrdNS5aG5w6sQl2gvwXlObiTkbygk1ADU70NiZEPgTKY7WNIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1520
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While amd_iommu is set to disable in cmd line, it will free the iommu
resources. Then the pages of rlookup table is freed as well. If that, we
have to check rlookup table in irq_remapping_select(), otherwise, it
will trigger a kernel panic below.

[    2.245855] BUG: kernel NULL pointer dereference, address: 0000000000000500
[    2.252861] #PF: supervisor read access in kernel mode
[    2.258053] #PF: error_code(0x0000) - not-present page
[    2.263247] PGD 0 P4D 0
[    2.265844] Oops: 0000 [#1] SMP NOPTI
[    2.269570] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-custom #1
[    2.276150] Hardware name: AMD Chachani-VN/Chachani-VN, BIOS VCH162755N.FD 03/04/2021
[    2.284085] RIP: 0010:irq_remapping_select+0x5c/0xb0
[    2.289107] Code: 4b 0c 48 3d 70 7c c8 8f 75 0d eb 35 48 8b 00 48 3d 70 7c c8 8f 74 2a 0f b6 50 10 39 d1 75 ed 0f b7 40 12 48 8b 15 f4 8a 3b 02 <48> 8b 14 c2 48 85 d2 74 0e b8 01 00 00 00 4c 3b a2 90 04 00 00 74
[    2.307999] RSP: 0000:ffffffff8f403d40 EFLAGS: 00010246
[    2.313285] RAX: 00000000000000a0 RBX: ffffffff8f403d98 RCX: 0000000000000021
[    2.320471] RDX: 0000000000000000 RSI: 000000000000000a RDI: ffff8cbb4006118a
[    2.327658] RBP: ffffffff8f403d50 R08: 0000000000000021 R09: 0000000000000002
[    2.334838] R10: 000000000000000a R11: f000000000000000 R12: ffff8cbb401bfe40
[    2.342022] R13: 0000000000000000 R14: ffff8cbb401be900 R15: 0000000000000000
[    2.349210] FS:  0000000000000000(0000) GS:ffff8cbd73e00000(0000) knlGS:0000000000000000
[    2.357399] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.363198] CR2: 0000000000000500 CR3: 00000002dae0a000 CR4: 00000000000406b0
[    2.370382] Call Trace:
[    2.372897]  irq_find_matching_fwspec+0x48/0xd0
[    2.377489]  mp_irqdomain_create+0x7c/0x180
[    2.381736]  ? __raw_callee_save___native_queued_spin_unlock+0x15/0x23
[    2.388320]  setup_IO_APIC+0x81/0x875
[    2.392048]  ? clear_IO_APIC_pin+0xd6/0x130
[    2.396294]  ? clear_IO_APIC+0x39/0x60
[    2.400103]  apic_intr_mode_init+0x107/0x10a
[    2.404432]  x86_late_time_init+0x24/0x35
[    2.408507]  start_kernel+0x509/0x5c7
[    2.412230]  x86_64_start_reservations+0x24/0x26
[    2.416911]  x86_64_start_kernel+0x75/0x79
[    2.421068]  secondary_startup_64_no_verify+0xb0/0xbb

Fixes: a1a785b572425 ("iommu/amd: Implement select() method on remapping irqdomain")
Tested-by: Xiaojian Du <xiaojian.du@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index f0adbc48fd17..a08e885403b7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3862,7 +3862,7 @@ static int irq_remapping_select(struct irq_domain *d, struct irq_fwspec *fwspec,
 	else if (x86_fwspec_is_hpet(fwspec))
 		devid = get_hpet_devid(fwspec->param[0]);
 
-	if (devid < 0)
+	if (devid < 0 || !amd_iommu_rlookup_table)
 		return 0;
 
 	iommu = amd_iommu_rlookup_table[devid];
-- 
2.25.1

