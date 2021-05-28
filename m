Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD0D394126
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbhE1Kkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:41 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:42516 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236564AbhE1Kk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:28 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcfUf011416;
        Fri, 28 May 2021 10:38:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh8nsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxBH5w8y5h/CsFhrhojehuAVhfkfYs6rk2KwkbFnQg3Uel/4UWpe/K4azBcFdrSTOVH3mPca2ajOhBxgnJMNrLayKYEym4gA93yU9fkM31dGxhVPAirSJTqMza/R71KM/46+ZXDp1IDoc1gOo1+26i3nUqjx510bFfW2q1bPS21w1KkE9U9F3CTnUFK+OryGQ95qozXaOgSibD4vktbA3UT2UBSz6w+OgKZXSuaTnr2AiOk8SMhVASD+1M7Wd5ecWhCTvHsRUHuHYWRJPsCRUYAonw3pmVr5Yf9laD0zy5HuWz5/4ttF7bZE24pChnjJxtVord1b72/9jF2uNUAhXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgOr4zXICQXz1wkrbSV1bW6ZLKPkDuxtqFMx5UmhsTA=;
 b=EY5hGXVd/qxgp0ZVMEaqEOLoO77Y0kihLE6oNVfSHkADTzE0cH3VjYK86CJmrdETvUSZBfuGz9TSCkXqqqYhY87gXNom9lm2W5MowgspW/iA665QytZicHIZ3tCzfoA3D4agvWuiFKaE4aRJZYLkploU36c11fC+GK24X7bPfJNyTWufb0jBMN07FqYnYwJqPSihQXlJSdpFfYoGrqRFIYWcuMk+/pxSl3/Yi4B6+TvjP3Hzpi2Z0yk3vFZxvOvzdbNhBvmi/x6v/sCiYadD19F0sewoVYFUvGkEGryhagjwtxWGa/2b4bHJjJBHkLd3ZOeA80WuoQ8OLUaMjCQbRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgOr4zXICQXz1wkrbSV1bW6ZLKPkDuxtqFMx5UmhsTA=;
 b=kwF+Gkj/ixeW/9nhvVSTbqh6rWi+36EtmLeJpxeKCydD/kE6iRU7ykMKV0eZbL6Appy6Doa+O6v3QsI6TLJscQswgg890/5YdUBtnJBUuUSeFhivWfDynletoKaSVVyjtcvLsrIX6qPXL1+Dtd/T+b6HoU6IHfXn6Jdehz6+N+0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:39 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:39 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 06/19] bpf: Test_verifier, bpf_get_stack return value add <0
Date:   Fri, 28 May 2021 13:37:57 +0300
Message-Id: <20210528103810.22025-7-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8591658c-f637-46af-edf1-08d921c4c12f
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB20974CD33B4F93DD6989BF17FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8O1Rwn5vqJnRtkF2b12I6uqVVx6Q+X3hxQlPo7qvexqURnMbgm3d8zyVBrn4IeVgSjqaHVoLULeS69Y5atdU+hIJGjyosh2pcS4vEoM6AYxKzBBnxfkVz6egvKSsFe8gzKS+SDc+DK8ATvsj4X1zftiTyogt5Tla4OTuk3EyPIcZLIFN2rlQwMZZBeIHHNH8nf7quGkiMFF7gLo2DPs9wyfx0Pua4owXoh5TEzqnHD0+XDv3/DyimLeLy6xX/9yLebevyvggB53P35fmLgbWAZPZVhv0Z9TdYMcnFP0DcRybXQjOeIN1XVn6iR8fqTBjYYgOafk48Gf49OGyKBjGSYeUXRwYBLFX75Wg7SpgkO4faiQ7j6PJLop1RqcRYP05q+KCk9GtfnZ6nY1iwX36k16ijvPsS5MpVS59TsGmHq9pWeCu8cP7yg0ksHSCrYhRHwm8v0T6+OhJMSP0930Bh9P0CtNrisfKXfVmDIaQMuEJ/maW7NtW4eLdKDGmvVGfBRGF/vM/G2wSb7+ZlLgqvYQ3Ua/q9H+r7di8dMPRALelF3qlwf2o8yUyIuRT/TsyIrdc0s2fNWR8osymxuqGemeqxWDiQfkooosJpBybj9R+CfAVMbs6hADKHtAB43ZzyGrQc02G6KuW8smfR3UUbEEgMC4RYioz6kdcjOyvyBh1lV7sXtsx9SJrWOuTx3o/tvGyQwYDdoBu7n2YyFxNVbpkPf4pyZex976pA04zeooAPjdn97jM0kXSHooulbZ4vlh4de2r8kKI1jyg2a0Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(966005)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/IwwyIM9jnHBlTXMosrsmKB4xcwlmga3PYvaWJJcm6Xk/gENpwvliHIWCTG1?=
 =?us-ascii?Q?OPLm8Rg4+EmEDpPIBP8O4YDpN6BoBuboiC8i6Bu5/Hnb6U0QVuVNmUdFz1Vv?=
 =?us-ascii?Q?776wwDJ4W/md2BsG3H8J39/EEqQDjbSmjhPoqI3zrWhF/OrxsU8t4gZdFuCD?=
 =?us-ascii?Q?4edF+fRyqU1N4H9nZHw5UiARTz4I0A0XvtpDkRj94M47hDej67S4W33cHIVP?=
 =?us-ascii?Q?20lg66aYXZ07ittwdbd4gIPq6h+k+GMxD8PDsT+DJxL6DKWGHH9hIvPKpYis?=
 =?us-ascii?Q?2JR1ebXn6D781SGFC7MXDQc5OfcyvEJILZFOUHtsHhlDcvYshLNN/Ibw0YWI?=
 =?us-ascii?Q?FDzWGhLx21uR+0TsYLhRgk5pfLCS5Eai0ww8XhWTqhScN3OaPJZIbo5QqkZ7?=
 =?us-ascii?Q?NURTzIIXBdNYvUI/xEdZRJMsYO/6Yi97LvpSEAuDsHXC6+ZuvvpebyY6DMNv?=
 =?us-ascii?Q?/fsOx0EKVLAgIxlW6JrAGiHaOvJOwgwhRrQLDZvDQOEyQPEAVvKmqmwOeSee?=
 =?us-ascii?Q?tbey8htIilmdp9zrpGFyJVJ+Abfs9DW3nUs2TBKD3eH6hVwvyru26BDFIt63?=
 =?us-ascii?Q?7Bb1uuDwqAyWZ1MI+iNMDXdl+3U8e1xfVCKChy8wMB6AfFvIJ9FSaSg9W0Vj?=
 =?us-ascii?Q?L9xY02rXvgbRa+MjfCrZDKt8rsCIpipdQqGHh/z5OQ/Bt8qqh9ZhS/dJH2UW?=
 =?us-ascii?Q?4Pvg7weSE2A0apcZQm3f9dm2HFVfetu4Cw2JKWwVtgcNtLG8Xd4Wf58zlc8M?=
 =?us-ascii?Q?YdsVPNcZwgjLJ/9FWeZH5wzNqpyC3K7kYhLnyQIoBeQgb08aFOK2VVUe+X0f?=
 =?us-ascii?Q?Zbuyfq6+y6Uas6FtcsEQaQMyhaJAzlU6GYobD5eHomuH3PCyVr5yj01CxwoV?=
 =?us-ascii?Q?pNjRNYeNjdzQoJPuCOq7qkHKlAq6Qo10oYe7kHhOtyqpEAmk0XcScbL7LZnQ?=
 =?us-ascii?Q?ulIG/K8L506sh/H3wivmr7FtPbaqp85wtGrffIhd0WyUxYJfZ9u9zmdQM/CE?=
 =?us-ascii?Q?WySHw7WNIEjhOTLRcKcBOp2o009NQ2SBMHGaG0d0kLM009stKn6Bnj/vKb6B?=
 =?us-ascii?Q?EbdyrunS+4sh+3SVZ5GcM7HBH4m5yyoUyjAxVhwIbVcznaiI0ydPcFcBXzjz?=
 =?us-ascii?Q?Zzwx/fDeja0NJCw6MLip7knpJ5vDr8wXxqclHGVSeLS5h8y4snMCjyReLNEq?=
 =?us-ascii?Q?LZyiKIn2VKlsML1Pt5JRZnthVEctFE7Rdp4Acc4G7Zb/NdOpWfISsV5Bgubg?=
 =?us-ascii?Q?IEO3wzAkYriBvhiZwSuIdmffrSmYMtyExMiPeou045t7oqPmFh+bpncakNzt?=
 =?us-ascii?Q?pwMeMnZZZnp69IDH1yp/Prb9?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8591658c-f637-46af-edf1-08d921c4c12f
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:38.9715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nh+JYmHzx72ssKGEIvaPO7roMarJ8P1OLfGdemtwYTCdGN4DoDPM87dMbE7rBL1vA74N1dI9Z3H9GhKoQOmXpgpV0jU22fAi2lZP8h2gz1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: 5rh8cE6EknC3_xtlQ6C4d2SzAOTYfn6W
X-Proofpoint-GUID: 5rh8cE6EknC3_xtlQ6C4d2SzAOTYfn6W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280070
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 9ac26e9973bac5716a2a542e32f380c84db2b88c upstream.

With current ALU32 subreg handling and retval refine fix from last
patches we see an expected failure in test_verifier. With verbose
verifier state being printed at each step for clarity we have the
following relavent lines [I omit register states that are not
necessarily useful to see failure cause],

#101/p bpf_get_stack return R0 within range FAIL
Failed to load prog 'Success'!
[..]
14: (85) call bpf_get_stack#67
 R0_w=map_value(id=0,off=0,ks=8,vs=48,imm=0)
 R3_w=inv48
15:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
15: (b7) r1 = 0
16:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
16: (bf) r8 = r0
17:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
17: (67) r8 <<= 32
18:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smax_value=9223372032559808512,
               umax_value=18446744069414584320,
               var_off=(0x0; 0xffffffff00000000),
               s32_min_value=0,
               s32_max_value=0,
               u32_max_value=0,
               var32_off=(0x0; 0x0))
18: (c7) r8 s>>= 32
19
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=2147483647,
               var32_off=(0x0; 0xffffffff))
19: (cd) if r1 s< r8 goto pc+16
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=0,
               var32_off=(0x0; 0xffffffff))
20:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=0,
 R9=inv48
20: (1f) r9 -= r8
21: (bf) r2 = r7
22:
 R2_w=map_value(id=0,off=0,ks=8,vs=48,imm=0)
22: (0f) r2 += r8
value -2147483648 makes map_value pointer be out of bounds

After call bpf_get_stack() on line 14 and some moves we have at line 16
an r8 bound with max_value 48 but an unknown min value. This is to be
expected bpf_get_stack call can only return a max of the input size but
is free to return any negative error in the 32-bit register space. The
C helper is returning an int so will use lower 32-bits.

Lines 17 and 18 clear the top 32 bits with a left/right shift but use
ARSH so we still have worst case min bound before line 19 of -2147483648.
At this point the signed check 'r1 s< r8' meant to protect the addition
on line 22 where dst reg is a map_value pointer may very well return
true with a large negative number. Then the final line 22 will detect
this as an invalid operation and fail the program. What we want to do
is proceed only if r8 is positive non-error. So change 'r1 s< r8' to
'r1 s> r8' so that we jump if r8 is negative.

Next we will throw an error because we access past the end of the map
value. The map value size is 48 and sizeof(struct test_val) is 48 so
we walk off the end of the map value on the second call to
get bpf_get_stack(). Fix this by changing sizeof(struct test_val) to
24 by using 'sizeof(struct test_val) / 2'. After this everything passes
as expected.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/158560426019.10843.3285429543232025187.stgit@john-Precision-5820-Tower
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index a34552aadc12..da985a5e7cc5 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12253,17 +12253,17 @@ static struct bpf_test tests[] = {
 				     BPF_FUNC_map_lookup_elem),
 			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 28),
 			BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
-			BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)),
+			BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)/2),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
-			BPF_MOV64_IMM(BPF_REG_3, sizeof(struct test_val)),
+			BPF_MOV64_IMM(BPF_REG_3, sizeof(struct test_val)/2),
 			BPF_MOV64_IMM(BPF_REG_4, 256),
 			BPF_EMIT_CALL(BPF_FUNC_get_stack),
 			BPF_MOV64_IMM(BPF_REG_1, 0),
 			BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
 			BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
 			BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
-			BPF_JMP_REG(BPF_JSLT, BPF_REG_1, BPF_REG_8, 16),
+			BPF_JMP_REG(BPF_JSGT, BPF_REG_1, BPF_REG_8, 16),
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_8),
@@ -12273,7 +12273,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_1),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
-			BPF_MOV64_IMM(BPF_REG_5, sizeof(struct test_val)),
+			BPF_MOV64_IMM(BPF_REG_5, sizeof(struct test_val)/2),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_5),
 			BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 4),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
-- 
2.17.1

