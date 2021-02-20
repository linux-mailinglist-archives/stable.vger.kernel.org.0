Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19016320426
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 07:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhBTGSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 01:18:30 -0500
Received: from mail-eopbgr1320137.outbound.protection.outlook.com ([40.107.132.137]:44384
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229470AbhBTGSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 01:18:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSpNWTV1nNnLHFOpJFwSFypbbWL2LdgNol+scVc86Vooot5U15zQvy0Y3gXMuHYIEDxKJPtli/ROYSGfL0D/TeL5BFwt9D3iU1CSewxlIxLMdAw1RFLsKRSVsgZ7k9RDDoR/9UgKYXY/b7oAQCvAlowlGTNOKdY6//VGssSfL1Q8lxoICBdkyAO/lHQh3dPtA7UJRdA6oFdmETn7hdqs1SOC6rBGFGfx3JmB6Uv6smgJBLSP8NCKdFVi+F9IKHN+wFpQtFIARE39058D5qjq6UpQmYNm+ku9Z2f+pUis2IWH4nHo557l8JfNI9VyOvACxsSQO651VyMiOCRRSp01Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RT0faO0HpIy2YHHHXUJxFIQT7C4OIKNyTpTTzmMkuwQ=;
 b=MlvfGETR38OjPORuQcC8uv+jkNKgpRnRhJnOSoPZfSjUA1PetA4B4l1DLUv4E3NoIn1VYzhFGeEXtJyWGCOXZWheeX2/VEAhCybB76Yu46QronxejYcExt5iy4jPK5AU1l1Umj9tr+nd0tCgjJjggE2YNpVo+E8FJme7rGuONoNsKg6SbfSKGMUx6fJS7X7R5Rn6hev4FP9nvDyiqmyeS3XZQo0ANFTbWBkRGVMBvJsxknwhAhMtFFkA8MSJ0l/sNuUxfCdEsI8FnlER1L0Fivmrxv7gK3YItSDumw1NMH2iYhMLs3ePllkwNSNjVoLzgFf94sVLcRdRqcsCahnVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RT0faO0HpIy2YHHHXUJxFIQT7C4OIKNyTpTTzmMkuwQ=;
 b=DeYccBT2dmwSimnu3QaLb+hyIuZEh2O+RvulapNjcipaHEu+Ypvut72/VCPkMjzTZF42ZP+gFSZVgxl+YL1GinWMCfWO3zBdp8Mu1TAQgGMs5PExktsTr4fHcNaXjRPQhRzMJG7WtvIhOSeP2Zx1NF4JbQ/gAVR/jtsDXOq2rJs=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK2PR04MB3779.apcprd04.prod.outlook.com (2603:1096:202:3a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Sat, 20 Feb
 2021 06:16:52 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%5]) with mapi id 15.20.3868.029; Sat, 20 Feb 2021
 06:16:52 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        jiaxun.yang@flygoat.com
Cc:     stable@vger.kernel.org, YunQiang Su <yunqiang.su@cipunited.com>
Subject: [PATCH] MIPS: use FR=1 for FPXX binary
Date:   Sat, 20 Feb 2021 06:16:35 +0000
Message-Id: <20210220061635.9976-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:202:2::14) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR0401CA0004.apcprd04.prod.outlook.com (2603:1096:202:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Sat, 20 Feb 2021 06:16:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee6e414f-6453-4219-1735-08d8d5671d09
X-MS-TrafficTypeDiagnostic: HK2PR04MB3779:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK2PR04MB37797B9F06689A58CA5EC03EF2839@HK2PR04MB3779.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZA3ha7DNIJyTePntzAaijuiU7pm3phqDOZsc2ACyjTYaNbDN76D5nLNnRL3kgpnRpicdMZCpS/9Fxe2QHICJ/RanY3FpKFti28yxMaGki56oG/YDvlG6x0PfOxjx9qnbHGxLjL99SJZEZLV/h+mEz/5OvhQmlggoeqdowvsbAE9xhHWnual5qxy3BYTbC8dsa6gOf2LpWeHhjIQ+3c7FjNONOjeGa47gV59TxhlKmMJyh50UNSdyBtNppVdYgVJa2d3nk/ToD2xRRjubrItY85YxzTOQ20FjspuBKX2zL+CPQ0rQ/Jn1JbpV2KDggbZ4r4EsrA+WCYAUoiEFQPIyHSH5k1mWmLSwkg0WGjlEH455+m8yeprZYotTnK4ddy1AtaedEMHS22RzKKz0RVzXLeFi96+1riOk6KaKmwLmYSahLF40Z/AVJvr35pkgPjYtdGBNKOzWm1RCWMvhZImhFtSZFx0KG759IeNoLfsR6yUryMI+k5JFNIfkQmZPyL0CgO3JeBLONIeerC/FOevC7WcY6guBGryLbHC2fX6D4Rv8DQXrpSaEu/nVhxAv8Ez2TNzKRn6NSWX7vDgI4QqJvUmej5nrx+9MFozQ6IcotlIqhyjbbeiRiJAOjUr7f5kD0HhyfSImZMErpIdsXV6Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(346002)(39830400003)(8936002)(4326008)(86362001)(478600001)(1076003)(5660300002)(36756003)(2616005)(66556008)(66476007)(956004)(83380400001)(69590400012)(186003)(2906002)(16526019)(6506007)(966005)(6486002)(316002)(6512007)(66946007)(107886003)(26005)(6666004)(52116002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xsKv83YboToGp77LfcqLKNNK9YR/AmcJu+vef33dHbs8SwYQP793+bvnK41l?=
 =?us-ascii?Q?LRv6UZKgV1M8PyOPHUxvHTOTXODISX1VKxs3aX9oTW8p5Qy5JnK/hV0K5dkA?=
 =?us-ascii?Q?18DlSGmEnnq7muLnxx6pnxyJzxi7f6MFvUr3Y0bqiemMUafiqhw2vBefiLUD?=
 =?us-ascii?Q?bHTaw/LHKxYKneovHVw6JtAwSK9/NFpm2vdeXEK8HXGSO+m3cgcOeZfIm/gs?=
 =?us-ascii?Q?hDr8sZv3LSrfVLvDFPl3gGopsghLiMOsoOeCxnitQiJ3c0533Bx6JuclLHPP?=
 =?us-ascii?Q?7RH8PqIVj5dUpDGBaqk3OlYPJwZtv09N92bwjfIcBNFPYR0i/faidCNLu8Wz?=
 =?us-ascii?Q?0iYL5IgdLIHCx1pHODKsAJwIePXz1XzsH73Ul9ErzbaH2RkuMnjHpMjzMRHf?=
 =?us-ascii?Q?+swUChHQjRV40XJgz8dQ99tz+yCITOU9CuowXM1Ro1utOFlj/OIUyogG5XFi?=
 =?us-ascii?Q?A2Q/epHeYoRWQAJ4osprak+NGIkxM5Xt0R/D/BvjJ4nAvMKj8zivS2G71fzz?=
 =?us-ascii?Q?X+aWLVBXnZOzZhUw2WjFyjKdYRsTbPh3zAVv83sqM7o84wB9S8RSbcvhhVBB?=
 =?us-ascii?Q?78Tu94jWHYub5D8B49GpSgYLGQnE2mFOH0xfEh3/ihwZbuDcVq/mjj8KElJT?=
 =?us-ascii?Q?YJZ0mufvKmtjd+tSNFr1Q5C3VJhxPj6g6L74p6p02RV49YQHLidgqjtdOk6R?=
 =?us-ascii?Q?z+E/V1pNW3giM97hXM8DmpJ8kKeMgKKoJpzAPh4/4T0s5WBDt5WzCCEConTU?=
 =?us-ascii?Q?q5LFVau690Wqyscg79IxpUwUjajUvodCJv0Wkg8eVaZYJ3VhltHUQjXnAb+z?=
 =?us-ascii?Q?iNtY5YP7dJt7kPa6izWYViT6IjjTtFRR9v2yIVb1sx1F4MSFTTHzX4liZRNa?=
 =?us-ascii?Q?j+xWo6RBQLstIbpML0f84lktONWye82Yq8xUwycC2oGaWOBgWDTnehFOlQhm?=
 =?us-ascii?Q?X2HV+01ERBe9q/n99Rq3kj8sY8XP5TPHsTcQMOAAUTigsZIJRQC10Oc5vt0i?=
 =?us-ascii?Q?Gk7LD8WgmwPr5jfFDevQDdW2cRHn2WIfBvKC9mmLmVQJCtSQ4SFbM68dkSrx?=
 =?us-ascii?Q?+Nq1DXmSea4E6feg/pkgjOL2Zih6+czIWtJtKLttwnUAk3QMGe3oCDmH5DJZ?=
 =?us-ascii?Q?OGg6rf0P6Kwn5xwJC0AFRaT0ESi0zIxkaoSz7+3bU9CjnVVcwsFrG8y+lyE3?=
 =?us-ascii?Q?wCGvSaArho7276gr8qspURfm3hbsjF1XxjeJcFuwVKGqPdyfh87qgMh/Iw0n?=
 =?us-ascii?Q?vQb1MwRAQ25OXFBQzGDTEvtv8g8WDEwazgauVq27t3kjcCA9XAc2C3aiZ/Hn?=
 =?us-ascii?Q?MmrX0SHyYTxWkS00dd6v+le5?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6e414f-6453-4219-1735-08d8d5671d09
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2021 06:16:52.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBcYHEDbTcnmYJs0bmwnTFX1Dz8zz3WN13TiYAQIs3byKmBTGEuTbNOMq8ZZHD+ZxRc7Qo40mwdy6qUJ4mynslU9b8P6wx28ctxOXs0AbLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR04MB3779
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

some binary, for example the output of golang, may be mark as FPXX,
while in fact they are still FP32.

Since FPXX binary can work with both FR=1 and FR=0, we force it to
use FR=1 here.

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058
---
 arch/mips/kernel/elf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 7b045d2a0b51..bf798ce0ec0e 100644
--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -234,9 +234,10 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 *   fpxx case. This is because, in any-ABI (or no-ABI) we have no FPU
 	 *   instructions so we don't care about the mode. We will simply use
 	 *   the one preferred by the hardware. In fpxx case, that ABI can
-	 *   handle both FR=1 and FR=0, so, again, we simply choose the one
-	 *   preferred by the hardware. Next, if we only use single-precision
-	 *   FPU instructions, and the default ABI FPU mode is not good
+	 *   handle both FR=1 and FR=0. Here, we use FR=0, because some
+	 *   binaries may be mark as FPXX by mistake (ie, output of golang).
+	 * - If we only use single-precision FPU instructions,
+	 *   and the default ABI FPU mode is not good
 	 *   (ie single + any ABI combination), we set again the FPU mode to the
 	 *   one is preferred by the hardware. Next, if we know that the code
 	 *   will only use single-precision instructions, shown by single being
@@ -248,8 +249,9 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
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

