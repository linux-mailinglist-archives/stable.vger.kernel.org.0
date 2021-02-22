Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E97320FD6
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 04:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBVDpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 22:45:32 -0500
Received: from mail-eopbgr1310100.outbound.protection.outlook.com ([40.107.131.100]:15252
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229952AbhBVDpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 22:45:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9s+OH66cuwpApKfOGvyNLLYTXs9qhhLoOK4VHw6DNtGuH7B9kjT6ckcrEmC4782oAGvqm4Y6zr1mYDTAwweKR/mHU0BP3DgaaR+Z6VVXRDTwgky+z1kovpaJoOvdAC/gJ25rl0B87dOSL0m+goK0Fen79FxVG/eFEbho+3q3LaRkMSDrVPlwgY+BJQ2gOi08TDxB/c55E2U71bLsIy7YZBlPB8zWb2U5IMysXm/lDelHepY9ZnQOF4CqTgwePHA/ZbG7DE7j/koZ2EOPMSBQc0sB6EN6CrmWuHH/CNPTG3N+BSGVl/IuUG76gitd+C9LvAWtNjIeaHm4K8d6eptyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+vJa9hf2XU3IDr49xIraV2wsfTbpeVGRcMLW1wCECM=;
 b=IPt44M6XXGTbWmDmxeag+4KUp/zpgqbF8ExMk/QcIRwJcgFPzIiOmyQ/4psbxrxCcuWCZaTs3OnJ/XUs1KX9HYH+QGJQn765zv1inMwg+TQ3hP4l5ehe4YNSklZvWiMaiYp3nUWDyDgf2J2f26UNe4KA4OCGUMC2/8j/3zqgOaUxat+qnFUeOGNW1Ul3FWgoCaaKCThduHCc/p2kajIkR4ogZ5nLJDh964shvpvOq4CJMWrooxr2EucZcUoWs4EkCrQMF0qDI1fgmqH4QgucTnppzUsLeGfbMJrOfJh2DLRWQaItFm9bWl5+dTN+wmiAiuWnGr3zmcE2GqK2groa+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+vJa9hf2XU3IDr49xIraV2wsfTbpeVGRcMLW1wCECM=;
 b=iqHW0c0m10kQeTWy2K6v+Ktr5OG1Wmw+3kg9RkwFuROFNT3L/vJC6DxjpdgH3r4/b+7j9Mh64af48wdBA4l7JZm01WUJeYFL8mhGW7K2o/ylFWzRHGvgFdevbSkJy3NpfbjEHCn+YenEV2CJFZ3WT+J2FDWXAolMyVhbQUKp48E=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB2258.apcprd04.prod.outlook.com (2603:1096:203:48::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Mon, 22 Feb
 2021 03:43:54 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%5]) with mapi id 15.20.3868.032; Mon, 22 Feb 2021
 03:43:54 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, jiaxun.yang@flygoat.com,
        macro@orcam.me.uk
Cc:     linux-mips@vger.kernel.org,
        YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Subject: [PATCH v4] MIPS: introduce config option to force use FR=0 for FPXX binary
Date:   Mon, 22 Feb 2021 03:43:42 +0000
Message-Id: <20210222034342.13136-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR0401CA0018.apcprd04.prod.outlook.com
 (2603:1096:202:2::28) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR0401CA0018.apcprd04.prod.outlook.com (2603:1096:202:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 03:43:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2447c640-cd5e-46f9-6d82-08d8d6e413b6
X-MS-TrafficTypeDiagnostic: HK0PR04MB2258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB2258A0960A44AD09281B5D72F2819@HK0PR04MB2258.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpHg8ClxLxU6TjyiJwFerqaVLRpKShom0/ba2TgqbvOrp8GAwNLVRx24PnYQX3zvL+cbbqQFa4n1Z5FLni2pCPFZl6BhRfXx6ucyWIDoylKrw9NZvfuTuNL05qVPWJ6pbmotg9w18HiznD9RmOtH3TSMTSPbGDwaeaY9mciXDoQ2iOq/GwrmVPGoTuLbwnlIGJifwdalHMWXZ+gU7Qf+62RYx7y4E3Qs6YEXAcCHWF5xCsVJniceqfqyva2ckK6C2wvVhEarLLhRvCjaOssXAwKrpBiy0q0+wtXsIZqUJSoY5QKYVdQymnsq0QAZjTagufco+S2xRPz5yk1pxeXx4/0vLuxd8MVrCw5vp69bLoCLUvPANIhLKGPwPeUSHirZuC2mEc2Y/NalcO6T1GtSv2zBWk9G0x4NOYJgXSnZb9/nOnVjdaMpUqWInnz/fcSXtDOrXMZWccF6YREMYXoV/JDGv06NR3i5d3qzN1D203NaJWRKNmNrFsR/yB2X59P3gJyHaXz6qgN4nyEIFX8WExuLtgztqCMmnyFnpNPBXUjocHmWEI0kkOIZaeHsie7MEwPBSQmLTX4zozUJprkb0KH2WPOVBp+Y/Kt4v82G5syn2N9Cf7AoBBjLMA4eCoK85Kba5LMu69l6CE8LK2wWCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(346002)(136003)(396003)(376002)(69590400012)(86362001)(2906002)(186003)(26005)(16526019)(52116002)(478600001)(6506007)(966005)(4326008)(8936002)(6486002)(83380400001)(8676002)(316002)(36756003)(1076003)(2616005)(66556008)(956004)(66476007)(66946007)(5660300002)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: f34dXcLbQoGZSmW18NYid1a63FTsEX5qDN1/zVjvlmD+VfqK9y2Oq1UtiwrQJgdlIPOcfbsvHJ07Z7Z3SPxeo0VZWFDlfiEu8S+YEJmQXAfubD0q6hvmEVnjWrxGecyLb+yLN7I1nxOrvwoeI8mZOIqUJ4OAqCB0f3MKS42yRvhXOuF/t0GRwq3BvFO3wTM/on7V1fuNoBipuz7DZdEnTcRTbNpiUlnghCA30DZbyr1paLbSEfgfnfSWqjaJOxiNQ0feynyUBGALLT9XfExSP5F9DwPt94tcVmfgOtGec5vk6CjRi22JAPlW8r4ZiIsbPdlVwt1deh3GgXVyJP5lr8KQluHGEpn60RDFc423A1jUmADMtAzeLQUl4ZlJBCkvvGapi3xpB4GTsLd7WOOi99z5Dg9pcUdyAdQnaLiQMLtcv4kk49+LDNgCvWNmtqQkj05XIS8ceMp7OsCwjs5xWbO4lMPZ/U5ZjNN2k0jlD+XGztbLDLhiC2sYtD0lPtmRIv/rnGblJxfy5oM9M/WAy5jgMXM8jk/eG8R1gQgOqqb9PXB2MbdN8Btmf90mxcbf9OOpe0t+1Lc7bPj4TZEybvsuAc415WoYhW2nz3pbra70I6p5jxnrrn7OmoR2bzJ035RshEDQvJpthuGljt91ZREieNMYhE6GrRE4DM4kPPkWzvD0P46Fs3MXV8Dy7c7ufLhsPBJy3Gbsh95SKbPW5Umh6Cz2KbhmYL1eo/O/rB0s8TWkGLy5XMsXZuxJFLD+
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2447c640-cd5e-46f9-6d82-08d8d6e413b6
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 03:43:54.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: om7AwsUjGByX1V1p/O9UlkrC5ib9lL1k0kiATXJDve597LykOjkBtaWeUVK2oix5HIslNWu83+GSQDa+2+TMYtS/DXQEU3ik8aJdHwcNQvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB2258
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

some binary, for example the output of golang, may be mark as FPXX,
while in fact they are still FP32.

Since FPXX binary can work with both FR=1 and FR=0, we introduce a
config option CONFIG_MIPS_O32_FPXX_USE_FR0 to force it to use FR=0 here.

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

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
index 7b045d2a0b51..443ced26ee60 100644
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
+#if CONFIG_MIPS_O32_FPXX_USE_FR0
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

