Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B96343640
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 02:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCVBaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 21:30:05 -0400
Received: from mail-eopbgr1320098.outbound.protection.outlook.com ([40.107.132.98]:33892
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229574AbhCVB3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Mar 2021 21:29:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsQBzieJ6fbzmOAgrgetYQDMa17RBy/TCTlJhmEeV/c0J25QH7dn2UGYOv+j7zkiVIRmmGL9lWfTVZBZ2lve3oYrtWW10sRnDOw9YpuGU/rs5dDIA1xImN9iEu7JPPHX7B0EjUoqkdTa1akzsMOC+HuW6yGTaFqbWPu5bRjEEOOvP+BwaQHQ6D79e4udFNy0VNBS0IDsXhQKay2ldoGxtSw6e77G+jJmlqyKUJMfmvH9xi+IgF1e/SjvwjlbaNwX3CEsUOu0lTJt+fgwaRgC3+T9uwVhNSpchy4OCghgfrUaxUyT0iZFvCGs8vrn40tWvKI1WgU9rwp8oAJOt+yZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqgWbiFyNWV1bxRaGMJe3NqL+OtN19RYTJsjklX3wkU=;
 b=cfqW0PZUTEEaQuYbto32YXiT9nV2lZ/rL1KDeTesCcJmGYpJo2vgTZycviMBK4BTt2cR1bOcscbZmsmCcQs4kVjwNNEN6pgrSmbRGqEIDCODC90b3zGBviiaJx1otqoNTUwfTKDliIZN+PyEHk/3f4s7qKC8HCsfkusOYowSDLFLqGIoK77Nj2bAehHD5pPkgwDVece+yx5+fqU6/JDMQCHoibM8tvnPStzPr2gkagLRXfs+dqZX8KTDQJvFN+/6KJaifV1ONoZ4TG90RlZ44SFtyQ3S6+RXrl+tXrHbZIZwLytA8W9jrv3NmbzAfaw3OwyS0sC5bptT1UwR4AZ21w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqgWbiFyNWV1bxRaGMJe3NqL+OtN19RYTJsjklX3wkU=;
 b=kOgo2V6EeK4Fyi3iZiy9GE/Mcsvz5Tc9qcbzpEuqN1C4fEsjcQCx7rP1UFNr6hzk5QFw2BGOwDokaK6qCGdY7NrxdMuvGIShvBKBNC7Q54UDFYRbwSVgDRBGALrh8HNEXNv/h+QTRro24EtffPN1Zmm6OUqDrY/kIu6KW7HUoUI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK2PR0401MB1953.apcprd04.prod.outlook.com (2603:1096:202:9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 01:29:17 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f%3]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 01:29:17 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     linux-mips@vger.kernel.org
Cc:     macro@orcam.me.uk, jiaxun.yang@flygoat.com, f4bug@amsat.org,
        tsbogend@alpha.franken.de, YunQiang Su <yunqiang.su@cipunited.com>,
        stable@vger.kernel.org
Subject: [PATCH v8] MIPS: force use FR=0 for FPXX binaries
Date:   Mon, 22 Mar 2021 01:28:59 +0000
Message-Id: <20210322012859.17083-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:202:2e::16) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR06CA0004.apcprd06.prod.outlook.com (2603:1096:202:2e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 01:29:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7f95edb-08ae-4654-6312-08d8ecd1e8ed
X-MS-TrafficTypeDiagnostic: HK2PR0401MB1953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK2PR0401MB195356C44506838922AD1D6AF2659@HK2PR0401MB1953.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azS9IyU+J6cPrq1lOB3jvHJ/38f6JoKo4fd1Y9En2ToPS+0ok1PCPfb6oZGQd1npFvHlKELjOZ7YqY9gJUN0XfXsKIWUQAak0RI2oxrexcvmB9FNZktPo+w720mPn05Tme/ZuEDhPbI7aoqkZiwCOUeBFc9LQdZGP6Xf2L+HxZgJ2TQoFUtfPAcdu7CaUTbIJ1HmxAM3P6NU5nlEFjL/+fEoAPEA8QG84JI0HW7u3xrrx9DCYPTLyii8z6N87aYJsZUHDs1PBovng2V4B3cjRajXGEmqL+gnvahOxrND6HevS08afNjwdvT4aCqEJ1MAKbt/w/mGKnwIkJdN6T1xZELhAqbD5NM8p3mrJ5Yyz574uoBYWpWd0ASnFC4cJKutZvVoREdBbywVH0g6KieoY5aK6aaRc4hV8ROIQN41d0O40LTCZ8Uvf2McHZtBGq8uqB2p/Zf1h03a15Yd1284Awx6dKsZV41nlBj9E0uo37s3OQv1MLHyFvWzHwPKh4MGRqh2GQJXO+BZ3YaH6BL206vi4t7xodsfgtUX2FFj3U1WQuOiTrWqk5Dozf4GyuWozm4G69Q5bDjQLvBz9uUj+E003vIVn20XtBXxEkqiX9NxKMrXS92J8OnwWkek/eYMBPlM7w2Of3PQbbBNAUwFks95UXoj5J6QFJ/6/g0dD6GaTtTXB8ud7epEScleAMbx1K+AS/qeYVir1LJRGoYqdoRyxhgLDr72J9s0tOX2Xa3FUf0bv9xLMEdl5XhNVow1bxA0/UE7x0kcJquPy1vMPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(346002)(366004)(376002)(136003)(478600001)(38100700001)(69590400012)(4326008)(83380400001)(6506007)(86362001)(36756003)(6486002)(52116002)(6666004)(8676002)(8936002)(5660300002)(66946007)(6512007)(1076003)(6916009)(66556008)(66476007)(2906002)(966005)(316002)(16526019)(186003)(26005)(956004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k5IahIS89LpVoYCI6Y+CmoSvJWxOiDZNrNxyPLixN0q1bUAYv1+JPXm3SAGk?=
 =?us-ascii?Q?PPeEo9M3266TbmYbxhd58uWjC77/H7Bp6Zmk96GALnrvngA2vdZtsnDB6FfS?=
 =?us-ascii?Q?9EsJh6icDPrIV/D317MHeRJfDjJ8J5jUZ6wEOZaA4hXP8f3S6RWVSzORh6mZ?=
 =?us-ascii?Q?EUxRDSozX33QIgcUzhNX7kr3AbRXeMrYVcqCDPTXkQwy/DyDfat3zkLU66YR?=
 =?us-ascii?Q?x9o2nnab/Z2cONr7hSRjVmLmKpaTbnJLEMZJDvCnxRMEIzDZJKrV5Av2g8cs?=
 =?us-ascii?Q?vC1YLpqsVu9Q8/qswnc/Zmt79gVZrRuYL46eY/KqiMTP+yjUk1T2uD4IeS1g?=
 =?us-ascii?Q?0PDGeN7va60pwKQApKPa8hDd/epx+tpjUruVqov+9oFsjIR65KuR6otAgQxH?=
 =?us-ascii?Q?KhOXfGC9Qjwi3WlltF92UURFsXf/qZElrTArOB7kvxGWRK8Yi7TCAmF4eLJ2?=
 =?us-ascii?Q?sNkFf27bqT0tzcYyXededY4IQAcPGR5ZpEbjEAhrP1uqt/ruiMGuRoOUjZ/L?=
 =?us-ascii?Q?a8Q4LRwUMxVYJ9r+rhc19NcAapSCqxp1G2u61z1ADQsA6PKzL6NDzos5P9zC?=
 =?us-ascii?Q?DeOMvn3WfBH4EdNn/NG8os8E2TV8tnbfYaXgU+3Xz19SXjSgt1ohQxd/A8j5?=
 =?us-ascii?Q?RSzVhwEE22xFCYVzDwgvLqdXlxX3AbTEcQa4B0/i8MO7QvbeLKFJ6HnrvXb7?=
 =?us-ascii?Q?mIRM/4FK0lROhZpFfgksYNttlKZsPprE4VLA6Nzvj9zcPx3Dte0GTTj1syAM?=
 =?us-ascii?Q?fcv7Ru7boMb+/tOsj0za9OYonsx1qmsA4r7YqlCrlP6RXEp1Mk4gR36CLQPn?=
 =?us-ascii?Q?2AV3LGgOTFjVt0ECD/fxstbtETgdEgzm304wHq1+doU4aXjloCgTxVclqOCF?=
 =?us-ascii?Q?08D48XysSrvcTgBqX5dHs5/mBrvIR2Cu+Qg06NfPOXZYTiP/BRxEn7Z2lUmF?=
 =?us-ascii?Q?XvDLSyVYsmAN9qIOS7gNoTQxChduypwHAskzvI5+VKRyzAD2CUauAFpCc1ku?=
 =?us-ascii?Q?1GlxyPKOZmvuCi79EDTbd8EGg5PjoVjStNJ7sNKssE3xtRZpII2Hk3YIyNv2?=
 =?us-ascii?Q?1UWj7be+Mfk73l/NsrDsW/BSqAkVB1Zgep1QJ39RsPojVxzPGxyZyKf9cSRV?=
 =?us-ascii?Q?EP4sE+2s3cG/y0t6Y3XAvpB0z7wjAD44vP9Ma51bB73tP5rAFufZWClzItuf?=
 =?us-ascii?Q?Zo0rpD3h7apqe5o/zS3ByPl3Sj55o8kPfffA/8c2KatXkR5HLTZyRt+JUOZH?=
 =?us-ascii?Q?TGBmyHeqH1asKZvVz1+iDP0SpDrf7/PjBysz0PzS4UyBhtamcFxVLFsMo3z7?=
 =?us-ascii?Q?ttW43D1pXTkVurh69Vrq++s6?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f95edb-08ae-4654-6312-08d8ecd1e8ed
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 01:29:17.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTxXyzGom2Hd/c15mEsjMcXc06uaZOCt0pK08O66yXp4V4L0Cc7r0AleKSeYyv4ZirGdo0SfExjyatwmJXq/Ly/Fa81ROy8K1T73JKid7Aw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR0401MB1953
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

