Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F89320464
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 09:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhBTIOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 03:14:22 -0500
Received: from mail-eopbgr1320118.outbound.protection.outlook.com ([40.107.132.118]:16544
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229803AbhBTIOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 03:14:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iigpyYUKiG74+lBjp8siVSPIVG0BJZgUkIsFOPMTbYoKtZE0o7poK5elR6ehdgBR90QM2D/+8Rg8RsPJSk7vWUQEEeHCur3bLO/EUNWscXXDwtB8SsjrpgYXR71Pmm0xa+E9I8pulpZlYCjnk2LoZeUE4FPeuKOeT4TydYTgGSe4csY76UvsNTNsNqEv2Z6opdv0ST+aIRgCLsFMxlxC4PPNXtDnAwihN/r4eGH1FvRFN/QgZkQavf/I2Jf6MmOmdQetWXNMMviJlCrEP76tilHaajqLHLZkooJHmtwxlIJQvh3yprwagwnXmWSpNpX0jfWrf1RJD6x/3Xz2cWKvHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlPFSeNfoFWSht4ZTxcZun0uX5qf5G+NauqNOH6cxO4=;
 b=AfaNsYzDmEBojnYYHGdTpl4VTTnNb7goV6mYoMFjC1279gTsazVv1B2D2fYOAjYswlWtHPI1V2DnjsoKQF9CLIPZirGjrC4JyAYQPRzGfTu1v7NxhCP6f+4ubkwltq7CTfZqWUfZCpmkvWpxP0Qgunw+O7abi9DiuSPPPh7NBjv+DVJZecyVdxyeIXD+sa6hjrDr4+HkZ9aXozrGE+4d/bWcGZAaimsLVIKp6TeDH9y8UfeGK1QVOKOaAGFxyDydW4Sn9Oq9PPSa/8iH3vJdDqe54m+cjCTYErwCWizZrIYOwSHE6Spv1B5Ag0x0f/gTAwGFISrWzPmS2rE0yWoXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlPFSeNfoFWSht4ZTxcZun0uX5qf5G+NauqNOH6cxO4=;
 b=MT9rq9PMaKNhFxjpOVRfvgUC6g6YCkWUJKo0hBPwXFmMSG3eA6QqD0h3dLRpHCHUF5mL5lIf0v1R4XYOUDc08XH4LsAeBMTxZgxMLti4xA8Incz7SKZHc1g8RPgNMF2saIb+4RSgQPuTLYkFBmY2C2BLUX+JfpRhyW1qKv/BeiM=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB3442.apcprd04.prod.outlook.com (2603:1096:203:86::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 20 Feb
 2021 08:12:44 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%5]) with mapi id 15.20.3868.029; Sat, 20 Feb 2021
 08:12:44 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        jiaxun.yang@flygoat.com
Cc:     YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Subject: [PATCH v3] MIPS: use FR=0 for FPXX binary
Date:   Sat, 20 Feb 2021 08:12:31 +0000
Message-Id: <20210220081231.10648-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR03CA0056.apcprd03.prod.outlook.com
 (2603:1096:202:17::26) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR03CA0056.apcprd03.prod.outlook.com (2603:1096:202:17::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Sat, 20 Feb 2021 08:12:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35a05d08-e8cd-434b-924e-08d8d5774cb2
X-MS-TrafficTypeDiagnostic: HK0PR04MB3442:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB3442D28FC7DC032CC34083CAF2839@HK0PR04MB3442.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72OpfV+qXbGt+v+u5oOy8IFDF+FNEF5kXmPB8jjLTIVcM0E3uBdB9eUfLC6pX1MDJfWtdJ6/mAuuNvz3V1xAzVSfLkFNx/w3xY1Z0RV2rUXaf+ZX38lUKEt+Duy9XDhwJGeqUzg9GyrgylXUla/yM7sl6UZeqafyC/w9SQjZ0uRZeh2JGGcO9LFYgl/O+N/rn0ZO8c08SSwZQbGaU4iY4H9k+NVvmDkcH62YMC5ifJ/D9UqZOa6Mdc6yRIx+Q6/O4bPWKoEDFnPffwpOalcITjgz2NfjNjlmURyKRl+i/hgkrLceA0vlGVTl/eGC5tDng9rhFTzCfkRVA9jZ705itYJV7PbVI0cOWWvkpZHBwf1qGdaMonCaQPVvRinI7kFkjqBhGdwidnJfSBGWomOf+jsSYNYewVqAMQ0NkA8ZK1Tivo0ey4SKmtOydXpeUIjP9nr+t8cg9xmGa0lhkjIjaFyJ/sVEXFaMW34a3tHvf8L8Mq/hAb2t5z2LguP0u9DBMUh7uI5aGTkOKuDHKhz9wSpz5z5ziIQVjSsESvFSYGoBaOYIqegGR4/ZQwqlcqt3yQ8Jh12V8G6QqIjpUCu8SJ3Tp4pZIqlpQZqI60cCkubBPxMYwD/tSqresvybXhn7AFb8F31qejvGWah7SuzklA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(366004)(376002)(396003)(136003)(6666004)(69590400012)(66946007)(8676002)(16526019)(1076003)(956004)(66476007)(6512007)(6506007)(5660300002)(6486002)(186003)(2616005)(966005)(2906002)(8936002)(36756003)(86362001)(83380400001)(26005)(478600001)(52116002)(316002)(66556008)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?busTkndrnElYCyNp3tQV+0G/uTmcN3N+f32Vn48MQcNNZylPMRAg8lMI3C/G?=
 =?us-ascii?Q?ATYK3YV4td2w06Y8vj19gaBzGuWPMZmdoMZ9vWeonmLn64ZSLNSHWarKAToE?=
 =?us-ascii?Q?aNUbUjUrCIjugWXCULFwBnde56hnpY4TOlIW23J8qDdJGnr2/B6kznFJDUKZ?=
 =?us-ascii?Q?xY4q4ZewxW9PBlzyAKN7yB2RZ80f9CF6khksdunVNhlrf2b/YGL5/yElXgB3?=
 =?us-ascii?Q?CdTomjlpeE4BhDEQrPUfVtLOi4rJ+Zla4XjWFfGuLlXvi6Kljr47V6RATnPn?=
 =?us-ascii?Q?q/a7/NTgaXcChDbJmyGTN+WOSiAOEET4O4l3xeWBjstmaeIbjKCQrhIFuUp6?=
 =?us-ascii?Q?pl+CSJz35PRUkmat/VOpQnZ+DPk4IEsvxhY+sRQYizhAB6XUsClbdddIQRqv?=
 =?us-ascii?Q?3GYnKmkFNmsZqT4ifWvC7I+5xDuec3wq+DWs/ttzQFuorsWUG12evaGt9wOi?=
 =?us-ascii?Q?rnnHyFsQjN/xdAdUmhC9jlUh0oeEVlzkZP6ieEJuU3B+/kebcA/inaR8X9YG?=
 =?us-ascii?Q?QZumoybDF8cLdcQtrm/Q8VFd3y4rnAgpsPcmK+0HO8sapii3Y2Xt81m2vyCv?=
 =?us-ascii?Q?Jc9kARHGutNOG6XHlCNPghtlGhf7Q5PRf2W1rahyP1rl26YN7nx7L3cJJ4bq?=
 =?us-ascii?Q?lPqgbYzmCj3jpi3jBIlykbmgvots/ynEDwMq9nDtpAEhr3Qtbyk2Wh7tLaB5?=
 =?us-ascii?Q?Lc+y0S3x95Mt3wdckTgvb60ONzkCiHlm6GX50utWdVuT5v1w6d9Fup7UUNj+?=
 =?us-ascii?Q?OjZ9ZtZwBP2EvCF3J35nszC3lftsSC6xHxbcveRRbdct4z+FhhkBXJPZbgfC?=
 =?us-ascii?Q?o9YyBcYG6234O1xLWUwVqp/agwd9Lg3kZPRj97S+COsiqbt/3BivOE61+l/G?=
 =?us-ascii?Q?10AdzeyZoTPZsZ0+eUBlVUFJPU6rXIp6ACz8+8JiVjI631Q1PcrhGlNulRv9?=
 =?us-ascii?Q?AiL89XwZj72D+UdbaWxtBi0ZN00BVQY/7wZB5ZZ95Gcsblrkd+XdkNUCwx2N?=
 =?us-ascii?Q?QdT6rx/nD4qPyPm3k4S4lacP6TS+iN8jDA6LDXCK+uXZZq71O32CF2NKW3bR?=
 =?us-ascii?Q?09czJcmgpmKOq+wFpicxZ4yjVvK23izttcBp9+w+lVHWMocI0VGo3gwfxhoA?=
 =?us-ascii?Q?Uex8YTxCI+MuGyfBEJrvo5Z6DTOm35N63d1nXFxIqt4LijNQs1QXQawJUYJb?=
 =?us-ascii?Q?kFCOfPDFNW2JVeArooOFMA7Vv9fmdcHGHkdkZOYSfZuLhrY164gAdZbazc2v?=
 =?us-ascii?Q?4na4VPmNjLlexinbKE7KBIYNH/eNF/mfkunHRyLtlBb67I6KzsHP8uUcVe2h?=
 =?us-ascii?Q?RAWusurkPTxEuDS2BIRj4K9+?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a05d08-e8cd-434b-924e-08d8d5774cb2
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2021 08:12:44.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sUeetOcimrhtvfIfmepcJAwluKDX4UB9HsOsT6OSPzGsF1xWYVh4EJMVF3qYdxAgWOaq3bzm5SDXWbRgfN+alBmmPz2e1VYp5FYgyc9nejY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB3442
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

some binary, for example the output of golang, may be mark as FPXX,
while in fact they are still FP32.

Since FPXX binary can work with both FR=1 and FR=0, we force it to
use FR=0 here.

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

v2->v3:
	commit message: add Signed-off-by and Cc to stable.

v1->v2:
	Fix bad commit message: in fact, we are switching to FR=0

Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
Cc: stable@vger.kernel.org # 4.19+
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

