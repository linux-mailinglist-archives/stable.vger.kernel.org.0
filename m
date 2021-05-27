Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5673934EA
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhE0RkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:16 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:36702 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234478AbhE0RkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:15 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHXKjl026033;
        Thu, 27 May 2021 17:38:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81bt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W08D63ft5gu+WerWuYXQvaSBoBAVhNbDrquYKzZXsohr9xXS73t5s+nMFsBgsLMp14x3DSXE956rHnWvFLA3PZXTeMf53jdVkK398jJknlVnVUcUfFwGsPDUh0zR8fJmtRq+NBukLAcQ9XMzebs4Ficd0gFtCSEOnl4Utzi6fsjLzvTTPl+g5yD7VAH4mo5jm3AeMY39TXY2WrEqfjHedCTEoh3mtGqGRtwPF/PHa7yLTTo6yNLRv4i9rh0e1SPs72xbEDHjoaa8j3YwJ59vCMM1fqva1tsxJL6Sh8pxXXsqxkn6U5cEGxeN7bIKDQQrEzBAAWGqbZq6HtRNQWS5Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0bby5SxKYX4E606Iza3GDlGax7ytfNFUgUtXvYvMLo=;
 b=VDzTQ2+kWu5yndWE+JqGxbuEm9f/CKIJVzdWst+duslCtp9Elz1rD4hzrrU8j3sw80t0qORoheNJf/SQZkGTzo+yidHZrITw14NlwDWPRb8OGNf3zCvMlZ6uRYttwCVId3eSRnVvsiLc9ECU3FUCAHTPSaq/ov9JEH5PiwwbTaf5Kclt1Hq0I1B7m6NGuhpWOMED18hTaJiBFyLC8NSoVAuJiZyVUFbzyhgSWHvFub6VxNCvuyN2EltmfH1owSMDXNhBai5pfw9bz7+MfennX7Ru0jRMqwKzP1sW3eUP3A4gJAbVrfU925NwAsHrQ/irTvu8z7xyotX1yTsKldqn3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0bby5SxKYX4E606Iza3GDlGax7ytfNFUgUtXvYvMLo=;
 b=OHMNTUO22OSl3kJnNM/L5vRzwfqBiaCxcu+704s9TQFPk2Bu7UsLdEF1tg1ujHAOAdyJyvgVe3+8UBjsMFkGw05APWAQj5tkRjsOeQ/dYDC08cwaYDStyHznmwn8QCfrC2Z3le4IM5R7JMG6y5HBXNOn9a2WcM/xVjHjQE7krus=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:22 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:22 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 01/12] bpf: fix up selftests after backports were fixed
Date:   Thu, 27 May 2021 20:37:21 +0300
Message-Id: <20210527173732.20860-2-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f15092bd-a8f8-4791-93f5-08d92136394e
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162F7E38BF98036118FFE21FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skmp+qbX8Zzp/uL4fETD2MRPx0yA61oF+clIhPGlX7GclndykUN6yC7hNIyVb5dpVPjbYG2pVTEJ9+2XtAz5ZqF1vrU5tcWgpjCZhf8NGD340KFIOS5XeODm9zuOqxMw1wSeiTVjy7zwKMUo0ok61WtCnF0FyKLCfVELMH+zntnFEqNdbKR1l9DzRvt1NtXm0PA/AGA6YZzN5dFbfXyRsgIRdZSxDQzSEuhG95jW8IzHqZaUgVylKM9sLELLdYtD+X9I9/eAsKfKjd0ngHP7QuPmaw2c4vh4d/vWEaLioUOVoqaNVo7x05WK6ACq0knMauVzWM8170agVDHej2xakly++e8p04P0672DK0MebaKCSQKi6uaB+RTwnWgYIIxd2vIB1qHnAL1Ysp7Bsq0SlgKXqk1/dg/67RW19zh33oBWopRwS+tYu9/GHAeVQowoe0aACNnLsmTOV8VphrFIO+/VcOOq4lpj1LCCYGosPe3xmLAjCeR4wxQGN18pg3VqYKTBz94nj3Pk80jOsM57S6vEdorTggnv6HLRUcDYQ68GzCFIL/PrtQ4L9KAQCYE0joya4+UTucUTLw87Idv6S44cwq7ATA45LbHfyMRFwy6+JfQ+fxDoUCtW1ALvxddk4amXxsk8AcQ+UyRZO337zFb79bHPYYU6pZhheiGDS8A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lJV4R8Dc24UEYZrt+HPH9oJw7/ts0nFJQ0dPEhCPmYKW9kpSzYV31Upk17lf?=
 =?us-ascii?Q?eNwszsqHDJo/Z+KE8y+ZGkQhANYfqTRP80qpkCzbfpbUYMbzQNSMPanhmShO?=
 =?us-ascii?Q?MowNQXe/ppnY2Hl2AYoiraHJTTSplrnjU7d2TaadhgnirjTrKhNWt9wFZJMT?=
 =?us-ascii?Q?9jEux9qXiso6+Z48NBJD/1CL+plMgPYf/teU9bPNJPIJVqO40XwfyGdmD0BH?=
 =?us-ascii?Q?RgWK4j4RPcITprx11shqDMnewL4M6LHC49+IdmgComQJSTbNQhUjB5w5TwA9?=
 =?us-ascii?Q?f9aHZcjBWvUHNsWVWKfODwKhZC16j3pVwv6e+fc5VpRAmCU0KPkoi6Zi0/zP?=
 =?us-ascii?Q?mxYC8L7DEm8YGawh9AfOsqW8gpogmEXIP6Yp5wnaEJXoPBnlVvcLEPGDwCIi?=
 =?us-ascii?Q?jLuwmXGn6YCkcfpDKFUDbUwDKFFmWLNPSYxd/LkNrP1CMK7GfCbLu+GPV1Rj?=
 =?us-ascii?Q?WYa4glRZtnWlzFnyUd58dwzinEwyuJGPKCOgs073/1GirLM/8llqyEKowraf?=
 =?us-ascii?Q?zeFf0URcq+o+as7iUttMU+8aLOYL9eEDMW6v/R++JV1WYZLdxiDbKgmWUAUP?=
 =?us-ascii?Q?EneSN937Ymx46aKT59VI7ETfSlyZr6D2A7e+vUJpx8kR/gYgAK2ZPqu+3hxD?=
 =?us-ascii?Q?zGgTTmGYYMuMQY0aKkvKM4V3+eykyWyGIQqmYmiXfqrF/eboBsAjNq/b6QQG?=
 =?us-ascii?Q?/YWVzo5s2PW/tUsBqq2Jq2qwCXL96CwQhOMDwULAuD9XFNO53gUDp+d8+uSF?=
 =?us-ascii?Q?v8bksglNqaE6kaIIhure1G86xWY3E0xmfa06K6uyvc5nqElVRlP5cFbCt768?=
 =?us-ascii?Q?fIpgCHnh7sE7fPREqFo7v6VurPwDqFgp+KhxM3oc4JH4mqLdNHrvUCslUN1Q?=
 =?us-ascii?Q?1mFalwgkx/UGMRw4ITPdAr3VBAzdKOzAtQq+Q2m8KhDGKaoNkcveD0IwGXyP?=
 =?us-ascii?Q?Q/YHw3mG1DPXTkSuW/rYy0Ua/kyL00d+R/IDoDpYkTm4lmxxdXqPFotIPmYp?=
 =?us-ascii?Q?ixkfjnIZcA7iTskbvpfW+ctkxILxGL5W3eRH9iRNX+Ra9t8fPpudCQrIlNbU?=
 =?us-ascii?Q?zurJI3FJn21n6u/fSHwU16U0cgPIzDZ1kp/e8b9AbI+QntCyiQUzhPEQrqyv?=
 =?us-ascii?Q?ErNyhOkXtF2gDUhGuJ78fvAOP845qhS5oJusVmP9BZ3sqre8MVe9CyS2T5Uu?=
 =?us-ascii?Q?HyDp9MwoMwyw479teNdVwuc/QHOyFQChGg1euUy1LXUKPKTc0w9Z5oIu95HP?=
 =?us-ascii?Q?7yirTH0OOyjhWccXVOP6GHFnv9dg+n7RM2qZ/DaXjsaupCF8oRbWmQOKvP6/?=
 =?us-ascii?Q?G7nRsh96dPQ6exsrG2yUaZM4?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15092bd-a8f8-4791-93f5-08d92136394e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:22.4696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LocyWn+8vABrld3Mtw+XAHY5k+h9RPdh1jcvgPEZ2kk8r7BkF4vY6lI1ZUKEbP4YJfazeqqVF4MwnTCiL5HdH7Gh72/ISx+YVMKJSDorlGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: HBGJiTS-FD1nW_ZJBonFuTXNte8qh_-0
X-Proofpoint-GUID: HBGJiTS-FD1nW_ZJBonFuTXNte8qh_-0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=985 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270113
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

