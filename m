Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561DB394118
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhE1Kke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:34 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:44056 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236551AbhE1KkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:25 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAaPMc004646;
        Fri, 28 May 2021 03:38:31 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra1r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sy16MYyPUkVW8H1+i6e557O8ujOugF0DhwUdkt2s44lxvDxe/p1Ey6KsXjs21Y6+Og/wfNW4rJOA3taEzoNfz+vX4MVS55yzMHTtw17Pa30kuyhs3NFDtKVWBk/b9EgxUk3IPVtHQ0HJ/RlBdWfr/5gpom4Jk1mNJaHqQUPB4Op5syB4tSDBWxgq674n78aNuHyTlogHyk5hitmQw5h1/MQrhUG6+Yi1ef/PImR5Unw0Xauc1XPPuk4qRZEOmZjeLMLSR6Oe4NVWTOo2H+4Vxz02QMcwjRIjxRe0sk+PdrhBtlTOw7i2T2W4wwdfTLfi9QLsx988AW4832GYFleVGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0bby5SxKYX4E606Iza3GDlGax7ytfNFUgUtXvYvMLo=;
 b=PNbM45y9ouFQmd4n90MpVmwRsGnQ79sjPXKK63jLC09U18Y+3Nnoxq7lhAO0JX64s2b7+bXl9AmRCwdNNOHy4WJSIdBCPXi9BjLOaoJg2UCIjaAAL1fxbIPpZXhHl9G14BXoohk0izESszN0gTYZNq3qzaBDnkKGr1/Ee1LfIdQziyjD+WZub/G3FlKKZ9yyNILqbP9ZewmckAoe4YPRn6Y3a1oMLZ0qt7M421wwVpjH/MyK7ulE0Wn9IpRH0M/6ub0U04zDDgM7ZIo37FEn9j0MjvmiMBBjRscJdh9kmrB2fKCH3TgmiV93R95lIYnYx/xFcsJB7S0FJ7e/kbX9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0bby5SxKYX4E606Iza3GDlGax7ytfNFUgUtXvYvMLo=;
 b=gIPMbH2bxSwX5CXDmPggvvEigTWuPzynC7asPZ0V5W2A3QxSApBlzDzHkTYv9WSHln0cOuCnEXmrefNqnyXPr5NppgnFScHOZ8NYwKbTNNUZw6E3zbxcm70mwqNuyLb1jDY9UqwMw5dggMmOZ23CE/yip5LPOqdmDagnfxKFNsk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:30 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:30 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 01/19] bpf: fix up selftests after backports were fixed
Date:   Fri, 28 May 2021 13:37:52 +0300
Message-Id: <20210528103810.22025-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210528103810.22025-1-ovidiu.panait@windriver.com>
References: <20210528103810.22025-1-ovidiu.panait@windriver.com>
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1PR0102CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::24) To BN6PR11MB1956.namprd11.prod.outlook.com
 (2603:10b6:404:104::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 068414e6-835a-4753-e0ba-08d921c4bbbf
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2097B4DDBF2985F940B2A1FBFE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJbwpm8eAgf3g8UUhs0cJu72O/fg5vX9enWiW4SC3BFlwO9Boq1ZHfU+9QNcMWdUTy9mADt8qLaD1JvIk+AMvbkHK4zAI2WMjX+0kwGmkNCJ8CWAh1TVfU8KaZgn+fjDi4AafwYpTi3d2NiO23fUu52IFSTdq7YWhgHIUmPIQ2h2TzY5iCQjQwVRuHtCLyk+GwcFyI4Oa59vE0sEea5Kl1KloYoXP3049+lB+U2mQ8KpuWS0OMAF4s5IcMGAaWwX5ktb1odWmPk89rKMDZSDjtq6tbd279jNkRj2+ORz9u/474Mbpz+nRcByFtqUhvevdAkZ5f9ZLQAapugEOb0GTW7gQA6oBaBG2fjKqU4s2lY+aLj3PmfNcD6panuZxxjAovxGKqCp0kcVJrzRcgnwm746C7sFerx6RrCT3jyX1PQRGiC8ONR2BggFyI+urZ7EjjfRnndwsLOCku838N4DksOxzCtrBkE3RU9Yh4EoCxgkCVDtp8oKOOHGrVbnAMk8bbFwxZVAfyd+RxnlAn24ziRBoFmqVWWVQWn6hzG6+yA94/wDrJtcxxNb+EitWZf1coNjRdvIjH5yt+DqaQApteX/YDRxTIUXTO6acQopMO4TMhlJH5Svi+xdlMeruj3rPRqecEculKZp+TD+A/wwaLrkaG+TnkWFUQbQ1sVQIfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JOmP2tgAyOIY4uzRgpdxh/tHiPY2fWHW0Q12dMw3GtXvYOiAySnafMV1mvdk?=
 =?us-ascii?Q?pAsQ2qtB+omEE5dRLekAMoXTnKSOpPVUb+oOw0jc2CgrPZTZU4dNdG1lpxLG?=
 =?us-ascii?Q?HH5+vB9R8Fs2cN3uS1rC7/NIK8IfOrf7738BpeptT5G8FkgS0cEMDMPAs5T0?=
 =?us-ascii?Q?76tsapIufccx2/Pqize3Fpl4XX2XuI/rdKQvJqxZenHEE/PtBeuHHgkSW2DL?=
 =?us-ascii?Q?dm2tuhyOiLTmkAl46idn7lY9S0f4lYfFToeDagPxx69E4x8ADlGJH4QDVJ2F?=
 =?us-ascii?Q?X14e74TuQmjaFBNH3SJFULHEegHnywKpEucb3k0ZAfEDQCBc3KH3vd4AStwY?=
 =?us-ascii?Q?BmX5UsqQJQmtGAFyVbM1lEyJXc5qFR3AkOmYa331MBtWhfE/J5msRRGnIur9?=
 =?us-ascii?Q?cQ+GXIS04zQE2nO5OgJCuJ817jb1sPVBzBaPB5apml4tOdrd/N+IBJ/FNU4X?=
 =?us-ascii?Q?LvBf/WQ4AWaSB/7F1VM16MVZsBSlzwnEmChMprxP/wmxANY3X6eW/rpK0Xid?=
 =?us-ascii?Q?pI0Q+xVNHTHC46pEXjVe7ybUOBrTtv0TpnioyyuWKlqLR9PD4sQJF7xvbEFG?=
 =?us-ascii?Q?IZQ5gDrM0Ezra5O0l/dOfNMaNcFxTgcu/pzdNgZXFX2e5fsIQhw6SY2n9Sfk?=
 =?us-ascii?Q?hbTN15GaVaTdlgxDlK2mq7RR3lYcPb8YJiE9H7HoWckSJ97eCzVTzPcXxmM1?=
 =?us-ascii?Q?vKlFWpzBeKd0xJ/BWVOK7vgfwyG3fLMgLm5lcABg/1ErO1TSlwPWaiNxyQBS?=
 =?us-ascii?Q?GQyPqKqF5ZkaRlDfinMGImWaAlJsS+GeCeLHeFW56hofCQNsLDrKjBdOmRok?=
 =?us-ascii?Q?qDZYuVZLatrHWKqGZrnUCa8l4aYADr/zIKdFaJbJP1D54FUP/Fb9o7wyHGO2?=
 =?us-ascii?Q?X1rmTIsRp+96iRwdhSb7H+UAdiJmFR59GPZO9PFOVGsaQaCuesPo36l11f1K?=
 =?us-ascii?Q?u3Fj69hcZhkNdYihKmUMIJEDkr8E+nFPlxsxtOGTBD8fqnzPKjNRwRWgKGH0?=
 =?us-ascii?Q?uwxlbRPu0P9Y+cWVFzP4T0JWzD381zs3c6kRB/rfDZxDZWe9w/lzUcP+BiQz?=
 =?us-ascii?Q?+rk8uYy1shK2ykdCL+gzVcm4RaNHfKgp+3wfH7NbO8GqHhUR34Gv+JFNZyhx?=
 =?us-ascii?Q?Z2YPa5eLD2u5m1I1PzD2PSDLG3sYqLSA+WNAy+5b9+0/lQ3Jwr75q3d0NmNj?=
 =?us-ascii?Q?pdRUCSPFBXaWQmIRY7/LHR6Mumd9vnwZ8jY3Gb+ItqP+SBbSymY5vpXWclB1?=
 =?us-ascii?Q?+dIur7VnWEncfM+ZqRYw6qVH2cDvHV4w2cdjXxCeXQOWNGPdb1nW1xbtmZRm?=
 =?us-ascii?Q?CAkRXWlr1w7ZbNpBKr6lpruh?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068414e6-835a-4753-e0ba-08d921c4bbbf
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:29.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FukP5Hn+AdQkMCViz/N7Nqa+/Wiot2rOR23HMuigXq0CfN+Gr1U3IvbqinZfcM563nwXoLP8Q8DKBjAmb4DeX1xlhHIHGQ3cBCtCJxnWDJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: o4zpOX62f8nDvdWiJvjicyn87akVYnbh
X-Proofpoint-GUID: o4zpOX62f8nDvdWiJvjicyn87akVYnbh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=959 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After the backport of the changes to fix CVE 2019-7308, the
selftests also need to be fixed up, as was done originally
in mainline 80c9b2fae87b ("bpf: add various test cases to selftests").

This is a backport of upstream commit 80c9b2fae87b ("bpf: add various test
cases to selftests") adapted to 4.19 in order to fix the
selftests that began to fail after CVE-2019-7308 fixes.

Suggested-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9db5a7378f40..fef1c9e3c4b8 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2448,6 +2448,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = REJECT,
 		.errstr = "invalid stack off=-79992 size=8",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 	},
 	{
 		"PTR_TO_STACK store/load - out of bounds high",
@@ -2844,6 +2845,8 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
 	{
@@ -7457,6 +7460,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7481,6 +7485,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7507,6 +7512,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7532,6 +7538,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7580,6 +7587,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7651,6 +7659,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7702,6 +7711,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7729,6 +7739,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7755,6 +7766,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7784,6 +7796,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7814,6 +7827,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 4 },
 		.errstr = "R0 invalid mem access 'inv'",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7842,6 +7856,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -7894,6 +7909,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "R0 min value is negative, either use unsigned index or do a if (index >=0) check.",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -8266,6 +8282,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "pointer offset 1073741822",
+		.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 		.result = REJECT
 	},
 	{
@@ -8287,6 +8304,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "pointer offset -1073741822",
+		.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 		.result = REJECT
 	},
 	{
@@ -8458,6 +8476,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN()
 		},
 		.errstr = "fp pointer offset 1073741822",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result = REJECT
 	},
 	{
-- 
2.17.1

