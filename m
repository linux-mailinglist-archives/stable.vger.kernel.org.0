Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC25B343673
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 03:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCVB7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 21:59:45 -0400
Received: from mail-eopbgr1300133.outbound.protection.outlook.com ([40.107.130.133]:11051
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229574AbhCVB7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Mar 2021 21:59:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6pi4qQVPO+2AS2Y7KtfPT5W6RvqUYEtCTgTcAIxS2olXOSg1VBy7UIRHVxSkzUSBJylYGkx/qfMf4QRczbct1l4g/xn1Qa48FFoBIciGupDDdbjWgJjPfYzyFLxGcfer1zZ5Fjk1eByF6gCU0nPqJDzg5Hl01dWWK2FjDPr6TruN/yMZGRK5uqun4c03quvLQWpbCBUDyYwfR5ujg0wqSpnSW8qoaPsb6cKmDT9hasVU99RlEDzb4vsqoQsSIOoehw+Z5Zk7ULNbZV5mCdrHmUh4XVHCktTI2COI11S68FdwGAsQzueqXCZ2xROg3XL7W3uHJrSHFPijmTJyObvrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cV0yjClj4clZYjI3wR5ABf2xrRPEOXX7ZlTVGE0KK/0=;
 b=jrlTfX4jXN7G0XEvrHw02W6qzfxmIKTBsG8c2Qq3abEIzO0M0wswz+OnUfoZajYzDaHj0evAKb7Js1YKgVuOcgfZQKlGomsZ9s9TPl9O3tqm4ZBvQUBgO+fWCvBzUGsmgoNiPXUBR5J67hpCbqHmpgKob17EjxjrjpnMdKZ/rZTobt4kBissNN3nCAvbR2T9xBMfsCdjb7nejYiZOrRr//Y6VO1LqTRBOS9NngnU5m428538A6dr+hbw0dohvKB2eRwlqphiAYrhZjZZ9bWDY2gpz/JHpHBD9NFTY8G5v983k5mahflXiaVcwx+/cRArBlpbM7vDqSRI9IUoH4H4EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cV0yjClj4clZYjI3wR5ABf2xrRPEOXX7ZlTVGE0KK/0=;
 b=RZrB4GYXAXKkB0K1Gl26YSV42icjYUKR10QICg9GHFQWVkXaM6Fi/ZtIjntoQRHbSC70AiM0LVyswBAT7e6NdVAa6Ifc8fP3sg12ddlVAHPc9tYZDgDvVNMK3jgvgy4ZfM6A8DPZASTRxQI9D2NmlGccVueIZliRDo9QIQ3+fMI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB3314.apcprd04.prod.outlook.com (2603:1096:203:80::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Mon, 22 Mar
 2021 01:59:20 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f%3]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 01:59:20 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     linux-mips@vger.kernel.org
Cc:     macro@orcam.me.uk, jiaxun.yang@flygoat.com, f4bug@amsat.org,
        tsbogend@alpha.franken.de, YunQiang Su <yunqiang.su@cipunited.com>,
        stable@vger.kernel.org
Subject: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
Date:   Mon, 22 Mar 2021 01:59:02 +0000
Message-Id: <20210322015902.18451-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR03CA0047.apcprd03.prod.outlook.com
 (2603:1096:202:17::17) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR03CA0047.apcprd03.prod.outlook.com (2603:1096:202:17::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Mon, 22 Mar 2021 01:59:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdc021bc-2ad0-44d2-6410-08d8ecd61b72
X-MS-TrafficTypeDiagnostic: HK0PR04MB3314:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB3314E86BB22068906099F29EF2659@HK0PR04MB3314.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NyMiNGCY6ie3H6dxFO+u3nFtezfBcl4cGUK+aoFx8irWFHM/nnDs/oJhF5A3XfzKE/m1rgaoLzJq/LkXzxunrynnTqpOai5Rs+zDsYkCRiZb6WuqhiAvbtkrq+fOBMkOpEYnjc/sDF7pHH4vAvyTK4o6+1vIfIEAoimoO0+F/kW7Ba1RPIaLg0MiocMlDFXRJZojpPpU4IVeCBT6HU4CGlRJVSEs7D5LGqvJyxoRI9slZeD7atkEc375GOEsmvjqH1/PP3qXJnuGZi9nKeu1CcK0leJ1rSYhnvxrN3UcyMgeofEtnPJAB+5xrShMlzS9ut4aB8ZsCx42PIaqVE1b3OYcVGxdB8zMxt1ZKdwt35Ce5Wu6xAwjFWMmi9Q5HWXvkV7peX63D/Ed9RJkV2MyCRrhYwaARefuJVqSNdhDGj3zRx04lwjOMsGUzHk4SZcrkrYr0WbR+okguAgfOT0FD5XiCfuS1kWNL6WQ5o8DecwZG5Wtwx44BhyVfGIUB9Rl3MR0/dQ+ZjqoxpQeHY3y4ZDirbm5pOspSKRiGNi3eLl7TaN9uGAmm7TfcnXExSUjCnRDRIBdnTDVBIg4IeKht1SppynLHztdR2aj355Xmif2UIx7EO4ESkFxT6HaDPZRnxXISQRVJ8GGVBqlDd0VBMdEWlsSHhJWvPJZrUupsM4vCX9yIOGblhjEQQX+LL7sKgvn72cKIIMKuiodWus7Wp5ZaS9BxmZ9bck+dSu1qz1eWqL19/KLa25El4ghS61zy1EVkHr9dZfn5HvlWCyCkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39830400003)(366004)(376002)(136003)(2616005)(478600001)(956004)(6486002)(86362001)(69590400012)(83380400001)(186003)(52116002)(5660300002)(66476007)(66556008)(66946007)(2906002)(16526019)(1076003)(8676002)(966005)(36756003)(8936002)(6506007)(38100700001)(6916009)(6666004)(26005)(6512007)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5A7vcw46lTUhLpEkXHsI6BLaMez2ddu7Vf3FQjTgS9ndaL2lzLoY6VTDs9R9?=
 =?us-ascii?Q?IsSSrUsHR2dFQ6/DLJL8u/LBRreDFP4wS0BK7W+YDKOgcAYu5c5ZXTZaN7lA?=
 =?us-ascii?Q?kfPidT2bXq8UUpqro33CDpiyFz9//MIGaRiYvz9KkvtkJF+K0cw2fHS7iKFX?=
 =?us-ascii?Q?EflYqjuFo+BKVmWW9Haj4e+/fIUPwQbxq+P95KAww65+Y+f5CKEmAYlUpX5C?=
 =?us-ascii?Q?6debw/0FO+Lue92BZjOku6FJp+PKL8MvNdT7lq73n7W3eCP63t3MVSNyJKWM?=
 =?us-ascii?Q?tAxyFYUeyalfSFBIfwR78bur8Rd0abAjk3CLrt99BAD1hvhpAcTxDwigChrJ?=
 =?us-ascii?Q?xJx2StNbOx33xAXO0Akv5AhElbvMTUOcqLq7NNJ7iD5NSCwW+2qwWnYzVu0D?=
 =?us-ascii?Q?mXmehd4cn5OtXqhWSw7usEBcxKok9fKuSguEgXnVW0gEF2Cp9/KJHlb4StN/?=
 =?us-ascii?Q?Pm6nmXx+KB80wfrg8vSN8K8fyS2rd7X1rwgBNAU6wJW7PUT1NthVe0+od/d2?=
 =?us-ascii?Q?7jPHBedMt70cTJ+3OJ1DXcHr0A0Uku6nwaham5tPHEK4uO9Gf1IcxdU0GPVe?=
 =?us-ascii?Q?4n0rxuDUvuIaR63s+OWNYRHIpIuYFPb2EmNPJkStWpO3DMgrESehfIiuVgG7?=
 =?us-ascii?Q?0xIFHVWdd6sPmuDCF5IDfqg5WVOEQGN541RCTXZuL0y3pvih2YfBTyATspOL?=
 =?us-ascii?Q?IZMCvVyoM8jBwDhDYBMwYvq9gPcOvdwUGXXrDcFfdMaX6zkh4lryK1UjGYZL?=
 =?us-ascii?Q?bGnY7fJR6DMxTJsxf5NkY6xW2GoNIwmtjvuB3xWSO47jlgUsbtoDxlzNw7h0?=
 =?us-ascii?Q?n9SW7wYTgBK06MEpMKj4holpv/NeAnWdYged86VLAl377JLtXHmnyd3mSbfW?=
 =?us-ascii?Q?056M9Wdv2CRwnQZR73MbkfFvF6YijiDKnsupoGdLs1QCd2xvc0UojHfRpSnJ?=
 =?us-ascii?Q?pKMsH65WWn/vGJ6VvCRrkrFWsz5uk5aRjKZ6cc1pDBcoUKHrMXHjCHE3IgnD?=
 =?us-ascii?Q?+cMx3YaUTkHqCTuzQnsPpClUQJrAmbdKPZwQkwWUqoCeR8YKPDRkZj4Ef4Fb?=
 =?us-ascii?Q?mkK/gXWsc2FbxlVw9Px/+UKGuhWPOqRJGU3rzF/2qmYgUXdeVJ3keGmkgvjf?=
 =?us-ascii?Q?+nW3R51dnQxWTIZuWmp6wnNOmdAATBiBb3s8HNTWjNpYtwYFOeEcU3ghKGEg?=
 =?us-ascii?Q?9X4B37VUZC7JUCsRZRaMeaovi3oEGOh2g4cbmzBEH6aQrltXIt4uBjYq75It?=
 =?us-ascii?Q?OrOh5nX2Op0ZsLt9a83wFtl05fHRvETVerZpBZI/AKIf1yh8DVoJkW6xLdQs?=
 =?us-ascii?Q?rZXNR58aiHtIMA64TjNcHpMo?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc021bc-2ad0-44d2-6410-08d8ecd61b72
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 01:59:20.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ux25FASL0YREdmjYUwPYoOfEVla4IliIcrScJzO4jWyKwspMkSFXzKLFedKTHH2TLTEeieToL3Bz5ZM3YNNKvovdOd/NtLa4PcyYqgSBjks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB3314
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The MIPS FPU may have 3 mode:
  FR=0: MIPS I style, all of the FPR are single.
  FR=1: all 32 FPR can be double.
  FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FPR.

The binary may have 3 mode:
  FP32: can only work with FR=0 and FRE mode
  FPXX: can work with all of FR=0/FR=1/FRE mode.
  FP64: can only work with FR=1 mode

Some binary, for example the output of golang, may be mark as FPXX,
while in fact they are FP32. It is caused by the bug of design and linker:
  Object produced by pure Go has no FP annotation while in fact they are FP32;
  if we link them with the C module which marked as FPXX,
  the result will be marked as FPXX. If these fake-FPXX binaries is executed
  in FR=1 mode, some problem will happen.

In Golang, now we add the FP32 annotation, so the future golang programs
won't have this problem. While for the existing binaries, we need a
kernel workaround.

Currently, FR=1 mode is used for all FPXX binary if O32_FP64 supported is enabled,
it makes some wrong behivour of the binaries.
Since FPXX binary can work with both FR=1 and FR=0, we force it to use FR=0.

Reference:

https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
Cc: stable@vger.kernel.org # 4.19+
---
v7->v8->v9:
	Rollback to use FR=1 for FPXX on R6 CPU.

v6->v7:
        Use FRE mode for pre-R6 binaries on R6 CPU.

v5->v6:
        Rollback to V3, aka remove config option.

v4->v5:
        Fix CONFIG_MIPS_O32_FPXX_USE_FR0 usage: if -> ifdef

v3->v4:
        introduce a config option: CONFIG_MIPS_O32_FPXX_USE_FR0

v2->v3:
        commit message: add Signed-off-by and Cc to stable.

v1->v2:
        Fix bad commit message: in fact, we are switching to FR=0


 arch/mips/kernel/elf.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 7b045d2a0b51..554561d5c1f8 100644
--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -232,11 +232,16 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 *   that inherently require the hybrid FP mode.
 	 * - If FR1 and FRDEFAULT is true, that means we hit the any-abi or
 	 *   fpxx case. This is because, in any-ABI (or no-ABI) we have no FPU
-	 *   instructions so we don't care about the mode. We will simply use
-	 *   the one preferred by the hardware. In fpxx case, that ABI can
-	 *   handle both FR=1 and FR=0, so, again, we simply choose the one
-	 *   preferred by the hardware. Next, if we only use single-precision
-	 *   FPU instructions, and the default ABI FPU mode is not good
+	 *   instructions so we don't care about the mode.
+	 *   In fpxx case, that ABI can handle all of FR=1/FR=0/FRE mode.
+	 *   Here, we need to use FR=0 mode instead of FR=1, because some binaries
+	 *   may be mark as FPXX by mistake due to bugs of design and linker:
+	 *      The object produced by pure Go has no FP annotation,
+	 *      then is treated as any-ABI by linker, although in fact they are FP32;
+	 *      if any-ABI object is linked with FPXX object, the result will be mark as FPXX.
+	 *      Then the problem happens: run FP32 binaries in FR=1 mode.
+	 * - If we only use single-precision FPU instructions,
+	 *   and the default ABI FPU mode is not good
 	 *   (ie single + any ABI combination), we set again the FPU mode to the
 	 *   one is preferred by the hardware. Next, if we know that the code
 	 *   will only use single-precision instructions, shown by single being
@@ -248,8 +253,9 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 */
 	if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
 		state->overall_fp_mode = FP_FRE;
-	else if ((prog_req.fr1 && prog_req.frdefault) ||
-		 (prog_req.single && !prog_req.frdefault))
+	else if (prog_req.fr1 && prog_req.frdefault)
+		state->overall_fp_mode = cpu_has_mips_r6 ? FP_FR1 : FP_FR0;
+	else if (prog_req.single && !prog_req.frdefault)
 		/* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
 		state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
 					  cpu_has_mips_r2_r6) ?
-- 
2.20.1

