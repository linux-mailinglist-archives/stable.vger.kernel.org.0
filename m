Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF832AEA8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 03:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhCBX7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 18:59:41 -0500
Received: from mail-eopbgr1320121.outbound.protection.outlook.com ([40.107.132.121]:13186
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237937AbhCBCcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 21:32:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFLNyTS5MAKsbRKAnmwUj0xOxwBooDkgP+ObGPcVQ2NJlK8uJz+tcapZG4xH4sXyznc8MCSlisluAu9tHqIm55vdL4m05GMF0pAcVZsg5MW1Y77ehMDNzH5DBlvfdV0yz2pN/zmvDJj97sCVuDtbjs6tQHb/BNOBq02Acy31VhIMn1f53h9lFzXvM4ysgowYlQp2C7eTGMflOmVFkDU1hX3NP0r4gl5Icj3qrbnOgAmIED0vvuzrHEmJKMjGHiZadXKsKRns5hLCt7IeGFkA2j2cx4/TRHxHxpnEgFBQDVjq7tDt+qOROBBkP+i21bt+cNjrrBrZxrGOYt4gnoB+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2pvf2kLfdKNbrrImQjuHyi1NnIhQ7Qsn57H9AvPLRQ=;
 b=eP+8DgfK1jkJR8M6w9rvN3x4JdZc78Pp+njiid1X4MI0/+4QLXrQ6qR5YVKfvHXtjja9M/R8nCIPxrJnUUvFQ+DD5A8JFxoAft0/xDzE5d9Ex6QaG89oda0lqFwKQtu4qhgD+Jc0WmKC+b1mFgUUFGIVMyIW+p6dcHJ2V1u5xYr5YGe827BWfmQF19VUfju0nar13CyrJa7twmiDi+0+Rdgk29DNPrxkdoJvPj9hoGfz1PgMLs6kq0eFfeJem048chWcyaD1VfNTY4D4XJ0HHdV+LLgIJUf+EP05n3tdj0+VV0LtirY4lBZv8mu5AIPk1X41Dac7PpR2tdQeeu8iuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2pvf2kLfdKNbrrImQjuHyi1NnIhQ7Qsn57H9AvPLRQ=;
 b=vlOMtrHsmzUrF80TlCg1KT9IorCq1nOFEm0O6Ct64duwLuHiWLmgLfR8FOOqCY6x3yP5x8f27g5M1bARN/8mW4gRhMVjSS/3KO+NStKu1yV3H9YodzYVWu2JRzPPP+MjvuuxzDEmtOl/sN3lq9M4n4gzZ0vrtFTTsRzpoM0Ohg8=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB2705.apcprd04.prod.outlook.com (2603:1096:203:60::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 2 Mar
 2021 02:29:21 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 02:29:21 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, macro@orcam.me.uk,
        jiaxun.yang@flygoat.com
Cc:     linux-mips@vger.kernel.org,
        YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Subject: [PATCH v6] MIPS: force use FR=0 for FPXX binary
Date:   Tue,  2 Mar 2021 02:29:07 +0000
Message-Id: <20210302022907.1835-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HK2PR02CA0153.apcprd02.prod.outlook.com
 (2603:1096:201:1f::13) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HK2PR02CA0153.apcprd02.prod.outlook.com (2603:1096:201:1f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Tue, 2 Mar 2021 02:29:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeffc697-ae8d-4f4c-3014-08d8dd22fc78
X-MS-TrafficTypeDiagnostic: HK0PR04MB2705:
X-MS-Exchange-MinimumUrlDomainAge: googlesource.com#5977
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB27052E004B4AB45F8C669427F2999@HK0PR04MB2705.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeHLYLq4OTbsTs6UiXM7mE2kWeIXSu0bIgz468es1nAXt7s7p7cQVd7PR2bt6ZJKZSPmIBQv3ici2AcWJJL1QaOWsbykZtWEv1iyV0kxNXiyF9i74XexivjE5H88bkAkir+gHfHmfp2tEkReM+Re3Kyl5yK1DEXle+XM504XvjK3ww2wZYgwOp1VpmTAvsvfRZoRI7wH1NtTKakf0OB2oV6puFR43ubaqNxDM7LIUN2+R1MAGtYsTtT64KHNMOw9fNjE6TIyVX3ajW99y4aWHiDw7swbb0tndyLmyQcccgiz6VAAD5mUYYaUvIdQ0I9T7Xu60fM1x1GEHbELPARbBB+sEN7xN+mNmxtFvM8imZWTJ3kFgsnyIdDDeRbtJP0ujL11/RPvKQbzxN03YQjMDX8PRpSDCrgJY+H3HiM06ZGRbHFnKbIqYZiAe/oF2UhVUBFciP381QIxa5Tzj/DlOkcFRybhEEMKZTraZIKiaf+7tpsDHLiHQpokn4nlKQb+K2muQEw9+F4YQYtDAQwShH9YIlkegxbr6MhkZVEUzcGA/6KSD5tj3c3GAWfSNq1O7PpAKSRZEFvBVgKl4rl9pylJPjixvVUSqaDBd+rlWRxbT8ijVipjifjzv7zdWADPXq6RPvdCwCXXBKauMAXdOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39830400003)(396003)(1076003)(16526019)(966005)(186003)(2906002)(66946007)(66556008)(6666004)(6512007)(6486002)(83380400001)(66476007)(8676002)(4326008)(26005)(6506007)(956004)(36756003)(86362001)(69590400012)(52116002)(316002)(8936002)(2616005)(5660300002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6Ca2+9E0zwCLxHYiGZwtp2GgwJiRjpNXufkgde2kjvegjHRfRXWIAxnWHBB0?=
 =?us-ascii?Q?FHZ/AFASwHWejMZrK8GVXRq0pwSdaYrCfnvJsjGc7cLEPHSBImtP38k4OHLR?=
 =?us-ascii?Q?5QmSFuTtAa2FiDanjn2xfazjiv2o+fcmgRmuMGB3KXS75nxlVkOKP0c0B0t8?=
 =?us-ascii?Q?7WXb1zaw96/m/yRK21/OrqbPHP2HkgPZQZfRXIrZpMaviLhUwuHG+fMKvtaE?=
 =?us-ascii?Q?3M7zfwgI9+DU9+lpTK1qSjEV05Q+2sOL6miw5Ow8sxnvi76zSp6DJl/v2OcR?=
 =?us-ascii?Q?sXgNE6ipyEUanScOKzWCU3M7SNM7NIYgLf3gnCMhHY0NitxlrO9HHmXVWjGb?=
 =?us-ascii?Q?qV4AMFxUi1vxopiSI/d1VAnsAuyb4ke2IzvAAInZclScVSZrwj/2Th0KvdKx?=
 =?us-ascii?Q?haol/hTPoauEJgNNIkuklUgppEjy6Qlo9Jb310BrsK0dlHut9NF/qkWVOabl?=
 =?us-ascii?Q?Hl7H/bZ6Lj7chKP/xSuW7DWbbxCQu+a+BUkwla9/3RDiQPQ1uPoFAwKQcyLq?=
 =?us-ascii?Q?hcv38c3D6WcvI4Dwcl6NK0t8FGT0imQlrxKlesVpgs8JjUhKPD41o9BkXHXD?=
 =?us-ascii?Q?53dpVGysg9wzIM4wzWbQ35bQGu+JxwBJo4cIMVM399wBdLT8QpIDw+aEb1KB?=
 =?us-ascii?Q?y1WwQA7ZelMGkUUe7AZflUPwyIRMkAAewPyd8Uc3ysjWAxq6NYdYnPMrVg4i?=
 =?us-ascii?Q?jnV2UDVhpiZEDr6iMLl/6T1eh62kF7ZsBnEqOvCus7uZeESwmvRF87+vVcfR?=
 =?us-ascii?Q?nrzd+fbXFfUiorkcxWV84t8rMIAgfNq6QOGUcwhAdxWRvAkTpOwi2OzLfjHs?=
 =?us-ascii?Q?lkDnuQzdx40VeGVuRhW+IIxUltbPjh4khYZE6slA8i3wDKRTjJBzV/jpq/Bu?=
 =?us-ascii?Q?4Xd4HooKPSIXdcUFG1nsMhbEXNi1S31thZ5Q4cs+Hm0EbkXYKwRIShQwuHwi?=
 =?us-ascii?Q?c1mmgMM09ZQQU2mMgodzTZ+og+aepthTovEVZ3jcmeliEAswKGSIpTUiMfkX?=
 =?us-ascii?Q?5XYM9OdWNiBgCXO50AWFtCEvIwKpp+sdqQNNDfYF5Xn+9wg1uZGbMd0Hvl2d?=
 =?us-ascii?Q?WFe2ElB/BcdATAPSXJJCq/DNK8g52m2l1duZFV526dtHS0meg9Ue5mapVgGg?=
 =?us-ascii?Q?pNCs1QGTq7dh37BUe72XQDhriWveF4JGYXBcOXvlKulIoBDDhijKS3vhUkne?=
 =?us-ascii?Q?CpXZS5mO/dwV/NL1dLqjT5vQk5hWYWQ9WuJbT2LxqdY/CI29sqGTh08JnC4q?=
 =?us-ascii?Q?QtOPU5pgooXjCqijQv4kgmTVcpkkpDcTrWECp4R4beJTgFq1DgEsTwaU4MH4?=
 =?us-ascii?Q?IFYukmvrTXkmB/O1JBzQiRq1?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeffc697-ae8d-4f4c-3014-08d8dd22fc78
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 02:29:21.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DA+ggBJkoMBMFLsJe/X4X7p/8DAjHdvNUGB1tyPcMIsig8Kc45ojyWQWuu7JSXNwlN7GbI+GuS/Xow9K9+aBOS29GZeN459kQNtUDppc/Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB2705
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The MIPS FPU may have 2 mode:
  FR=0: MIPS I style, odd-FPR can only be single,
        and even-FPR can be double.
  FR=1: all 32 FPR can be double.

The binary may have 3 mode:
  FP32: can only work with FR=0 mode
  FPXX: can work with both FR=0 and FR=1 mode.
  FP64: can only work with FR=1 mode

Some binary, for example the output of golang, may be mark as FPXX,
while in fact they are FP32.

Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
we force it to use FR=0.

Reference:

https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
Cc: stable@vger.kernel.org # 4.19+

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
---
 arch/mips/kernel/elf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 7b045d2a0b51..d1aa907e9864 100644
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

