Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83C232272E
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 09:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhBWImj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 03:42:39 -0500
Received: from mail-eopbgr1320105.outbound.protection.outlook.com ([40.107.132.105]:27718
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232054AbhBWImj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 03:42:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neRYyw4ST5IjBzdy75KZufkcY6HHhLVgPMaEk4sQY46H29v8mG7lqYIQFSI2a9YXF3Gyj4TsM36ROZFLrD0sl+wX6B0eGty8tbgmveyHWLb3addspw3xA2zVJ7dyEbde/mUc+U8GOa6zEtkx2ljsNfDze1M50Jj7du/JXeDp6OQ7JqvboVtLLmKl6LHIsn+6YhsbBPwzXqK7wa1idWoU3fpfIozhRDc5GQ36p9vOK5OfoMJHv6LpSASoHF3KuHkypI0ecxEiAx/DnwmRnlj2DtCTPVC/scufn5rFlcsTWo2AGDAxKvY+A2t2R1jIbsQKeufKcsPKtFegoUInZBUKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRzTOLozD2+GmOLIG4rzAWnEQh+qTnWV3UcLHAF3Vw8=;
 b=g24iwtI6bIFmzXwqgoJfRcAAccbh3KCBQWwx/3qqdE43BXvB6hdji9IMCKNhFWq+sLH+dVgws79glD+S6E6SJxVEhNJd9/CSBQ/+23rSZGyTwuoL9AnMAKQXWkwvJ+gUSNV70UYFnA69EksI9dKBE/T4MlybVpqaiqcISLYhAEtmjd/iYj1nDWQ1YKKTMdLuhWFxHGxxP7ASLKkkFYrp4qkxeIXN7ttCas3MiO+xVWitEmZqtJdPl9gR8ySpqd6bzAUICzB2vjrgecgVPQMMCVB4Lf4ixCs61bE2zswdpUuIG3efHDaK/9YL3T5Xg+4V4H4VS0tRFoWHtE2KHzqn0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRzTOLozD2+GmOLIG4rzAWnEQh+qTnWV3UcLHAF3Vw8=;
 b=weMWllObg505MUxcLSCIvb8aPe28Kfod/31z5YwSPad783CeQ2v/G8ELPou8nErMrNnmG9C5v4iiyJpfZDz4tmqMM99Mg1r+o2GMi/L1Dseo7oFB2oc+zcwzqeWwVbqKQQDtLL3mR1uU7cUkozf3lYoXEZSNYrPSLUJyuyl05dI=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB3444.apcprd04.prod.outlook.com (2603:1096:203:8d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Tue, 23 Feb
 2021 08:41:01 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 08:41:01 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, jiaxun.yang@flygoat.com,
        macro@orcam.me.uk, syq@debian.org
Cc:     linux-mips@vger.kernel.org,
        YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Subject: [PATCH v5] MIPS: introduce config option to force use FR=0 for FPXX binary
Date:   Tue, 23 Feb 2021 08:40:49 +0000
Message-Id: <20210223084049.16475-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HKAPR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:203:d0::24) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HKAPR04CA0014.apcprd04.prod.outlook.com (2603:1096:203:d0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 08:41:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05600c75-2e5a-4bfa-70a7-08d8d7d6bf51
X-MS-TrafficTypeDiagnostic: HK0PR04MB3444:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB34445DBE3DEA9E35E5A488DFF2809@HK0PR04MB3444.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gP3fcG2i++eeZte0tTpes1CbU+oRTo9ZuJ6YC/fnwTSaaD9hSJp53TxT96zV4psI6pTDD/Fxecvsml+6GkACXbcxT89q9Kq2bkgQk+1QhitZeianzpErjVEogyUIJFrdZRROX5V9X1wTaqOgIPAfKpOTCI6p18o183gwdau4O/e+YVFyKV4eEiXKgfNpOJYi1EZTEcgKY/2WV+c/QfSp1+bGT0cZU+F/4SqxABENHmkyE7yzoTpFadNnUS2/NNVQrF3Sw7DUTR7IQ0DYERc7hWdVrrwyOTbvjPgAp+JlrXe2zGPl6VR0P1Zp+VJPOMpBjO5EPNzS5m9xDuDa97GfCRTQz1VA0dDgtOpyFgEChH7iIrUHxjr3IODvRRXqDF/+jNZ63D+A/K3ZDCVoXOC9ZLaYLYY/cc6d3CKA/ykBZeSFh+rFIZYUrFiAB+h7tx+AsF5cBWhLwe9qfhFg303n10Yw9DUtQpKSX+6ztSik/LwcQuVyP++4gop5k9oA0hpbpKbIm3q/l7fUNIpu5RFz04ljGIVTehamM0V6Lp8VUuk5rVjMdNuLJxjTgvQuFXf2Xiq3wPuZBlO9icfgjh/GcX0XEoMGk+KLf0gbWr1af33jXOWBFnbvXu/LCSUG/tEYvTaKreF1WtRBrv9hRp1Ptw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39830400003)(346002)(6666004)(6506007)(8936002)(6512007)(966005)(86362001)(5660300002)(2616005)(26005)(16526019)(186003)(1076003)(956004)(36756003)(2906002)(66476007)(8676002)(69590400012)(52116002)(83380400001)(316002)(66556008)(66946007)(478600001)(4326008)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8CIDHE60kQ1cQAYjg/GG0ZwpvzLJpOK375BxOOYLXOucD+2C1KeDY5V1MNgk?=
 =?us-ascii?Q?aH6soQBOQaF+7r2vNuWSj/HbyqS1r9dMLa9eMpCpx/p9u2mfZzK0K4aMGDo+?=
 =?us-ascii?Q?cTau4UxZ+4h9tivTgaaBBOzCUtals4mItMtROLVRMrcw9LbvmHTiDX2Zj2Ze?=
 =?us-ascii?Q?OXxBJccLbZlD5USGCE/icpaw1uGkM/EdpL1MXM2OAZmqJRC8+kWubly84TA3?=
 =?us-ascii?Q?QNaegryqkmLkkJ0j27668xwV4pdePdsujz8TpXdU0mvWCCjt/l4VoZGCw4XU?=
 =?us-ascii?Q?DYPmt6YSmGFD8yvUOO9InDVT1c8+gpM4RGhC1C5kfi0bas/klsDKzWhar4Nw?=
 =?us-ascii?Q?1xF9/Oy0Ge3YjMe9Z91BiQx6vC8DSwpdB3jt8L49Pl7qUYNzHyavh9eU25kz?=
 =?us-ascii?Q?DLROuL0Q9Es474nk0sr3zPkBAE/wE399Dqvdo2OwDqJjIYuRweWQISAmhDmb?=
 =?us-ascii?Q?2Ob/kF3yj8RiCgKrhQOWbnLPycnsP3BFQjOMtI6iHKmZjAwtnzPVxbilM9Ym?=
 =?us-ascii?Q?caH8bB1nualzgM7zoWtGHmFrs9zMiY6BBBp7j9q4YtVbx8Xm2n7aOUm/WDn2?=
 =?us-ascii?Q?/1oBWAwSZPiXzixAjhhyCDCKEIo1LfDlJd92kJiBtW3nEiUpg2vtg/sRSWxG?=
 =?us-ascii?Q?nncWTsGGMLyUvw+e9zUyC6Lrqrbx/GdeWmh5l6XjEaYXfFOqDcB2EPeOq7w3?=
 =?us-ascii?Q?iYBZ6du1f+0DNxhpSM7UtVD/V/SGbdBev4AUzxiH8ProID4mAIttnLUwOhFN?=
 =?us-ascii?Q?6k0VjYdPaQp1nu/ZNUhY0qs0ZzuaAmWAe7th2k0mGQ1IyI0Faqs9sBmagSU/?=
 =?us-ascii?Q?RRfJYXD8q3UJDROVkO12Z0NrtKi9Rbd+tg5T6d+WlYyGxCdC41ygQT0OIr8c?=
 =?us-ascii?Q?oBwo1F/91nxnzZNTGsJFgZiqSokDc8XShhU13xZAqd3dK+83gcQxpcC4TLon?=
 =?us-ascii?Q?v/6esksSd1sp1cHK8shsEc9tjUvONIGrDxRpPH5wR453z9mzQcpKzQropuor?=
 =?us-ascii?Q?WfoxmSNO8SQk/MU4uMEby6ocTlVqWS3wbfUA7Q1yX6zkuQH/1BQFhRgpiDBU?=
 =?us-ascii?Q?iUKfYiM/+QsbGKb2Mir0aLCU7oq2sVLSz6NF3J/VT01GdJL90xUR9kYPk40q?=
 =?us-ascii?Q?hkZ1Kh65d6FqpQGBwMSRqoBKKWoFN/JjVJevbRJVdm+Eg/4cQ4f1ulf4wKON?=
 =?us-ascii?Q?qu8nbTfLgctfHsUtXWHVvSCVe1A+myCKA2mRiSsPskntfmjJGabUL6V5NiY+?=
 =?us-ascii?Q?Nw6it8vQGEmEj79sHQCxEsxNhyZO4bGGmpUXp2lzjZ8mW9HKDS4LftiIYOgP?=
 =?us-ascii?Q?Nj9N8DJdDF2XFLUJm5Z+L2H/?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05600c75-2e5a-4bfa-70a7-08d8d7d6bf51
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 08:41:00.9885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y30Ph/IxJG56qUs60lxLeL+lSjKUMqfvFzr8qOojwT07nQfaVpPeamJ7z5AGB66a23DFB5QgSm2Bc9b7lwWjNsX/GKlWNimX20m6q+dTW2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB3444
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

some binary, for example the output of golang, may be mark as FPXX,
while in fact they are still FP32.

Since FPXX binary can work with both FR=1 and FR=0, we introduce a
config option CONFIG_MIPS_O32_FPXX_USE_FR0 to force it to use FR=0 here.

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

v4->v5:
	Fix CONFIG_MIPS_O32_FPXX_USE_FR0 usage: if -> ifdef

v3->v4:
	introduce a config option: CONFIG_MIPS_O32_FPXX_USE_FR0

v2->v3:
	commit message: add Signed-off-by and Cc to stable.

v1->v2:
	Fix bad commit message: in fact, we are switching to FR=0

Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
Cc: stable@vger.kernel.org # 4.19+
---
 arch/mips/Kconfig      | 11 +++++++++++
 arch/mips/kernel/elf.c | 13 ++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 0a17bedf4f0d..442db620636f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3100,6 +3100,17 @@ config MIPS_O32_FP64_SUPPORT
 
 	  If unsure, say N.
 
+config MIPS_O32_FPXX_USE_FR0
+	bool "Use FR=0 mode for O32 FPXX binaries" if !CPU_MIPSR6
+	depends on MIPS_O32_FP64_SUPPORT
+	help
+	  O32 FPXX can works on both FR=0 and FR=1 mode, so by default, the
+	  mode preferred by hardware is used.
+
+	  While some binaries may be marked as FPXX by mistake, for example
+	  output of golang: they are in fact FP32 mode. To compatiable with
+	  these binaries, we should use FR=0 mode for them.
+
 config USE_OF
 	bool
 	select OF
diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 7b045d2a0b51..54b40b2b40b7 100644
--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -234,9 +234,10 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 *   fpxx case. This is because, in any-ABI (or no-ABI) we have no FPU
 	 *   instructions so we don't care about the mode. We will simply use
 	 *   the one preferred by the hardware. In fpxx case, that ABI can
-	 *   handle both FR=1 and FR=0, so, again, we simply choose the one
-	 *   preferred by the hardware. Next, if we only use single-precision
-	 *   FPU instructions, and the default ABI FPU mode is not good
+	 *   handle both FR=1 and FR=0. Here, we may need to use FR=0, because
+	 *   some binaries may be mark as FPXX by mistake (ie, output of golang).
+	 * - If we only use single-precision FPU instructions,
+	 *   and the default ABI FPU mode is not good
 	 *   (ie single + any ABI combination), we set again the FPU mode to the
 	 *   one is preferred by the hardware. Next, if we know that the code
 	 *   will only use single-precision instructions, shown by single being
@@ -248,8 +249,14 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 */
 	if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
 		state->overall_fp_mode = FP_FRE;
+#ifdef CONFIG_MIPS_O32_FPXX_USE_FR0
+	else if (prog_req.fr1 && prog_req.frdefault)
+		state->overall_fp_mode = FP_FR0;
+	else if (prog_req.single && !prog_req.frdefault)
+#else
 	else if ((prog_req.fr1 && prog_req.frdefault) ||
 		 (prog_req.single && !prog_req.frdefault))
+#endif
 		/* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
 		state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
 					  cpu_has_mips_r2_r6) ?
-- 
2.20.1

