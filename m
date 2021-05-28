Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0986939412A
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhE1Kkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:43 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:54268 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236629AbhE1Kkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:31 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAVG2a003650;
        Fri, 28 May 2021 03:38:44 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thst8j2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFhX/DM+oiH8ZddOc54+D6H69ZrYLjMFwKtKqvZFWox0NCSPcvR7ZN/EjbBhSnk7okKk22Jvsh/k5Xj7FlLylVCGGnMOvMhawWKXZa6Qc6LaHpTrfWuNvQo9qfaWuy5iWhqQBleMqxsUrOEFAQOkqcvWCsavjhfDfMUVby2alLMgLp4nIZv3f1v5nHhFVM8/97ewQeicb0Ah0/T308zNvUDbAkSjUhFM6aa86gLOtxg2edVta1BURQvmIGvHANUXFLJK+MCq6jG+2qeGUzvFeTJOCOCnXA7QGEVX62zBVUgguzEjnVttYmGgM45AIxCDGHttEyLPSthhdjDwUwBdYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcodndmaRyao1haJSGj9TgUMEVSUz2jKshDkUJI+Jqs=;
 b=JakKqVGDXQ3o7a7OKfarb97iluITaTZy/+VWzlp0NXHM2wP6m4aDDviHk2315H1PfZqd2/y2eupUMXP42WBrmhC2YhR9nsTtqmlP1AA7D/6e6xLZll2q8Lmdu1uUvKkimZsGFANSJWVBrAriwTHVopRQi/TXRHPph/1JAV1YZdhDOSDIbv5uHoatjTb3JPcZMqbr56Dkz1wcn65WHE3qC5GjRCGwY1DaGTFuU4ZKXkomTRxzEPGfGlCU4gE2vwauIkT2CsCMYB08tnaECWeZvmiDnO2mrEkKEE7wmAcYKwsVfv+6daycvoO113E0YGANsi0Ap4ifn9wQUcwfBq0xEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcodndmaRyao1haJSGj9TgUMEVSUz2jKshDkUJI+Jqs=;
 b=WPNXwbZRpog7R5fjOx8mv0nIit4Iny+t47AWRnN/o09bZOtD1YURvWvg+SOcPRFaa9uEhEXEa6AMSpck3+C/eNPTVPu0axC9L2Jg/lrAmLLlMbIauHJpEJKNOeAnSNL8JgAOlgO7dbiwhBJ6Z5LLGgabUmlKX18Ym+Jt3KyufOM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:42 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:42 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 08/19] bpf: Move off_reg into sanitize_ptr_alu
Date:   Fri, 28 May 2021 13:37:59 +0300
Message-Id: <20210528103810.22025-9-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7be07470-4bbe-49c7-d4bd-08d921c4c35f
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2097B4574F3B8B5F1CDE999EFE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vu0w9i5ryCWLFLC8iLULynMt/TGqDeIl/LCcE6uEexfxHJ1IQOtiUd0VnoBXLm2RjqS6rb/4iUT0CAvNf+0OFleMS3oJWbEc6r1ICLXB/qABXmHtu3ZcNmM3KUdXZxzcDTl8ymz7eMCdYpHqk+BpMV8KwDhy7zCii2CW23/oYmT1FBZNS3pjfRZnAO3l+ppI7FBlVQoizQPxDeNprLA9peF+xJeHJfhWQVEetu4t6mWxg4RUY48PcSBUBNfPZ8LgBcqsq/0PZVSkStw/LVAFt/8yAL8nDJtXM7BX4mpmNsy7a2ST0Uobc+TdMxwZjFaMXvQTLLh6ST6LAJ+h43VdDxfCyF9OeaWsIX8+YDoRlVu729i9mD3cgk82RyNIQ3t0ZybqWJbv25zAu1PltDVv+UUGBJnZQnldVdMwuRJEMln2nptVIy+Zj+fXr5OY4dXJrLOBLz0aJjjBFRyrfdfzHQHIfy+oZbukNzCqEMVTqmf3zCjFBrwROck5XoA0UXWoxoqyljoMyRIDH4e9C/u2Bta/A9CVTHBgGv4jcTv9Ub0sy8gQGuEjXQQBR1uDVDwal/r+PT7kc1f06CjI13gCLlHhsECVBYLBKPtWiyux1pyJo8jEKywFZ/JJ0lEJ9f21shfiufzhzR2fQ0rFqZce2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FkPz7lBvlSz1AYoxZNyRIH36kDRdSfflp7+Gn+Hd9IjVKMIo9UvOpm7o2YM/?=
 =?us-ascii?Q?9zDZQR9EKOMshR1hNRPSzoTJ5H5p0HhNwkp7aKfzYAXO+4EPejnWPHyByDfF?=
 =?us-ascii?Q?lcEroZXMKvKaKlik6p7udpcIwfF8HuHrEtuSQISju1x0/tv/9Q7mi7G3fjwW?=
 =?us-ascii?Q?ZUo+9S1rZh1EhF+y23Sn9Pa68PgRbOs2Ypw6B7Xh5qzxjTSFChtj3c7Y5QNa?=
 =?us-ascii?Q?TCQedJ71SX5ByuiufWSCkmEIslOaBkjDrmfUxwN46ITiPV33AKWOlsi2VWDC?=
 =?us-ascii?Q?/3aOd7kxM4HIAH/JaWS0675yfCzDpMNXIJ9IICuvQC9cxXuY+/F4tuHhvGI/?=
 =?us-ascii?Q?Eab5I4YWbtmKMmhsLCH1BqQXIBk3sFsYP7enSKnYNN5a5HDHgt9CVxb22pnM?=
 =?us-ascii?Q?LnxKiEjmrrHdiWZEQBm2XoBDSpGSUuWyJs6GEzz12ix9G6axeRYi4qNg8HwT?=
 =?us-ascii?Q?NwjMYkFg0fa3XFzs9eqCn2vsXThXEYKL+59YwL1AY18Ph4K6I/i4rN6xcnk0?=
 =?us-ascii?Q?jFUjxlURzmpC5nx2Yg4kPHWUHf8oMH6F7ltf6B9HXAxTeRLe3UtwzGlB3pLg?=
 =?us-ascii?Q?1RqMJM0lcrJKcXkPHo8G7vhE6hKgsMm+UwQukO7CqCiJ60iX/1AjbuLmh0c7?=
 =?us-ascii?Q?21zM96T7Pu7C3bmQn3XMUsShzdPPGWHnnUNj6Z2gETAR/hlOq53Xvj7qefxC?=
 =?us-ascii?Q?f4ZzscPl1c/j0TjTkUNFNbZLbl74lIhvigJdUMd3Pduj2uEv9sfXk2lO7ijk?=
 =?us-ascii?Q?27N1OT+qClE4t5Nh1hM65HIXV0aBhZPmgJHmY8/yYvl/milKknoMpIOTHKxO?=
 =?us-ascii?Q?AAH82UDV6JKPxYZ9W1l9jBfUKHtIr3SpzGouftZ4zy8iJOLkHQ9uZ2P+dl53?=
 =?us-ascii?Q?4zGOkUVC0dkWzC+oxFH24ejPVpavykUweoTvGJg0L8oMWgszyuPyhZqE7Q+i?=
 =?us-ascii?Q?YDuZ7li6lToENqzNpVkuGMtpWxLClIkq+826iih8GTaiiUpaXq+CAp4iIOMx?=
 =?us-ascii?Q?hqHQVz2w09Zga0HrRyPZlLe0JPrYb6d5Cei81EQW9XMBwTxP9JjzpX7QZKi2?=
 =?us-ascii?Q?qYEXOlC63aELxQzZBdZm1XDhcESHPqWcAB0kZYo5CWjKzNGbixnlmuqCrBqJ?=
 =?us-ascii?Q?DSw0CNS3ZANp4109owocx/9RVU2osOb+CUq5276HyZs/1gxjJ1LehEQrLKsx?=
 =?us-ascii?Q?4sUMnq2fsysMWsiysE9pSxwNLaIfcRdbQ+qVJbnx63ggOtApmxohjlydD1F0?=
 =?us-ascii?Q?EXqYYjp3qWMKHn0+RbcIftXWKYFEm0c/S4oCGazcdOoG8K0Yw/k9zz6Fzzgr?=
 =?us-ascii?Q?OR2JT6A04O5h3uEzEyclU80D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be07470-4bbe-49c7-d4bd-08d921c4c35f
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:42.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXOVDm6UslHo9h0UFu6vTX8jGAYVVKUr92HHj3WyDr6gBHQgp3iU6bUkTNZmRlAdiSLRAAXjPi/e7PcDRKMJ+ZAaEgBci4/Z9GpBVHH8Zks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: E-tjGpeAGEdAVDkmhTfvd0EiiIdSXUVP
X-Proofpoint-GUID: E-tjGpeAGEdAVDkmhTfvd0EiiIdSXUVP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 6f55b2f2a1178856c19bbce2f71449926e731914 upstream.

Small refactor to drag off_reg into sanitize_ptr_alu(), so we later on can
use off_reg for generalizing some of the checks for all pointer types.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 275c1078d80b..4edae9b29cd1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2799,11 +2799,12 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
-			    struct bpf_reg_state *dst_reg,
-			    bool off_is_neg)
+			    const struct bpf_reg_state *off_reg,
+			    struct bpf_reg_state *dst_reg)
 {
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_insn_aux_data *aux = cur_aux(env);
+	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
 	u32 alu_state, alu_limit;
@@ -2927,7 +2928,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	switch (opcode) {
 	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
@@ -2982,7 +2983,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;
-- 
2.17.1

