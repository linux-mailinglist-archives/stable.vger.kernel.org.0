Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3539411F
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhE1Kkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:37 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:37580 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236590AbhE1KkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:25 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcXlT011402;
        Fri, 28 May 2021 10:38:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh8nsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtIUCNdvEHEyaJgR9gltVCwyvdBt5fLXkgxKjteL+iGbzu+OOdsckzDTOUy9dVV5OsyFZZvwFuzcH10AasRNOwvgIAPiUWzjE02o4Hs4NLLCGDZSR6pHcgfX6LnF3qGq+ODtQ875/ZsHBtC/PZoxAc5QM5/EihQw5TsEldyeCk6evan/j5Yd3ye2IW04PSrZS/J7Bd1SivEG4TSKsNIlhEMo1gjNzE49AlUvhtqa1szFrQG3gefIfXXRJ21C1eAaQ3+YxmdPOv+gFt8YMiIbSi7MSVb81KCuM9RcVuBDMurJWsI24Exwlkv0VCiq5rFnGrXDicI9XjlT+qCFYbfDqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZFtFZQ19dtiGu0q4A91o88mfw7+X77N4k1AxGl1Uog=;
 b=mWa8oXkWbLcQuadmbdAr7t1EvOrOEDyQogAcPynml78iEFg2qIiLdr9x3adRZ2rRgpSsmxsvyjLN58EkR3OVgdGau9JCvo6rT7PuaHEuG6xG4wGYStD02Sj7FAQ485wPeuU6HWhEuqQKKxCoPqhGlcXjQMA2y7wdlXsd91l3FsYyBsMo79Y4CpuXtOAT7sPXEh427VaAl1flPOQCH9awAbCbyBdCDBwlCOwbn53LMBJVqzCVag7veK7IgtCMBhxGZUdRBxJcj1wJ9MUb5MhqJXvj2Su+7p8x01ge1JTvl3uuCjQ5oRks8pjrJzD+fzYgOQ2Fr8W+gtFbji4eBhUb5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZFtFZQ19dtiGu0q4A91o88mfw7+X77N4k1AxGl1Uog=;
 b=GmjUMDFm5kK7uyJXcZQs9122CE5r2QvI9hBfYMp1+cc26JUxr6E2aOnxSXLze2FHJFKzDNZz8R9QW/I7us/ZaZyRwIuTiz0GejKjsdWzwVN1i5PbWE7zglFBMzEUMgKdyL7cnzKBe6e7+b1Rq1t5uOymjab57LHYU18fzgIzKoc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:31 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:31 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 02/19] bpf, selftests: Fix up some test_verifier cases for unprivileged
Date:   Fri, 28 May 2021 13:37:53 +0300
Message-Id: <20210528103810.22025-3-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 546c8293-68b2-4128-af4a-08d921c4bcd6
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB20970B04D37D280C70D46CEDFE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VzcCnIYGAzzEOvSHMhJyY+YDUj2hsZT1rh/hUGK78iVT3qek7vuapsZOCuFYSGDIoQBVqAQaIuqINrgqKzaD8+gfjlpnncgiTV6EQ5PbwB4Iv6zNt2+xz2KCxawuvP2r6G3OnQuBX4gRB7farYPgZ7dY6XjYFcVqlWU72Tb9KfbsZdTzuB/UYOl4ABF20MiuJPtZnCqQP647wkXZNH9KnQd4fYuphE+ELv9cyimt81MYq1LJmK08dCi+nm1gPGlsGHOhCibVe3jZ3ExbBlJWYVFYFJ4BtxxTRe2fMZDPZSXAXYdmdWIUeS50mrMyTNz91Wnbg0jT/5VXtVBSWP+jpmefptM8BtBO7URta/XAuNPwF5VQm/njC79wM8er0cVx0HLhXOVY1SbKCCKAr25vNcBAqPZS0qsLOjJi2dNguCN6TPioVdwRtuPYxIVztGor0BedvYNc3qdmMh1dRtxGswiMuWA+WPZ0VHdXsGxVOAqmH+Tw8ePfuKxGi2K9tvP8trCbHMlvPm/nNNS+VB7bLYE04h74i9ggFvv9MMe/ggsdUE7qQJReUdG6zZUvag1lY3fR7ht93eLwXsN0BXMKvFzf0haa3xqE0XrHVJQZJwsYlfXyMV/+R5VNDNVox1bQlmH9yGJ7BPd4lMjBR/4X6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RFyr/usDKseozWR94zD/dJLUq6aZ4sNICi1UFDvilSze4wz3Asg3efXSYnmq?=
 =?us-ascii?Q?r0VbcRC6w+k2WVQqyCWv6u5F1ORJap9vQw47LboMRT9Bo0eAFvYY6MGi4yHr?=
 =?us-ascii?Q?4nfwtM5V+fy/iG93C/hPx8yZWmDBmYm6TWOjsbiaH1ppfV/TaJ5IERtqjrIn?=
 =?us-ascii?Q?UJW/ITWqLFA7tjHx0D2ZcSAhibHaqD935rW/WN3Wl2uxHpQXcOW2O6mAMAXd?=
 =?us-ascii?Q?wv7p3PAPVA2UxVo6PCIQfQHMv+tuCHUdduPp4EL5hXZP/209MOv4265bPnah?=
 =?us-ascii?Q?FbEkRxWdcFuQuzSyRxRIIAKxP7QqF7TsjTmKczlswchVvviOwrgFFonV/cdb?=
 =?us-ascii?Q?0X9Rrz25IUghhFvCSKNDfaqAMlbxaahkWg3z12QMGFLoIATlZSYt/aLmM8O+?=
 =?us-ascii?Q?fdfvEj2CGNqo5sHNzXliQ1KW1pl4FG8g354I3aj+VjBS4g10mrZ7Zu/hJBWt?=
 =?us-ascii?Q?clwFEhdwfS98c0TWhCe3KznJSPBTShUJyhBp0ZgZ24QiYBHEFbbZK9mkOXDr?=
 =?us-ascii?Q?wvn4sxENQqHpSii4JW4eg7DLxKfg5RH6/7eTwXPSBW1QCDvIT+m9uG1IAJC8?=
 =?us-ascii?Q?Bp5rgiHZa3EFeVgcvJb4h1AvRTYhcUrsT6ReMeU3hWNq4GHzaWIUs53vpjpu?=
 =?us-ascii?Q?l+/GNvddXzk5Y4ZdhVQiQ+6PSGvkT0p+7Q97HMJAFeVpgJ2lF5Mi+lY7g/n2?=
 =?us-ascii?Q?RqMsnRqSdxpiYbhzjDA7u3bDHlERIOmHvbQjLOWAevr8r22/Xu8VqlM9QUSu?=
 =?us-ascii?Q?mkxYNgw3dVJKrA+Y53w0mcykfjnm2g3URij+JhlR/dV7Rxph52lUwQ/NKYQM?=
 =?us-ascii?Q?L1rjAPmHjMi79TQOtliT8PwRVUc22tJMDWnpjZC/Kqvf+/TWwRd3niTO4wEX?=
 =?us-ascii?Q?mvDt6uUq385jwDHAmdpHcR6E1IccbEV05KNwOWL06PEYcTq39wBwj51D9tyN?=
 =?us-ascii?Q?PA7N8CsnjkRRAuCRK8Av9T92Cp1UyIc8CIRerckq8zq4UWnqaJMm/2w1TroD?=
 =?us-ascii?Q?x8/HMkEhfjSz6xyY7CiK42XwDV0XYOA7JReYW55zQzntpwY3rqIpfRulmmZ1?=
 =?us-ascii?Q?ccRAV+q3anXAwBP8SazlK9glpq7AiKjQypB03YRVMqpU6iVT8ICo5ZYMS+/X?=
 =?us-ascii?Q?wNzKwdntYW4FNaMerKuNZ4xgLEgxVDs7Ro1fChwWQjP/6e5iZnvYizkZyXUa?=
 =?us-ascii?Q?3pS9ZIv35hoXH7ZPqzqnSSwM8ePZ9r/uFsAbZFvyIxO/UBO8pccJXfqfzGiK?=
 =?us-ascii?Q?oUS/QWyY4S/f6iBp0u8guyFw0KCzYAOBVK4sJHyu4vzmKAP7aKBR70kMPOd/?=
 =?us-ascii?Q?xi6oEnFTEwAT5uHQ0S7PFpBY?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 546c8293-68b2-4128-af4a-08d921c4bcd6
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:31.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wWCnGkkBcCjFjmWQIq3M2ZomXxpPqREKAbFawaqADSLiWiFWdTrD6+ofFjD4lf07T9WL9O/kTQ58+0S3ihVQPaK42iq4TBM1ay4Br1mMpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: rcu0JJm-mhB2CxpfCTdztvKB-X-Bsz7Z
X-Proofpoint-GUID: rcu0JJm-mhB2CxpfCTdztvKB-X-Bsz7Z
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

From: Piotr Krysiuk <piotras@gmail.com>

commit 0a13e3537ea67452d549a6a80da3776d6b7dedb3 upstream

Fix up test_verifier error messages for the case where the original error
message changed, or for the case where pointer alu errors differ between
privileged and unprivileged tests. Also, add alternative tests for keeping
coverage of the original verifier rejection error message (fp alu), and
newly reject map_ptr += rX where rX == 0 given we now forbid alu on these
types for unprivileged. All test_verifier cases pass after the change. The
test case fixups were kept separate to ease backporting of core changes.

Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: backport to 4.19, skipping non-existent tests]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 42 ++++++++++++++++-----
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index fef1c9e3c4b8..29d42f7796d9 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2837,7 +2837,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"unpriv: adding of fp",
+		"unpriv: adding of fp, reg",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_MOV64_IMM(BPF_REG_1, 0),
@@ -2845,6 +2845,19 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
+	},
+	{
+		"unpriv: adding of fp, imm",
+		.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
+		BPF_EXIT_INSN(),
+		},
 		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
@@ -9758,8 +9771,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 2",
@@ -9772,6 +9786,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 		.retval = 1,
 	},
@@ -9783,8 +9799,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 4",
@@ -9797,6 +9814,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
 	{
@@ -9807,8 +9826,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 6",
@@ -9819,8 +9839,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 7",
@@ -9832,8 +9853,9 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "dereference of modified ctx ptr",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 8",
@@ -9845,8 +9867,9 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
 		.errstr = "dereference of modified ctx ptr",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 9",
@@ -9856,8 +9879,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 10",
@@ -9869,8 +9893,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
 		.errstr = "math between ctx pointer and register with unbounded min value is not allowed",
+		.result = REJECT,
 	},
 	{
 		"bpf_exit with invalid return code. test1",
-- 
2.17.1

