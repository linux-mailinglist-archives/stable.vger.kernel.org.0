Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597F43934ED
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhE0RkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:17 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:36848 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234586AbhE0RkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:15 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHYLco002811;
        Thu, 27 May 2021 17:38:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by mx0a-0064b401.pphosted.com with ESMTP id 38ss3vs2p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ul0sLSYnrjLug424BNgR10U7KLARO46+3bC980dKbBWk0afo44jaBmVxp3xbVw1FZ4BID/jnYg2NDdk2BkLprWOhUZ1BTt8z6BcVrXhIx5eZ30XtoNvXg//QM3uqw8+eOLwZQCf0XMVE+Kg/cj4vMRQxQJQiZ4rFDDm8GHhr+3httXeKkBRVrsFuFYXUvF1eVT6cxv3+ioA1KE5ydaHasH0KlDPTQJAiZg+igx9qfaLImsCkHGnhsJuatL5yVcXMIEfPZW0KC8maYK11rG6C9ypvnfeYnfSdR1QJJEWPbT+kat0fbC1XKLsmZVHr58e9S/bJHkdWk7OpE+38BqjP7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRmoQRVmrgXAjw29R5fGwGAKf7Spg0d+6ui2tLZYW10=;
 b=h4c6ybQyDvPX48gd2sMc6FnmR85RZYg1njF3oADFD3+Si/j7Oa8OgnGVtFSngf0oSL8d2uzb6I/QHlTlW6ID/ze6KUajAfHZEBJvq+o12i73RDEybJC8pUoaj25b428o96rGzNAI7gyaR2/oEVylCcVUrWADMKO7vDBwpDzY2rq4EUANqPdEBF/8odazv+Kfy30CcI5q74QI5Uw9+/cM1f5Qk6BIcQhytvVKnEp9xeT99/17MF7xbZz6M1Sv8AjThzv+sgIV+de7Tt33aj7qS38lKVU8A+zbHd32/Or+ZATVPTI/zOT0UFUCeaNojPdiohx35ielMFzR9Ant8E2Sew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRmoQRVmrgXAjw29R5fGwGAKf7Spg0d+6ui2tLZYW10=;
 b=V8X7oaW/1X4dwPH3wc+0dEWIt4EzO3fdviGjYeMud4mznFWNPlzc7IsHdmk5f7wc3/BtCY2dPJgmjNXUBKNjHM+P8Mec4jYGHrY+1iRABYzmhfFu0yS/8cMIKVNWHVTdfIDeRO8cXQGL/EH5HXg6llBoEtmvjc5bfBltOp2AlGA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:26 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:26 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 03/12] selftests/bpf: Test narrow loads with off > 0 in test_verifier
Date:   Thu, 27 May 2021 20:37:23 +0300
Message-Id: <20210527173732.20860-4-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f3aae3c-a499-429a-125c-08d921363b8a
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162B68B4942F931F00DA1DCFE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tfqu5Vi5hOf+ifS/Ozh0M1UoPl3RHvGYjYoptIl6VF0eqUOJ5H63N8GOUvUyFl5kgZh9Q8l31NEe219gnj3KUNlu5j9CL9l2cR9+atlv02WbZqy9X42T8aLKOGomTqbJZMIRUy7i1/axV6tfwOrOi2uf1kRMbySLWmFSrCQfEza+O3SRbcUn3z/5+EoFxqmd3HzOyuxUaACwnUrBzIL6h279gSEYLKtrIAm+Mq83hhLolnLM+B/zH/+FeBno3V7snpkWcW4R7iZgVfd9mV2DcLqNHG52qKzchxeHlVoiZM+7rqx7Z/1Z7QkAtjYiXD9T9aHvN2DU/LR2tMmFg2Jes3AMtQTaOwXFUHQTblQZHxM2YVi02ERR0xsr7MVLmD3FZTGrMZQXEgykYvKw8z5QBrOgNiusmM/9cCqPMtArXyYS0Kt11PWHPwNaGspV8cRlbtwKBN71Os5B4i+L5HkQ836dqBdAK/0bW++IXoQvt6NnmxdcdRFwsEUZ+3ewUgaJGUEG/gwKBp+JWrt/T1aOVRuLhv/E/c3ymHlDiC9bJcGZk2B0J6OGHCiUjHrhh3JQF54Yi7f/V7oMFBl6qWpAwhYvxztoCDj8JDzu6GdCJkxwequmunHgN/SZdN2cy3CVcMSlHZeJ/tp3ZZ3dG1vqHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vdHAAFcQXHhzeCm19fAWN9O/QKj025b96rdHWRXmMqT2iFnhS925q5Hagk6K?=
 =?us-ascii?Q?ka1636JYkQ83aK63JGkqOg9gLE0mRvCTIr+CndR6MAjFYtA05j9SZEQJdj/T?=
 =?us-ascii?Q?rwTsgb52bscumVqpSx3zLP3GI5rX3s3NiwABpOwPPoAdyn8X+i1zTXrB4cjv?=
 =?us-ascii?Q?ecqbjTcNlgm3D76SOIDGuEjARwxeejhVr7HjUPUyuKvlQAhuA1idTuWLZZRH?=
 =?us-ascii?Q?Uc8j2kUc14nfzX3fyHBacIIQWQdsQi48ftvRYJUw+FWZ4zEubbeZouPdzo4K?=
 =?us-ascii?Q?ScV/UsOBMxevWkyjglLtmw6Y+qz2VJjVifYDpaZ9i66IQ8ZhyM9yUQc+ATU5?=
 =?us-ascii?Q?LbdKZLaL4S7GKRFORaI9oSak0aDqo2g524pv9/n7WeKReH7MKbjRZ0Kp/KWa?=
 =?us-ascii?Q?h6ZLftfWC1fFH074sobHtgKOPiY0CVqNrnC9iTBTfCHeaVpQyneoFW5fVfwb?=
 =?us-ascii?Q?UvfBVkCF/2jWAQd3OLkEGgZHiRVz9FHfOumYDFYcd4rDHu3ZcY+0w67Txpg3?=
 =?us-ascii?Q?A41xG2CrMp2OfpnPuRduGiXIQivF5Gxm5raptDHST9OCY1msOZPBYTEL3Rwf?=
 =?us-ascii?Q?QqSj5pvMlgcN7YtAgmgbxyp8AumqyP54cVIr+jWAChBoIoTYbxEugVb/KrJH?=
 =?us-ascii?Q?Jj667uBj9xAgf/sHWm4nKtvJ2hBOSCcZoeQs5Cf41jwAwooGh7V8JKnMxSBY?=
 =?us-ascii?Q?FXq5uZCW/JNxxIGdZ+6FJG9mHJnOvxJqOf1a9ekCb+Gq8Rp0UaY/oi1VKNPB?=
 =?us-ascii?Q?FOek6lg/wWMsJ1t9UIUef5jtK/rEGbdVPrNa9US8u+RXpdwiU8I9Ka8NTWeD?=
 =?us-ascii?Q?KyomXCNCKzILKYUCAhkYeSNw/yBHczx0/ZFK7BeqBYx3iBTXLGaDH5RqwVuH?=
 =?us-ascii?Q?ikhvcKnd3UvjsXMACuSUDjpxvroifufVj/JBNTUuiYklS9pVwLMpOqu+CqTI?=
 =?us-ascii?Q?j1v6Sx3Z48TBxs6MdQH+8J2ZkhXpUhO9OZm8eqKwPjlMeF8fGh3Od5i2eiOj?=
 =?us-ascii?Q?mFoAoOIrIivUFVAiY+CmV9iGjTq9BWH/mLarNDClz4nSRIZtvHCKiMsqSv2Q?=
 =?us-ascii?Q?mnhsLGTeRuAqJadyCWZwxYD8cRiurH/r9MZS2twXVFziiJ2WzKQn1tvjh1Gv?=
 =?us-ascii?Q?kJY1Pb10gJWMr72c140NtEiwVIb/PZO8lFA201JKEupYJJnf/z9LP4qQJPWU?=
 =?us-ascii?Q?RSK+GN9SWM19P0EChT2o9ZjlpcyKNjnORViGWaCZgcOYR37P4zVl0V3wtbj4?=
 =?us-ascii?Q?TL2z/WuSy8Dmq+q2EVU+dkklLAiDdobTTBI4NYud1U+H2UQhU1rSHQGoDqwX?=
 =?us-ascii?Q?hIbD2Wc+4dI+PeS2nyIIlvKS?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3aae3c-a499-429a-125c-08d921363b8a
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:26.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYb3yKb+KKvwZVLsl1BxGqZ3vmIC1WJpxm0fvYTibqkRjaFcnsg4hr7UfVzrUUGOgupCu62+Erk6dHJ2deEe3RIaGo0VH4NyjvLNIjv3On8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-GUID: iaBhmFHke9M4CdNZGlcDN9ClLLySxYFA
X-Proofpoint-ORIG-GUID: iaBhmFHke9M4CdNZGlcDN9ClLLySxYFA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=905 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 6c2afb674dbda9b736b8f09c976516e1e788860a upstream

Test the following narrow loads in test_verifier for context __sk_buff:
* off=1, size=1 - ok;
* off=2, size=1 - ok;
* off=3, size=1 - ok;
* off=0, size=2 - ok;
* off=1, size=2 - fail;
* off=0, size=2 - ok;
* off=3, size=2 - fail.

Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 48 ++++++++++++++++-----
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 29d42f7796d9..fdc093f29818 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2002,29 +2002,27 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"check skb->hash byte load not permitted 1",
+		"check skb->hash byte load permitted 1",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
 				    offsetof(struct __sk_buff, hash) + 1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid bpf_context access",
-		.result = REJECT,
+		.result = ACCEPT,
 	},
 	{
-		"check skb->hash byte load not permitted 2",
+		"check skb->hash byte load permitted 2",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
 				    offsetof(struct __sk_buff, hash) + 2),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid bpf_context access",
-		.result = REJECT,
+		.result = ACCEPT,
 	},
 	{
-		"check skb->hash byte load not permitted 3",
+		"check skb->hash byte load permitted 3",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -2036,8 +2034,7 @@ static struct bpf_test tests[] = {
 #endif
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid bpf_context access",
-		.result = REJECT,
+		.result = ACCEPT,
 	},
 	{
 		"check cb access: byte, wrong type",
@@ -2149,7 +2146,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"check skb->hash half load not permitted",
+		"check skb->hash half load permitted 2",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -2158,6 +2155,37 @@ static struct bpf_test tests[] = {
 #else
 			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
 				    offsetof(struct __sk_buff, hash)),
+#endif
+			BPF_EXIT_INSN(),
+		},
+		.result = ACCEPT,
+	},
+	{
+		"check skb->hash half load not permitted, unaligned 1",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 1),
+#else
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 3),
+#endif
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "invalid bpf_context access",
+		.result = REJECT,
+	},
+	{
+		"check skb->hash half load not permitted, unaligned 3",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 3),
+#else
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 1),
 #endif
 			BPF_EXIT_INSN(),
 		},
-- 
2.17.1

