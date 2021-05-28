Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF0139411C
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhE1Kkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:35 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:46590 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236608AbhE1KkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:25 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAaPMd004646;
        Fri, 28 May 2021 03:38:35 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRI6keoGm/dXKfsAd1nJHgwUfHp50Pm2rWTW92rTMgf/2zn8Sp5C7wJGJuTzrIVidTJfUv1C/wz0PQhtjTqfVK1EbsPVC+VI49JCWTfF3gHwpq3xBwNUa8drJ2bAuDhJ2Qr+GTxr+NpuoOY596Oyrx0n9EOrZDEtepXarfru86qkms/Ay48khbgnKdoE+psAzw92EiJLJVh/2+16GQlniMyygXB/cuDnbdmtUW90wSirygu52SLu0xt0/JMJPx+i8+hfm/jfAOcga0crP0hEx8ZTORIbc4pAMnC2j+n5kgxQizS+4W/nMEWuSh/3WUU7wA2L/HoS9O9PMZw8Ok3/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRmoQRVmrgXAjw29R5fGwGAKf7Spg0d+6ui2tLZYW10=;
 b=jI/kjfYd0EaIWDTjHJcLr+FNNslXxzUgbN3WFvzTgGi7jL/ahfibJzXN501icJEfT8R1A6r94mWNmOTACrZ5zSNEvd8p06BUgdOVVo+0j9lpDtNpMliQMg19Iajg7eK4+kG26NqtfQQWhUlYp5SF+uKn7tc2PhnNRFI3eCsqiYV/CTRAepXKHXhuKP4Z9ivf43cTzoNvAf3fDPubafIF3WH82F0icG4K2pYCjvA6ic+x6e4YvUYOs4zyzcnEpIaGJ0hNmJp392PBT2TXtAAF4nVVWoxombAn/TYTtGYcJgirf18LB3xyWC7URHZ1CgLsov9yOIlPnij2oZe86vWq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRmoQRVmrgXAjw29R5fGwGAKf7Spg0d+6ui2tLZYW10=;
 b=IgHyIH3iHXNafuuAOiK5oNV63PSTYZpB4MWHTgf1JZX60Lz8TqiRNFBhh3nrjx0HARG6w+u/VdAB4z9rOldjlBhrh9z2XUN9o9T83NKxv1Ob2C6zdG4onbap5DYvWPtRNnLNxLn6xz+gCOB/gfFdzr1bh79cQXZUuoJ9NmhvMEA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:33 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:33 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 03/19] selftests/bpf: Test narrow loads with off > 0 in test_verifier
Date:   Fri, 28 May 2021 13:37:54 +0300
Message-Id: <20210528103810.22025-4-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85c01f51-ff58-418a-2fc3-08d921c4bded
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2097D4CC3ECC6657BF13672BFE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DHIGv9IsICCeGz85ZIYHJ8HXI6JK6Ih4TeVjVu5XFcofwL6tSwrdGHQ2bdcogJSRKWiR5Fh9ae0gCwsZU24sdo5X0VixRNRxPMyxIJ/R1R2pYeMcT10EO2pfht9hx56d4gVExFkn9nfsjPpy+ZvVqjHDZSbhjpLA8XpNBR3D8Pxt2Wsv3dgv0e5v4Y3VYiJQaz1pB6BujByb4mRLRfsKm53Jd7BlVuJvKU/1WBqW4fgpm5Hdnwb4712jPBfi92kKBD0ooGnBPCNP2AKEOMeW8air9NgDzNEb0Cgjn0ZcGvT23TnE/sCg0N0gdn1Dx9PkA7GW8zaGpVZDUd2TZnQSHeguh8fvX8DpzRJJG5u8zDuZkDZgOXdGVQiGebRg9mwX5kf9udEbDhO0kDksVDuEU3NRIsX77/iMCqYL/sr6hrWynOI4XWUwnX7V3CZgL4kwmYfpTNRzRF2jx/pgqLuM8NF9w032PmntwnhDcg7PCvjxRqvn7tTyc8PSyUSgXYXjQEGAjG21y9T7HS2+8GCQZPZLEZ65S9nUbsD7O7+n3V85VkYPYV5VzfXVygQxAGl9ZhYaMKhUZDLHmPzoDE6U/1e7k3kd1cLM3Kbp7m5GNGj988Livrs0wZZL9QbZSHybtlZCgdDOjce2HezcQHTfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SktyY1+r6SZHhKwKoqKu8p5Czry05t0G//L5tX9G9Dz9sToSdJSnmc+SlLJe?=
 =?us-ascii?Q?TI7o+KU/PbPasq1DwOUGtZ42XD0UKJ40VFouyFSNOtXAUWflZXBYgIM+2H/R?=
 =?us-ascii?Q?FKTOLF+m/GdYRaSG+ZpxtS+Yxura4J5+YD5c90rYBeOTrYhrG2T/VFGn9Rok?=
 =?us-ascii?Q?rqtX7uZsrfZy4+yYxYDQr9Pmz0fdGwg4iKGnVxAplcG9uTNXazzKeWDNsa/B?=
 =?us-ascii?Q?EEJvCe7FZdwsM1VFSZMqzl7EWzfHBFMHg1CC01hngYq9zCHSlT3qcxcPFH3P?=
 =?us-ascii?Q?qYXXtx6O38P3OuJ2I4o+k6LCbqYpROefQj7FMs5FuNwyWxR1+OdqG2gzlbl/?=
 =?us-ascii?Q?YHH8oFdUUf9YzTdbemnFjto71dA09JGQp8WASPDDMyMUkEA5Gv47cx619mU+?=
 =?us-ascii?Q?QnfzyzwAjTM3R3PB3CDhIIMhJFjZtnVac6I+BX1HKmLziNqtAqEXzhkf6SwV?=
 =?us-ascii?Q?dYodka39V2POd6DBAD7z2hkDcW4ARmyhR0FZyUr1y7GQJScnx5OFMC3Op2qi?=
 =?us-ascii?Q?LWCBIXzYvrranSkaSmbRkoETjQEJEoM8H6kXuZaH+Vds9z2abrFfJVuLNmU4?=
 =?us-ascii?Q?QsIdynlrsecdG/U8a4/YO5DGUdQEb7nKpoq319foROLtgXldD8Pq4AFPDn9Z?=
 =?us-ascii?Q?eTPUqLpYPy4FTLr3A26m+NqNfxtn7EoNYvVWtXd/xF4dM769wr4tgnCgM6H/?=
 =?us-ascii?Q?yhDkrAGJG88YkTmL9VjgGovWN1hc1w1zGk7z4RnS7kr2rNSPf64ojWpA4SP+?=
 =?us-ascii?Q?Gvct/s3hgZxfSeMGX34Z1ofBjCxXpN5Updb8CWFZpvV6veV1jnTU30Suv9O/?=
 =?us-ascii?Q?GD67YMG5pUPEC8bUPGJ/xYKSDIv87AauOM9VW+8EYrmz+kQoDghZwvdvtxXY?=
 =?us-ascii?Q?Ca6BM5GjIuMUeW/bxqN1Csjx8u30JqA05GyF5AQupLePHaqW0iNh5Uxg/w6l?=
 =?us-ascii?Q?Xk1N0W0RDD6pRL4jrzJq6F1stChOz9t8KCJOnwpWwukbTLUqTGEpdXe8de9/?=
 =?us-ascii?Q?j4HT+whnGDyAUiGJnTX5xeHcONv+Zk/PQsNnVbUWomAuY4fo9IbsG2T3cPWT?=
 =?us-ascii?Q?UDzPOzTKetrC15nHEet++CFB023MAuDPXCh06OMZMRP2N7/MWaB+EhqHP7wI?=
 =?us-ascii?Q?PNarGr0kk1NgEQ6piWzN08sD2S+CXLq2/P3M38XOyH6GeZ1wQhp72kWuTraC?=
 =?us-ascii?Q?PBo4zGgqhvzmbRt0cZWBxBbKb0U9Lzs2TJq7I5lyge3fkGgYInEatEJDYj04?=
 =?us-ascii?Q?noSoU31VaM6w3zi5qw43lmoUDnUOfKgdblWwVlchn/pdYeRO3UuOjG/Taqox?=
 =?us-ascii?Q?eG7qklkBra0B5dB9aFSxrinv?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c01f51-ff58-418a-2fc3-08d921c4bded
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:33.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fH9r1UBwwpz/ysv2TRIz4qvJUm+OYUtZjc8B2XrUnrBKyal7KK0qdW3XIpMDg7GgXkO5ee7Nl/+YmAgjUPR30DATP2lxWALonDXg4hR+R7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: 1pnuoV-cOfeMHnQf-ZDQYK52KN_Iu2dI
X-Proofpoint-GUID: 1pnuoV-cOfeMHnQf-ZDQYK52KN_Iu2dI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=880 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280069
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

