Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FEC442180
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 21:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhKAUQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 16:16:06 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:30144
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229560AbhKAUQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 16:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=At2UUx6LK1GvQ076OC38mFCBcrnXG1+A4mWGuIPZzw4rP2lqzkMJLY5mqXfmojqBkCNuYq06xnVtnsnrPoZZeEOgwySOtSze96/TTmfTUQPn3kLD3HGHgxhH2trmdEwQAxaNEWl8jbwdAAzED7SeSkIO9CSf2Hx3sIS7p2qNFYhLbJRZq3wqWZO4yPHBalcB9uVEqIJppbJMCG9RcjuXBAFkL3v7xbTMPZz8asDFV7Lvh8c+cE/0VFyJj4iTr5QZXjzsIniPiZjJFJiJ7/uvmQ4893KUmGQWr+isO/ont6jrgjCC5knSnsvnf3P6/RT3h0157zogchrSY7z7xP7yig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdRkleo1hQ0sGuKwylRlasN/e5TQesaEp9QlYk2JFeg=;
 b=djh/Jxi5cfjxLOADKujIuKSEWgFfTZkW21SjrTE2Po43dmn4h1cjhlOCZON3xj9W3UTNAImQrUlvw1ldx11J4VLAB3XEwytJ4QHu9698FNwZC/nRaJ4MCOMIKKiUvO7Q7C23dbWDXD2tN/WinJ5xw2B2M467qzAwFH7iKVZzePnBwWArcA5SmuYPpBvPe31BGP7w1n+NZexNHg2XVbjN8Ttxms/P6qZUJpbHMtC44ctO4+ecrNE9CDUgV9FKk6Eu/YHesus9EsC6uHnPMnYueB9HVEnWI0H90ZFgw5+trHFI9g2o43n//UFj90eGenjAjNkQLBvx5BtOgEcRghoRcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdRkleo1hQ0sGuKwylRlasN/e5TQesaEp9QlYk2JFeg=;
 b=FowWJ3MtvrJYtJkpyTAE5huQEhWZhA/Zrs1+AbdGax0pGLUUg/Ri0WA93jqXVJj+o8VH3TbnzvbTbn+pvmBJ8Qsqhk6F1/lMEwzZE0o6w04L2D2Do9umUkkTmPHPOK/u2PB+XzCjd+GoebHpZ9X4gqs2CkUIu00ncAfbHmwM1EM=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=vmware.com;
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by CO2PR05MB2679.namprd05.prod.outlook.com (2603:10b6:102:6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.8; Mon, 1 Nov
 2021 20:13:30 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4669.009; Mon, 1 Nov 2021
 20:13:29 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     linux-mm@kvack.org
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm: fix panic in __alloc_pages
Date:   Mon,  1 Nov 2021 13:13:12 -0700
Message-Id: <20211101201312.11589-1-amakhalov@vmware.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:610:e4::28) To MWHPR05MB3648.namprd05.prod.outlook.com
 (2603:10b6:301:45::23)
MIME-Version: 1.0
Received: from amakhalov-virtual-machine.eng.vmware.com (128.177.79.46) by CH0PR03CA0203.namprd03.prod.outlook.com (2603:10b6:610:e4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4649.15 via Frontend Transport; Mon, 1 Nov 2021 20:13:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f7f3521-68a1-4141-8850-08d99d741228
X-MS-TrafficTypeDiagnostic: CO2PR05MB2679:
X-Microsoft-Antispam-PRVS: <CO2PR05MB2679E37577DE6E7581D541ACD58A9@CO2PR05MB2679.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpOYGzjM94NnCxGsXZ+p+i2gOdJfzHzuX/1HE5NAUASZSbp0rkujRicO6RWBiGMTN8k9Z14VBzsKkBH1+1dQl+MLz3rFyWYvqqXfOnokLnKcOpexf7s/k6LdH5IenIz4ptdkY/SifKce4zsX1O6lfjVYK6qMp4oR6OuV864RTeV7+LF69Vd+qMQkwv2A3Zpa66rVsVSSOtVz7PyFVLiF5alnGUxtyLKqk69qhP7eeCGDHamf4VzO8fJJQmitrFylQ2jFDw+6KoRRizKiyHnaJPodoKqrF+3JwFTjIWUQYfiCIlrUQvKPiMcfkKnUk+t22LBWiAFbL1sQZvwu5P3agNM/JdSAQSx6wYmhhUhgBmH2nZ85lxZ9acSsWWbOdGttduizcEV2aaxWTSdV7u8kFOktqWgR/S4/gm9o5WgWHRuFh1Iw0/K6WhgON1VD4Etsoi7adsP7jIbHp4H1ZZw9S2To9DM4K6/ow4ooEFHfwHGvqa+0fBDFGz5qd3RhgtX/vIxfnFrma0zAOKT6NY737VYfhRIy3sK+duqibGDyhJHEjyLuA50p5mXrw/6ckOKNBiZn0Wsvah8Ct5TQlbiErrwJywwD7wqJqArEyw877HYci//qz2zKlbhMrJeSZjLEIPNY8wks3awKWj4yhZbj1MRqASQykqy+mSmLY9nxRMzqQPtA5+EvD7N34Jd4u/YCThT6MwvSK5OCIMUI5oS7Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2906002)(66946007)(1076003)(316002)(8936002)(52116002)(38350700002)(66556008)(8676002)(5660300002)(86362001)(66476007)(38100700002)(508600001)(6666004)(26005)(6486002)(7696005)(54906003)(186003)(956004)(2616005)(6916009)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Si1s9OlYlbVtyc5vKeC+qc7ZZiCGO5lBRKflUG8m+NQ3FZOn0KOaD9Jgclh2?=
 =?us-ascii?Q?5em0NifJF1FEbGgLB/HZAT11gFkLGoQ6AejQFPOU3Rv6i8+430qex0NXM6eR?=
 =?us-ascii?Q?0Nvh4Rj2/x6jsnMTnlcJ/wfuCIqPtMwPxMkd1qBHxYD1E3NS07gTefW3bfml?=
 =?us-ascii?Q?nZgICVRgZrDVSQQMqs4GQrnNOIKn4x/PyOYX12nSwDX1oMLt1LiWK9vgo0nk?=
 =?us-ascii?Q?eskMPXiXjKsix6OpG7GihjjVkjkaGZrjm8hKBdss6J28RXZ7TBWA59b9xYFy?=
 =?us-ascii?Q?KioVPBt2BVUewNMhikbWfsCOGTtETCKb07dCQyiBHHLhrIfP2+HmS8FmsEEP?=
 =?us-ascii?Q?OsBFEzjhc6rbSaONPhB+xAgY9/N63vMIdfq4mV3oN43bmNP8tupHkUPSoqi8?=
 =?us-ascii?Q?FlHw6BRt9urCjVsj539JNpe/f+TzRY6xFVOUPAM9z4DfBrfgsJeRfWB1XrQb?=
 =?us-ascii?Q?bv1XL6rIepVEAUUSXDv0mbL9joAZpbK+UZNLimuCb45FoMA3S/yVewR5gCdZ?=
 =?us-ascii?Q?VOEdGC+z0FiQ1JoJLNpH5bGaSoB1nDi57pDTD4GULTYnp14XEP7OtPkWJ3Ld?=
 =?us-ascii?Q?7txRnD1CNJfsg5uyenWXrPDTmrGyqgiS51PDi9DgJdgDCIUEnbrhv8idaAok?=
 =?us-ascii?Q?pgL/u2ElBTkEO4SBaKSXd8yng6HG6ho6Qh24EbsM/tY0LbOY6SprIuSX874C?=
 =?us-ascii?Q?Ssirh5p/gMcceZyFJinyivdBzVQw8WbG637iU6fibjq3CcqbwcAq1VY4YljD?=
 =?us-ascii?Q?WXOgO78Xmtex1gMkS2Pfj8yL88gTCRHS4wv8hxkEW6mAstecYzACVP+3xjUi?=
 =?us-ascii?Q?Xs+hYSsShJF+Bbu2o58D8TkvYUT5+FiZHcH6DDViVuVvjjR5bPkWUdTLsxJh?=
 =?us-ascii?Q?vb5WjSBXtIfQwr25oBodHqKR6v04s8xGTd5bovauA4aq6wGsVXC+pDjbvtSW?=
 =?us-ascii?Q?uJ7F4cOHAi1vsu1R/FlOts+eKj+K52WBZKjpjfGLVRE+1YF62HYU8PdamM1f?=
 =?us-ascii?Q?6kOl8s1W0OIxtSlhZbKlei1+HsVTZ3bGTTZOezNgbcQrRZkpAnSmaYP0SMj8?=
 =?us-ascii?Q?BbkD1khQ21NdMUIgtcHzkNcezLBlKHOHVzzEpTsHNCYQgm+iy88B+u8kGf3h?=
 =?us-ascii?Q?VRU9mf9HU8tUGUkGn8AW/q6SaLRV+NFEGQDw4kz1zW96/RN1rbb+gdEGrJja?=
 =?us-ascii?Q?fIF8YcAUIG5MmT9yJS6ehVf/FIIJutSlWGmVZ2jLpFNfqDdCJMnvYIv5/kxn?=
 =?us-ascii?Q?579/Y4jrexpTPiwNqMEtlmZZfheIsW/AP2G0Y/HIlw3U8XkpkwovVjEpQnn1?=
 =?us-ascii?Q?k3dxrhjWC+uRym/Iw1+BkFBt5jLOJYLLbvqlJxcCL5iMmCqu0t5nrJpc7zw6?=
 =?us-ascii?Q?GjJIl2esdaDf8AIyvI/ahxl8dmfhR5ZlWBL/kl7IfUNaPtmgx36iiGEPYrzZ?=
 =?us-ascii?Q?gmp3gwKExyHEThipoJ8jOX0DSYng9HOGltCy56vlXNBB4a3u4x1Sj2byvnZf?=
 =?us-ascii?Q?1q+W51h4/cbz1+UPVHIgHp/AhYh4J96TpmCL4jnSTKOC6ss97IYl1PJG+TFh?=
 =?us-ascii?Q?wb1LfdeAHKkwzeyMqB/+x1VaI2qAY9biwR3MLNZ/9km6eRiCCFx8kZ1D4ilj?=
 =?us-ascii?Q?uxXftRXM7NvjPa1uynkH3p4=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7f3521-68a1-4141-8850-08d99d741228
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 20:13:29.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9eRnQyLXvxjkShI09+8QA3uM4BUNy5NPUDKyIDttxd4kg3fENxYRhniiRcDiOnWSTM3Ya+XuQ3Np7Iesh7ZHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR05MB2679
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a kernel panic caused by __alloc_pages() accessing
uninitialized NODE_DATA(nid). Uninitialized node data exists
during the time when CPU with memoryless node was added but
not onlined yet. Panic can be easy reproduced by disabling
udev rule for automatic onlining hot added CPU followed by
CPU with memoryless node hot add.

This is a panic caused by percpu code doing allocations for
all possible CPUs and hitting this issue:

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

Node can be in one of the following states:
1. not present (nid == NUMA_NO_NODE)
2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
				NODE_DATA(nid) == NULL)
3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
				NODE_DATA(nid) != NULL)

alloc_page_{bulk_array}node() functions verify for nid validity only
and do not check if nid is online. Enhanced verification check allows
to handle page allocation when node is in 2nd state.

Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 include/linux/gfp.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 55b2ec1f9..34a5a7def 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -551,7 +551,8 @@ alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_arr
 static inline unsigned long
 alloc_pages_bulk_array_node(gfp_t gfp, int nid, unsigned long nr_pages, struct page **page_array)
 {
-	if (nid == NUMA_NO_NODE)
+	if (nid == NUMA_NO_NODE || (!node_online(nid) &&
+					!(gfp & __GFP_THISNODE)))
 		nid = numa_mem_id();
 
 	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
@@ -578,7 +579,8 @@ __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	if (nid == NUMA_NO_NODE)
+	if (nid == NUMA_NO_NODE || (!node_online(nid) &&
+					!(gfp_mask & __GFP_THISNODE)))
 		nid = numa_mem_id();
 
 	return __alloc_pages_node(nid, gfp_mask, order);
-- 
2.30.0

