Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2683934E8
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhE0RkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:16 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:36618 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234061AbhE0RkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:15 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHXKjm026033;
        Thu, 27 May 2021 17:38:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81bt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1qLl9rln/+GftjgmFs3XN5Qa1U37l4X2CJAUrvkEIRGPqgGRLWcLrxPbFR0n6d7VCQleuKalwNRLBSsLrfhheWJsrsjdb3LB+LHLUF3RYLs6V6dlElN+KGTrSF2tevjlDCI8yiBQrpvkWrgUzLujf4AVklqjsa++xkieLHk7vGDPzDg3YILHKK60O59YUrITPEX3jvkfuFm6mKRvbwvj79AK/BNplYnlW9NZ3O8bToONwoOP+1yz3jGnt2llx9NQwWR4QyWMYCad3GTOj3lDluYcn931OJbkEY6USGJlEZfAdi4OTt5nE1zN9lPYZu55FjGEmbC7Ci4RdUdKl4EuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZFtFZQ19dtiGu0q4A91o88mfw7+X77N4k1AxGl1Uog=;
 b=BiHDvqlHTVmjZhiSHDh7ZUqi4Phb+AjZs3xOb/v8joIFg28km6FmVQR84bcK1IzRqCMY1NdVeyNRqpTMw4r+cRbKNxrRyNVmj8xvDzCSVLDIEYgjDB/+2w1ONMTitBIjxQwh7zf7HUGCwKBLOG3nJM1aM/T2Gqoorf+00JWLrKwfptmOBr/k/F9vEkzQstxY558FjgrDtU+gpOLytty1IoTOI/2Sm1AqWBTsq3Cj5ZNSzFWLy9WuLJkI6Q/UYDqE57o3afl5HWexsXe23f7CWGWcpu6gywG2xLLzVkjM/EveJkQYlJ8dKXlq9dOON6pnuE1tLqvI3scYMEA6xiev/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZFtFZQ19dtiGu0q4A91o88mfw7+X77N4k1AxGl1Uog=;
 b=cOPHjOXYcuWGrM1zVSlb/udTiqvWnEeeJEDPJxstk/YD/FjbiYqmJy6/7GNBAP7cT29g6p9pZY/ArdIdVIUx77FT7x3kvX34OKHvWOnLmL17Vo2VIqoswOy6ZYjz5lp4in88Hi35WfaNJxntrvepJPBBzIQO8ohxP610Un8o0Gw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:24 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:24 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 02/12] bpf, selftests: Fix up some test_verifier cases for unprivileged
Date:   Thu, 27 May 2021 20:37:22 +0300
Message-Id: <20210527173732.20860-3-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64ed15d8-081e-4a45-968e-08d921363a68
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162650A2F05D094CB6FA29FFE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5aoqfKHEXaAIRpHb5BXx1Npr1Fmr6qGxn+67aD5VdeEoMGcvp49kUaNT3zpCwJq8OCkCiZuBo3/WtMwp+zeEOCHPY1SLfaScC5vDGP7JBJMK55qmzakP5vzM+FsY7dfGtHlIWJyizu/ajStto8NObQyfqUaiZPhyEg7wnXmXcbWDbuZVncPyoNAmwYeSnOAF99tNIvGd8r/6657j8wSy+XllIopM+L3Yx6YzwlA60mVnJwGF1RBMq6ZARdsLt7ys0l14aZze+i2+X3ldbvifQ0LFo2D5yLGglq3Ny6zd0k2a64E7S3jtj7NZrynlSBFLKeIejlGesEOK1k6/j0CDURXaXB9GNjduQIu9pgDFoh0V4w+8/4zt0g3rNj9GrzzVdcuRPMTz9IUM/EZp0Dw5W0DLH8+TlHfCi4xxLF6IpNYCiyLYwG5jo1NGOan0NaTxXuXuw0NKi5YIU7rg0G1BWTgeAv5RwXIqXeGDXjxLxdhlp3+6H/IrOWzFx8wasihVudrh9df7ej3qrHgWxv2kmIPwtT9cfAtWEtL6YEkcKPXKozCPe46xx8ls01aa0Wtvijoe2wczHvQQdwzwxPQUOgKgcLBcLrj0Kx0HTh6ycQrgYxGwQJAv0phgmRxfJxfwnu3l5W0nu3SbOsB//4Zh9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8Cm6kPE3cttzSccPe3tdWtE58exkqs1WS9XkUU3tD3rwWlqwWrQrHeyhP8Eh?=
 =?us-ascii?Q?6shPRXDT0hngNlrVmdtMW1FtYhDkTXA0j2EttWpspSxEMzuDL0V6rKtbEs/n?=
 =?us-ascii?Q?UdsZeDe+wLSSESrk5SlLPjm2QI2tvhAS82IAYq8KuKcJWLckZ8wnHMv2P+QH?=
 =?us-ascii?Q?RaX3Mv2sp6jJCDOy0ZhF/4faqN5/cIdvbZDnlhyiKBwpxWUe+UZ/p38MS3z3?=
 =?us-ascii?Q?ubrdqg1i/fNXVDNzf9vBukmcCcmZg4CncMEKDPMwkFqaG5h2MpM+UIgvKm9d?=
 =?us-ascii?Q?2P4ika/NNYY72E+HpLtH91am5OItHBMmwoB/LlA2KMO9zchySJmbyv771uXM?=
 =?us-ascii?Q?MV2e3Ys8gqHndxiP4NPLYgKJB5TFxThtG0ocSV8QohJJUq0RWCL9bNfb/D6X?=
 =?us-ascii?Q?Ts54mbBUPBqmZrXPlQwANI6gkSTSVnk6oDt0dn5ynIeiT9zxN6IsmkPbRyoh?=
 =?us-ascii?Q?TPUqhWPMsesVgjyXtJfpUFILa5xlGV0JD0/TUGkqxRa/UmpZIKuNUeg992f9?=
 =?us-ascii?Q?mMOESLUkxO2CqeB3xXMTkRRy5EZWn7ioZdZ7FsR/2Ph+3oottzUvSn29ZBNY?=
 =?us-ascii?Q?jZ3So6tP1Fis3T8jIrs4yEEkTt8IB6e1oCBm34jeFHvmWPCd+PPBHpJivkHf?=
 =?us-ascii?Q?1SLlHfkx8tTJgCgwQzt5AvXYVRzu8BplQ2BdRMuIsIqrN9qPcvmcUmnQaqgI?=
 =?us-ascii?Q?79RVMyh9CPACztq7ajDso692RvorlMos/VJun2U1MLr1A2ha5N+zIrqIQ62u?=
 =?us-ascii?Q?+FyADTWwaObhKbLLFPArncvqzKtmeMl1qb19j0EsR+q4sGm69w7w6wrZbJDf?=
 =?us-ascii?Q?P8v2JfcijT7b0IiSvRaPdAbtipohD5nsqEAnTswyf018EvWAFEdl7F9ydNtt?=
 =?us-ascii?Q?aY1y3yB3oD0Q8b3IwBR3NjmsZ6KEN/E8Gp/5HpW83Uwi3uurxaSd/6dQIosh?=
 =?us-ascii?Q?VXv1wd9kdPowo+PA6m4wD+8xolk53DbVZFSbq1NQdrSpfXFN/DoPTl/az+AE?=
 =?us-ascii?Q?jnO0l3k/E8w0Da5uQS40jcnbQf4Cif/0HlpPvi9PQdFb7g4SY5JI2vyUl0F2?=
 =?us-ascii?Q?A/c8xrMbU4wruydQDHu3PHxd5vG1WIMfMjOXg9/B24tfXi4YLVfRS8BSyHFp?=
 =?us-ascii?Q?xMOial87W5FyEoMCovIP/aRBEos9GpQqbxWkRrxiBsROpE/zRBv9nxlVJhW6?=
 =?us-ascii?Q?MOmNGVNswFaiGzWJSVCBxCka/DsL6u6OrpO776IjTVSuDBOzLm78j8hr6HuR?=
 =?us-ascii?Q?Dp3OAwpann/ea0jU3fJMh+oBxMWW2KvzJNtcI0PLbr/dzj99Q/hB5CGwEn1O?=
 =?us-ascii?Q?sLP9AqSMmP3Xis522wXjNrtm?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ed15d8-081e-4a45-968e-08d921363a68
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:24.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xG2gha2JYnuZN9nqnkEcy4H3ymX2SwNigQ94XKl8n0lb+gKqabAMiASM0ghRqWy1v4CcYlmRjo5e2zekRfoOWRS9BIAt+zUMHLG7h1ircSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: Gwzjxnl0mjDUlXEm-nEs1dmz_f8CnxRr
X-Proofpoint-GUID: Gwzjxnl0mjDUlXEm-nEs1dmz_f8CnxRr
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

