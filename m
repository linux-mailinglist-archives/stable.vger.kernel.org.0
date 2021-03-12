Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C302338A8C
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhCLKtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:49:22 -0500
Received: from mail-eopbgr1320114.outbound.protection.outlook.com ([40.107.132.114]:28011
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233287AbhCLKtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 05:49:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHsU0q8QkQP/MP3btciPfWg4WTuasg2F2MoK1qEH3kPtKHmR235czhV3NPAsdcZzaSiU9akkr5gC6lfZQNxMEnLsKrckQcaXuF0iqc35BTq5zEIwTGbotMY2eqsLBCiWjkNGk/8YCjq7ZjwNu8XAAKb55hB/+6cNPccHC2FLR13zD+H2aklBnwX6vjiw2HeVvdf0aByWxq0IfusmPS4Q/RSMFRADZzffnGo5g8p6CVtxL6k/Qo1YmQ99WJKchWTA9q/xvZfny/bJMFwKlW+ZVN/sTsb1jgz8/y0OdINX/oXsNhbiZ/rteYGzT2Kzj6ct7tp47oiIY0TSDSBp9w6DVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBNunaDRtxLUqHwmP9fqk7SzOmhEj+1m2Rlg2znYQPo=;
 b=c9aQAdAY1CdZp2veoLj5iuzifmCnWQrIcHEkxFfQGe5Su90KjdcyXgBsmdNJ9RDfV79GFBcSjokQiErVsDjNaqS5Pusjj75bIZz91jFPdKeHXIAuQzYgkUo69y054onWQcP4ELZDpM60LDE08EmKxzUDlaZQPANT0+3FsRbwDDJ2cpHZy/k9SgXKIrfqtsbhJLd6agCqgvVZ4Om08T+vxB4srY9FK5XuzjKJ+o5BZOsR2UuPUk6xHqjmZfXBU99RJU3kWYBPuzYgNKpxHLQjRsDCGfUttX7mmQQkgDKmxRmgmgEO6sDByUtF3FIYuPinujGDts+h6TxqMrD9IgTqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBNunaDRtxLUqHwmP9fqk7SzOmhEj+1m2Rlg2znYQPo=;
 b=Fp9iJqnYOsGRRYw+7yQtS+PAKnEamVYevFvQCtbEoTBJ5w0i41bvMVcLu0v8y2n6zgfV4ufv6m0jgrYtEYIKxs8C7qa4nVssY5aEkL3CdOuJdM6MeUBcfwi+zW0D7buyhW4Oboo7HuJPjHG4PEUBYxF03/EnmAn6vr5MFvs10ng=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB3316.apcprd04.prod.outlook.com (2603:1096:203:8f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Fri, 12 Mar
 2021 10:49:12 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%6]) with mapi id 15.20.3890.038; Fri, 12 Mar 2021
 10:49:12 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     linux-mips@vger.kernel.org
Cc:     macro@orcam.me.uk, jiaxun.yang@flygoat.com, f4bug@amsat.org,
        tsbogend@alpha.franken.de, YunQiang Su <yunqiang.su@cipunited.com>,
        stable@vger.kernel.org
Subject: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX binaries
Date:   Fri, 12 Mar 2021 10:48:59 +0000
Message-Id: <20210312104859.16337-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR02CA0181.apcprd02.prod.outlook.com
 (2603:1096:201:21::17) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR02CA0181.apcprd02.prod.outlook.com (2603:1096:201:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 10:49:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e065f069-2aee-4505-da47-08d8e54478f0
X-MS-TrafficTypeDiagnostic: HK0PR04MB3316:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB3316CEE1A4C97ADAD5F3F95AF26F9@HK0PR04MB3316.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Cq5wqwrESad5LhcTOWpnPVV63cgMLL2D8mFwnUPIR0wbFFTi1Lm6OyPOOF3VMvHP4e2Zn/6HOPrRRY/beGfDP7ro2pPnQrzdCYq92wVmx0FDteK3rdi6jrOg+H3vzSr+oIHjlCpiY4T8IPDphu7T2k0kKzsaySAdfAkMugeLl3paokCSZ6kGwpxP2XE5canrel27srqQ2fPRiNyKjuy0iVAsarm++ezW87gkC1afA4kBgogVomi8wif4stuDKtbGLW8FoqsdUM8B2Vbr4AopQ7HWucTYq9JYXjdANiQwV1dJESpV+ZkuXxFd2ahmoY2p31Os8GxEV2DfjdxRAmpw2y2jHMfZHUI8Fzp8WcWrXjuYV4efB1KCLn/iqejdWMBk3PEwVXHhVCdPLfFD0fsOuW4Wo9zLOD7/nEViTVEUKJ7dkD1MV2JD5DMYOIi7ldLrTl8921ZBBZea9nR/8mR7DyFeEYRJ2PnaNG08NzcCvKoxn4dZJbDCHLK1mGKgTqZ/4u5NV9dgQWQpIT8K1Pq9wV4wiULh9MNxowv9ItB8ZACQNIZ/ObAaBK9yscouTNNok4XAJyuzKVuHwz1tqAz4JihZ7QbjPpS1hYxsNhznB+5DAfdXg3Kxkzq8LtHpEIyfeDRxty6u7Qpgzx5OZam6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(346002)(376002)(366004)(136003)(16526019)(6666004)(186003)(36756003)(66476007)(4326008)(66556008)(478600001)(83380400001)(52116002)(5660300002)(8936002)(2616005)(6506007)(66946007)(316002)(956004)(1076003)(8676002)(6512007)(26005)(966005)(69590400012)(6916009)(6486002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WdKpBrVZxZEP6esXmj4KbUdhprFAqJKYZ7qvAH8CdZhNFuuLIrEc5KgcXeI2?=
 =?us-ascii?Q?D2TEU0IPvk640A6b9tels4oHDC+X35QjkTNII08FSugYHaoleWSsGTq/bybj?=
 =?us-ascii?Q?SKg1EXTvsORH3PrPrbcyQK9eR873AaaJJFUAF/w70KI4ShzSkhd+PkOyEB7Y?=
 =?us-ascii?Q?7i7Iv8TZNSjll0XZjq4KPb/tjqA/k+uDXtXL+R4pgWpdYzpAs6BxX9s7CPVV?=
 =?us-ascii?Q?U9dx4ua/u1PzwpaV4idKCK46A0u7CYTHA+Sg1uT6LftGp9OdcyF5KR0cb6ip?=
 =?us-ascii?Q?kkzMNJTDbCciUmj2UYOneWa7bPPdfXdPsKvbfh/dO6BDHxyxGzYTx5rX0+ST?=
 =?us-ascii?Q?PzzzaiqKi2VBTkan9pEBgch0SHhMiBtkBsNvtfXfK3399wVYIpgf+hf3eRx+?=
 =?us-ascii?Q?v+ag0HbHOA3PAwFI+Ppkx6JmvWBxd6uWFCyVnBPqpjvfuQm+BBkDF7Xc/33U?=
 =?us-ascii?Q?qIoyA40ALN2vboKh3s/tWsU0cGtIKSDcgiiXJaLuCsOi0kjyRLzIC/psWN9v?=
 =?us-ascii?Q?gGE5Zj2Got9K9Kw7C5Rd/4PFAepUTF+FLAnwY4mNyKLdMIGRZRB+W6Z279rs?=
 =?us-ascii?Q?pYyzkC1q4nAFLwUei1595WOQqxX63fjEsabnEFBBqxmnxfwXKEIsZPfhrUQC?=
 =?us-ascii?Q?w3jmdEudyvbJ34DibCApktkP0mz5Df9RA0TN5v0PjIXZvdjvPRq6nMhhVCeD?=
 =?us-ascii?Q?T8jkSuyXPubsSAwOhCQmqRkm557ZVENyBqYoUjyAZTOds1K/KdQCSH8H8gWq?=
 =?us-ascii?Q?1YfvVxHzj8uWrZoTmT3BgsDL/4z6ruxoQoBq7EbE7gq9nQ/UsgEPFwM9i6FT?=
 =?us-ascii?Q?7Vsgc01GsMBd2ii/zt357s+Y7l7G/YtslNYanY7Lb5mkWl7HiPNUYrLC72KL?=
 =?us-ascii?Q?62poFsgt6Hud5lUunDZXhadEW6RwejZJptwXlSdCa5R1Rdr7/vNmRPoJfvOB?=
 =?us-ascii?Q?ROfFtQKtpSl+MTShddeMbXyo8T/MHZqoLlzU1Lle/V4WOu5hwLBpKA30W8Yo?=
 =?us-ascii?Q?2Pvito3twaWZsw9Obpfv8k/RLvQM9CBdZ1JymvJHr0qDAkLE9nsZI5ivYr8R?=
 =?us-ascii?Q?slIUWxlzR9wFUC5PE9GybkNQMK8IolfQQD4GJq2JCMV93F7hFwwkFhWtQl/V?=
 =?us-ascii?Q?5jXCcEgQpnSwNpH4xAUlJ4Ts5I2n2ZI0EA2V/M77IEywd2A+hBxT5lIk5fIY?=
 =?us-ascii?Q?uvhnTpRTu41/6VTRNy3tOwshstmgJyRsKMK03ep8/N/NZOhsBTs5F+autm9k?=
 =?us-ascii?Q?ZoVAR1zSE4wvgdyIdpwYxZlpC4kqUkEez7t2gPQ8MK9M1PxdK0D9ql5jbmCV?=
 =?us-ascii?Q?XtVHC1xmeKAHweF7iTkRffRF?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e065f069-2aee-4505-da47-08d8e54478f0
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 10:49:12.4493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5swQG5XDZTuxweo8qWdflZNq/QjkAqPzp9EK+TjxUYGI8Z0lVBOjg2N+uiz5c4DTCixR5jML4e4zFeQ9u0K9wV7OduCVvXSfXZTiCxp83tY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB3316
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

Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
we force it to use FR=0 or FRE (for R6 CPU).

Reference:

https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
Cc: stable@vger.kernel.org # 4.19+
---
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
index 7b045d2a0b51..4d4db619544b 100644
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
+	 *   Here, we need to use FR=0/FRE mode instead of FR=1, because some binaries
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
+		state->overall_fp_mode = cpu_has_mips_r6 ? FP_FRE : FP_FR0;
+	else if (prog_req.single && !prog_req.frdefault)
 		/* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
 		state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
 					  cpu_has_mips_r2_r6) ?
-- 
2.20.1

