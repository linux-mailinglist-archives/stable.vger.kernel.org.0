Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7F9320FCB
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 04:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBVDjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 22:39:41 -0500
Received: from mail-eopbgr1320123.outbound.protection.outlook.com ([40.107.132.123]:43568
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229844AbhBVDjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 22:39:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qv/iKTIw591hg1kaPjLB9hNKOQK8Vx+fbEJYQYcoGhR+4kd6i4xOYIhPK0xdk7c+OgZF2A6IAEuvmI7mtYDpiAzXDbfHDblMlTGQo9UJCVjty73tuJaE3CVl+QaI8/E47TVmY38QsDUNNWxpta5RwhLpYe+MosutZnQEIacIR8s7rJq88fTY3O0/gjes/ArbeOXv7GUEtMguK9ozfyWYlmVK53M1Jrxg+h1HuukHV8IoLwJpLBdlFDmdC35vDT41bW1kLIagHz8rV96Ae8i8N5EWJZmOKseCskkLZyBUJWgKsos/o6HrGAHBlyOb8y7q7BZt/EBXy579HQ5Vg/bQNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+vJa9hf2XU3IDr49xIraV2wsfTbpeVGRcMLW1wCECM=;
 b=mQNhII8f/a0Y47ibzki1yKZy8HgARH8p1KbWb6J5XSYDJ48NsTg2GY7rJdE8sK7T5eM4wfACoMSDlwDGTsQBnh1GXdh8u14/mD8EMma8W0OSzXEYrDUbps5dY60ej96ZVWcNIm5wNaeZpy+Rr2oTinQJ2n7v31vc5jNpt6vXhcdhFS31cXdArau080WvFsMvrpEnYTbF9qfR6QeJn46+xCMMtsPQ9/8WpLL8Ma9g1Ey75imQ1HYeJcWRn8JmGNON5SC7KdFDKs0fS+F3QexK0zLFyokbnchKN7JeeAAHDZslXxhVf7W+R5+duozXIPvk+uOkVYK9AdwuC0MUDmhUEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+vJa9hf2XU3IDr49xIraV2wsfTbpeVGRcMLW1wCECM=;
 b=x7txZwJwk1XS42VkwJ8ItRKhunCOSDGDnWPY5MZgm83wPKMSL+9+kHHBOBMh6zjXrfLsRd4iCxQF8rYtth0H4r+PLapQkzq1NLan0RxnqsvA56hUkcwRkUPWTkARBFFOjUe17GZz3FkPdf36uxGq95tKSGJx1K6ytEPTMkdAiZY=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB2913.apcprd04.prod.outlook.com (2603:1096:203:33::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Mon, 22 Feb
 2021 03:38:04 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%5]) with mapi id 15.20.3868.032; Mon, 22 Feb 2021
 03:38:03 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, macro@orcam.me.uk,
        jiaxun.yang@flygoat.co, linux-mips@vger.kernel.or
Cc:     YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Subject: [PATCH v4] MIPS: use FR=0 for FPXX binary
Date:   Mon, 22 Feb 2021 03:37:49 +0000
Message-Id: <20210222033749.12952-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HKAPR03CA0027.apcprd03.prod.outlook.com
 (2603:1096:203:c9::14) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HKAPR03CA0027.apcprd03.prod.outlook.com (2603:1096:203:c9::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.8 via Frontend Transport; Mon, 22 Feb 2021 03:38:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5f95e4e-9d2f-45b1-c35a-08d8d6e34279
X-MS-TrafficTypeDiagnostic: HK0PR04MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB291375DB00646B18F755E1A5F2819@HK0PR04MB2913.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: my1h8fDHaCe4qkBdKqqLRozkU5sacbf0MPug1Ct5jI0OrhGMNLEJ3GWOdCoICpe5hjnewJg74QryGVb7F843b+VYTD83xEeQphgC9ERrthr6Iz733fybI2aC6uJ7mk4nnQ+26R3AfM3zYqQoCTEToywIuI8nSVIzSWvBBDNVPfSt9Ud7Lsfn6hOw0qzSkJxv4YyA2FQWzMnXKSVB24WbBsIaHjSaohGNOJWGo5m3ml94Ey3Bs2uNCwkC5GanvvWmwmNPgEUoHmt/bTzbEt0G+v/D5S9zIV48rJEf6jtMSiMnNVkyq3wkJ2cGXD1eDN2gZtt1f5I0imJKmYm+23u4wIte54eK5wuU5i0Awex4o2C7rr8Z/mmSm5KlaVXntkR27gKZ3rol3Q70JM2szBd7a5ow9WQTy+Q81wG7rSWz6N0UqHeVDYT6FhkUVqTA6+Brwn9DTzPXWB0BmisjIcBYjlFmZz8+gpYk5QhfcDrwaayCaWWsitm0P/wQvx8FftXcd021O+bSjINAtYlgsyRRG39sRWWnt5VJtKscdN/M3VKTB3+QK4SpzacfLuLTWrnGImJrsvMy+p3joi/fvug2MWO4gWIQvBJTdWTclElbRgXo31SDBri0/JeiQwVZcfIqZLvwZ9HjnTfWB5SjV0pxyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39830400003)(376002)(346002)(66476007)(66556008)(16526019)(186003)(66946007)(8936002)(2616005)(6512007)(4326008)(956004)(36756003)(69590400012)(8676002)(316002)(52116002)(6486002)(1076003)(6666004)(5660300002)(2906002)(6506007)(83380400001)(966005)(26005)(478600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RqJ1U61gOhIRWwFQ3x/77iShlEQQ9aYnXmxAJgVeWWrAxAx4udkFpD2tCtWV?=
 =?us-ascii?Q?aCxPbSpWzKMjXRwvyTEJlJ7DGu5sicJKWs3qeSZ4EGJjK1ZfK1uUboLvvSIa?=
 =?us-ascii?Q?vVjNryklLpsx/ZDb4y9FB27c9aZy2WXMAFvN8l/S1pTIMcPnqMpwAiMe6P0m?=
 =?us-ascii?Q?79lDf2CdMpX6EKASZyghouKUv/oUd1CTgIiuGLZHnrSDQAcCJsGRSlk6CqN6?=
 =?us-ascii?Q?RrYnYieZwdFCbwC7AWWcN73Vb314Yx522s2/+NqbnfFRyjnTwNifFSNu53Ve?=
 =?us-ascii?Q?7fe9dJGNtnpPDuZdt1rm8XI68N5ebWmRXbvFZCBW+WmiDUm+1BXCGQFcs4JL?=
 =?us-ascii?Q?/H752k4Kc5jIuNjD4m1fMuPbz0eOjtND6Kkk2qyhwcZFoR2WuOftZ46dR+gB?=
 =?us-ascii?Q?NIsxhsg52PgckV+M8xDa3nWGY93+Oiz5mUIJJOU4ho9osnNp4sk8Cc+u1kx6?=
 =?us-ascii?Q?FoXhMSajLrYnTw7QOPeZX3DwXBniOypdGsabsxXi1pf+nUWntBKUSe+1C8Af?=
 =?us-ascii?Q?09KqK4Lgq+MJ1VOwND2UrRfIhj4xaOdyxFSkgoAo1R3joaHkq/Z66ge9tT2P?=
 =?us-ascii?Q?as7O8y2Cl3NTuFbxY8hgYMHYAaNioYwLGILsrFOkLTvCkOCTUkIU4wD4mn9h?=
 =?us-ascii?Q?v1G5j21GyHEdeOyQV6F1AYu5ie8uFn4VFx4S49r+txuxiZL02iWAalzMKfHt?=
 =?us-ascii?Q?gAzLIsorV5gyMIzxX+Izjk+Z0KkjPXb460DvFlmzEWdBLhoEyegIC6dCoKR8?=
 =?us-ascii?Q?apOI6uD6IYoDOFWu0+CxhdNG3WY/smvSpBn+VgehBaAZOqffoPmcSRIGN95P?=
 =?us-ascii?Q?q53X3gaVB0WphQjIdrRkiKfYIyqaSzAI1M+DVVkdIjNhglpp9OdMO8vh3PsY?=
 =?us-ascii?Q?U3kI5sQcVDb4pYrCWcUZ0Mj6JT1nWwPdtT8P361jIlF0IIDoGs9nOtmXH0rK?=
 =?us-ascii?Q?q9xPu1J6+YD5rPp1f68UWRXQeW4KTjHaVKO+BCPn1OJ9IHnYM/EZlWAtTQNy?=
 =?us-ascii?Q?hszUWFV8+oSuY5Qizw7Ag1OzqNdns6DNnwrcE7BDF32VwUDyKm2HLbTPBB1O?=
 =?us-ascii?Q?9EseE3eqgpM55Vp6JKx1RJnnxFBF9BTzuGPJlfk7/3VVOJO8A3vEQwPP9IlT?=
 =?us-ascii?Q?QJdNeknr6sQeIXoie8psnQ2NzbXfRMnzf0R3d6Nq9brZzV0IV6oMsoZoDVRk?=
 =?us-ascii?Q?ASqcGB0jBnQolfCov3IktUOY5EfSuvW1EbI/mpwmkXPOM9FI1OjrPgD1dfR9?=
 =?us-ascii?Q?0JvhUotQqg170TZZVrMxEBX3GDYHSAXLevsw/afgQ+zUHMp4g0+TtspJUXL0?=
 =?us-ascii?Q?TymSKJVFODi7LmxcLMFjbtt9?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f95e4e-9d2f-45b1-c35a-08d8d6e34279
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 03:38:03.6023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5jgrnTgWz2yaHNg84+YoOnezk/O6PxaXZb886XWdlgEibgcAz07pmFnJp7HKpOl7ZULVG4nqHhfjJtcZRVHVisNs8+4cAMp5A1qxrs+CmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB2913
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

