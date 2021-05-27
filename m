Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FC393500
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhE0Rkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:32 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:57152 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235365AbhE0Rkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:31 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHXB2T025634;
        Thu, 27 May 2021 17:38:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gg9iiOiyZz9gqdmBwsZkV3uDWr/3AshTD6kC848bX1O9+q0QgCi3nZBHNbndVHiXcJWNM0FRjyBTAQ6B0N7ZJOJzx6GpB2mDNighAkbgfukw3qoVAQUzCoyc5DKTNZuTmsSPNK8pzY4E0OBP9buiUUSr0WtD35K/7noj/JunxolsPTKoGwiXf7J5h7z9CRhOkzP2zut7c+XA4PDvmCHEBwDsjLEYWflDJmomaqJQUwqJrG8Cpo7Hn0Qu1BQe74xLp5RfbSqfvJprqU9b4BtT8icbH+OmgEKyP/Q9pDnhujQemo2u1XlpID6whikLiOPEleEXEUDXxVx/iNovOe3Grw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FspNwqKwkyB64IQR/2ISxIO8KO+paEDJ8iCMzITFv8s=;
 b=X27UCVPN6MARxUbU8lmWrni19diLnNa+9+lgnZlBhWdxM9JsXAwXurjFe5XUdeQDeObl0IhzC9VGbDT+MQ1Kev513ww3Zxqv3pXmPv6VKo6PLT00Ig9Lp948v/VQe5U1ZGBDiERm3RzPnLHbCt9IdnZum3FUHwNsY1BH+fpde4C0oT3ef8m1+SLbIX1/xwFKWPkcCaqShB4zS3Vk6ZJjRf77PlFQr6jDQVEy9j3PnO8r26vCSTSSML52JtDZaq/F5tzaatuhZhY8NtQmB8k8A/UWHvJsFPwm6QFyyeRH0oUAcxYqTS/J7x6kBe5iLrX/ghZWCrAgBruqag8a04eDGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FspNwqKwkyB64IQR/2ISxIO8KO+paEDJ8iCMzITFv8s=;
 b=FKRqJZ5JSiVBZyxU5iY8+mzgeM1FdA923vaVG6viaPbudcMEjigmW2O/TWFrnjzFeCtyNliRK0MK/y4liT7gTVadglPVch155zkTlH3d7kUHnihVj+iajWZ5J739xhgI+StCV062kfhzqJWnV88nqlEOtB+hDFdxBSwJ8PeJIhE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:41 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:41 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 11/12] bpf: Tighten speculative pointer arithmetic mask
Date:   Thu, 27 May 2021 20:37:31 +0300
Message-Id: <20210527173732.20860-12-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc742c4-dbca-46d2-4d6e-08d92136446c
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162EC7D2BDFCC224F82B181FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fGTrGlfuBC1AjklYYih+dK2rhl/ShoBck526ihl1ND2LB/4Ao/PsQQc3SgdAOPrHzj7/ieDNJ3vsHVoJs74ws+jKeDrHlJifJ1lAyeUoM7pMLnRCiMbUdIsrxUajU0jmh4vvNeF/B39n3/UC680hgyQTMBr/J59uLs8eDpttNGn/A4O7sDKxWUqx3e7wKCEylYTOzcSHmnlzUQ3wiu54EUU5AHf2Ia0yyQIG+bWWUjzDmocVK6H8kZ9wf+A1JVA0Omz6H50WBHS4qFwDi4jd/xPTm49CcQzlF0diDXsWcxYlPx2+3voX3K6ZlQnM7WDhHOtXUZqzBTls/f9QSZRbRfsME2v3dN9bsq8YHB2p12kqOKgWuHeUlb4cJ/HhpSjGUS//bvXC7Got0wuVJ2bqoT0yj5sOAZJWRjWo98lrrqKcebp0b06STHOhX1V1Twg0HrnQhsrJ3wQBhm4wMn1GS9+FwVovRFp8urH+5ay6jWqC29zHW+ixb9GdgZMx1rbe8qjYNNJj7fIP2JDWFCmTJ7hCCNSQR7mcy72JG7hdUmdnedxjH1stNPCv5RJGdgUs9p97JwSMksnwLuqk9vUJ+REYM59Ne5+mL80IWVC+CB2GpDvRf3oUerSGoos3gzRsFq4iiTArLwnZXpNwGi1+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BHW7ZU7yTw3D6EiimWolRSy5LO/BGAFOtLBp3F2nac0OdOknx9h5Ib1pLre7?=
 =?us-ascii?Q?y1t/ZjA7ZxnN6A8a2j6dRQtxGmfMapD+fCLmF868bD3LlOgOm3wxtYwdtnkw?=
 =?us-ascii?Q?qY2a/XScAjiLLzevPOi9wU1lXHOebRwp3mmrcRpSzdsqdEu7toSjhXg4Dp+p?=
 =?us-ascii?Q?b2qnVHZqovX8U6Cfx1gn7e9zuaDfzioQUGtOdFx0cWfi6sMCzpGTrtjtiq8d?=
 =?us-ascii?Q?wzxm0av9F0tU8CurjZqgTQrOPDD0PPUl6z1YhYmgwg8zZY98Yh8xVyoNwG3A?=
 =?us-ascii?Q?4fEp9amNkmriHy5BBXiCr+BPL2HZ+gHwtrVgbhxVLhS2VJ+ouhADJUTNBf9o?=
 =?us-ascii?Q?+k6t3/iJYt1R1h9FNYEb+NTXxUmu56CGJzHq62I+8Mod8mnoU2Eb4dYYMTr6?=
 =?us-ascii?Q?hC9FI+IV6u9GONdkwgTDmzYgeQ9eKm3qHzzPJtDVWZTsLretHJZw7f52HVFB?=
 =?us-ascii?Q?+hiNg/GRg5qrEN4Pz4RBe0Afc3Yiut9fIujPzXuUcmTwLMkecrChJEj/HHi6?=
 =?us-ascii?Q?KK6NmUo7p82pa5EN+5iC4gUzkld21dMRkT1nXZkwu0ejGetA806pGShIRBJ1?=
 =?us-ascii?Q?oTfRO2xDOpsbhDxe5P32jVCm6K3QgSxxg6bYbcBWSM89t2T2BoKqWF62bBwW?=
 =?us-ascii?Q?QDLc5NxkxYjgxeAgnjpJ1cP08v73fITGVih0hgT+fFzTvF99bDdiG/5BNW4k?=
 =?us-ascii?Q?NYwSXTLAsNLUmfr5+C0GpbeLkSm9kfcGk8En4xHo4+AWzwZQfKYvGRMR8oSW?=
 =?us-ascii?Q?Ja2vcAjli4ya5VszEXptALv1sqMENMZSszliHiFZbtAQwrhZGhoFSGhABvb/?=
 =?us-ascii?Q?YYmbR8mBsDtbvONrW8zLcafAChoAr59SsfsTEu4FHssprmW+TjvchPdoE9iI?=
 =?us-ascii?Q?PPxzt7YEpYpeGJsxrAGfDG6mNKjj8744B5LXkb2WxB1/XyppFlBL11HZHAT3?=
 =?us-ascii?Q?MFxLmNbbl13OPQxpb4yLZOv83Ky+kn02bENG3csPTEEnZ6FQ5M+1oeKmn672?=
 =?us-ascii?Q?t/7xJikNM6k2ZxzV5NXgPkwpyzWFj9Z+Q7M5xfXHbWgcBRY259K974ZJltuA?=
 =?us-ascii?Q?b52W35PpGtj6oPxcBmeeBxP+HtOLXjgtEKjOkzPBLYYXY9b/YjT8hKr6g3dm?=
 =?us-ascii?Q?X2vGjLldNrZgcJw0fMQ9qPL5c+zghDGUHX9zpQbQkbH1MJ5mMjpRHgMDiGXC?=
 =?us-ascii?Q?Q48d7/6Z1wbDmd4EI2ozTVQ6d4Sqmetw+3Rp8vmkMOekE7qhVghImxUFLbtR?=
 =?us-ascii?Q?eB9V/xD/nhAC0RyW0J5ERhAlyAtd8u/yO0/5iTpQR25lzfmlJPdZmyueiCuM?=
 =?us-ascii?Q?8zmyje4778gKOum0BKH8RtCG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc742c4-dbca-46d2-4d6e-08d92136446c
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:41.1563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMDmxn98dzwnn49cOr3T2T2sOZ00uK8gsS0IaX/+xwEw0+UV3Rw4zgjhBjPSicJQRYFGN2ggLYDzdME4YcZ2pv2Yfg9QEX3cF5r45ZZ8WOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: spYghOng0lH20TbKmAxZTkMMuBDysYKV
X-Proofpoint-GUID: spYghOng0lH20TbKmAxZTkMMuBDysYKV
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

commit 7fedb63a8307dda0ec3b8969a3b233a1dd7ea8e0 upstream.

This work tightens the offset mask we use for unprivileged pointer arithmetic
in order to mitigate a corner case reported by Piotr and Benedict where in
the speculative domain it is possible to advance, for example, the map value
pointer by up to value_size-1 out-of-bounds in order to leak kernel memory
via side-channel to user space.

Before this change, the computed ptr_limit for retrieve_ptr_limit() helper
represents largest valid distance when moving pointer to the right or left
which is then fed as aux->alu_limit to generate masking instructions against
the offset register. After the change, the derived aux->alu_limit represents
the largest potential value of the offset register which we mask against which
is just a narrower subset of the former limit.

For minimal complexity, we call sanitize_ptr_alu() from 2 observation points
in adjust_ptr_min_max_vals(), that is, before and after the simulated alu
operation. In the first step, we retieve the alu_state and alu_limit before
the operation as well as we branch-off a verifier path and push it to the
verification stack as we did before which checks the dst_reg under truncation,
in other words, when the speculative domain would attempt to move the pointer
out-of-bounds.

In the second step, we retrieve the new alu_limit and calculate the absolute
distance between both. Moreover, we commit the alu_state and final alu_limit
via update_alu_sanitation_state() to the env's instruction aux data, and bail
out from there if there is a mismatch due to coming from different verification
paths with different states.

Reported-by: Piotr Krysiuk <piotras@gmail.com>
Reported-by: Benedict Schlueter <benedict.schlueter@rub.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Benedict Schlueter <benedict.schlueter@rub.de>
[fllinden@amazon.com: backported to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 70 +++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1c1736851581..38866ba16035 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2744,7 +2744,7 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off, max = 0, ptr_limit = 0;
+	u32 max = 0, ptr_limit = 0;
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
@@ -2753,23 +2753,18 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
-		 * left direction, see BPF_REG_FP.
+		 * left direction, see BPF_REG_FP. Also, unknown scalar
+		 * offset where we would need to deal with min/max bounds is
+		 * currently prohibited for unprivileged.
 		 */
 		max = MAX_BPF_STACK + mask_to_left;
-		off = ptr_reg->off + ptr_reg->var_off.value;
-		if (mask_to_left)
-			ptr_limit = MAX_BPF_STACK + off;
-		else
-			ptr_limit = -off - 1;
+		ptr_limit = -(ptr_reg->var_off.value + ptr_reg->off);
 		break;
 	case PTR_TO_MAP_VALUE:
 		max = ptr_reg->map_ptr->value_size;
-		if (mask_to_left) {
-			ptr_limit = ptr_reg->umax_value + ptr_reg->off;
-		} else {
-			off = ptr_reg->smin_value + ptr_reg->off;
-			ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
-		}
+		ptr_limit = (mask_to_left ?
+			     ptr_reg->smin_value :
+			     ptr_reg->umax_value) + ptr_reg->off;
 		break;
 	default:
 		return REASON_TYPE;
@@ -2824,10 +2819,12 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
 			    const struct bpf_reg_state *off_reg,
-			    struct bpf_reg_state *dst_reg)
+			    struct bpf_reg_state *dst_reg,
+			    struct bpf_insn_aux_data *tmp_aux,
+			    const bool commit_window)
 {
+	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
-	struct bpf_insn_aux_data *aux = cur_aux(env);
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
@@ -2846,18 +2843,33 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	if (vstate->speculative)
 		goto do_sim;
 
-	alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
-	alu_state |= ptr_is_dst_reg ?
-		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
-
 	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
+	if (commit_window) {
+		/* In commit phase we narrow the masking window based on
+		 * the observed pointer move after the simulated operation.
+		 */
+		alu_state = tmp_aux->alu_state;
+		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
+	} else {
+		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
+		alu_state |= ptr_is_dst_reg ?
+			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
+	}
+
 	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
 	if (err < 0)
 		return err;
 do_sim:
+	/* If we're in commit phase, we're done here given we already
+	 * pushed the truncated dst_reg into the speculative verification
+	 * stack.
+	 */
+	if (commit_window)
+		return 0;
+
 	/* Simulate and find potential out-of-bounds access under
 	 * speculative execution from truncation as a result of
 	 * masking when off was not within expected range. If off
@@ -2969,6 +2981,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
+	struct bpf_insn_aux_data tmp_aux = {};
 	u8 opcode = BPF_OP(insn->code);
 	u32 dst = insn->dst_reg;
 	int ret;
@@ -3018,12 +3031,15 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    !check_reg_sane_offset(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
 
-	switch (opcode) {
-	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
+	if (sanitize_needed(opcode)) {
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
+				       &tmp_aux, false);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+	}
 
+	switch (opcode) {
+	case BPF_ADD:
 		/* We can take a fixed offset as long as it doesn't overflow
 		 * the s32 'off' field
 		 */
@@ -3074,10 +3090,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0)
-			return sanitize_err(env, insn, ret, off_reg, dst_reg);
-
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
@@ -3160,6 +3172,12 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
 		return -EACCES;
+	if (sanitize_needed(opcode)) {
+		ret = sanitize_ptr_alu(env, insn, dst_reg, off_reg, dst_reg,
+				       &tmp_aux, true);
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+	}
 
 	return 0;
 }
-- 
2.17.1

