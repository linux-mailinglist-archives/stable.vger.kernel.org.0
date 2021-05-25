Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F8438F849
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 04:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhEYCrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 22:47:33 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:45152
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229986AbhEYCrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 22:47:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcCIyzOsAKU/p8GSjKLBZbMuqWtpTXpbDykBWWuM+XX0ducMA4zNqYF1HpvLdRgEoRbvKp01Y1/x/SqM60Ws8HjcdWJQ6gZMjC9TpCy7Aqxi3Ujg77yJSoyyqck+qtx3dvdl6nuneHuRv5//0lfmmZ3yCr+PQxYHiACGy2RaKFVLvq0e+gvcZo+xHk2MkAYB1ZvAAof+s2Wc96ayXnVmKYxBssg8DiuuGjzhr/cTakSAA90s11N0rblOrpKd0wDqPgdEWk1U1T4rdZ1DHhMboL+zHmaFHuKNqUeaL0wPKjz97fx/g+yAuss3SIvCeOGRoznvDkMS6o1RN0WoCPPxfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4O0cmhqdU1T2dED8gA2hFPZMnoQw1+GtaPBIWVaMvU4=;
 b=GqnFGZfdcTaJd/fhTiGRvLsWKdvshoPhyzoUZpugKRJV4fS37Zrh8bBv8WcUHpV3QdxqIX30jCsCRweUcP/Wa3C/jICNA28DfYfIXDdFY3FdJ8iHabcyzIWLfJibwikXBaaToKn5yo6WdWfs/9Sr5y1wDNTDR/TfK4p9I/svmp/6AsWyelh9odZayckZilrXIWOarub04DoVFmtIPBgGBvyoaM8vbu5gQlrRnjIAYAmuxqbeKATtepcJ8ySv1i6d3jxzZpjrpP0k3ZV44BG4iB+R7TY3O4epDJx32UzAQTS0avehK4/SeFVX8O+V3ylFrAYJNOzJrga2lWLDKU6H8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4O0cmhqdU1T2dED8gA2hFPZMnoQw1+GtaPBIWVaMvU4=;
 b=E0A0LzpOoI9mNIv4CKNW7ml2Y7Tfu2YQEB9Cc8mCzQ2KOzOe4+px9rY6FAGLickRcyf+HxdabyfCHt9+126N3xhpZdbqrLghHQ7AYgEeuG/vWiNeimC3oZ0orQc6kUDgyJha0FPZF8519iwKypbMqMCYJ09+8Z8W1DKbmarMHE0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN8PR03MB5041.namprd03.prod.outlook.com (2603:10b6:408:d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 02:46:01 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791%4]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 02:46:01 +0000
Date:   Tue, 25 May 2021 10:45:51 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marco Elver <elver@google.com>
Cc:     Alexander Potapenko <glider@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] arm64: mm: don't use CON and BLK mapping if KFENCE is
 enabled
Message-ID: <20210525104551.2ec37f77@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:a03:334::12) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR05CA0097.namprd05.prod.outlook.com (2603:10b6:a03:334::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.14 via Frontend Transport; Tue, 25 May 2021 02:45:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5057732-9aa3-4e56-527e-08d91f273b8e
X-MS-TrafficTypeDiagnostic: BN8PR03MB5041:
X-Microsoft-Antispam-PRVS: <BN8PR03MB50411F5B6AC97679DF6774F4ED259@BN8PR03MB5041.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FwOVY6Gc/ieYGEyRSXMRnm/6qN84jLMIcNiSBl+rWUWyApc121ON6EVxNEyIB5kjD002FoCe4SzOiFg8VZW0E7yl4yEFtauVMDURHWlkUcN/1h2GlVaS0dgCxffC0TJEdtg1oNNMmxHxqWOzd2+VSu31pR9NT5RUyQ/F2ZtfHVofDAEDjJpgouPOGxFRBItn6jVKpr6tW5oi7jqHkaT2xzJ+KgfKosLzbh39qs4uhDD9QnWSNk3aAXf+qeMk0kt5P9S0m0h+W1AjZ2P6prgAi2vV9FUX6EIFb+kf1zRYRS8HP1vl7d9mBP1pfCRY8d3ZceKYoHxBbZ1bnizmcoQG7FKPtFQGa6378/DEVW/b3/pB4enG22d31NeJDwDzNl+qypqV3S01Ks/Ev5obFUZ8UpLk1YzSCdYljPy+B0gF8nvPffinhal6AYsNDKpFf5cjbnlmTfSPkgHVrXoI2qiU34aTq9v2zvqBGVqrRTfdf9CDzEKPBFCvmXMSupGAV8AZ2ipiv+xA3r4BLW/H1fNJeK348w4+1qJZqsFZatXtddEb92kdPMNJjbE3Ft34ammfy02vrvkIFuXsWcPUffagrI5qs0GGJTqBPwtZBQ/eZZIVhLc0tVOJIrHiGiamtaZ8KS3udNnkDh+TtL9SkbxB5Kp3BQxUgiOkMAOT/msXjg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39850400004)(366004)(186003)(956004)(86362001)(66476007)(38100700002)(52116002)(38350700002)(8676002)(8936002)(6506007)(7696005)(16526019)(66556008)(4326008)(1076003)(478600001)(9686003)(5660300002)(110136005)(6666004)(66946007)(83380400001)(2906002)(316002)(26005)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5w0zH2ROGyavK3Hx2AuHEmODvGJlzcJT3YHSWZrHmCMe//YWJkdhWe6f2KNh?=
 =?us-ascii?Q?QfLAAOpBbjduLpCoY+Bc0+XhTuR0OOYzzNUBVgHjiSDV68WcPcYW8pJkpeCY?=
 =?us-ascii?Q?n8s+GV/HimhoW+NTWyg8sjJIjqFq6DiAa8wew6ryXRGLoOnJ3S8LhRRL4ydM?=
 =?us-ascii?Q?i4IPt2yohEIXOzORpPRo3j56V21Qvq6E8CDU5GYWUnAKI+/tj48Rgjx0jA7k?=
 =?us-ascii?Q?0dh2EDQpgmXNNt1HAPKbyiimmB7PMd/NSW9VjPuEYVnBhE/W7YPO/nffYHZE?=
 =?us-ascii?Q?H3qr0daovnkyc+0rUqk6w37Qb3Zkomb5Mmheqb1AI9ZQQMDzvZZn0iRqJaK2?=
 =?us-ascii?Q?XERVDDDo9JIKDIbhLmWhGBpzkddWwT78hVi3/8b6Wl793xOdNvhWQ7GpfU+A?=
 =?us-ascii?Q?NgovcUvffeOsljbcW1tjHpQLpzPWcvbPrS51uh3L0sRysHUbGVfY2TL77scg?=
 =?us-ascii?Q?G3a8TU5byLQlZBqbXelEwaKYioZEY8g4DTXvFNExGHQ1EpYFpeGpme6PZoI/?=
 =?us-ascii?Q?ru8Ay5BhStHKx6N87GZCpiAjlfsfW2qh5niIqkhLfCKQHBlNL835Csmy+BK0?=
 =?us-ascii?Q?vFHv8UHgiM9l4yrH5SZHa24ArBWvsyGi+L/6SFxUb/zs8FcfQaOPp70VZDVq?=
 =?us-ascii?Q?JKAIJCgyKwoRifERXT2Hm8CWmRHzGeaaJsgVuGUfrl2fveaiZaLz0n70dq6E?=
 =?us-ascii?Q?qxAlrQ6cxFHb6UROP0V3l832j/XNG3lMpCswRbTRdPPn2963fbeVmAM33W5G?=
 =?us-ascii?Q?hVSrPP51W4M1RoZVrrXyNWK6a4ozR73/2j9c0iXvtGR2O0b5ohffWhDqL6ET?=
 =?us-ascii?Q?dffIpKl9zdVD0QtCF1yDRlvQhSOa3CpARDryVS7R+jX/TfnehV8ejjO37bnB?=
 =?us-ascii?Q?A9JdmJOL4nj1eKBUTvQ0NiQB+wvrGBpKkiznddM1FiqSphe/Bz3PHz3M1q1Y?=
 =?us-ascii?Q?Bm1AgXkvTrXhcOTG8DRCVYDVSzqsShbLe3gaRijWjr2Lkt2Agc06IKz1Y34p?=
 =?us-ascii?Q?y+05AqVLyXhKRNpO+0gRjIQxyLcSLu4lchpFrG2BHoqNV3ZC7R+cNvMgVGHp?=
 =?us-ascii?Q?bQJtDjM+OX/i10OJICoEcaQBMxHcAmECR6NzXqzgRs9zd8gPyRYQBmMJIlRd?=
 =?us-ascii?Q?3e5xulbK9bhRnxETsmCTUF3onLhHLtIDzMJbV6gsfa7eSXwwEs6aVhyFs9DR?=
 =?us-ascii?Q?m+eh0i8Wbs7ty9NioxWEaoRd4bj1sEkWzYEHHVELOiQhp2LNoGh/gcDs3CfK?=
 =?us-ascii?Q?6vneYWRgu6SmzXg4EJt+Ux4fq5WnnUEOBNgMDQgWoIvNPoyDvrKQj6BNOtn2?=
 =?us-ascii?Q?PTG+CT8ig636nY5K3l9FoAE2?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5057732-9aa3-4e56-527e-08d91f273b8e
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 02:46:01.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsDr6m1q64M2lSWTXvPd9D4IeYMWw7BUwoXNBW7O7cV5ZP207LgWNenBRqdRsXhAnT2bbycXRx3hDnwBuRnDjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB5041
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we added KFENCE support for arm64, we intended that it would
force the entire linear map to be mapped at page granularity, but we
only enforced this in arch_add_memory() and not in map_mem(), so
memory mapped at boot time can be mapped at a larger granularity.

When booting a kernel with KFENCE=y and RODATA_FULL=n, this results in
the following WARNING at boot:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/memory.c:2462 apply_to_pmd_range+0xec/0x190
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc1+ #10
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
[    0.000000] pc : apply_to_pmd_range+0xec/0x190
[    0.000000] lr : __apply_to_page_range+0x94/0x170
[    0.000000] sp : ffffffc010573e20
[    0.000000] x29: ffffffc010573e20 x28: ffffff801f400000 x27: ffffff801f401000
[    0.000000] x26: 0000000000000001 x25: ffffff801f400fff x24: ffffffc010573f28
[    0.000000] x23: ffffffc01002b710 x22: ffffffc0105fa450 x21: ffffffc010573ee4
[    0.000000] x20: ffffff801fffb7d0 x19: ffffff801f401000 x18: 00000000fffffffe
[    0.000000] x17: 000000000000003f x16: 000000000000000a x15: ffffffc01060b940
[    0.000000] x14: 0000000000000000 x13: 0098968000000000 x12: 0000000098968000
[    0.000000] x11: 0000000000000000 x10: 0000000098968000 x9 : 0000000000000001
[    0.000000] x8 : 0000000000000000 x7 : ffffffc010573ee4 x6 : 0000000000000001
[    0.000000] x5 : ffffffc010573f28 x4 : ffffffc01002b710 x3 : 0000000040000000
[    0.000000] x2 : ffffff801f5fffff x1 : 0000000000000001 x0 : 007800005f400705
[    0.000000] Call trace:
[    0.000000]  apply_to_pmd_range+0xec/0x190
[    0.000000]  __apply_to_page_range+0x94/0x170
[    0.000000]  apply_to_page_range+0x10/0x20
[    0.000000]  __change_memory_common+0x50/0xdc
[    0.000000]  set_memory_valid+0x30/0x40
[    0.000000]  kfence_init_pool+0x9c/0x16c
[    0.000000]  kfence_init+0x20/0x98
[    0.000000]  start_kernel+0x284/0x3f8

Fixes: 840b23986344 ("arm64, kfence: enable KFENCE for ARM64")
Cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marco Elver <elver@google.com>
---
Since v1:
 - improve commit msg as Mark suggested
 - add "Cc: stable@vger.kernel.org"
 - collect Mark and Marco's Acks

 arch/arm64/mm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6dd9369e3ea0..89b66ef43a0f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -515,7 +515,8 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
-	if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
+	if (rodata_full || crash_mem_map || debug_pagealloc_enabled() ||
+	    IS_ENABLED(CONFIG_KFENCE))
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
-- 
2.31.0

