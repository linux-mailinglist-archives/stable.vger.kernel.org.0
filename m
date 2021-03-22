Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8770343635
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 02:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVBV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 21:21:56 -0400
Received: from mail-eopbgr1310098.outbound.protection.outlook.com ([40.107.131.98]:64592
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229579AbhCVBVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Mar 2021 21:21:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFMurRaft+0t6gqke0rgbb2LM7ugLwY7L6S1tUvtcmkHZ7gREedHkv8GLR6GbKi//103ZMZ4MxHRJSVsh52Ht+EHP9qYtcTbXd0C7blYnE2LYUQ2xjaxoqssA49sT0kLmCfUsc+heF86YC1+GQr0OErtTwBUQgo/A+l5fgN3R2KEuY1U/W6BoyglyX2NhOtOW2/LMl62u4qLf4pcvoJEIF7Tn7rMBJBO42Tte6ltKrC9YpfVhd+/pvmDN+DC/mhEFFCdzSsfa8FGwKkxzusZboLY2F2VDmd49g/hRiQEi87oXFo1W75D4sGfwfqNaOsrdLbiREID4PSrIBanIWFhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD9v2kIgSGwXBCoWJFWoUX9VcbcZZzJdsJkuCjjbBRc=;
 b=QOwRB+Vx4YgMLwuAB04a6xI2R10POSM78ln/OLw5zHyr7gg+AwJpSInvE4icQTPmWoYDq0cJrdRzeqmRauV0NiPZumfowMUsjPQtjSMnfsyn+Xi3aaH/4uRt34InXKHftvU+rLjE/2mRnFoRem1BdPpBOL7aTYREhU0fT9MuFBEko50MwXIqy1ICybBLEZs4f0fWzTJUAS/8jybwtBn5ydnWgu+pF9peeixNoGrI+QpXH6opxF+4BwxnPfRUF3zmeCtBfj5qK9vs6f6Iaeow2S7Dx2gCGhYFCOPSin2/eFyxb4OH72MMFuJZP1ZNi2HfCz9u1d+GE0C0EYuC35jiAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD9v2kIgSGwXBCoWJFWoUX9VcbcZZzJdsJkuCjjbBRc=;
 b=jITyX0piwhbP07wyElJ5zO2II2A+IIiWqkULmhDneEL7UhpWPaYjz0bW51HW+l9NYshQiNcAEXSbJ8Ks2XCzjyEqAqFriv0FHg47IwxnbnqI8zisVNRmfVrMVTf6HvTsZMI5hmhVrt5L+mUUdfkLtUSQyj6UczIkTyUIx70SUWo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HKAPR04MB3987.apcprd04.prod.outlook.com (2603:1096:203:d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 01:21:36 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f%3]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 01:21:35 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     linux-mips@vger.kernel.org
Cc:     macro@orcam.me.uk, jiaxun.yang@flygoat.com, f4bug@amsat.org,
        tsbogend@alpha.franken.de, YunQiang Su <yunqiang.su@cipunited.com>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: force use FR=0 for FPXX binaries
Date:   Mon, 22 Mar 2021 01:21:22 +0000
Message-Id: <20210322012122.16754-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR0302CA0021.apcprd03.prod.outlook.com
 (2603:1096:202::31) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR0302CA0021.apcprd03.prod.outlook.com (2603:1096:202::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.15 via Frontend Transport; Mon, 22 Mar 2021 01:21:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25e34c16-0d0f-470e-fa10-08d8ecd0d5b7
X-MS-TrafficTypeDiagnostic: HKAPR04MB3987:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HKAPR04MB398756D2E01659AA4B116E13F2659@HKAPR04MB3987.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NkLPtJSC44OTdasBlrP07R+JirMTCdFj3xXb1AC8tuk4+MJsh1L+P4mz9aKhacUpZN6uQPd2naho2//pik2ggorKv3DILXQK8ae95PUeH5m/Htnp43Jrw3/NZOtSCKKLyOOwoMsQm5Bl8VVOJDpF2yti+kUp1u8CTEtKSu0DAZeuuvdvv6LOEvd3chwsyO9m+n2zBj/0JGRU4nnWQH1l2iT3BLrvIHn+tFYx6AB+VtkLZqCsb/vnKzlCzgPN7Z13+ySXp/rtblH6+MsD7QGW9xq7CivzF9U5LcIjj1IUN/tlBSg6P5YkdDlY5ouR6H+QATHuXU2Go/zxgvlFoVyllEpbaOJX9j276bk/uYMyXTjKEFjoqkTNKoxxwlYWn3x2Gi+zXsARyuDTFrBkvPyKIU89/HtATgDFFPROb52DbZHffzSkT+6P0iPwJnwP94RqttsDcFQLI3bkxMggNEecgEeKxlirv8jQ02Do6LKdJSie/UC5xU2TgDjGlWbhuYNdQA1iOu/Yvr6MbugnJOCsAatj66yZ0XyTOyikweAOYXdwUhShgbWdsoCZgAOvkcOq4D2/axstQZJvKMxuQxVQ0jqZLnOLS8XTbIOrqX7fslT2K4rIeflbAd7Xm7Bc1sJZCs1UO1yDayM/Gu4MXp8jDEtcNeXJNsjWkX25Kny4nxY8ExfPpfvX1JTdiciLDjAkC8ghHNWxRfNdoTnjXYi2fpBhz+Blfn5lQD3PVPQw+v1y4eLYLO7Mf3ilqNzoqhKwSC7T6+PJw6ABw5XZNPmLRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39830400003)(396003)(346002)(366004)(86362001)(2616005)(8676002)(316002)(186003)(6486002)(36756003)(2906002)(1076003)(6916009)(38100700001)(6512007)(966005)(26005)(5660300002)(52116002)(16526019)(956004)(4326008)(69590400012)(83380400001)(6666004)(8936002)(6506007)(478600001)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?trdOpX/EMZtFzPY0gEowf2j5oRDt7IFn2TtZpZ9TKH/2h9OsqfTt3lAXG5Iq?=
 =?us-ascii?Q?Kt54nMm2xBsatrd90CwpRUQS+YYla/d3+asc956Ueys11LAE9T8+EfHFLokZ?=
 =?us-ascii?Q?0fS4rdUJnKOllrP0oc9WsiacB6orSlhWBI9mpMVWIaZPYFKtS+2zgvohpmML?=
 =?us-ascii?Q?OCV8Vrzw6RdK4v0ZlbjOYJmrVsBDyCJgcOD+z3l4Fxfo/3gfELbqy198fs5F?=
 =?us-ascii?Q?eilxIUPItQBuIq8TVy4pznVnRkGU+K6HC7ODd+1DPStgmHDpk/JfVkvRURCi?=
 =?us-ascii?Q?Sml/xooS+s/BY/YMQsBHlJa5mw1S/M66jLBUbzFHcGyX+wwseTo/VVTbDOMs?=
 =?us-ascii?Q?asktREGs/HuRVvW4H2VcABFCa7PGs+agCWlMMYkJNKcRIWduIgWiLKHHvbRY?=
 =?us-ascii?Q?M6r7JIoobqbZBEhpRZihu1Xp+atcjvtN4YOl/gCuynYDfdT+qHmxpjsLYCt0?=
 =?us-ascii?Q?8/B9lVfpca+zBLEIvFrSWNA5FISPMo5CFbGvJfRL7RHKLbXVkdho9T9cfSrL?=
 =?us-ascii?Q?wJmwpB9b3lvWpTY2ANornauQXlM0sBAOTtZUvQYXM2M8G2YBkR+av7kKp2i6?=
 =?us-ascii?Q?5jSeDF84Y2NZmK56BjWRVS1u9jTXhbFP6/RkkpnX+ZaZAH7S03ROy10B7muZ?=
 =?us-ascii?Q?Z2IDuNbwVJtRtBKNZL8BtJzwTBTadr44O4HAGaT9pzCyIUsbYipWahu7o899?=
 =?us-ascii?Q?PI1al8MmjrEB6D3dfV/IO2IusThrxWTuVdthmLCZ+5Cq7z3UVfGerJ+fybS2?=
 =?us-ascii?Q?YtKBI+qG+LpKVsnC+XYxaPyIw6Rqm29xTGxA2xlpbic8X+mOArrUscSuMhcl?=
 =?us-ascii?Q?GEhwvfIxvJ4+eWLgTP8tBr1bx1P4MeX0nh6cLoCVmXMkP55hjFbZ/E3P8N15?=
 =?us-ascii?Q?A3Y4c5xVYADsSLbDMPx+Nr1CmPumlbdEQQ1ictprBVfqS04Bly0nIKXaF2yj?=
 =?us-ascii?Q?w9FvputI7G18gQHLcTY30vHOdlrSY9F6Nuj7fkzegknUA9NsOZHWhUIlmIKe?=
 =?us-ascii?Q?9Iy5ggCKs4P9QDN7wG6iBIO+7t7cA8dCSrYj54ghmA28A1OVbxWLMLf7K29f?=
 =?us-ascii?Q?py+vivAllslA2Ms/gB7KzWOCFJB2J114z/hrkwT7GJHR3igZswXwUEOJoqrY?=
 =?us-ascii?Q?v1cskxy5tWPBEqjmCUK/g6CameZZ4R3FhiONxmH+MrSE4RC/NR3DM7JjvBss?=
 =?us-ascii?Q?vXTKUNct5PFiJ0IIAxQxlU/Cg1liPx65D9Rml97D1nAZQsIV9QgMSz2Xx16F?=
 =?us-ascii?Q?sGhCNVgJEM1ukCSHojMuZUMrxeBmSTUgvoaSIH1m9aJOmNHhULR5XJEc72iS?=
 =?us-ascii?Q?cOC3xKJK3kDsAcTtvoZ+asMn?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e34c16-0d0f-470e-fa10-08d8ecd0d5b7
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 01:21:35.7265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YLEuITGh3EYjhFgHVTkPKRSOm3c1oL1ZqGwfjIvTZNOGB8UJi2C0ltZgSdIQSUs47ppyxB+oM2qlhwGLG+PgfqvkWj8AdCpxeeVPIDM7Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HKAPR04MB3987
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
v7->v8:
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
index 7b045d2a0b51..311c4fde910d 100644
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
+		state->overall_fp_mode = FP_FR0;
+	else if (prog_req.single && !prog_req.frdefault)
 		/* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
 		state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
 					  cpu_has_mips_r2_r6) ?
-- 
2.20.1

