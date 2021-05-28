Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099B3394137
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhE1KlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:00 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:4550 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236629AbhE1Kkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:45 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SActBJ010271;
        Fri, 28 May 2021 03:38:57 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra29-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeUXT5ekS3EKKZVYbk1I1S68X/0F9kNiP2HVXh+LwUbiCHRLBelzUcrq7n8iAoo5SnuIDybE7D4oO4V3T4VZhceXSZ43oLxA9WFqm1yLU9XLwSIwqWM+vvNif7CKcDStK0QnATusEhdskcHqq4+iD7Gpees9sHp+fk3RdJe3uSGGZ8VajxNDWylWVyuMSLr8LNHVNZI4+1Bcjst+0JTFT5Lf9x/wumOE+UJUV4ZtLvxgtynKNXC6p5DoCP+VK3wdqvrXPMv6o/QDk9fQCjczo7jVBgWx2ulRU+VeDMeYEVi4fBwzPbjxJe5uS85HIKb0nQ6jvRlDMJ+/kErJjsCI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuJheAUwd+FS9wsLTF2TSxmH+z2RB5twAnc+wG0ilTI=;
 b=kjR2DwqQPAxmWJr47EvOMGEYs0yFzGITdTuwVGbrhBP8qLWiGr4AUlw1slCrFsq7B9IVlliyhIoawP142911LUdF1OUt7EUUInqawszRLVfbbXb5lHMfsAuiRoo3H9jnR1pBJP/1AYaPGOx4CjdEMAcL9FPGyPihON2ZQJk2GtdzKeK0zee87UD3pY9eG7gYEShynGgwf2imN9OXOgesdrP3FWNxPxB6HSlEJOZxHiMg6S/5BfDMChbOGa0ndjpVmEOjYmHyR9bdMHhqaU5tt6JrZMtFZr4fJ6aVXQnUXXHr+WqZLpr1oo4ZG9/cOzMYom4XRfYO/+saGQcfxqO4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuJheAUwd+FS9wsLTF2TSxmH+z2RB5twAnc+wG0ilTI=;
 b=Rp1fUYesL2I10ndYfSWA3RAIpH+48exIOVv6XjbWmoJv268OBhkEjM+x8pZO+AwrecB2WWVg5iFI/FqdR7wM8OOVRQE4jdz4vKhtABTx18h25GLoyhFue2Vq8uPVXDx+cokLfX9QwcTRmdfAs9CuC3M1V2Bhih0hLEiTS1U2XC4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:55 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 15/19] bpf: Update selftests to reflect new error states
Date:   Fri, 28 May 2021 13:38:06 +0300
Message-Id: <20210528103810.22025-16-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2cfd8da-c865-4bff-01b8-08d921c4caef
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB3780D6CD445F23FB73D78FC0FE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yT1xfVF1S+Ok3dPcFyDUVbrk89JoEgZc0ugc9hIT0g4irMWY/wKlqE65W1CU1PL2qn6CxSe523OAyfwKF6U6jC0u8+9Hn7r6uivkjoUUpmtp3dYll1cqjBI3Pakijf68glmC4LZ0kmW6vsfjez0djzxv9wfSaKqI9D6xlRkjz4b2NCLLHA6kFDEw/aYfhGJxs7kTrLZKtePabLr8nyXpUEO/0TJ+swYZFoSu+8hIwqbZiL01mRz5HxZkroRalXme1gx9O3v5tne6FtVtCuv3P7Ywtcpw1PmeVSBBWj/C6/fG2jEnqc/pktLw0LphGwVzSVkY/Jiw13uYfrrNMzyEVt5GN6HPUXwjRCow0FCV4eUqYhJqWvenvfmYg2lieJn0NUDjEIVcIO05vOc4L9idQhhf6Y4Q0LJRoAH7/xKwBtgsuKoQr80Oe9gfbxuSNj+XdUXmdyycWdl1Lo7lelmFu12EX6ix0q4bIAt0FPAiewadh0xcNmmd7qskvVny9nQURg+9/D7kHyFxBsTS3uqdwV4tsz9i5X8U6IfIpat7p/KISEOl0jYaiDiXfkDp8LkdnXKGNVTeal8OVjdK/dOyMxQCGFtMUZncorfaMpXpMxID8KwlNbt4Uv2jlFRbO32ubdQwU7cveCgqIefWBe3cqUAo9CyDhfcL8oEqRCo1dHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(15650500001)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?er1WSK0/+SQZ4abVA3mrHH76OXeD0nwbQNj2m92Gd7l71yH7hbuzLyGOW5Ln?=
 =?us-ascii?Q?RrQe8P9HBzTzkEtT6aoxgf3Z8ciiD4skGF3DQb+DoX+WBo/GlFZrGOocHqnC?=
 =?us-ascii?Q?u4JiJJ+su1P+uIcHZqS7qMzKmJidsDkdCdgaeTR/G6GMyxONdD67skYFhtbM?=
 =?us-ascii?Q?pQmLL0OoX/8UMRyJENph/FpGOQUM1wOAACjs4WBPjU3zG38Gq4Z8X2NErkaL?=
 =?us-ascii?Q?yv0Aal3UHdii6rO8rZInyJzyEsz+lTldXmtgJhUFICW8PmDJ/vzRiTXDsrSv?=
 =?us-ascii?Q?8c1Fx1IAekmURFKuyGedvpo2nvK1HnvJB/rjaxerPso+WkrzlEOGT6x93ftB?=
 =?us-ascii?Q?46mTEpAr2lSrQm9IewmMpIP0HRa2HYDnF4wQy3MN7CDtldbROSbim7u1yN/c?=
 =?us-ascii?Q?ukHFHlUfjqhAK1bdYcZlOA0g7GFldbsqQJJ8WTtAQf/98xayYos1RGEp1Hm7?=
 =?us-ascii?Q?1ar5RRF36TMR2hNUUWxV3q3Mh7mZsVRQXtQjaOLlz7257FSJKskKxepG6qW3?=
 =?us-ascii?Q?vxeMTZYd4ycCUxVeCMyYqfFG33LqlvuV5Y2Y4bLPOJpa+k0nq0nEruxwqtaA?=
 =?us-ascii?Q?WwnSE4Jzu1tYOQ2nsH6rQP3fpQp3yT/WcBHWrireVw602mMhEKJxCoT+ropb?=
 =?us-ascii?Q?4BCRbUKch2dOi6+BVAZAKHd3CfExl2knI9MvhGiDvbpdsmrbUBtCH82Jje55?=
 =?us-ascii?Q?D8Ns7yN3MMZ/rKe40EXSISxHsFLJTb9vtnoXfMGKvWog3vVkqmIfXawMDWT/?=
 =?us-ascii?Q?GnQDXIwvatn/tNx3PrH23fyGQeccXsti+DtvwUju599xF17aEGHR3+VXOAml?=
 =?us-ascii?Q?vFwXqgWNC+PfIb5aSAKHizXyul7PmBb1SOVosyx6pSzPbSMiUpe/6V+8fapJ?=
 =?us-ascii?Q?fcVs0d/KVDvGcG6wzNfNQR44a0DJ7h1c1ot1Nu2xGxBKbG5CAPSct3m9FomC?=
 =?us-ascii?Q?lQlLlKA+GFcWJBYzGzXPAesXncC7At5zX13WxOBIuHAQQkmTEewfKEMnErYB?=
 =?us-ascii?Q?ObTSmg4EWYj08jcEXjupZr2a1UKmqs01bFBO2cJ0HWF/ai7Mv513iQIR/mns?=
 =?us-ascii?Q?uKaiCkggJN/1gck0CQvDmgjodbvLrikvNQWb/fkVnrKANfHTjRhGlWa3vzk7?=
 =?us-ascii?Q?r1iTYz/tZ5+WxdyuJ53uKbDvnoHzJZsZcTl/C1oW9n5jgisP+/peakSDMop+?=
 =?us-ascii?Q?beM35mqk8FZCAnuebrrcYvdCMCoiPaxvmbAhZmoswbl6QTaMDsvXM0Ra044Y?=
 =?us-ascii?Q?jQ7mgZKqtFtNj0e65awM9040zsoSnAzyQnhr939EQIxElrppetPKrnEXH6hb?=
 =?us-ascii?Q?W9bWvOo+E0KrBztcreCeZh12?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cfd8da-c865-4bff-01b8-08d921c4caef
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:55.3142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uymsFRwGtO/1kLFsDoEq77y8+48tu/r+47tMuQjLeCpWYD0KBI/o4cWKt+1Rt9AemPGFYcDknH29xzDWV2WgV/m1Tp69XmbUrl0e+42li2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: Q9IvUh9chfdnZvh0E3hFOwlANOXiQwOh
X-Proofpoint-GUID: Q9IvUh9chfdnZvh0E3hFOwlANOXiQwOh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280070
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
index 662d6acaaab0..e1e4b6ab83f7 100644
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

