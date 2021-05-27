Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8553934FE
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhE0Rkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:31 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:56562 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235205AbhE0Rkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:31 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHZk0c027371;
        Thu, 27 May 2021 17:38:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKRSeGndwmETLJreGjA4X3vEKi8WAwMJjI21EJVyeNO4VtcVoSnA+U+d/ijUK0Bim4A8CzhB2E3iHaKGUdHMjqpFwJrJrSSxuOUH4oa46XOj5a4ODv3LaRtYb0dPTwdK9Vo8aHblLmJXlNv65PmNEIqBcAKtzYDsgzGBkMXbhabM/xRDsAhJFdxB/s0hV7tvAHRFA8GTL7CLInm56dALU+AOGf0y0u3bfV8o9hd2SW8hdmoyxqloWkhjU5YaiuhBUUE6X9RN62lMboJH7OYuxxTZROlGd+1kICF2xfaT7R6/vfToKArWKBFedwXVJg/+df2eV1aGt+9N4cfUokQe4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtaiXxOhCP9UCk/fdVIFV2RwWeMlRCPtTeBpaoQxgjE=;
 b=JcT/lDI3wnLAJi6jMV372Ux4WnNREEb659HrQlkQ7n9gyvU6TXttDM1DDwIuh28kV4SL8ubpQ3eiYYP3qRQb9gD1Gk+3/EhpYozejEetU/ZxXZ4rzjChzVZ8J2Z2zyl+vqgRJ/kthvnnowFx17I4V02fwmdjL2Vx13IC/A/tnbhMDivEFv14wFVopR2R0HFlJN5ma3jHB4io8/SX3+KQvhCvIlK+n8YInJHb/fLtk7upLdq/wN+U1mXLYnsqgZcNfh9pC6iGL81rFwi9zvx5BogVSElQ5EelGwCEl4a7TOhH1e7YKfapQSY/1VFzlQsLwbsUU9OQQ2TSMPRsbmE0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtaiXxOhCP9UCk/fdVIFV2RwWeMlRCPtTeBpaoQxgjE=;
 b=TMj2b4UJT0u0tIPvxvLMZVF4aleJCmYXTmenH1EV0gFSTnSnhqOe64NOAmsjgBELWCr2+esCbannJ3MtnbhgytvVhltgaNhEqvhN66TstYUYUcBp6RFWiJEQJeCzVJTsvujC/ctSG7Ordjn1BpwdR74D8IHnVguKgIfZWrkAAXM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:43 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:43 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 12/12] bpf: Update selftests to reflect new error states
Date:   Thu, 27 May 2021 20:37:32 +0300
Message-Id: <20210527173732.20860-13-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210527173732.20860-1-ovidiu.panait@windriver.com>
References: <20210527173732.20860-1-ovidiu.panait@windriver.com>
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::26) To BN6PR11MB1956.namprd11.prod.outlook.com
 (2603:10b6:404:104::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a92cb5-0364-4540-c4d0-08d92136458f
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162E08399611E0CDC0BAA67FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlH+HHiElaogx7DI59zB1BdUrtfFhBHrxAKvOrgPHOrkrdYt7eZEjnSN9Ym+5hACP2h4N4fadRBnu7fSf0sD/orqoBB9OWyOluFKoHRBrZwWYT7NkYzeFL/Lq+W6Q70awpgjNWoSzmfOLhbhO3vTSUEufV2JVc3ugv7LTfMFqvGZz5y6Vm1Dn+AChUHWFJpSNp5R12Ou8/YHlqiz9liD9vrr9FxHkWcfXgcbA6/UIkJhllFx8spFVqApA+3jFPrKBsHO6h4KbV395EcUL88gnOUDXBAUwh1RQqIoaovEc/GG4fUqtvGG3JpJ0XaBVKJO4EVncFrZ8GxRHifjNwzRbimeIXLWZG0paD6kfjZwKtDJASY51lVvr4F2DnIS/AGXEiIq6Z+7h16mXEQiFnf94oYfespGS9gxuLEjJrrQnHiV3kOi+nOJGoTRuym5ZlnWcvC4eTZAJPpWdK6zFyqou3IqXwjRde9kKFekn4NvBpW9hPngHkSEL+HuDtf+TgpU5M+1jd6fmzqQXnNvDompOld7Ahrw4yQ3fTWjGA5KwZ1sUR812oAScibjhKN/yytcBCpYyyN7l7DdReWkUc0UfMqmdGcMfU6A4KRcESY8FAANE8gJFBE6oA+T3o0FiFhBwKPfHGtNiyJ+edrbL3OPEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(15650500001)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O0HI/vJhoEu1HhXjPwUyH4qwnX71tiqeTV+krOkZrjSJl4qySNN7Moz0tw0V?=
 =?us-ascii?Q?VEsbbpOViayk5XQZWsc8ox/HIoi6oI3LBa8EddLKf4keCnyrU+P9Vw0C+5QJ?=
 =?us-ascii?Q?A6XSvwJMfnPN9hiZ7bhhmwWXpwUZlP48/VQo/IBEDKKpQR5x9+6bm1j0RZGr?=
 =?us-ascii?Q?9TcmIdfNM+30V9uLNvZWoExTzqUdjrzO2v+cB7hQcYFEUpZnoYFdIxHkt3xb?=
 =?us-ascii?Q?OL/aaGPYuyEzDJkEnSa4TPUJqwwK1lLHHXQQz2Yq7WQ4lXctkhwvxv6saNHD?=
 =?us-ascii?Q?hUZLkvgjJ94JbwmDF1CDqGfSo5FkyecaASKYnBQrcfOAba/z2zJDA/mjGO5Y?=
 =?us-ascii?Q?+YFhhx6QhsksNH/G2ogILSofnLXRmOHry3sy7eb2oBkROGYY4nCmTY9nYAYU?=
 =?us-ascii?Q?etSfqrBGVrtkr+OU0c/ebP9iib85Er6L9G0e2aEXSKGs1gxAWt030ZCt9sjo?=
 =?us-ascii?Q?kJux4lYzUVR1XxGb7vv05tgDDNAA9xQgDm7OIFs/lnzMWMsL5R4rLB10P+4L?=
 =?us-ascii?Q?Y6Rg1Cgmp6g1RQ/eiHEGZwi94DBJ/W3HJWAOsGzkUfslny9K3w/D+SJq6V5c?=
 =?us-ascii?Q?gpp3UloTuMNjNff+NpMDL0eFltEt/U0VRstt7p9V6HTKz0ZXT9NhJQI05CRU?=
 =?us-ascii?Q?Nz4p8K4RDImsw/blJ+qO2yA6XoljDs2d0xGIiM0oJUntdv4ScanlbJZ0leV4?=
 =?us-ascii?Q?sDwThabl1DDIy66oiO5bpU6BhPIXj9ho7LdawkOO7wbnNIhz24RXUtlzSC6J?=
 =?us-ascii?Q?I/4w+hi6WBICFjyfulyv8Y1nyAsjPp8f1KLh/DwsczcZ6aF2FnP9U9/g/yjp?=
 =?us-ascii?Q?wyeaNUjM/59G8S+8kFegLqDc96as92TDTf/7OWunMSUwfmwvRxvD0d0jJM+W?=
 =?us-ascii?Q?p6dQM7LtoHrphR+8YwShlOjL1uEk+itF5xpIOws4C8UGa+H2qxiXRhwD+Dl6?=
 =?us-ascii?Q?997+7IBKKsUf1AE+JyEVFuQugfgjV0OZ0Fh3ngPf02xk+hzsA2RNgX/w3cCf?=
 =?us-ascii?Q?9CKmTYJLlFtZj8Ol2RZB4PSYlLpgcBQYcVIrzoH6luFm8uUb2ViHmQC3wSoM?=
 =?us-ascii?Q?3EzshvSjoYi/rEv1vMVo74/5Pn+l0WwE8mJUfwC6QWBndc26LaneutRLZV48?=
 =?us-ascii?Q?u+dEA1tWeojK04eyPCWnMujXrH/PmP2cJGCV8tUq7cg/3x18XX92ZzTvCDFF?=
 =?us-ascii?Q?iPATR8lMQK6OT/JvmO5cLpsy9Oqwfg2IQ/9ioIllzokeH8S8CCCEZhuIHFk+?=
 =?us-ascii?Q?gRZqTRC8hRbTJVyLlm1fP3VPic0HgLAYx3tZqKpuiSKsruljUxFq9RRAJYmT?=
 =?us-ascii?Q?Q50lkZqRLNCRRibhcZy34Hra?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a92cb5-0364-4540-c4d0-08d92136458f
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:43.0335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/rAqcUtqgfbLQHC7ju4MutUviXn5ptuLu7/u+U1lHJghnosESk09dlecEm7BiyUiCrc1SLp4fBbolq5M4q2FYHQOu73GuQ1hrmUSBDzyV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: tDLO8lLZYHVtbDe4UY0jW-lVGUaK-uks
X-Proofpoint-GUID: tDLO8lLZYHVtbDe4UY0jW-lVGUaK-uks
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d7a5091351756d0ae8e63134313c455624e36a13 upstream

Update various selftest error messages:

 * The 'Rx tried to sub from different maps, paths, or prohibited types'
   is reworked into more specific/differentiated error messages for better
   guidance.

 * The change into 'value -4294967168 makes map_value pointer be out of
   bounds' is due to moving the mixed bounds check into the speculation
   handling and thus occuring slightly later than above mentioned sanity
   check.

 * The change into 'math between map_value pointer and register with
   unbounded min value' is similarly due to register sanity check coming
   before the mixed bounds check.

 * The case of 'map access: known scalar += value_ptr from different maps'
   now loads fine given masks are the same from the different paths (despite
   max map value size being different).

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: 4.19 backport, account for split test_verifier and
different / missing tests]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 35 +++++++--------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index a34552aadc12..770f4bcc965c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2873,7 +2873,7 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
@@ -7501,7 +7501,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7526,7 +7525,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7553,7 +7551,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7579,7 +7576,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7628,7 +7624,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7700,7 +7695,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7752,7 +7746,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7780,7 +7773,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7807,7 +7799,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7837,7 +7828,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7868,7 +7858,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 4 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7897,7 +7886,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -9799,7 +9787,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -9814,7 +9802,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 		.retval = 1,
@@ -9827,22 +9815,23 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 4",
 		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_JMP_IMM(BPF_JSLE, BPF_REG_0, 0, 1),
 			BPF_EXIT_INSN(),
 			BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 0, 1),
 			BPF_EXIT_INSN(),
-			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
+			BPF_ALU64_REG(BPF_SUB, BPF_REG_6, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R6 has pointer with unsupported alu operation",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
@@ -9854,7 +9843,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -9867,7 +9856,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -9881,7 +9870,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 	},
@@ -9895,7 +9884,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 	},
@@ -9907,7 +9896,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
-- 
2.17.1

