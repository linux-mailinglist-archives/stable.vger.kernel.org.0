Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65257394132
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhE1Kk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:59 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:3462 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236551AbhE1Kko (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:44 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SActBI010271;
        Fri, 28 May 2021 03:38:56 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra29-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwzJlY4Gy/EjqqLgcyMJ1yBFiO6ovOmeZVYy7G+rniEglv/IA0KutzP3ooLLBKFA3a8d0OAgIYa3Arv4ezTHqfZs5j2Q0gUoxk84uA3GYQrK8v/wMgoPS8LNAnAlbs/E1e0wIa/ElmxkDgK8iNIF2CNLZ+oGy/xheUknIsgjx6+HxxYcGJBKUPnDiH4jbfnOOpVjU38m9zPI+PbgB6LeKFwBtjVAkpVK3RCZzQwSSruXe2qoCSXqnNFyzOfMlDmskGd0oHQ5/dGBD/rtg1nqJ4eoR0MWsgr7VxaZjQA5QXceeYDY4JWcSLcUdPNtaO6lbL/doCMZgRNb0G7ZBFQFkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGOXbo9ypi/CUkoapeVLOvl3pYb+a8M4KiPKlcsrmqM=;
 b=hcagkNkSvqSCjxTsn7jHFnel2iVD4ShaWdGlGb82QoQt9vgZYCfoF4wCdP69JUdb60LmYgcC5f1fEVqJiM+rg+tfMuZ4rlrQMDv5KVVDP32U+IR9TQ/NBa+hepa8YAYgSLSoZ/RH5oFeZkdIwPtKprQTsY5gzZO7fC58tB6bSfrPO+scNHEktxnThmJxkUxbjXL27h9SUWQtX/9vD5eS6wtGOoPzQIgBkN7FqPVJBLA1MYPRzGYYcCfSqGGRxWS7GGwo7wlrVZkCwBqTXbxnKnueXn6oaquf5d4mYUkQhPapPOVEBaa2kOQiv4yYF7dFfEdy4ymTIuR+dZQLQrJ3oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGOXbo9ypi/CUkoapeVLOvl3pYb+a8M4KiPKlcsrmqM=;
 b=JOpBwLh2FTJaZe83es164rOZZOTcPj3BQ0p9WSR3YuG1CSwjvey0Ez0jLDzHLQ+o72/phuTpM8GNd8g7FIEpQIMsEC7x4Wp+d+iFqV95ZGb1w6IXbCebKW2EsNAi77UG5yfG4i0/E47ItQ6blh8d5VGQ6gNGUAcu6D92Xg3zceY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:53 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:53 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 14/19] bpf: Tighten speculative pointer arithmetic mask
Date:   Fri, 28 May 2021 13:38:05 +0300
Message-Id: <20210528103810.22025-15-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f55e1dab-0dae-43dc-e0a4-08d921c4c9d9
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB378000A5C100E847D6C13C41FE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNlW87t+mTAEeaMQ9geiWBWeBVHXDfa9GlSt6FZ3NcHJbMfyHjQDNNOMzmM2AHCxFt+QwnyZggOEG9BCJxpVRvhT5FM8ii3B0k4i4K//STl6G9h2pgp83bhwpVWSi4Avy2ysx9hA87ZA43/3/j/O2My1NaBUzxUAULyhObhKPit1MSkjPTpb81kfqMiP/7nadt7pmYyedoiVX9saO6hVRY//c6814jdaK0UXTjW6wOgScsZUdtMP05C1pBB3bwldoy3qRLFT6yfkNpyTH9tEy/P2186j9xidNTgCZ+vw5dxJmUYQ8AcePN6CYnLfMFiGjctLyCUTfdqTXt/ikwq2NlEhXQPma2MgKoJYdkZlB7rTZQXZWwEfI9lOg1INqSvgIPi7F43xr3ETbgvyFkbQhB5X3XmswttLNPf5StHaIPa84RAObfECjc5Op59x3LkdgkY8nzXkQEvW8v2VXA0p2y6gM+sbyPm19rJJ4LHc5OXSxiSltFJJKytfe32enQCuH5PedM2vMpWdNl9hxT6s92RYRHU3dnsizmTiJW4a6qgSh0/2lJu1KeZfs19c61P1cyMsGK/T23UhRwDat0bXRzwnM1sGaUN6E1KPOlWakOZm509xngZm/9Ej9eJWQ3qzCBeP09JWO+cmrHTfAaafafb3ba+bQd7jX4sbLSccj3M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+C6MfKDmgZ09NN05kddfWVmzUi2dRgaug3r9UVzEjgozatNuicr7qIIH6HV8?=
 =?us-ascii?Q?I4kiIUyH8UZ+tSSAatDi3KVNnt6WZLl4gJfFRrUGNurJ/iJoOLrvS9tkjAyM?=
 =?us-ascii?Q?NaO8QBdKNU4ixBq6W9qNvfbgrEUlDEtZXP4oK9fPi6mDfdZxWMxq6GekLkJd?=
 =?us-ascii?Q?3MbJoDWGGZayrqigDs0gMvi8LIegNZskU64SVM8MPx7hjq2C40BnsSLcE78U?=
 =?us-ascii?Q?kGRt6RpfjkxF+tKF+k/zz3qcGG4FiHQWju295oYvpuI4ree006rki0rrdzOU?=
 =?us-ascii?Q?E6mKyIJCbBhxpnYp3LyOvg0Mt2EvNlQdD20+hTvnxXufvALBcthjQyxaWCSr?=
 =?us-ascii?Q?givXwScs/iJweyj5vIxoFNUo4I1wedSPLVVrKT1RqcpbtcB4c0pxh0lsqpgW?=
 =?us-ascii?Q?dbFBApkp0/oF6oPwaF/Wb+JwzsQskCZoRjTLiwU/XwycdnbXk8gRj08wPxcU?=
 =?us-ascii?Q?EMjuDe4FVfztCvT4RMpX28J2s2UbBf30tgSvBXmzSCEBh1Hwjfxd3jwWtzyJ?=
 =?us-ascii?Q?nPo+4o1toCqo2/i4F+7Ah122lO9DtaWhalFxLBx9jrNi69KEkyp0vOtTtf4Z?=
 =?us-ascii?Q?04y/qdKx7cZWdjkSw7fFcqmnTNEgTccnwaIncAsnX0nmpHnkPGp/aoXLRD/I?=
 =?us-ascii?Q?aidLAGzr7L267JVeIGEisKlZc69Iw2fiv+UOmSfK8oggd7PIjMN4Job6N0PU?=
 =?us-ascii?Q?Bk3yybOXs8AXcNcAG/Orv9/Aoaafkgal2Z0pjakqaY2zHULccSsUU8PaG9lk?=
 =?us-ascii?Q?GEfElMnqmzm2kJ44teti21cxa/dc2IbFVWMNtoQC5xq/6J93sZAYHFNCOwdi?=
 =?us-ascii?Q?uc2OZWX2SMklsyF5Jhqda96vHTKAlZhlXBUuZab2M1BhuDt4mAYKnAqXQoNq?=
 =?us-ascii?Q?qeu4GFUBRkONZdvyc4dSBwzE3TSFgK49aDJl7kiG4HmLVtdbb5Znf5bdcup7?=
 =?us-ascii?Q?v7oFm4pmx+pyZuo6FbkxiFz6nMSm1Rk4h6aGjEXWHyN3bx/LRaSc6195XtiI?=
 =?us-ascii?Q?fwDMuusZh26ghFoQC0SIiI0DMEXxBOFydCQ0HxbHjhGrXt8H40hdqTK1NnAD?=
 =?us-ascii?Q?HmOz7MBD7JAXtAz430sAMlukxhlBTDrt7ZPjLRhoeDb/KYVGQOit1DLfsnYA?=
 =?us-ascii?Q?QTuKkKneSqpccAt17nLNVmlOXuwUqidFpAccucTdQ3Y/30fC8KekUfc0QM5I?=
 =?us-ascii?Q?RSB+MLd9O0A0W5Hp8YWQPI3JUcSwHfdt/H1HoFyUCcniD7EQOfYVK2nZb94E?=
 =?us-ascii?Q?hvOfS5IWw/FBl3S0599qjLcfrXOc4OrhkaK5OLDcphMrS7r4YgmE+5lTg/C8?=
 =?us-ascii?Q?5g1cirPyfGfhbZT4IwlbvV7e?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f55e1dab-0dae-43dc-e0a4-08d921c4c9d9
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:53.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nq2xSy3ABnvVjXgYj9T7ULSzcXX8ra3PCTrfo2HUoG+7KJq70U+P6UF+lGAHL9om0ck+CnAz9A/Ocm5diDZJuKn0bCZczCz5Hwbh9yCufPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: UumA6ynEO8s0Seg2-Z-_wsgFhoeEBkT7
X-Proofpoint-GUID: UumA6ynEO8s0Seg2-Z-_wsgFhoeEBkT7
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
index 094f70876923..908251977bef 100644
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

